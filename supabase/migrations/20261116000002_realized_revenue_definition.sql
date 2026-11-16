-- Realized-revenue definition (reporting bug, 2026-11-16).
--
-- "Gross realized revenue", AOV and the dashboard hero counted every order
-- that was not cancelled/returned — including unpaid pending QR orders. A
-- pending $56.50 QR order therefore inflated realized revenue and deflated
-- AOV. Realized means the money actually arrived or the goods were handed
-- over:
--
--   * delivered  -> cash-on-delivery collected (COD may still carry a
--                   pending payment row until the admin records it), or
--   * payment.status = 'transaction_verified' -> QR/bank money received,
--   * never cancelled/returned, and never with a refunded/refund-required
--     payment.
--
-- The predicate lives in the `realized_orders` view so both RPCs share one
-- definition. Views are security_invoker (like cart_item_details): the admin
-- SECURITY DEFINER RPCs run as the owner and see every row, while a direct
-- PostgREST read still applies the caller's RLS. No SELECT grant is added.

create or replace view public.realized_orders
  with (security_invoker = true) as
select o.*
from public.orders o
where o.status not in ('cancelled', 'returned')
  and (
    o.status = 'delivered'
    or exists (
      select 1
      from public.payments pm
      where pm.order_id = o.id
        and pm.status = 'transaction_verified'
    )
  )
  and not exists (
    select 1
    from public.payments pm
    where pm.order_id = o.id
      and pm.status in ('refunded', 'refund_required')
  );

comment on view public.realized_orders is
  'Orders whose revenue is realized: delivered (COD collected) or with a '
  'verified payment, excluding cancelled/returned and refunded payments.';

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
        select date_trunc('day', o.created_at)::date as day,
               count(*) as orders,
               coalesce(sum(o.total_minor), 0) as sales_minor
        from public.realized_orders o
        where o.created_at >= now() - interval '14 days'
        group by date_trunc('day', o.created_at)::date
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
       where o.created_at >= p_from and o.created_at < p_to + 1
    ),
    'completed_orders', (
      select count(*) from public.orders o
       where o.created_at >= p_from and o.created_at < p_to + 1
         and o.status = 'delivered'
    ),
    'cancelled_orders', (
      select count(*) from public.orders o
       where o.created_at >= p_from and o.created_at < p_to + 1
         and o.status = 'cancelled'
    ),
    'realized_orders', (
      select count(*) from public.realized_orders o
       where o.created_at >= p_from and o.created_at < p_to + 1
    ),
    'total_sales_minor', coalesce((
      select sum(o.total_minor) from public.realized_orders o
       where o.created_at >= p_from and o.created_at < p_to + 1
    ), 0),
    -- AOV denominator = realized order count (never all orders).
    'average_order_value_minor', coalesce((
      select sum(o.total_minor) / greatest(count(*), 1)
      from public.realized_orders o
       where o.created_at >= p_from and o.created_at < p_to + 1
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
        where o.created_at >= p_from and o.created_at < p_to + 1
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
        where o.created_at >= p_from and o.created_at < p_to + 1
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
        where o.created_at >= p_from and o.created_at < p_to + 1
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
      where o.created_at >= p_from and o.created_at < p_to + 1
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
        where o.created_at >= p_from and o.created_at < p_to + 1
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
      where o.created_at >= p_from and o.created_at < p_to + 1
        and pm.status = 'transaction_verified'
    ), 0)
  );
end;
$$;
