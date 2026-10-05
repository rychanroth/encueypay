-- 2-Role Academic Prototype, Section 7D (living spec Part B §7): order
-- cancellation with the QR flow — decisions (user, 2026-10-05):
--   * customers self-cancel pending/confirmed orders regardless of payment
--     state; a verified payment flips to refund_required (recorded — the
--     prototype does not move real money);
--   * the admin "marks refunded" (payment → refunded + reference),
--     completing the assignment's payment vocabulary; a notification fires
--     on every payment-status change so the customer sees the refund
--     recorded.

-- Cancellation: ANY verified payment becomes refund-required (not just
-- bank transfers — QR money may already have moved).
create or replace function public.cancel_order(p_order_id uuid, p_reason text default 'Cancelled by customer')
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
    select 1 from public.orders
    where id = p_order_id
      and status not in ('pending', 'confirmed')
  ) then
    raise exception 'Order can no longer be cancelled';
  end if;

  update public.orders
  set status = 'cancelled',
      cancelled_at = now(),
      cancellation_reason = coalesce(nullif(trim(p_reason), ''), 'Cancelled by customer')
  where id = p_order_id;

  -- Stock restore (§2d): quantities come from the historical order items.
  update public.products p
  set stock = p.stock + restored.qty
  from (
    select oi.product_id, sum(oi.quantity) as qty
    from public.order_items oi
    where oi.order_id = p_order_id
    group by oi.product_id
  ) restored
  where p.id = restored.product_id;

  -- Payment consequences (§7D): a verified payment means money moved —
  -- record that a refund is owed. Unpaid methods stay pending.
  update public.payments p
  set status = case
    when p.status = 'transaction_verified'
      then 'refund_required'::public.payment_status
    else p.status
  end
  where p.order_id = p_order_id;
end;
$$;

-- Admin records the refund (§7D): refund_required → refunded with the
-- transfer reference. Completes the payment vocabulary.
create or replace function public.mark_refunded(
  p_order_id uuid,
  p_reference text default null
)
returns void
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
begin
  if not public.is_admin() then
    raise exception 'Only admins can record refunds';
  end if;

  update public.payments p
  set status = 'refunded'::public.payment_status,
      transaction_reference = coalesce(
        nullif(trim(p_reference), ''), p.transaction_reference)
  where p.order_id = p_order_id
    and p.status = 'refund_required';
  if not found then
    raise exception 'No refund-pending payment for this order';
  end if;

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor, 'payment_refunded', 'order', p_order_id,
          jsonb_build_object('reference', p_reference));
end;
$$;

-- Payment lifecycle notifications (assignment §8 "payment statuses"):
-- verified = payment received; refund_required = refund owed; refunded =
-- refund recorded.
create or replace function public.notify_on_payment_status()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_customer uuid;
  v_title text;
begin
  if old.status is distinct from new.status then
    select customer_id into v_customer from public.orders where id = new.order_id;
    v_title := case new.status::text
      when 'transaction_verified' then 'Payment received'
      when 'refund_required' then 'Refund pending'
      when 'refunded' then 'Refund recorded'
      else null
    end;
    if v_title is not null then
      -- 'order' type: payment statuses are part of the order experience
      -- (the notification_type enum has no 'payment' value; adding one in
      -- the same transaction as its first use is not possible).
      perform public.notify(
        v_customer, 'order', v_title,
        'Order ' || new.order_id::text || ': payment is now '
          || replace(new.status::text, '_', ' ') || '.');
    end if;
  end if;
  return new;
end;
$$;

create trigger payments_notify_status
  after update of status on public.payments
  for each row
  execute function public.notify_on_payment_status();
