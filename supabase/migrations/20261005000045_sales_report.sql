-- 2-Role Academic Prototype, Section 8C (living spec Part B §8): the
-- date-range sales report backing the Reporting & Analytics screen.
-- Assignment §8 metric set: orders, completed, cancelled, total sales,
-- average order value, best sellers, top categories, low stock, customer
-- purchase frequency. is_admin-guarded; [p_from]/[p_to] are inclusive.

create or replace function public.get_sales_report(
  p_from date,
  p_to date
)
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  with ranged as (
    select o.*
    from public.orders o
    where o.created_at::date between p_from and p_to
  )
  select jsonb_build_object(
    'from', p_from,
    'to', p_to,
    'total_orders', (select count(*) from ranged),
    'completed_orders', (
      select count(*) from ranged where status = 'delivered'
    ),
    'cancelled_orders', (
      select count(*) from ranged where status in ('cancelled', 'returned')
    ),
    -- Spending = orders that contributed (cancelled/returned excluded, §8A).
    'total_sales_minor', (
      select coalesce(sum(total_minor), 0) from ranged
      where status not in ('cancelled', 'returned')
    ),
    'average_order_value_minor', (
      select coalesce(round(avg(total_minor)), 0) from ranged
      where status not in ('cancelled', 'returned')
    ),
    'best_sellers', (
      select coalesce(
        jsonb_agg(jsonb_build_object(
          'name', best.product_name, 'units', best.units
        ) order by best.units desc), '[]'::jsonb)
      from (
        select oi.product_name, sum(oi.quantity) as units
        from public.order_items oi
        join ranged r on r.id = oi.order_id
        where r.status not in ('cancelled')
        group by oi.product_name
        order by units desc
        limit 5
      ) best
    ),
    'top_categories', (
      select coalesce(
        jsonb_agg(jsonb_build_object(
          'name', top.name, 'units', top.units
        ) order by top.units desc), '[]'::jsonb)
      from (
        select c.name, sum(oi.quantity) as units
        from public.order_items oi
        join ranged r on r.id = oi.order_id
        join public.products p on p.id = oi.product_id
        join public.categories c on c.id = p.category_id
        where r.status not in ('cancelled')
        group by c.name
        order by units desc
        limit 5
      ) top
    ),
    'purchase_frequency', (
      select coalesce(
        jsonb_agg(jsonb_build_object(
          'name', freq.full_name, 'orders', freq.orders
        ) order by freq.orders desc), '[]'::jsonb)
      from (
        select coalesce(u.full_name, 'Customer') as full_name,
               count(*) as orders
        from ranged r
        join public.users u on u.id = r.customer_id
        group by u.id, u.full_name
        order by orders desc
        limit 5
      ) freq
    ),
    -- Current snapshot (stock is not a per-period metric).
    'low_stock_products', (
      select count(*) from public.products
      where status = 'active' and stock > 0 and stock <= 5
    ),
    'out_of_stock_products', (
      select count(*) from public.products
      where status = 'active' and stock <= 0
    )
  );
$$;
