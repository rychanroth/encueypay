-- Executive report extras (DESIGN.md §5.2.4): get_sales_report gains
-- additive keys — payment gateway distribution (KHQR vs COD), brand revenue
-- rankings, inventory capital valuation, and the net settled balance.
-- Existing keys are preserved verbatim.

CREATE OR REPLACE FUNCTION public.get_sales_report(p_from date, p_to date) RETURNS jsonb
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can view reports';
  end if;

  return jsonb_build_object(
    'from', p_from::text,
    'to', p_to::text,
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
    'total_sales_minor', coalesce((
      select sum(o.total_minor) from public.orders o
       where o.created_at >= p_from and o.created_at < p_to + 1
         and o.status not in ('cancelled', 'returned')
    ), 0),
    'average_order_value_minor', coalesce((
      select sum(o.total_minor) / greatest(count(*), 1)
      from public.orders o
       where o.created_at >= p_from and o.created_at < p_to + 1
         and o.status not in ('cancelled', 'returned')
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
      select jsonb_agg(jsonb_build_object('name', t.name, 'units', t.units))
      from (
        select oi.product_name as name, sum(oi.quantity) as units
        from public.order_items oi
        join public.orders o on o.id = oi.order_id
        where o.created_at >= p_from and o.created_at < p_to + 1
          and o.status not in ('cancelled', 'returned')
        group by oi.product_name
        order by units desc
        limit 5
      ) t
    ), '[]'::jsonb),
    'top_categories', coalesce((
      select jsonb_agg(jsonb_build_object('name', t.name, 'units', t.units))
      from (
        select c.name, sum(oi.quantity) as units
        from public.order_items oi
        join public.orders o on o.id = oi.order_id
        join public.products p on p.id = oi.product_id
        join public.categories c on c.id = p.category_id
        where o.created_at >= p_from and o.created_at < p_to + 1
          and o.status not in ('cancelled', 'returned')
        group by c.name
        order by units desc
        limit 5
      ) t
    ), '[]'::jsonb),
    'purchase_frequency', coalesce((
      select jsonb_agg(jsonb_build_object('name', t.name, 'orders', t.orders))
      from (
        select u.full_name as name, count(*) as orders
        from public.orders o
        join public.users u on u.id = o.customer_id
        where o.created_at >= p_from and o.created_at < p_to + 1
        group by u.full_name
        order by orders desc
        limit 5
      ) t
    ), '[]'::jsonb),
    -- Payment gateway distribution (§5.2.4): realized orders only, split by
    -- the order's payment method row.
    'payment_split', coalesce((
      select jsonb_build_object(
        'qr_count', count(*) filter (where pm.method = 'qr'),
        'cod_count', count(*) filter (where pm.method = 'cod'),
        'qr_amount_minor', coalesce(sum(pm.amount_minor) filter (where pm.method = 'qr'), 0),
        'cod_amount_minor', coalesce(sum(pm.amount_minor) filter (where pm.method = 'cod'), 0)
      )
      from public.payments pm
      join public.orders o on o.id = pm.order_id
      where o.created_at >= p_from and o.created_at < p_to + 1
        and o.status not in ('cancelled', 'returned')
    ), jsonb_build_object(
      'qr_count', 0, 'cod_count', 0, 'qr_amount_minor', 0, 'cod_amount_minor', 0
    )),
    -- Brand revenue rankings (§5.2.4): realized order items joined to the
    -- catalog brand.
    'brand_revenue', coalesce((
      select jsonb_agg(jsonb_build_object('name', t.name, 'revenue_minor', t.revenue_minor))
      from (
        select coalesce(b.name, 'Unbranded') as name,
               sum(oi.line_total_minor) as revenue_minor
        from public.order_items oi
        join public.orders o on o.id = oi.order_id
        join public.products p on p.id = oi.product_id
        left join public.brands b on b.id = p.brand_id
        where o.created_at >= p_from and o.created_at < p_to + 1
          and o.status not in ('cancelled', 'returned')
        group by coalesce(b.name, 'Unbranded')
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
