-- 2-Role Academic Prototype, Section 4 (living spec Part B §8): admin
-- dashboard KPIs. Extends the platform report (0014) with the assignment's
-- §8 dashboard vocabulary: total products/orders/customers/sales,
-- best-selling products, and a 14-day sales trend. Low-stock reporting is
-- possible again since stock returned in 0031. All admin-guarded.

create or replace function public.get_admin_kpis()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'total_products', (select count(*) from public.products),
    'active_products', (
      select count(*) from public.products where status = 'active'
    ),
    'total_orders', (select count(*) from public.orders),
    'total_customers', (
      select count(*) from public.users where active_role = 'customer'
    ),
    'total_sales_minor', (
      select coalesce(sum(total_minor), 0) from public.orders
    ),
    'low_stock_products', (
      select count(*) from public.products
      where status = 'active' and stock > 0 and stock <= 5
    ),
    'out_of_stock_products', (
      select count(*) from public.products
      where status = 'active' and stock <= 0
    ),
    'best_sellers', (
      select coalesce(
        jsonb_agg(jsonb_build_object(
          'name', best.product_name, 'units', best.units
        ) order by best.units desc),
        '[]'::jsonb)
      from (
        select oi.product_name, sum(oi.quantity) as units
        from public.order_items oi
        group by oi.product_name
        order by units desc
        limit 5
      ) best
    ),
    'sales_trend', (
      select coalesce(
        jsonb_agg(jsonb_build_object(
          'day', trend.day, 'orders', trend.orders,
          'sales_minor', trend.sales
        ) order by trend.day),
        '[]'::jsonb)
      from (
        select d::date as day,
               count(o.id) as orders,
               coalesce(sum(o.total_minor), 0) as sales
        from generate_series(
               current_date - interval '13 days', current_date,
               interval '1 day') d
        left join public.orders o on o.created_at::date = d::date
        group by d
        order by d
      ) trend
    )
  );
$$;
