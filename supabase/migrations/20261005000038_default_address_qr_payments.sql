-- 2-Role Academic Prototype, Section 6b (living spec Part B §6): default
-- address + QR payment (ABA PayWay / Bakong KHQR) infrastructure.
--
-- Payment model (user decision): QR replaces manual bank transfer in the
-- checkout UI (the enum value stays for legacy rows). Confirmation is
-- real-time: PayWay pushes a server-to-server webhook to the
-- `payway-webhook` Edge Function (HMAC-validated; inert without the
-- PAYWAY_API_KEY secret); the Bakong path polls `check_transaction_by_md5`
-- via the `bakong-check` Edge Function (inert without the BAKONG_TOKEN
-- secret). Both converge on confirm_qr_payment (service-role or admin
-- authority). A dev-only simulate_qr_payment (admin) demos the full
-- pending → paid flow locally. External prerequisites are documented in the
-- living spec (Part A.5).

-- ------------------------------------------------------ default address
alter table public.addresses add column is_default boolean not null default false;

-- At most one default per user.
create unique index addresses_one_default_idx
  on public.addresses (user_id) where is_default;

-- Backfill: the oldest address becomes the default where none is set.
update public.addresses a
set is_default = true
where a.id = (
  select b.id from public.addresses b
  where b.user_id = a.user_id
  order by b.is_default desc, b.created_at
  limit 1
)
and not exists (
  select 1 from public.addresses c
  where c.user_id = a.user_id and c.is_default
);

create or replace function public.set_default_address(p_address_id uuid)
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
    select 1 from public.addresses
    where id = p_address_id and user_id = v_user
  ) then
    raise exception 'Address not found';
  end if;

  update public.addresses set is_default = false where user_id = v_user;
  update public.addresses set is_default = true where id = p_address_id;
end;
$$;

-- --------------------------------------------------- QR payment plumbing
alter type public.payment_method add value 'qr';

alter table public.payments add column qr_payload text;
alter table public.payments add column qr_md5 text;
-- Gateway/verification reference (spec §40 "Transaction/reference
-- information") — recorded by the confirming path.
alter table public.payments add column transaction_reference text;

-- The Bakong account that receives QR payments (admin-managed prototype
-- configuration; empty = QR unavailable in the checkout UI).
alter table public.platform_settings add column qr_account_id text not null default '';

-- The customer registers the generated KHQR against their pending payment.
-- The MD5 transaction key is computed from the payload by the confirming
-- path (Postgres md5()) — never trusted from the client.
create or replace function public.register_qr_payment(
  p_order_id uuid,
  p_payload text
)
returns void
language plpgsql
as $$
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;

  update public.payments p
  set qr_payload = p_payload,
      qr_md5 = md5(p_payload)
  from public.orders o
  where o.id = p.order_id
    and o.id = p_order_id
    and o.customer_id = auth.uid()
    and p.method = 'qr'
    and p.status = 'pending';
  if not found then
    raise exception 'Payment cannot be registered';
  end if;
end;
$$;

-- The convergence point for every confirmation path (webhook, poller,
-- simulation). Callable by the service role (Edge Functions) or an admin
-- (simulation); customers cannot call it.
create or replace function public.confirm_qr_payment(
  p_order_id uuid,
  p_reference text default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_role text := coalesce(
    current_setting('request.jwt.claims', true)::json ->> 'role', '');
  v_actor uuid := auth.uid();
begin
  if v_role <> 'service_role' and not public.is_admin() then
    raise exception 'Not authorized to confirm payments';
  end if;

  update public.payments p
  set status = 'transaction_verified',
      paid_at = now(),
      transaction_reference = coalesce(p_reference, p.transaction_reference)
  where p.order_id = p_order_id
    and p.method = 'qr'
    and p.status = 'pending';
  if not found then
    raise exception 'Payment cannot be confirmed';
  end if;

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor, 'qr_payment_confirmed', 'order', p_order_id,
          jsonb_build_object('reference', p_reference));
end;
$$;

-- Dev-only simulation of a confirmed gateway webhook (admin authority), so
-- the full pending → paid → realtime flow demos without credentials.
create or replace function public.simulate_qr_payment(p_order_id uuid)
returns void
language plpgsql
as $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can simulate payments';
  end if;
  perform public.confirm_qr_payment(p_order_id, 'simulated');
end;
$$;

-- Realtime: the order-success screen watches the payment flip.
alter publication supabase_realtime add table payments;
