-- Admin records a cash-on-delivery payment after delivery (prototype
-- simulation). Reusing transaction_verified keeps reports, customer labels,
-- and the payments notification trigger consistent with QR payments.
CREATE OR REPLACE FUNCTION public.admin_mark_cod_paid(p_order_id uuid)
RETURNS void
    LANGUAGE plpgsql
    SET search_path TO 'public'
    AS $$
declare
  v_status public.order_status;
  v_method public.payment_method;
  v_pay public.payment_status;
begin
  if not public.is_admin() then
    raise exception 'Only admins can record cash payments';
  end if;

  select o.status, p.method, p.status
    into v_status, v_method, v_pay
  from public.orders o
  join public.payments p on p.order_id = o.id
  where o.id = p_order_id;

  if not found then
    raise exception 'Order not found';
  end if;
  if v_method <> 'cod' then
    raise exception 'Only cash-on-delivery payments can be marked paid';
  end if;
  if v_status <> 'delivered' then
    raise exception 'Cash is collected when the order is delivered';
  end if;
  if v_pay = 'transaction_verified' then
    return;
  end if;

  update public.payments
     set status = 'transaction_verified',
         paid_at = now(),
         transaction_reference = 'cod'
   where order_id = p_order_id
     and method = 'cod';

  perform public.record_admin_audit(
    'admin_mark_cod_paid', 'payment', p_order_id,
    jsonb_build_object('method', 'cod'));
end;
$$;
