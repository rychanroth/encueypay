-- Phase 7: driver delivery (spec §14–§16, §20.1, §35.3, §58 Delivery ops).
--
-- Assignment is atomic: a conditional UPDATE on a still-available row — the
-- first valid driver wins, no two drivers can claim the same delivery
-- (§15.1). Driver rejection returns the delivery to available (§15.2).
-- Delivery may only start once every pickup stop is satisfied (§16); COD is
-- collected at delivery completion (§20.1).

create or replace function public.is_driver()
returns boolean
language sql
stable
as $$
  select exists (
    select 1 from public.users
    where id = auth.uid() and active_role = 'driver'
  );
$$;

-- Row-level update paths for the RPCs below (invoker — RLS applies).
create policy "deliveries_driver_update" on public.deliveries
  for update
  using (
    driver_id = auth.uid()
    or (status = 'available' and driver_id is null and public.is_driver())
  )
  with check (
    driver_id = auth.uid()
    or (status = 'available' and driver_id is null and public.is_driver())
  );

create policy "pickup_stops_driver_update" on public.pickup_stops
  for update
  using (exists (
    select 1 from public.deliveries d
    where d.id = delivery_id and d.driver_id = auth.uid()
  ))
  with check (exists (
    select 1 from public.deliveries d
    where d.id = delivery_id and d.driver_id = auth.uid()
  ));

create policy "business_orders_driver_update" on public.business_orders
  for update
  using (exists (
    select 1 from public.deliveries d
    join public.pickup_stops ps on ps.delivery_id = d.id
    where ps.business_order_id = business_orders.id and d.driver_id = auth.uid()
  ))
  with check (exists (
    select 1 from public.deliveries d
    join public.pickup_stops ps on ps.delivery_id = d.id
    where ps.business_order_id = business_orders.id and d.driver_id = auth.uid()
  ));

create policy "payments_driver_update" on public.payments
  for update
  using (exists (
    select 1 from public.deliveries d
    where d.order_id = payments.order_id and d.driver_id = auth.uid()
  ))
  with check (exists (
    select 1 from public.deliveries d
    where d.order_id = payments.order_id and d.driver_id = auth.uid()
  ));

create or replace function public.accept_delivery(p_delivery_id uuid)
returns void
language plpgsql
as $$
begin
  if not public.is_driver() then
    raise exception 'Only drivers can accept deliveries';
  end if;

  -- Atomic claim: only a still-available row can transition (§15.1).
  update public.deliveries
  set driver_id = auth.uid(),
      status = 'assigned'
  where id = p_delivery_id
    and status = 'available'
    and driver_id is null;
  if not found then
    raise exception 'Delivery is no longer available';
  end if;
end;
$$;

create or replace function public.reject_delivery(p_delivery_id uuid)
returns void
language plpgsql
as $$
begin
  update public.deliveries
  set driver_id = null,
      status = 'available'
  where id = p_delivery_id
    and driver_id = auth.uid()
    and status = 'assigned';
  if not found then
    raise exception 'Delivery cannot be rejected';
  end if;
end;
$$;

create or replace function public.complete_pickup_stop(p_stop_id uuid)
returns void
language plpgsql
as $$
declare
  v_delivery_id uuid;
begin
  update public.pickup_stops ps
  set status = 'completed',
      completed_at = now()
  from public.deliveries d
  where ps.id = p_stop_id
    and d.id = ps.delivery_id
    and d.driver_id = auth.uid()
    and ps.status = 'pending'
    and d.status in ('assigned', 'pickup_in_progress')
  returning ps.delivery_id into v_delivery_id;
  if not found then
    raise exception 'Pickup stop cannot be completed';
  end if;

  -- The business portion is picked up → its lifecycle completes (§11).
  update public.business_orders bo
  set status = 'completed'
  from public.pickup_stops ps
  where ps.id = p_stop_id
    and ps.business_order_id = bo.id;

  update public.deliveries
  set status = 'pickup_in_progress'
  where id = v_delivery_id and status = 'assigned';
end;
$$;

create or replace function public.start_delivery(p_delivery_id uuid)
returns void
language plpgsql
as $$
begin
  -- §16: cannot proceed until the appropriate stops are satisfied.
  update public.deliveries d
  set status = 'delivery_in_progress'
  where d.id = p_delivery_id
    and d.driver_id = auth.uid()
    and d.status = 'pickup_in_progress'
    and not exists (
      select 1 from public.pickup_stops ps
      where ps.delivery_id = d.id and ps.status = 'pending'
    );
  if not found then
    raise exception 'Complete all pickup stops first';
  end if;
end;
$$;

create or replace function public.mark_delivered(p_delivery_id uuid)
returns void
language plpgsql
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
