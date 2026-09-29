-- Fix "infinite recursion detected in policy for relation business_orders"
-- and the update paths that silently no-op'd under RLS.
--
-- 1. business_orders_driver_update's USING read pickup_stops under RLS, and
--    pickup_stops_read's business-owner branch read business_orders back — a
--    mutual cycle that made ANY business_orders UPDATE fail at plan time
--    (accepting an order included). The driver check moves into a SECURITY
--    DEFINER helper, terminating the cycle (same pattern as 0019).
-- 2. The driver policy was the ONLY update policy on business_orders: the
--    owner's accept/reject/prepare/ready transitions matched zero rows.
--    An explicit owner policy closes that gap.
-- 3. cancel_order (customer) and mark_delivered's COD payment flip (driver)
--    had no covering update policies either — both RPCs already authorize
--    their caller internally, so they run as SECURITY DEFINER instead of
--    gaining broad table policies.

-- ─────────────────────────────────────────────────────────────────────────────
-- 1+2. Cycle-free business_orders update policies
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.owns_business_order_driver(
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
      and d.driver_id = auth.uid()
  );
$$;

drop policy if exists "business_orders_driver_update" on public.business_orders;
create policy "business_orders_driver_update" on public.business_orders
  for update
  using (public.owns_business_order_driver(id))
  with check (public.owns_business_order_driver(id));

create policy "business_orders_owner_update" on public.business_orders
  for update
  using (exists (
    select 1 from public.businesses b
    where b.id = business_id and b.owner_id = auth.uid()
  ))
  with check (exists (
    select 1 from public.businesses b
    where b.id = business_id and b.owner_id = auth.uid()
  ));

-- ─────────────────────────────────────────────────────────────────────────────
-- 3. cancel_order: definer so the customer's business_orders update lands
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.cancel_order(p_order_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user uuid := auth.uid();
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;

  if not exists (
    select 1 from public.orders
    where id = p_order_id and customer_id = v_user
  ) then
    raise exception 'Order not found';
  end if;

  if exists (
    select 1 from public.business_orders
    where order_id = p_order_id and status <> 'pending'
  ) then
    raise exception 'Order can no longer be cancelled';
  end if;

  update public.business_orders
  set status = 'cancelled', rejection_reason = 'Cancelled by customer'
  where order_id = p_order_id and status = 'pending';

  -- Payment consequences (§12/§21): only verified transfers need refunds.
  update public.payments p
  set status = case
    when p.method = 'bank_transfer'
         and p.status = 'transaction_verified'
      then 'refund_required'::public.payment_status
    else p.status
  end
  where p.order_id = p_order_id;

  update public.deliveries
  set status = 'cancelled'
  where order_id = p_order_id;
end;
$$;

-- mark_delivered: definer so the COD payment flip lands (no driver update
-- policy exists on payments). Caller authorization stays explicit:
-- the delivery row must be assigned to auth.uid().
create or replace function public.mark_delivered(p_delivery_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_order_id uuid;
begin
  update public.deliveries d
  set status = 'delivered'
  where d.id = p_delivery_id
    and d.driver_id = auth.uid()
    and d.status = 'delivery_in_progress'
  returning d.order_id into v_order_id;
  if not found then
    raise exception 'Delivery cannot be completed';
  end if;

  -- COD is collected on successful delivery (§20.1).
  update public.payments p
  set status = 'transaction_verified',
      paid_at = now()
  where p.order_id = v_order_id
    and p.method = 'cod'
    and p.status = 'pending';
end;
$$;
