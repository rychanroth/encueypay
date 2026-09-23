-- Phase 12: analytics & reports (spec §2.2/§2.4, §58 GetBusinessAnalytics).
-- Server-computed aggregates (§53); client only displays.

create or replace function public.get_business_analytics()
returns jsonb
language plpgsql
stable
as $$
declare
  v_user uuid := auth.uid();
  v_business_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  select id into v_business_id from public.businesses where owner_id = v_user;
  if v_business_id is null then
    raise exception 'No business found';
  end if;

  return jsonb_build_object(
    'total_sales_minor', coalesce((
      select sum(bo.subtotal_minor - bo.discount_minor)
      from public.business_orders bo
      where bo.business_id = v_business_id
        and bo.status in ('completed', 'ready', 'preparing', 'accepted')
    ), 0),
    'order_count', coalesce((
      select count(*) from public.business_orders bo
      where bo.business_id = v_business_id
    ), 0),
    'pending_count', coalesce((
      select count(*) from public.business_orders bo
      where bo.business_id = v_business_id and bo.status = 'pending'
    ), 0),
    'completed_count', coalesce((
      select count(*) from public.business_orders bo
      where bo.business_id = v_business_id and bo.status = 'completed'
    ), 0),
    'rejected_count', coalesce((
      select count(*) from public.business_orders bo
      where bo.business_id = v_business_id
        and bo.status in ('rejected', 'cancelled')
    ), 0),
    'top_products', coalesce((
      select jsonb_agg(jsonb_build_object(
        'name', t.name, 'quantity', t.qty, 'revenue_minor', t.revenue
      ) order by t.revenue desc)
      from (
        select oi.product_name as name, sum(oi.quantity) as qty,
               sum(oi.line_total_minor) as revenue
        from public.order_items oi
        join public.business_orders bo on bo.id = oi.business_order_id
        where bo.business_id = v_business_id
        group by oi.product_name
        order by revenue desc
        limit 5
      ) t
    ), '[]'::jsonb)
  );
end;
$$;

create or replace function public.get_platform_report()
returns jsonb
language plpgsql
stable
as $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can view reports';
  end if;

  return jsonb_build_object(
    'order_count', coalesce((select count(*) from public.orders), 0),
    'gmv_minor', coalesce((
      select sum(o.total_minor) from public.orders o
      where exists (
        select 1 from public.business_orders bo
        where bo.order_id = o.id
          and bo.status not in ('rejected', 'cancelled')
      )
    ), 0),
    'delivery_fees_minor', coalesce((
      select sum(o.delivery_fee_minor) from public.orders o
      where exists (
        select 1 from public.business_orders bo
        where bo.order_id = o.id
          and bo.status not in ('rejected', 'cancelled')
      )
    ), 0),
    'active_businesses', coalesce((
      select count(*) from public.businesses where status = 'active'
    ), 0),
    'active_products', coalesce((
      select count(*) from public.products where status = 'active'
    ), 0),
    'pending_applications', coalesce((
      select count(*) from public.role_applications where status = 'pending'
    ), 0)
  );
end;
$$;
