-- 2-Role Academic Prototype, Section 5b (living spec Part B §5): the
-- promotion/coupon/banner redesign, per the e-commerce convention (user
-- decision, 2026-10-05):
--
--   promotion  = the discount RULE      (scope platform|brand|legacy business,
--                                        mechanic type+value, manual kill switch)
--   coupon     = the redemption TOOL    (code, min order amount, start/end
--                                        window, status; FK -> promotion)
--   banner     = the ADVERTISING SURFACE (image, optional promotion reference,
--                                        display window, moderation status)
--
-- The old single-table model — banner rows inside `promotions` with
-- banner_status/banner_image_path and an exemption from the discount check —
-- is dissolved. Existing banner rows are migrated into `banners`; the banner
-- columns and the discount-check exemption are dropped.
--
-- Expiration is DERIVED at evaluation time (validate_coupon / checkout check
-- `active AND now within [starts_at, ends_at]` plus the promotion kill
-- switch). No Edge Function/cron: derived checks are authoritative and never
-- stale. `promotions.active` is the admin's manual kill switch.

-- ----------------------------------------------------------------- banners
create table public.banners (
  id uuid primary key default gen_random_uuid(),
  created_by uuid not null references public.users (id),
  name text not null,
  description text not null default '',
  image_path text not null,
  -- The promotion (if any) the banner advertises — an ad may reference a
  -- coupon-bearing promotion or nothing at all.
  promotion_id uuid references public.promotions (id) on delete set null,
  starts_at timestamptz,
  ends_at timestamptz,
  status public.banner_status not null default 'pending',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.banners enable row level security;

create policy "banners_public_read_approved" on public.banners
  for select
  using (status = 'approved');

create policy "banners_admin_read" on public.banners
  for select
  using (public.is_admin());

create policy "banners_creator_insert" on public.banners
  for insert
  with check (auth.uid() = created_by);

create policy "banners_creator_read" on public.banners
  for select
  using (auth.uid() = created_by);

create policy "banners_admin_update" on public.banners
  for update
  using (public.is_admin())
  with check (public.is_admin());

-- Migrate existing banner rows (any promotion that carried an image).
insert into public.banners
  (created_by, name, description, image_path, starts_at, ends_at, status,
   created_at, updated_at)
select created_by, name, description, banner_image_path, starts_at, ends_at,
       case when banner_status = 'none' then 'pending'::public.banner_status
            else banner_status end,
       created_at, updated_at
from public.promotions
where banner_image_path is not null;

-- ------------------------------------------------- promotions → pure rules
alter table public.promotions add column active boolean not null default true;

alter table public.promotions drop column banner_status;
alter table public.promotions drop column banner_image_path;
alter table public.promotions drop column starts_at;
alter table public.promotions drop column ends_at;

-- Banners are gone from the table: restore the strict discount check.
alter table public.promotions drop constraint promotions_discount_value_check;
alter table public.promotions
  add constraint promotions_discount_value_check
  check (discount_value > 0);

-- ------------------------------------------------ coupons: assignment §5 set
alter table public.coupons
  add column min_order_amount_minor bigint not null default 0
    check (min_order_amount_minor >= 0);
alter table public.coupons add column starts_at timestamptz;
alter table public.coupons add column ends_at timestamptz;

-- Legacy expiry carries over as the window end.
update public.coupons
set ends_at = expires_at
where ends_at is null and expires_at is not null;

-- ---------------------------------------------------- RPC re-creations
-- Atomic admin creation: promotion (rule + scope) + its first coupon
-- (code + min order + window) in one call.
create or replace function public.create_platform_promotion(
  p_name text,
  p_description text,
  p_discount_type public.discount_type,
  p_discount_value bigint,
  p_code text,
  p_min_order_amount_minor bigint default 0,
  p_starts_at timestamptz default null,
  p_ends_at timestamptz default null,
  p_brand_id uuid default null
)
returns uuid
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_promotion_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can create promotions';
  end if;
  if p_discount_type = 'percent' and (p_discount_value < 1 or p_discount_value > 100) then
    raise exception 'Percent discount must be 1..100';
  end if;
  if coalesce(trim(p_code), '') = '' then
    raise exception 'Coupon code is required';
  end if;
  if p_min_order_amount_minor < 0 then
    raise exception 'Invalid minimum order amount';
  end if;
  if p_brand_id is not null and not exists (
    select 1 from public.brands br where br.id = p_brand_id
  ) then
    raise exception 'Brand not found';
  end if;

  insert into public.promotions (
    created_by, scope, brand_id, name, description, discount_type, discount_value
  ) values (
    v_user,
    case when p_brand_id is null then 'platform'::public.promotion_scope
         else 'brand'::public.promotion_scope end,
    p_brand_id,
    trim(p_name), coalesce(p_description, ''),
    p_discount_type, p_discount_value
  ) returning id into v_promotion_id;

  insert into public.coupons
    (promotion_id, code, active, min_order_amount_minor, starts_at, ends_at)
  values (
    v_promotion_id, upper(trim(p_code)), true,
    p_min_order_amount_minor, p_starts_at, p_ends_at
  );

  return v_promotion_id;
end;
$$;

-- Coupon validation against the FULL assignment §5 attribute set: existence,
-- status, date window (derived), promotion kill switch, scope eligibility
-- (checked by the caller against the cart), and minimum order amount.
create or replace function public.validate_coupon(p_code text)
returns jsonb
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_cart_id uuid;
  v_coupon record;
  v_subtotal bigint := 0;
  v_scope_subtotal bigint;
  v_discount bigint;
begin
  if v_user is null then
    return jsonb_build_object('valid', false, 'message', 'Not authenticated');
  end if;
  select id into v_cart_id from public.carts where user_id = v_user;

  select c.id, pr.scope, pr.business_id, pr.brand_id, pr.active as promotion_active,
         c.min_order_amount_minor, c.starts_at, c.ends_at,
         pr.discount_type, pr.discount_value
  into v_coupon
  from public.coupons c
  join public.promotions pr on pr.id = c.promotion_id
  where upper(c.code) = upper(trim(p_code))
    and c.active
    and (c.starts_at is null or c.starts_at <= now())
    and (c.ends_at is null or c.ends_at >= now());
  if not found then
    return jsonb_build_object('valid', false, 'message', 'Invalid or expired coupon');
  end if;
  if not v_coupon.promotion_active then
    return jsonb_build_object('valid', false, 'message', 'Coupon is disabled');
  end if;

  select coalesce(sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity), 0)
  into v_subtotal
  from public.cart_items ci
  join public.product_variants pv on pv.id = ci.product_variant_id
  join public.products p on p.id = pv.product_id
  where ci.cart_id = v_cart_id;

  if v_coupon.scope = 'business' then
    select coalesce(sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity), 0)
    into v_scope_subtotal
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    join public.products p on p.id = pv.product_id
    where ci.cart_id = v_cart_id and p.business_id = v_coupon.business_id;
  elsif v_coupon.scope = 'brand' then
    select coalesce(sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity), 0)
    into v_scope_subtotal
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    join public.products p on p.id = pv.product_id
    where ci.cart_id = v_cart_id and p.brand_id = v_coupon.brand_id;
  else
    v_scope_subtotal := v_subtotal;
  end if;

  if v_coupon.scope <> 'platform' and v_scope_subtotal = 0 then
    return jsonb_build_object('valid', false, 'message', 'Coupon does not apply to your cart');
  end if;

  -- Minimum order amount applies to the eligible-scope subtotal (§5b).
  if v_scope_subtotal < v_coupon.min_order_amount_minor then
    return jsonb_build_object(
      'valid', false,
      'message', 'Coupon requires a minimum order of '
        || (v_coupon.min_order_amount_minor / 100.0)::text || ' for the eligible items');
  end if;

  v_discount := case v_coupon.discount_type
    when 'fixed' then least(v_coupon.discount_value, v_scope_subtotal)
    else (v_scope_subtotal * v_coupon.discount_value) / 100
  end;

  return jsonb_build_object('valid', true, 'discount_minor', v_discount);
end;
$$;

-- Checkout mirrors validate_coupon (§53): window, kill switch, scope
-- eligibility, and minimum order amount — then applies and records the
-- discount. Stock logic from 0032 is unchanged.
create or replace function public.create_order_from_cart(
  p_address_id uuid,
  p_payment_method public.payment_method,
  p_coupon_codes text[] default '{}'
)
returns uuid
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_cart_id uuid;
  v_address public.addresses;
  v_settings public.platform_settings;
  v_item_count integer;
  v_valid_item_count integer;
  v_item record;
  v_subtotal bigint := 0;
  v_discount_total bigint := 0;
  v_delivery_fee bigint := 0;
  v_order_id uuid;
  v_business_order_id uuid;
  v_delivery_id uuid;
  v_business record;
  v_biz_subtotal bigint;
  v_biz_discount bigint;
  v_seq integer := 0;
  v_code text;
  v_coupon record;
  v_coupon_discount bigint;
  v_scope_subtotal bigint;
  v_share bigint;
  v_allocated bigint;
  v_largest_business uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;

  select id into v_cart_id from public.carts where user_id = v_user;
  if v_cart_id is null then
    raise exception 'Cart is empty';
  end if;
  select count(*) into v_item_count from public.cart_items where cart_id = v_cart_id;
  if v_item_count = 0 then
    raise exception 'Cart is empty';
  end if;

  select * into v_address
  from public.addresses
  where id = p_address_id and user_id = v_user;
  if not found then
    raise exception 'Invalid delivery address';
  end if;

  select * into v_settings from public.platform_settings where id = 1;
  v_delivery_fee := coalesce(v_settings.delivery_fee_minor, 0);

  -- Every cart line must still be an active variant of an active product at
  -- an active business (server authority, §53). Archived = disabled =
  -- unpurchasable (§2d), so the active-product requirement stands.
  select count(*) into v_valid_item_count
  from public.cart_items ci
  join public.product_variants pv on pv.id = ci.product_variant_id
  join public.products p on p.id = pv.product_id
  join public.businesses b on b.id = p.business_id
  where ci.cart_id = v_cart_id
    and pv.status = 'active' and p.status = 'active' and b.status = 'active';
  if v_valid_item_count <> v_item_count then
    raise exception 'Some items in your cart are no longer available';
  end if;

  -- Lock product rows for the transaction, validate product-wide stock per
  -- line, and price the order from the database (§2d; §50).
  for v_item in
    select ci.quantity, p.stock, p.name as product_name,
           coalesce(pv.price_minor, p.base_price_minor) as unit_price
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    join public.products p on p.id = pv.product_id
    where ci.cart_id = v_cart_id
    for update of p
  loop
    if v_item.quantity > v_item.stock then
      raise exception 'Insufficient stock for %', v_item.product_name;
    end if;
    v_subtotal := v_subtotal + v_item.unit_price * v_item.quantity;
  end loop;

  -- Coupons (§24–§26 + §2d brand scope + §5b windows/min-order):
  -- server-authoritative validation; scoped discounts are tracked per
  -- business so each business_order gets its share.
  create temp table _biz_discount (
    business_id uuid primary key,
    discount bigint not null
  ) on commit drop;

  create temp table _coupon_discounts (
    coupon_id uuid primary key,
    business_id uuid,
    discount bigint not null
  ) on commit drop;

  foreach v_code in array p_coupon_codes loop
    if coalesce(trim(v_code), '') = '' then
      continue;
    end if;

    select c.id, pr.scope, pr.business_id, pr.brand_id, pr.active as promotion_active,
           c.min_order_amount_minor,
           pr.discount_type, pr.discount_value
    into v_coupon
    from public.coupons c
    join public.promotions pr on pr.id = c.promotion_id
    where upper(c.code) = upper(trim(v_code))
      and c.active
      and (c.starts_at is null or c.starts_at <= now())
      and (c.ends_at is null or c.ends_at >= now());
    if not found then
      raise exception 'Coupon % is invalid or expired', v_code;
    end if;
    if not v_coupon.promotion_active then
      raise exception 'Coupon % is disabled', v_code;
    end if;

    if v_coupon.scope = 'business' then
      select coalesce(sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity), 0)
      into v_scope_subtotal
      from public.cart_items ci
      join public.product_variants pv on pv.id = ci.product_variant_id
      join public.products p on p.id = pv.product_id
      where ci.cart_id = v_cart_id
        and p.business_id = v_coupon.business_id;
      if v_scope_subtotal = 0 then
        raise exception 'Coupon % does not apply to your cart', v_code;
      end if;
      if v_scope_subtotal < v_coupon.min_order_amount_minor then
        raise exception 'Coupon % requires a higher eligible subtotal', v_code;
      end if;
      v_coupon_discount := case v_coupon.discount_type
        when 'fixed' then least(v_coupon.discount_value, v_scope_subtotal)
        else (v_scope_subtotal * v_coupon.discount_value) / 100
      end;
      insert into _biz_discount (business_id, discount)
      values (v_coupon.business_id, v_coupon_discount)
      on conflict (business_id)
      do update set discount = _biz_discount.discount + excluded.discount;

    elsif v_coupon.scope = 'brand' then
      select coalesce(sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity), 0)
      into v_scope_subtotal
      from public.cart_items ci
      join public.product_variants pv on pv.id = ci.product_variant_id
      join public.products p on p.id = pv.product_id
      where ci.cart_id = v_cart_id
        and p.brand_id = v_coupon.brand_id;
      if v_scope_subtotal = 0 then
        raise exception 'Coupon % does not apply to your cart', v_code;
      end if;
      if v_scope_subtotal < v_coupon.min_order_amount_minor then
        raise exception 'Coupon % requires a higher eligible subtotal', v_code;
      end if;
      v_coupon_discount := case v_coupon.discount_type
        when 'fixed' then least(v_coupon.discount_value, v_scope_subtotal)
        else (v_scope_subtotal * v_coupon.discount_value) / 100
      end;

      v_allocated := 0;
      v_largest_business := null;
      for v_business in
        select p.business_id,
               sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity) as biz_sub
        from public.cart_items ci
        join public.product_variants pv on pv.id = ci.product_variant_id
        join public.products p on p.id = pv.product_id
        where ci.cart_id = v_cart_id
          and p.brand_id = v_coupon.brand_id
        group by p.business_id
        order by biz_sub desc
      loop
        if v_largest_business is null then
          v_largest_business := v_business.business_id;
        end if;
        v_share := (v_coupon_discount * v_business.biz_sub) / v_scope_subtotal;
        v_allocated := v_allocated + v_share;
        insert into _biz_discount (business_id, discount)
        values (v_business.business_id, v_share)
        on conflict (business_id)
        do update set discount = _biz_discount.discount + excluded.discount;
      end loop;
      insert into _biz_discount (business_id, discount)
      values (v_largest_business, v_coupon_discount - v_allocated)
      on conflict (business_id)
      do update set discount = _biz_discount.discount + excluded.discount;

    else
      if v_subtotal < v_coupon.min_order_amount_minor then
        raise exception 'Coupon % requires a higher subtotal', v_code;
      end if;
      v_coupon_discount := case v_coupon.discount_type
        when 'fixed' then least(v_coupon.discount_value, v_subtotal)
        else (v_subtotal * v_coupon.discount_value) / 100
      end;
    end if;

    insert into _coupon_discounts (coupon_id, business_id, discount)
    values (v_coupon.id, v_coupon.business_id, v_coupon_discount);

    v_discount_total := v_discount_total + v_coupon_discount;
  end loop;
  v_discount_total := least(v_discount_total, v_subtotal);

  -- Commit path — every insert below is one transaction (§51).
  insert into public.orders (
    customer_id, shipping_recipient_name, shipping_phone, shipping_line1,
    shipping_line2, shipping_city, subtotal_minor, discount_minor,
    delivery_fee_minor, total_minor
  ) values (
    v_user, v_address.recipient_name, v_address.phone, v_address.line1,
    v_address.line2, v_address.city, v_subtotal, v_discount_total,
    v_delivery_fee, v_subtotal - v_discount_total + v_delivery_fee
  ) returning id into v_order_id;

  insert into public.payments (order_id, method, amount_minor, status)
  values (
    v_order_id, p_payment_method, v_subtotal - v_discount_total + v_delivery_fee,
    case when p_payment_method = 'bank_transfer'
         then 'awaiting_payment_verification'::public.payment_status
         else 'pending'::public.payment_status end
  );

  insert into public.deliveries (order_id, delivery_fee_minor, driver_earning_minor)
  values (
    v_order_id, v_delivery_fee,
    v_delivery_fee * coalesce(v_settings.driver_commission_percent, 0) / 100
  ) returning id into v_delivery_id;

  v_seq := 0;
  for v_business in
    select p.business_id, b.name as business_name
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    join public.products p on p.id = pv.product_id
    join public.businesses b on b.id = p.business_id
    where ci.cart_id = v_cart_id
    group by p.business_id, b.name
    order by b.name
  loop
    v_seq := v_seq + 1;
    select coalesce(sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity), 0)
    into v_biz_subtotal
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    join public.products p on p.id = pv.product_id
    where ci.cart_id = v_cart_id and p.business_id = v_business.business_id;
    -- scalar subquery: no coupon row -> 0 (SELECT INTO would assign NULL)
    v_biz_discount := coalesce(
      (select discount from _biz_discount where business_id = v_business.business_id),
      0);

    insert into public.business_orders (order_id, business_id, subtotal_minor, discount_minor, status)
    values (v_order_id, v_business.business_id, v_biz_subtotal, v_biz_discount, 'pending')
    returning id into v_business_order_id;

    for v_item in
      select ci.product_variant_id, ci.quantity, pv.name as variant_name,
             coalesce(pv.price_minor, p.base_price_minor) as unit_price,
             p.id as product_id, p.name as product_name
      from public.cart_items ci
      join public.product_variants pv on pv.id = ci.product_variant_id
      join public.products p on p.id = pv.product_id
      where ci.cart_id = v_cart_id and p.business_id = v_business.business_id
    loop
      insert into public.order_items (
        business_order_id, product_id, product_variant_id, product_name,
        variant_name, business_name, unit_price_minor, discount_minor,
        quantity, line_total_minor
      ) values (
        v_business_order_id, v_item.product_id, v_item.product_variant_id,
        v_item.product_name, v_item.variant_name, v_business.business_name,
        v_item.unit_price, 0, v_item.quantity,
        v_item.unit_price * v_item.quantity
      );
    end loop;

    -- One PickupStop per participating BusinessOrder (§14/§16).
    insert into public.pickup_stops (delivery_id, business_order_id, sequence, status)
    values (v_delivery_id, v_business_order_id, v_seq, 'pending');
  end loop;

  -- Historical coupon record (§26): actual discounts computed in pass one.
  insert into public.order_coupons (order_id, coupon_id, business_id, discount_minor)
  select v_order_id, coupon_id, business_id, discount
  from _coupon_discounts;

  -- Product-wide stock deduction (§2d/§4). Rows are locked above, so
  -- concurrent checkouts serialize on the same products.
  update public.products p
  set stock = p.stock - sold.qty
  from (
    select p2.id, sum(ci.quantity) as qty
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    join public.products p2 on p2.id = pv.product_id
    where ci.cart_id = v_cart_id
    group by p2.id
  ) sold
  where p.id = sold.id;

  delete from public.cart_items where cart_id = v_cart_id;

  return v_order_id;
end;
$$;

-- Banner submission (business portal — bypassed but kept runtime-correct):
-- now inserts into the banners table.
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
  v_banner_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  if coalesce(trim(p_name), '') = '' then
    raise exception 'Banner name is required';
  end if;

  insert into public.banners
    (created_by, name, description, image_path, ends_at, status)
  values
    (v_user, trim(p_name), coalesce(p_description, ''), p_image_url, p_ends_at,
     'pending')
  returning id into v_banner_id;
  return v_banner_id;
end;
$$;

-- Banner moderation (admin): approve / reject / disable.
create or replace function public.moderate_banner(
  p_banner_id uuid,
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
    raise exception 'Unknown action';
  end if;

  update public.banners
  set status = v_new_status,
      updated_at = now()
  where id = p_banner_id;
  if not found then
    raise exception 'Banner not found';
  end if;
end;
$$;
