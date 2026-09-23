-- Phase 5b: customer order cancellation (spec §12/§13/§21/§50).
--
-- Rules (MVP): a customer may cancel the whole order only while EVERY
-- business order is still 'pending' (nothing prepared yet). Cancellation
-- releases the reserved stock; a verified bank transfer becomes
-- RefundRequired (actual refunds stay outside the MVP); the delivery is
-- cancelled.

create or replace function public.cancel_order(p_order_id uuid)
returns void
language plpgsql
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

  -- Release reservations (§7): restore the reserved quantities.
  update public.product_variants pv
  set stock = pv.stock + oi.quantity
  from public.order_items oi
  join public.business_orders bo on bo.id = oi.business_order_id
  where bo.order_id = p_order_id;

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
