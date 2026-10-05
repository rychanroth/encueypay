-- 2-Role Academic Prototype, Section 8A (living spec Part B §1/§8): the
-- customer overview panels. Spending now counts only orders that
-- CONTRIBUTED — cancelled and returned orders are excluded (user decision);
-- supporting counts + a cart subtotal feed the Profile-embedded panels.

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
      where o.status in ('pending', 'confirmed', 'processing', 'packed',
                         'shipped', 'out_for_delivery')
    ),
    'completed_orders', (
      select count(*) from my_orders o where o.status = 'delivered'
    ),
    'cancelled_orders', (
      select count(*) from my_orders o
      where o.status in ('cancelled', 'returned')
    ),
    'total_orders', (select count(*) from my_orders),
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
    'cart_subtotal_minor', (
      select coalesce(sum(coalesce(pv.price_minor, p.base_price_minor)
        * ci.quantity), 0)
      from public.cart_items ci
      join public.carts c on c.id = ci.cart_id
      join public.product_variants pv on pv.id = ci.product_variant_id
      join public.products p on p.id = pv.product_id
      where c.user_id = auth.uid()
    ),
    -- Spending = orders that actually contributed (cancelled/returned
    -- excluded, §8A).
    'total_spending_minor', (
      select coalesce(sum(total_minor), 0) from my_orders
      where status not in ('cancelled', 'returned')
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
                 when o.status in ('pending', 'confirmed', 'processing',
                                   'packed', 'shipped', 'out_for_delivery')
                   then 'active'
                 when o.status in ('cancelled', 'returned') then 'cancelled'
                 else 'completed'
               end as state
        from my_orders o
        order by o.created_at desc
        limit 5
      ) recent
    )
  );
$$;
