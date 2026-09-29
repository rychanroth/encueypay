-- TransactionHistory (spec §58 analytics, per-day profit):
-- Business profit = net revenue (subtotal − discount) of a completed
-- business order, booked when the driver picks it up. Driver profit = the
-- delivery earning, booked on delivery. Neither lifecycle transition had a
-- timestamp, so the completion moments are recorded from here on; the
-- per-day listing RPCs are SECURITY DEFINER because their joins cross
-- RLS boundaries the caller legitimately cannot read (an owner/driver has
-- no select on orders) — both self-authorize via owner_id/driver_id.

alter table public.business_orders add column if not exists completed_at timestamptz;
alter table public.deliveries add column if not exists delivered_at timestamptz;

-- Pickup completion completes the business portion (§11) — book the moment.
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
  set status = 'completed',
      completed_at = now()
  from public.pickup_stops ps
  where ps.id = p_stop_id
    and ps.business_order_id = bo.id;

  update public.deliveries
  set status = 'pickup_in_progress'
  where id = v_delivery_id and status = 'assigned';
end;
$$;

-- Delivery completion books the driver's earning moment (§20.1).
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
  set status = 'delivered',
      delivered_at = now()
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

create or replace function public.get_business_transactions(p_day date)
returns table(id uuid, occurred_at timestamptz, amount bigint, label text)
language sql
stable
security definer
set search_path = public
as $$
  select bo.id, bo.completed_at, bo.subtotal_minor - bo.discount_minor,
         coalesce(u.full_name, 'Customer')
  from public.business_orders bo
  join public.orders o on o.id = bo.order_id
  join public.users u on u.id = o.customer_id
  where bo.business_id = (
      select b.id from public.businesses b where b.owner_id = auth.uid()
    )
    and bo.status = 'completed'
    and bo.completed_at is not null
    and bo.completed_at::date = p_day
  order by bo.completed_at desc;
$$;

create or replace function public.get_driver_transactions(p_day date)
returns table(id uuid, occurred_at timestamptz, amount bigint, label text)
language sql
stable
security definer
set search_path = public
as $$
  select d.id, d.delivered_at, d.driver_earning_minor,
         coalesce(o.shipping_city, 'Delivery')
  from public.deliveries d
  join public.orders o on o.id = d.order_id
  where d.driver_id = auth.uid()
    and d.status = 'delivered'
    and d.delivered_at is not null
    and d.delivered_at::date = p_day
  order by d.delivered_at desc;
$$;
