-- 2-Role Academic Prototype, Section 5 (living spec Part B §1): customer
-- dashboard. One server-side aggregation per sign-in user — the assignment's
-- §1 "Customer Dashboard" vocabulary: recent orders, active orders, wishlist
-- count, cart items, total spending. auth.uid()-scoped by construction; the
-- definer form avoids relying on every underlying table's select policy.

create or replace function public.get_customer_dashboard()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  with my_orders as (
    select o.*
    from public.orders o
    where o.customer_id = auth.uid()
  )
  select jsonb_build_object(
    'active_orders', (
      select count(*) from my_orders o
      where exists (
        select 1 from public.business_orders bo
        where bo.order_id = o.id
          and bo.status in ('pending', 'accepted', 'preparing', 'ready')
      )
    ),
    'wishlist_count', (
      select count(*) from public.wishlist_items wi
      join public.wishlists w on w.id = wi.wishlist_id
      where w.user_id = auth.uid()
    ),
    'cart_items', (
      select coalesce(sum(ci.quantity), 0) from public.cart_items ci
      join public.carts c on c.id = ci.cart_id
      where c.user_id = auth.uid()
    ),
    'total_spending_minor', (
      select coalesce(sum(total_minor), 0) from my_orders
    ),
    'recent_orders', (
      select coalesce(jsonb_agg(jsonb_build_object(
               'id', recent.id,
               'total_minor', recent.total_minor,
               'created_at', recent.created_at,
               'state', recent.state
             ) order by recent.created_at desc), '[]'::jsonb)
      from (
        select o.id, o.total_minor, o.created_at,
               case
                 when exists (
                   select 1 from public.business_orders bo
                   where bo.order_id = o.id
                     and bo.status in ('pending', 'accepted', 'preparing', 'ready')
                 ) then 'active'
                 when exists (
                   select 1 from public.business_orders bo
                   where bo.order_id = o.id
                     and bo.status in ('rejected', 'cancelled')
                 ) then 'cancelled'
                 else 'completed'
               end as state
        from my_orders o
        order by o.created_at desc
        limit 5
      ) recent
    )
  );
$$;
