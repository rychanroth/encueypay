-- Admin product search (parity with admin_search_orders): server-side
-- filtering, sorting, paging and filtered totals for the Products tab. The
-- old read was a client-filtered fetch silently capped at 100 rows.
--
-- Effective price = cheapest active variant (the same value the admin list
-- displays); products.base_price_minor is only the fallback when a product
-- has no priced active variant.

CREATE INDEX IF NOT EXISTS products_created_at_idx
  ON public.products USING btree (created_at DESC);
CREATE INDEX IF NOT EXISTS products_status_created_at_idx
  ON public.products USING btree (status, created_at DESC);
CREATE INDEX IF NOT EXISTS products_stock_idx
  ON public.products USING btree (stock);

CREATE OR REPLACE FUNCTION public.admin_search_products(
    p_search text DEFAULT NULL,
    p_statuses text[] DEFAULT NULL,
    p_brand_id uuid DEFAULT NULL,
    p_category_id uuid DEFAULT NULL,
    p_stock_buckets text[] DEFAULT NULL,
    p_min_price bigint DEFAULT NULL,
    p_max_price bigint DEFAULT NULL,
    p_from date DEFAULT NULL,
    p_to date DEFAULT NULL,
    p_sort text DEFAULT 'newest',
    p_limit integer DEFAULT 25,
    p_offset integer DEFAULT 0
) RETURNS jsonb
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_search text := nullif(trim(coalesce(p_search, '')), '');
  v_from timestamptz := p_from::timestamptz;
  v_to timestamptz := (p_to + 1)::timestamptz;
  v_limit integer := least(greatest(coalesce(p_limit, 25), 1), 5000);
  v_offset integer := greatest(coalesce(p_offset, 0), 0);
begin
  if not public.is_admin() then
    raise exception 'Only admins can search products';
  end if;

  return (
    with base as (
      select
        p.id,
        p.name,
        p.created_at,
        p.stock,
        coalesce(
          (
            select min(v.price_minor)
            from public.product_variants v
            where v.product_id = p.id
              and v.status = 'active'
              and v.price_minor is not null
          ),
          p.base_price_minor
        ) as effective_price_minor
      from public.products p
      where (v_from is null or p.created_at >= v_from)
        and (v_to is null or p.created_at < v_to)
        and (coalesce(array_length(p_statuses, 1), 0) = 0
             or p.status::text = any(p_statuses))
        and (p_brand_id is null or p.brand_id = p_brand_id)
        and (p_category_id is null or p.category_id = p_category_id)
        and (coalesce(array_length(p_stock_buckets, 1), 0) = 0
             or (p.stock = 0 and 'out' = any(p_stock_buckets))
             or (p.stock > 0 and p.stock <= 5
                 and 'low' = any(p_stock_buckets))
             or (p.stock > 5 and 'in' = any(p_stock_buckets)))
        and (v_search is null
             or p.name ilike '%' || v_search || '%'
             or p.id::text ilike '%' || v_search || '%'
             or coalesce(p.description, '') ilike '%' || v_search || '%'
             or exists (
                  select 1 from public.brands b
                  where b.id = p.brand_id
                    and b.name ilike '%' || v_search || '%')
             or exists (
                  select 1 from public.categories c
                  where c.id = p.category_id
                    and c.name ilike '%' || v_search || '%')
             or exists (
                  select 1 from public.product_variants v
                  where v.product_id = p.id
                    and v.name ilike '%' || v_search || '%'))
    ),
    filtered as (
      select b.*
      from base b
      where (p_min_price is null or b.effective_price_minor >= p_min_price)
        and (p_max_price is null or b.effective_price_minor <= p_max_price)
    ),
    paged as (
      select
        f.*,
        row_number() over (
          order by
            case when p_sort = 'oldest' then f.created_at end asc,
            case when p_sort = 'newest' then f.created_at end desc,
            case when p_sort = 'name_asc' then lower(f.name) end asc,
            case when p_sort = 'price_asc' then f.effective_price_minor end asc,
            case when p_sort = 'price_desc' then f.effective_price_minor end desc,
            case when p_sort = 'stock_asc' then f.stock end asc,
            case when p_sort = 'stock_desc' then f.stock end desc,
            f.created_at desc,
            f.id desc
        ) as ord
      from filtered f
      order by
        case when p_sort = 'oldest' then f.created_at end asc,
        case when p_sort = 'newest' then f.created_at end desc,
        case when p_sort = 'name_asc' then lower(f.name) end asc,
        case when p_sort = 'price_asc' then f.effective_price_minor end asc,
        case when p_sort = 'price_desc' then f.effective_price_minor end desc,
        case when p_sort = 'stock_asc' then f.stock end asc,
        case when p_sort = 'stock_desc' then f.stock end desc,
        f.created_at desc,
        f.id desc
      limit v_limit offset v_offset
    )
    select jsonb_build_object(
      'total_count', (select count(*) from filtered),
      'total_stock_value_minor', (
        select coalesce(sum(f.effective_price_minor * f.stock), 0)
        from filtered f
      ),
      'products', coalesce(
        (
          select jsonb_agg(page_obj.obj order by page_obj.ord)
          from (
            select
              pg.ord,
              jsonb_build_object(
                'id', p.id,
                'name', p.name,
                'description', p.description,
                'base_price_minor', p.base_price_minor,
                'stock', p.stock,
                'status', p.status,
                'category_id', p.category_id,
                'brand_id', p.brand_id,
                'created_at', p.created_at,
                'brands', case
                  when b.id is null then null::jsonb
                  else jsonb_build_object('name', b.name)
                end,
                'categories', case
                  when c.id is null then null::jsonb
                  else jsonb_build_object('name', c.name)
                end,
                'product_images', coalesce(
                  (
                    select jsonb_agg(
                      jsonb_build_object(
                        'id', pi.id,
                        'storage_path', pi.storage_path,
                        'sort_order', pi.sort_order
                      )
                      order by pi.sort_order, pi.id
                    )
                    from public.product_images pi
                    where pi.product_id = p.id
                  ),
                  '[]'::jsonb
                ),
                'product_variants', coalesce(
                  (
                    select jsonb_agg(
                      jsonb_build_object(
                        'id', v.id,
                        'name', v.name,
                        'price_minor', v.price_minor,
                        'status', v.status,
                        'image_path', v.image_path
                      )
                      order by v.created_at, v.id
                    )
                    from public.product_variants v
                    where v.product_id = p.id
                  ),
                  '[]'::jsonb
                )
              ) as obj
            from paged pg
            join public.products p on p.id = pg.id
            left join public.brands b on b.id = p.brand_id
            left join public.categories c on c.id = p.category_id
          ) page_obj
        ),
        '[]'::jsonb
      )
    )
  );
end;
$$;
