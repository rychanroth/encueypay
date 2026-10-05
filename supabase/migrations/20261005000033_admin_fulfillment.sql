-- 2-Role Academic Prototype, Section 3 (living spec Part B §7/§8, ledger
-- L-07): admin fulfillment. With the Business Owner and Driver portals
-- bypassed, the Admin Prototype "manages Orders" (assignment §8): it drives
-- the per-business lifecycle and completes the delivery administratively.
--
-- These RPCs MIRROR the effects of the owner/driver RPCs exactly so the
-- customer's derived status, notifications, and payment flows keep working:
--   transition_business_order (0021)  -> admin_transition_business_order
--   complete_pickup_stop (0026) +
--   mark_delivered (0023)             -> admin_complete_order
--   process_return (0019)             -> admin_process_return
-- The original RPCs remain in force untouched for the (hidden) portals.
--
-- Rejection restores product-wide stock (Section 2d): a rejected business
-- order never ships, so its quantities return to the shelf — mirroring the
-- customer-cancellation restore.

-- ------------------------------------------------- business order lifecycle
create or replace function public.admin_transition_business_order(
  p_business_order_id uuid,
  p_target public.business_order_status,
  p_reason text default null
)
returns void
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
  v_current public.business_order_status;
  v_valid boolean;
  v_order_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage orders';
  end if;

  select bo.status, bo.order_id into v_current, v_order_id
  from public.business_orders bo
  where bo.id = p_business_order_id;
  if not found then
    raise exception 'Business order not found';
  end if;

  v_valid := (v_current, p_target) in
    ( ('pending', 'accepted'),
      ('pending', 'rejected'),
      ('accepted', 'preparing'),
      ('preparing', 'ready') );
  if not v_valid then
    raise exception 'Cannot move business order from % to %', v_current, p_target;
  end if;
  if p_target = 'rejected' and coalesce(trim(p_reason), '') = '' then
    raise exception 'Rejection reason is required';
  end if;

  update public.business_orders
  set status = p_target,
      rejection_reason = p_reason
  where id = p_business_order_id;

  if p_target = 'rejected' then
    -- The portion never ships: restore product-wide stock (§2d) from the
    -- historical order items.
    update public.products p
    set stock = p.stock + restored.qty
    from (
      select oi.product_id, sum(oi.quantity) as qty
      from public.order_items oi
      where oi.business_order_id = p_business_order_id
      group by oi.product_id
    ) restored
    where p.id = restored.product_id;

    -- A verified bank transfer becomes RefundRequired (§13/§21) — but only
    -- when every business portion of the order is dead (no partial refunds
    -- in the MVP).
    update public.payments p
    set status = 'refund_required'::public.payment_status
    where p.order_id = v_order_id
      and p.method = 'bank_transfer'
      and p.status = 'transaction_verified'
      and not exists (
        select 1 from public.business_orders other
        where other.order_id = v_order_id
          and other.id <> p_business_order_id
          and other.status not in ('rejected', 'cancelled')
      );
  end if;

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor,
          'admin_business_order_' || p_target::text, 'business_order',
          p_business_order_id,
          jsonb_build_object('from', v_current::text, 'reason', p_reason));
end;
$$;

-- ------------------------------------------------- administrative delivery
-- One-shot completion of an entire order: every accepted+ business part
-- completes (the pickup-stop effects of complete_pickup_stop), the delivery
-- delivers (mark_delivered), and COD verifies. Requires the admin to have
-- accepted every part first — pending parts must be accepted or rejected.
create or replace function public.admin_complete_order(p_order_id uuid)
returns void
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
  v_delivery_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage orders';
  end if;

  if exists (
    select 1 from public.business_orders
    where order_id = p_order_id and status = 'pending'
  ) then
    raise exception 'Accept or reject every business order first';
  end if;
  if not exists (
    select 1 from public.business_orders
    where order_id = p_order_id
      and status in ('accepted', 'preparing', 'ready')
  ) then
    raise exception 'Nothing to complete';
  end if;

  -- Pickup-stop completion effects (0026): stops complete and each business
  -- portion completes with its timestamp.
  update public.pickup_stops ps
  set status = 'completed',
      completed_at = now()
  from public.deliveries d
  where d.id = ps.delivery_id
    and d.order_id = p_order_id
    and ps.status = 'pending';

  update public.business_orders bo
  set status = 'completed',
      completed_at = now()
  where bo.order_id = p_order_id
    and bo.status in ('accepted', 'preparing', 'ready');

  -- Delivery completion effects (0023): delivered + COD verified.
  update public.deliveries d
  set status = 'delivered',
      delivered_at = now()
  where d.order_id = p_order_id
    and d.status <> 'cancelled'
  returning d.id into v_delivery_id;
  if not found then
    raise exception 'Delivery not found';
  end if;

  update public.payments p
  set status = 'transaction_verified',
      paid_at = now()
  where p.order_id = p_order_id
    and p.method = 'cod'
    and p.status = 'pending';

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor, 'admin_order_completed', 'order', p_order_id,
          jsonb_build_object('delivery_id', v_delivery_id));
end;
$$;

-- ----------------------------------------------------------- return reviews
-- Mirrors process_return (0019) with admin authority instead of business
-- ownership: same status transitions and payment consequences.
create or replace function public.admin_process_return(
  p_return_id uuid,
  p_approve boolean
)
returns void
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
  v_order_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage returns';
  end if;

  select order_id into v_order_id
  from public.return_requests
  where id = p_return_id and status = 'pending';
  if not found then
    raise exception 'Return request is already decided';
  end if;

  update public.return_requests
  set status = case when p_approve then 'approved'::public.return_status
                    else 'rejected'::public.return_status end
  where id = p_return_id;

  update public.return_items
  set status = case when p_approve then 'approved'::public.return_status
                    else 'rejected'::public.return_status end
  where return_request_id = p_return_id and status = 'pending';

  if p_approve then
    update public.payments p
    set status = 'refund_required'::public.payment_status
    where p.order_id = v_order_id
      and p.method = 'bank_transfer'
      and p.status = 'transaction_verified';
  end if;

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor, 'admin_return_processed', 'return_request', p_return_id,
          jsonb_build_object('approved', p_approve));
end;
$$;

-- Admin reads every order with its parts/payments/returns (§8 oversight).
-- The customer-scoped select policies stay untouched.
create policy "orders_admin_read" on public.orders
  for select
  using (public.is_admin());

create policy "payments_admin_read" on public.payments
  for select
  using (public.is_admin());
