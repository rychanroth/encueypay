-- Store-local day bounds for the date filters (admin "Today" bug, 2026-11-17).
--
-- Symptom: the admin order queue's Today chip was empty for orders placed
-- after midnight. The app sends the device-local calendar day as a bare
-- `date` (p_from/p_to), and every RPC turned it into an instant with
-- `p_from::timestamptz`, which resolves in the *database session* timezone.
-- The local dev harness runs Asia/Bangkok, so it matched the phone; hosted
-- Supabase runs UTC, so "Today" covered 07:00 today -> 07:00 tomorrow store
-- time. Orders placed 00:00-07:00 local fell outside the window (and the
-- 7D/30D edges, the dashboard trend bars and every sales-report total were
-- shifted by seven hours in the same way).
--
-- A bare date now always means the store's calendar day. Cambodia has no
-- DST, so the offset is a fixed +07; it lives in one place
-- (store_timezone/store_day_start) instead of being repeated per RPC.

-- ------------------------------------------------- store day definition
create or replace function public.store_timezone() returns text
    language sql immutable
    set search_path to 'public'
    as $$ select 'Asia/Phnom_Penh'::text $$;

comment on function public.store_timezone() is
  'IANA timezone of the store: a bare date filter means this local day.';

create or replace function public.store_day_start(p_day date) returns timestamptz
    language sql immutable
    set search_path to 'public'
    as $$ select (p_day::timestamp at time zone public.store_timezone()) $$;

comment on function public.store_day_start(date) is
  'Midnight starting the store-local day p_day (NULL stays NULL), so date '
  'filters mean store days regardless of the database session timezone.';

-- ------------------------------------------------------- dashboard KPIs
create or replace function public.get_admin_kpis() returns jsonb
    language plpgsql stable security definer
    set search_path to 'public'
    as $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can view reports';
  end if;

  return jsonb_build_object(
    'total_products', (select count(*) from public.products),
    'active_products', (
      select count(*) from public.products where status = 'active'
    ),
    -- Order volume stays every order placed (funnel/volume), while money
    -- metrics use realized_orders only.
    'total_orders', (select count(*) from public.orders),
    'total_customers', (select count(*) from public.users),
    'total_sales_minor', coalesce((
      select sum(o.total_minor) from public.realized_orders o
    ), 0),
    'low_stock_products', (
      select count(*) from public.products
       where status = 'active' and stock > 0 and stock <= 5
    ),
    'out_of_stock_products', (
      select count(*) from public.products
       where status = 'active' and stock = 0
    ),
    'best_sellers', coalesce((
      select jsonb_agg(jsonb_build_object(
               'name', t.name, 'units', t.units,
               'product_id', t.product_id, 'image_path', t.image_path))
      from (
        select oi.product_id,
               coalesce(p.name, oi.product_name) as name,
               sum(oi.quantity) as units,
               (
                 select pi.storage_path from public.product_images pi
                  where pi.product_id = oi.product_id
                  order by pi.sort_order asc
                  limit 1
               ) as image_path
        from public.order_items oi
        join public.realized_orders o on o.id = oi.order_id
        left join public.products p on p.id = oi.product_id
        group by oi.product_id, coalesce(p.name, oi.product_name)
        order by units desc
        limit 5
      ) t
    ), '[]'::jsonb),
    'sales_trend', coalesce((
      select jsonb_agg(jsonb_build_object(
               'day', t.day, 'orders', t.orders, 'sales_minor', t.sales_minor)
               order by t.day)
      from (
        select (o.created_at at time zone public.store_timezone())::date as day,
               count(*) as orders,
               coalesce(sum(o.total_minor), 0) as sales_minor
        from public.realized_orders o
        where o.created_at >= now() - interval '14 days'
        group by (o.created_at at time zone public.store_timezone())::date
      ) t
    ), '[]'::jsonb)
  );
end;
$$;

-- ------------------------------------------------------- sales report
create or replace function public.get_sales_report(p_from date, p_to date) returns jsonb
    language plpgsql stable security definer
    set search_path to 'public'
    as $$
declare
  v_from timestamptz := public.store_day_start(p_from);
  v_to timestamptz := public.store_day_start(p_to + 1);
begin
  if not public.is_admin() then
    raise exception 'Only admins can view reports';
  end if;

  return jsonb_build_object(
    'from', p_from::text,
    'to', p_to::text,
    -- Order funnel counts every order placed in the window; revenue uses
    -- realized_orders (paid or delivered).
    'total_orders', (
      select count(*) from public.orders o
       where o.created_at >= v_from and o.created_at < v_to
    ),
    'completed_orders', (
      select count(*) from public.orders o
       where o.created_at >= v_from and o.created_at < v_to
         and o.status = 'delivered'
    ),
    'cancelled_orders', (
      select count(*) from public.orders o
       where o.created_at >= v_from and o.created_at < v_to
         and o.status = 'cancelled'
    ),
    'realized_orders', (
      select count(*) from public.realized_orders o
       where o.created_at >= v_from and o.created_at < v_to
    ),
    'total_sales_minor', coalesce((
      select sum(o.total_minor) from public.realized_orders o
       where o.created_at >= v_from and o.created_at < v_to
    ), 0),
    -- AOV denominator = realized order count (never all orders).
    'average_order_value_minor', coalesce((
      select sum(o.total_minor) / greatest(count(*), 1)
      from public.realized_orders o
       where o.created_at >= v_from and o.created_at < v_to
    ), 0),
    'low_stock_products', (
      select count(*) from public.products
       where status = 'active' and stock > 0 and stock <= 5
    ),
    'out_of_stock_products', (
      select count(*) from public.products
       where status = 'active' and stock = 0
    ),
    'best_sellers', coalesce((
      select jsonb_agg(jsonb_build_object(
               'name', t.name, 'units', t.units,
               'product_id', t.product_id, 'image_path', t.image_path))
      from (
        select oi.product_id,
               coalesce(p.name, oi.product_name) as name,
               sum(oi.quantity) as units,
               (
                 select pi.storage_path from public.product_images pi
                  where pi.product_id = oi.product_id
                  order by pi.sort_order asc
                  limit 1
               ) as image_path
        from public.order_items oi
        join public.realized_orders o on o.id = oi.order_id
        left join public.products p on p.id = oi.product_id
        where o.created_at >= v_from and o.created_at < v_to
        group by oi.product_id, coalesce(p.name, oi.product_name)
        order by units desc
        limit 5
      ) t
    ), '[]'::jsonb),
    'top_categories', coalesce((
      select jsonb_agg(jsonb_build_object(
               'name', t.name, 'units', t.units,
               'image_path', t.image_path))
      from (
        select c.id, c.name, c.image_path, sum(oi.quantity) as units
        from public.order_items oi
        join public.realized_orders o on o.id = oi.order_id
        join public.products p on p.id = oi.product_id
        join public.categories c on c.id = p.category_id
        where o.created_at >= v_from and o.created_at < v_to
        group by c.id, c.name, c.image_path
        order by units desc
        limit 5
      ) t
    ), '[]'::jsonb),
    'purchase_frequency', coalesce((
      select jsonb_agg(jsonb_build_object(
               'name', t.name, 'orders', t.orders, 'avatar_url', t.avatar_url))
      from (
        select u.id, u.full_name as name, u.avatar_url, count(*) as orders
        from public.orders o
        join public.users u on u.id = o.customer_id
        where o.created_at >= v_from and o.created_at < v_to
        group by u.id, u.full_name, u.avatar_url
        order by orders desc
        limit 5
      ) t
    ), '[]'::jsonb),
    -- Payment gateway distribution: realized orders only, split by the
    -- order's payment method row.
    'payment_split', coalesce((
      select jsonb_build_object(
        'qr_count', count(*) filter (where pm.method = 'qr'),
        'cod_count', count(*) filter (where pm.method = 'cod'),
        'qr_amount_minor', coalesce(sum(pm.amount_minor) filter (where pm.method = 'qr'), 0),
        'cod_amount_minor', coalesce(sum(pm.amount_minor) filter (where pm.method = 'cod'), 0)
      )
      from public.payments pm
      join public.realized_orders o on o.id = pm.order_id
      where o.created_at >= v_from and o.created_at < v_to
    ), jsonb_build_object(
      'qr_count', 0, 'cod_count', 0, 'qr_amount_minor', 0, 'cod_amount_minor', 0
    )),
    -- Brand revenue rankings: realized order items joined to the brand.
    'brand_revenue', coalesce((
      select jsonb_agg(jsonb_build_object(
               'name', t.name, 'revenue_minor', t.revenue_minor,
               'image_path', t.image_path))
      from (
        select b.id, coalesce(b.name, 'Unbranded') as name, b.image_path,
               sum(oi.line_total_minor) as revenue_minor
        from public.order_items oi
        join public.realized_orders o on o.id = oi.order_id
        join public.products p on p.id = oi.product_id
        left join public.brands b on b.id = p.brand_id
        where o.created_at >= v_from and o.created_at < v_to
        group by b.id, coalesce(b.name, 'Unbranded'), b.image_path
        order by revenue_minor desc
        limit 5
      ) t
    ), '[]'::jsonb),
    -- Inventory capital valuation (§5.2.4): active stock × base price.
    'inventory_valuation_minor', coalesce((
      select sum(p.stock * p.base_price_minor)
      from public.products p
      where p.status = 'active'
    ), 0),
    -- Net settled balance (§5.2.4): verified gateway settlements in range.
    'net_settled_minor', coalesce((
      select sum(pm.amount_minor)
      from public.payments pm
      join public.orders o on o.id = pm.order_id
      where o.created_at >= v_from and o.created_at < v_to
        and pm.status = 'transaction_verified'
    ), 0)
  );
end;
$$;

-- ------------------------------------------------------- order search
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
  v_from timestamptz := public.store_day_start(p_from);
  v_to timestamptz := public.store_day_start(p_to + 1);
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

-- --------------------------------------------------- customer history
CREATE OR REPLACE FUNCTION public.customer_search_orders(
    p_search text DEFAULT NULL,
    p_statuses text[] DEFAULT NULL,
    p_from date DEFAULT NULL,
    p_to date DEFAULT NULL,
    p_to_review boolean DEFAULT false,
    p_limit integer DEFAULT 10,
    p_offset integer DEFAULT 0
) RETURNS jsonb
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_uid uuid := auth.uid();
  v_search text := nullif(trim(coalesce(p_search, '')), '');
  v_from timestamptz := public.store_day_start(p_from);
  v_to timestamptz := public.store_day_start(p_to + 1);
  v_limit integer := least(greatest(coalesce(p_limit, 10), 1), 100);
  v_offset integer := greatest(coalesce(p_offset, 0), 0);
begin
  if v_uid is null then
    raise exception 'Not authenticated';
  end if;

  return coalesce((
    select jsonb_agg(
      jsonb_build_object(
        'id', o.id,
        'created_at', o.created_at,
        'status', o.status,
        'subtotal_minor', o.subtotal_minor,
        'discount_minor', o.discount_minor,
        'delivery_fee_minor', o.delivery_fee_minor,
        'total_minor', o.total_minor,
        'note', o.note,
        'cancellation_reason', o.cancellation_reason,
        'shipping_recipient_name', o.shipping_recipient_name,
        'shipping_phone', o.shipping_phone,
        'shipping_line1', o.shipping_line1,
        'shipping_line2', o.shipping_line2,
        'shipping_city', o.shipping_city,
        'order_items', coalesce((
          select jsonb_agg(
            jsonb_build_object(
              'id', oi.id,
              'product_id', oi.product_id,
              'product_name', oi.product_name,
              'variant_name', oi.variant_name,
              'unit_price_minor', oi.unit_price_minor,
              'discount_minor', oi.discount_minor,
              'quantity', oi.quantity,
              'line_total_minor', oi.line_total_minor,
              'reviews', (
                select jsonb_build_object('id', r.id)
                from public.reviews r
                where r.order_item_id = oi.id
                limit 1
              ),
              'products', jsonb_build_object(
                'product_images', coalesce((
                  select jsonb_agg(
                    jsonb_build_object(
                      'storage_path', pi.storage_path,
                      'sort_order', pi.sort_order
                    )
                    order by pi.sort_order
                  )
                  from public.product_images pi
                  where pi.product_id = oi.product_id
                ), '[]'::jsonb)
              )
            )
            order by oi.created_at, oi.id
          )
          from public.order_items oi
          where oi.order_id = o.id
        ), '[]'::jsonb),
        'payments', (
          select jsonb_build_object(
            'method', p.method,
            'status', p.status,
            'amount_minor', p.amount_minor
          )
          from public.payments p
          where p.order_id = o.id
          limit 1
        )
      )
      order by o.created_at desc, o.id desc
    )
    from (
      select o.*
      from public.orders o
      where o.customer_id = v_uid
        and (v_from is null or o.created_at >= v_from)
        and (v_to is null or o.created_at < v_to)
        and (coalesce(array_length(p_statuses, 1), 0) = 0
             or o.status::text = any(p_statuses))
        and (not p_to_review or (
          o.status = 'delivered'
          and exists (
            select 1
            from public.order_items oi
            where oi.order_id = o.id
              and not exists (
                select 1 from public.reviews r
                where r.order_item_id = oi.id
              )
          )
        ))
        and (v_search is null
             or o.id::text ilike '%' || v_search || '%'
             or exists (
                  select 1
                  from public.order_items oi
                  where oi.order_id = o.id
                    and (oi.product_name ilike '%' || v_search || '%'
                         or coalesce(oi.variant_name, '')
                            ilike '%' || v_search || '%')))
      order by o.created_at desc, o.id desc
      limit v_limit offset v_offset
    ) o
  ), '[]'::jsonb);
end;
$$;

-- ----------------------------------------------------- product search
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
  v_from timestamptz := public.store_day_start(p_from);
  v_to timestamptz := public.store_day_start(p_to + 1);
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

