-- Driver visibility: the delivery flow's data was invisible to the very
-- role that fulfils it. orders had customer-only select, users only
-- own/admin select, and pickup_stops_read's driver branch joined orders
-- (which RLS filters for drivers) — so an assigned driver saw a blank
-- 'Customer · ,' card with zero stops and, with no stop rows, the only
-- reachable action was "Release delivery". Business names for pickup
-- stops (business_orders(businesses(name))) were equally blocked.
--
-- Helpers are SECURITY DEFINER so each check terminates instead of
-- re-entering RLS (0019 pattern). A browsing driver may preview available
-- deliveries (stop count, pickup businesses, drop-off city); an assigned
-- driver additionally sees their customer's name and address.

create or replace function public.driver_can_view_delivery(p_delivery_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.deliveries
    where id = p_delivery_id
      and (driver_id = auth.uid() or status = 'available')
  );
$$;

create or replace function public.driver_can_view_order(p_order_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.deliveries
    where order_id = p_order_id
      and (driver_id = auth.uid() or status = 'available')
  );
$$;

create or replace function public.driver_can_view_user(p_user_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.deliveries d
    join public.orders o on o.id = d.order_id
    where o.customer_id = p_user_id
      and d.driver_id = auth.uid()
  );
$$;

-- Business names for the driver's pickup-stop UI. One definer check for the
-- whole chain — a policy that subqueries pickup_stops directly would chase
-- pickup_stops_read's business-owner branch back into business_orders.
create or replace function public.driver_can_view_business_order(
  p_business_order_id uuid
)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.deliveries d
    join public.pickup_stops ps on ps.delivery_id = d.id
    where ps.business_order_id = p_business_order_id
      and (d.driver_id = auth.uid() or d.status = 'available')
  );
$$;

-- Shipping address snapshot + customer link for the assigned driver (and
-- the drop-off city preview on available deliveries).
drop policy if exists "orders_driver_select" on public.orders;
create policy "orders_driver_select" on public.orders
  for select using (public.driver_can_view_order(id));

-- Pickup-stop business names for the driver UI.
drop policy if exists "business_orders_driver_select" on public.business_orders;
create policy "business_orders_driver_select" on public.business_orders
  for select using (public.driver_can_view_business_order(id));

-- Customer name for the assigned driver.
drop policy if exists "users_driver_read" on public.users;
create policy "users_driver_read" on public.users
  for select using (public.driver_can_view_user(id));

-- Stops: keep the customer branch, add a helper-based driver branch that
-- no longer depends on the orders join (dead for drivers), keep the
-- business-owner branch.
drop policy if exists "pickup_stops_read" on public.pickup_stops;
create policy "pickup_stops_read" on public.pickup_stops
  for select using (
    exists (
      select 1 from public.deliveries d
      join public.orders o on o.id = d.order_id
      where d.id = delivery_id
        and (o.customer_id = auth.uid() or d.driver_id = auth.uid())
    )
    or public.driver_can_view_delivery(delivery_id)
    or exists (
      select 1 from public.deliveries d
      join public.orders o on o.id = d.order_id
      join public.business_orders bo on bo.id = business_order_id
      join public.businesses b on b.id = bo.business_id
      where d.id = delivery_id and b.owner_id = auth.uid()
    )
  );

-- deliveries_read's available-delivery branch read users directly; route
-- it through is_driver() (SECURITY DEFINER since 0019) so user policies
-- and delivery policies can never chase each other.
drop policy if exists "deliveries_read" on public.deliveries;
create policy "deliveries_read" on public.deliveries
  for select using (
    exists (select 1 from public.orders o where o.id = order_id and o.customer_id = auth.uid())
    or driver_id = auth.uid()
    or (status = 'available' and public.is_driver())
  );
