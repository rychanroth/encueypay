-- register_qr_payment idempotency (§6b hardening).
--
-- The client's registration raced its own realtime update: when Realtime
-- was unavailable the client never saw its registered qr_payload and
-- re-fired the RPC on every rebuild. Each call UPDATEs the payments row,
-- which re-triggers Realtime events — a self-feeding loop. The client now
-- registers once per screen instance; this migration also makes the RPC
-- itself idempotent: a pending payment that ALREADY carries a payload is a
-- quiet no-op (same registration twice = same QR), while the pending/qr/
-- ownership guards still reject everything else.
CREATE OR REPLACE FUNCTION public.register_qr_payment(p_order_id uuid, p_payload text)
RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
  v_user uuid := auth.uid();
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;

  -- Idempotent re-registration: the pending payment already carries the
  -- payload → nothing to do (no UPDATE, no exception, no event).
  if exists (
    select 1
      from public.payments p
      join public.orders o on o.id = p.order_id
     where o.id = p_order_id
       and o.customer_id = v_user
       and p.method = 'qr'
       and p.status = 'pending'
       and p.qr_payload is not null
  ) then
    return;
  end if;

  update public.payments p
     set qr_payload = p_payload,
         qr_md5 = md5(p_payload)
    from public.orders o
   where o.id = p.order_id
     and o.id = p_order_id
     and o.customer_id = v_user
     and p.method = 'qr'
     and p.status = 'pending';
  if not found then
    raise exception 'QR payment cannot be registered';
  end if;
end;
$$;
