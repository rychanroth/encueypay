-- Explicit archive state for sales and coupons (2026-11-17).
--
-- Until now "archived" was derived as `!active || expired`, so the kill switch
-- doubled as archiving: switching a sale off made it vanish into the archive,
-- and the archive was the only place to switch it back on. Status and
-- retirement are different things:
--
--   * `active = false`  -> Disabled: stays in the admin list, flip it back on.
--   * `archived_at`     -> deliberately retired; ONLY the archive action sets
--                          it. Archiving also switches the row off so it can
--                          never price/apply while parked; restoring returns
--                          it to the list as Disabled.
--   * past `ends_at`    -> Ended: simply over, derived, never stored.
--
-- Pricing/redemption paths key off `active` (the `active_sales` view,
-- `validate_coupon`, the order RPCs), which archiving clears — so no pricing
-- function had to change. The view additionally excludes archived rows so a
-- stale client that flips `active` back on still cannot resurrect one.

alter table public.sales add column if not exists archived_at timestamptz;
alter table public.coupons add column if not exists archived_at timestamptz;

comment on column public.sales.archived_at is
  'Set by the dedicated archive action; archived sales never price products.';
comment on column public.coupons.archived_at is
  'Set by the dedicated archive action; archived codes can never be redeemed.';

-- ------------------------------------------------------------- sale status
create or replace function public.admin_set_sale_active(
    p_sale_id uuid,
    p_active boolean
) returns void
    language plpgsql
    as $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can toggle sales';
  end if;
  update public.sales
     set active = p_active
   where id = p_sale_id
     and archived_at is null;
  if not found then
    raise exception 'Sale not found or archived';
  end if;
  perform public.record_admin_audit('admin_set_sale_active', 'sale', p_sale_id,
    jsonb_build_object('active', p_active));
end;
$$;

create or replace function public.admin_set_sale_archived(
    p_sale_id uuid,
    p_archived boolean
) returns void
    language plpgsql
    as $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can archive sales';
  end if;
  update public.sales
     set archived_at = case when p_archived then now() else null end,
         active = case when p_archived then false else active end
   where id = p_sale_id;
  if not found then
    raise exception 'Sale not found';
  end if;
  perform public.record_admin_audit(
    'admin_set_sale_archived', 'sale', p_sale_id,
    jsonb_build_object('archived', p_archived));
end;
$$;

create or replace view public.active_sales with (security_invoker = true) as
  select id, created_by, scope, brand_id, category_id, name, description,
         discount_type, discount_value, active, starts_at, ends_at,
         created_at, updated_at
    from public.sales
   where active
     and archived_at is null
     and (starts_at is null or starts_at <= now())
     and (ends_at is null or ends_at >= now());

grant select on public.active_sales to anon, authenticated;

-- ----------------------------------------------------------- coupon status
create or replace function public.set_coupon_active(
    p_coupon_id uuid,
    p_active boolean
) returns void
    language plpgsql
    as $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can toggle coupons';
  end if;
  update public.coupons
     set active = p_active
   where id = p_coupon_id
     and archived_at is null;
  if not found then
    raise exception 'Coupon not found or archived';
  end if;
  perform public.record_admin_audit(
    'set_coupon_active', 'coupon', p_coupon_id,
    jsonb_build_object('active', p_active));
end;
$$;

create or replace function public.admin_set_coupon_archived(
    p_coupon_id uuid,
    p_archived boolean
) returns void
    language plpgsql
    as $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can archive coupons';
  end if;
  update public.coupons
     set archived_at = case when p_archived then now() else null end,
         active = case when p_archived then false else active end
   where id = p_coupon_id;
  if not found then
    raise exception 'Coupon not found';
  end if;
  perform public.record_admin_audit(
    'admin_set_coupon_archived', 'coupon', p_coupon_id,
    jsonb_build_object('archived', p_archived));
end;
$$;
