-- Phase 9: promotions management (spec §24–§27, §58 Promotions ops).
--
-- Business coupons need NO admin approval (§27); promotional banners DO.
-- Admin manages platform promotions + banner moderation. Admin authority is
-- explicit (§35.4): banner approve/reject/edit/disable — never order/delivery
-- state overrides.

create or replace function public.is_admin()
returns boolean
language sql
stable
as $$
  select exists (
    select 1 from public.users
    where id = auth.uid() and active_role = 'admin'
  );
$$;

create policy "promotions_admin_read" on public.promotions
  for select using (public.is_admin());

create policy "promotions_admin_update" on public.promotions
  for update using (public.is_admin()) with check (public.is_admin());

create policy "coupons_creator_write" on public.coupons
  for all
  using (exists (
    select 1 from public.promotions p
    where p.id = promotion_id and p.created_by = auth.uid()
  ))
  with check (exists (
    select 1 from public.promotions p
    where p.id = promotion_id and p.created_by = auth.uid()
  ));

-- ------------------------------------------------------------- banners feed
insert into storage.buckets (id, name, public)
values ('promo_assets', 'promo_assets', true)
on conflict (id) do nothing;

create policy "promo_assets_public_read" on storage.objects
  for select using (bucket_id = 'promo_assets');

create policy "promo_assets_creator_write" on storage.objects
  for insert with check (
    bucket_id = 'promo_assets'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "promo_assets_admin_write" on storage.objects
  for update using (bucket_id = 'promo_assets' and public.is_admin())
  with check (bucket_id = 'promo_assets' and public.is_admin());

-- ------------------------------------------------------------------- RPCs
-- Business: ordinary coupon promotion (no approval, §27).
create or replace function public.create_coupon_promotion(
  p_name text,
  p_description text,
  p_discount_type public.discount_type,
  p_discount_value bigint,
  p_code text,
  p_expires_at timestamptz default null
)
returns uuid
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_business_id uuid;
  v_promotion_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  if p_discount_type = 'percent' and (p_discount_value < 1 or p_discount_value > 100) then
    raise exception 'Percent discount must be 1..100';
  end if;
  if coalesce(trim(p_code), '') = '' then
    raise exception 'Coupon code is required';
  end if;

  select id into v_business_id from public.businesses where owner_id = v_user;
  if v_business_id is null then
    raise exception 'No business found';
  end if;

  insert into public.promotions (
    created_by, scope, business_id, name, description,
    discount_type, discount_value
  ) values (
    v_user, 'business', v_business_id, trim(p_name), coalesce(p_description, ''),
    p_discount_type, p_discount_value
  ) returning id into v_promotion_id;

  insert into public.coupons (promotion_id, code, active, expires_at)
  values (v_promotion_id, upper(trim(p_code)), true, p_expires_at);

  return v_promotion_id;
end;
$$;

-- Business: submit a promotional banner for admin approval (§27).
create or replace function public.submit_banner(
  p_name text,
  p_description text,
  p_image_url text,
  p_ends_at timestamptz default null
)
returns uuid
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_business_id uuid;
  v_promotion_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  if coalesce(trim(p_image_url), '') = '' then
    raise exception 'Banner image is required';
  end if;

  select id into v_business_id from public.businesses where owner_id = v_user;
  if v_business_id is null then
    raise exception 'No business found';
  end if;

  insert into public.promotions (
    created_by, scope, business_id, name, description,
    discount_type, discount_value, banner_image_path, banner_status, ends_at
  ) values (
    v_user, 'business', v_business_id, trim(p_name), coalesce(p_description, ''),
    'fixed', 0, p_image_url, 'pending', p_ends_at
  ) returning id into v_promotion_id;

  return v_promotion_id;
end;
$$;

-- Admin: platform-wide promotion with a coupon (§24/§27).
create or replace function public.create_platform_promotion(
  p_name text,
  p_description text,
  p_discount_type public.discount_type,
  p_discount_value bigint,
  p_code text,
  p_expires_at timestamptz default null
)
returns uuid
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_promotion_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can create platform promotions';
  end if;
  if p_discount_type = 'percent' and (p_discount_value < 1 or p_discount_value > 100) then
    raise exception 'Percent discount must be 1..100';
  end if;
  if coalesce(trim(p_code), '') = '' then
    raise exception 'Coupon code is required';
  end if;

  insert into public.promotions (
    created_by, scope, name, description, discount_type, discount_value
  ) values (
    v_user, 'platform', trim(p_name), coalesce(p_description, ''),
    p_discount_type, p_discount_value
  ) returning id into v_promotion_id;

  insert into public.coupons (promotion_id, code, active, expires_at)
  values (v_promotion_id, upper(trim(p_code)), true, p_expires_at);

  return v_promotion_id;
end;
$$;

-- Admin: banner moderation (§27).
create or replace function public.moderate_banner(
  p_promotion_id uuid,
  p_action text
)
returns void
language plpgsql
as $$
declare
  v_new_status public.banner_status;
begin
  if not public.is_admin() then
    raise exception 'Only admins can moderate banners';
  end if;

  v_new_status := case p_action
    when 'approve' then 'approved'::public.banner_status
    when 'reject' then 'rejected'::public.banner_status
    when 'disable' then 'disabled'::public.banner_status
    else null::public.banner_status
  end;
  if v_new_status is null then
    raise exception 'Unknown action %', p_action;
  end if;

  update public.promotions
  set banner_status = v_new_status
  where id = p_promotion_id
    and banner_status in ('pending', 'approved', 'rejected', 'disabled');
  if not found then
    raise exception 'Banner not found';
  end if;
end;
$$;

-- Business: deactivate/reactivate an own coupon.
create or replace function public.set_coupon_active(p_coupon_id uuid, p_active boolean)
returns void
language plpgsql
as $$
begin
  update public.coupons c
  set active = p_active
  from public.promotions p
  where p.id = c.promotion_id
    and c.id = p_coupon_id
    and p.created_by = auth.uid();
  if not found then
    raise exception 'Coupon not found';
  end if;
end;
$$;
