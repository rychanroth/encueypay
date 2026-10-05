-- 2-Role Academic Prototype, Section 7E (part 2): return completion and the
-- QR refund-consequence fix.

-- Explicit admin completion of an approved return (user decision: a
-- separate action, not automatic on refund recording).
create or replace function public.admin_complete_return(p_return_id uuid)
returns void
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage returns';
  end if;

  update public.return_requests
  set status = 'completed'::public.return_status
  where id = p_return_id and status = 'approved';
  if not found then
    raise exception 'Only approved returns can be completed';
  end if;

  update public.return_items
  set status = 'completed'::public.return_status
  where return_request_id = p_return_id and status = 'approved';

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor, 'admin_return_completed', 'return_request', p_return_id, null);
end;
$$;

-- Approval consequence fix: a VERIFIED payment of ANY method (QR included —
-- previously bank-transfer only) routes to refund_required when a return is
-- approved.
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
      and p.status = 'transaction_verified';
  end if;

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor, 'admin_return_processed', 'return_request', p_return_id,
          jsonb_build_object('approved', p_approve));
end;
$$;
