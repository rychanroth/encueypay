-- Admin order search (operator feedback 2026-11-09): server-side filtering,
-- sorting, pagination and filtered totals. The old client fetch silently
-- capped at the newest 50 orders.
--
-- Brand/category filters match orders containing at least one line item whose
-- current product carries the brand/category: order_items snapshots keep the
-- product name/variant/price but not the taxonomy.

CREATE INDEX IF NOT EXISTS orders_created_at_idx
  ON public.orders USING btree (created_at DESC);
CREATE INDEX IF NOT EXISTS orders_status_created_at_idx
  ON public.orders USING btree (status, created_at DESC);
CREATE INDEX IF NOT EXISTS orders_total_minor_idx
  ON public.orders USING btree (total_minor);
CREATE INDEX IF NOT EXISTS order_items_product_idx
  ON public.order_items USING btree (product_id);
CREATE INDEX IF NOT EXISTS products_brand_idx
  ON public.products USING btree (brand_id);
CREATE INDEX IF NOT EXISTS products_category_idx
  ON public.products USING btree (category_id);

CREATE OR REPLACE FUNCTION public.admin_search_orders(
    p_search text DEFAULT NULL,
    p_from date DEFAULT NULL,
    p_to date DEFAULT NULL,
    p_statuses text[] DEFAULT NULL,
    p_payment_statuses text[] DEFAULT NULL,
    p_payment_methods text[] DEFAULT NULL,
    p_brand_id uuid DEFAULT NULL,
    p_category_id uuid DEFAULT NULL,
    p_min_total bigint DEFAULT NULL,
    p_max_total bigint DEFAULT NULL,
    p_exclude_cancelled boolean DEFAULT false,
    p_needs_attention boolean DEFAULT false,
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
    raise exception 'Only admins can search orders';
  end if;

  return (
    with filtered as (
      select o.id, o.created_at, o.total_minor
      from public.orders o
      left join public.payments p on p.order_id = o.id
      where (v_from is null or o.created_at >= v_from)
        and (v_to is null or o.created_at < v_to)
        and (coalesce(array_length(p_statuses, 1), 0) = 0
             or o.status::text = any(p_statuses))
        and (coalesce(array_length(p_payment_statuses, 1), 0) = 0
             or p.status::text = any(p_payment_statuses))
        and (coalesce(array_length(p_payment_methods, 1), 0) = 0
             or p.method::text = any(p_payment_methods))
        and (p_min_total is null or o.total_minor >= p_min_total)
        and (p_max_total is null or o.total_minor <= p_max_total)
        and (not p_exclude_cancelled
             or o.status not in ('cancelled', 'returned'))
        and (not p_needs_attention
             or (o.status = 'pending'
                 or p.status = 'awaiting_payment_verification'
                 or (o.status = 'delivered'
                     and p.method = 'cod'
                     and p.status is distinct from 'transaction_verified')))
        and (p_brand_id is null or exists (
              select 1
              from public.order_items oi
              join public.products pr on pr.id = oi.product_id
              where oi.order_id = o.id and pr.brand_id = p_brand_id))
        and (p_category_id is null or exists (
              select 1
              from public.order_items oi
              join public.products pr on pr.id = oi.product_id
              where oi.order_id = o.id and pr.category_id = p_category_id))
        and (v_search is null
             or o.id::text ilike '%' || v_search || '%'
             or o.shipping_recipient_name ilike '%' || v_search || '%'
             or o.shipping_phone ilike '%' || v_search || '%'
             or exists (
                  select 1
                  from public.users u
                  where u.id = o.customer_id
                    and (u.full_name ilike '%' || v_search || '%'
                         or coalesce(u.phone, '') ilike '%' || v_search || '%'))
             or exists (
                  select 1
                  from public.order_items oi
                  where oi.order_id = o.id
                    and (oi.product_name ilike '%' || v_search || '%'
                         or coalesce(oi.variant_name, '')
                            ilike '%' || v_search || '%')))
    ),
    page as (
      select f.id, f.created_at, f.total_minor
      from filtered f
      order by
        case when p_sort = 'oldest' then f.created_at end asc,
        case when p_sort = 'newest' then f.created_at end desc,
        case when p_sort = 'total_desc' then f.total_minor end desc,
        case when p_sort = 'total_asc' then f.total_minor end asc,
        f.created_at desc,
        f.id desc
      limit v_limit offset v_offset
    )
    select jsonb_build_object(
      'total_count', (select count(*) from filtered),
      'total_minor', (
        select coalesce(sum(f.total_minor), 0) from filtered f
      ),
      'orders', coalesce((
        select jsonb_agg(
          jsonb_build_object(
            'id', o.id,
            'status', o.status,
            'cancellation_reason', o.cancellation_reason,
            'subtotal_minor', o.subtotal_minor,
            'discount_minor', o.discount_minor,
            'delivery_fee_minor', o.delivery_fee_minor,
            'total_minor', o.total_minor,
            'created_at', o.created_at,
            'shipping_recipient_name', o.shipping_recipient_name,
            'shipping_phone', o.shipping_phone,
            'shipping_line1', o.shipping_line1,
            'shipping_line2', o.shipping_line2,
            'shipping_city', o.shipping_city,
            'users', jsonb_build_object(
              'full_name', coalesce(u.full_name, 'Customer'),
              'phone', coalesce(u.phone, o.shipping_phone)
            ),
            'payments', case when p.id is null then null::jsonb else
              jsonb_build_object('method', p.method, 'status', p.status)
            end,
            'order_items', coalesce((
              select jsonb_agg(
                jsonb_build_object(
                  'product_name', oi.product_name,
                  'variant_name', oi.variant_name,
                  'quantity', oi.quantity,
                  'unit_price_minor', oi.unit_price_minor,
                  'discount_minor', oi.discount_minor,
                  'line_total_minor', oi.line_total_minor
                )
                order by oi.created_at, oi.id
              )
              from public.order_items oi
              where oi.order_id = o.id
            ), '[]'::jsonb)
          )
          order by
            case when p_sort = 'oldest' then pg.created_at end asc,
            case when p_sort = 'newest' then pg.created_at end desc,
            case when p_sort = 'total_desc' then pg.total_minor end desc,
            case when p_sort = 'total_asc' then pg.total_minor end asc,
            pg.created_at desc,
            pg.id desc
        )
        from page pg
        join public.orders o on o.id = pg.id
        left join public.users u on u.id = o.customer_id
        left join public.payments p on p.order_id = o.id
      ), '[]'::jsonb)
    )
  );
end;
$$;
