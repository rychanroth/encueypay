-- Campaign banners (user decision 2026-10-28, Option A): a banner belongs
-- to a promotion; its Discovery target is DERIVED from the promotion's
-- scope at read time (brand → brand-filtered feed, platform → the full
-- feed). Campaign coupons carry auto_apply = true and the single best
-- eligible one is applied at order placement automatically (best auto +
-- manual codes stack, capped at the subtotal — user decision).
--
-- Cleanups riding along: the dead promotions banner_* columns, the unused
-- banners target columns, and the promotions_discount_value_check that
-- referenced banner_status (discount positivity is enforced by the RPCs).

alter table public.coupons
  add column auto_apply boolean not null default false;

alter table public.order_coupons
  add column auto_applied boolean not null default false;

alter table public.banners
  drop column if exists target_kind,
  drop column if exists target_id,
  drop column if exists target_name;

alter table public.promotions
  drop constraint if exists promotions_discount_value_check,
  drop column if exists banner_image_path,
  drop column if exists banner_status;

-- Promotions are customer-facing data (product-card discount chips, banner
-- target derivation, the campaign name on the checkout preview) — the
-- frozen baseline only granted SELECT to admins, which made every
-- customer-side promotion query return empty while the SECURITY DEFINER
-- discount RPCs kept working. Reads become public; writes stay
-- admin/creator-only.
create policy promotions_public_read on public.promotions for select using (true);

-- --------------------------------------------------- campaign creation
-- One atomic call: promotion + auto_apply coupon + approved banner. The
-- Discovery target is derived from the promotion's scope at read time, so
-- the banner carries no target of its own.
CREATE OR REPLACE FUNCTION public.admin_create_campaign(
    p_name text,
    p_description text,
    p_image_path text,
    p_discount_type public.discount_type,
    p_discount_value bigint,
    p_min_order_amount_minor bigint DEFAULT 0,
    p_starts_at timestamptz DEFAULT NULL,
    p_ends_at timestamptz DEFAULT NULL,
    p_brand_id uuid DEFAULT NULL
) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
declare
  v_promotion_id uuid;
  v_coupon_id uuid;
  v_coupon_code text;
  v_banner_id uuid;
  v_scope public.promotion_scope;
begin
  if not public.is_admin() then
    raise exception 'Only admins can create campaigns';
  end if;
  if coalesce(trim(p_name), '') = '' then
    raise exception 'Campaign name is required';
  end if;
  if coalesce(p_image_path, '') = '' then
    raise exception 'Campaign image is required';
  end if;
  if p_discount_value is null or p_discount_value <= 0 then
    raise exception 'Campaign discount must be positive';
  end if;
  if p_discount_type = 'percent' and p_discount_value > 100 then
    raise exception 'Percent discounts are capped at 100';
  end if;
  if p_brand_id is null then
    v_scope := 'platform';
  else
    if not exists (select 1 from public.brands where id = p_brand_id) then
      raise exception 'Brand not found';
    end if;
    v_scope := 'brand';
  end if;

  insert into public.promotions
    (created_by, scope, brand_id, name, description, discount_type,
     discount_value)
  values
    (auth.uid(), v_scope, p_brand_id, p_name, p_description,
     p_discount_type, p_discount_value)
  returning id into v_promotion_id;

  -- The campaign coupon is auto-generated and auto-applies at checkout
  -- (manual code entry remains available for out-of-band distribution).
  -- The campaign window lives on the COUPON (promotions carries no window
  -- columns — windows moved to coupons in 20261008000003).
  v_coupon_code := 'CAMP-'
    || upper(left(replace(gen_random_uuid()::text, '-', ''), 8));
  insert into public.coupons
    (promotion_id, code, min_order_amount_minor, starts_at, ends_at,
     auto_apply)
  values
    (v_promotion_id, v_coupon_code, p_min_order_amount_minor,
     p_starts_at, p_ends_at, true)
  returning id into v_coupon_id;

  -- Campaign banners are live immediately (single-admin prototype); the
  -- moderation actions remain available for reject/disable later.
  insert into public.banners
    (created_by, name, description, image_path, ends_at, status,
     promotion_id)
  values
    (auth.uid(), p_name, p_description, p_image_path, p_ends_at,
     'approved', v_promotion_id)
  returning id into v_banner_id;

  perform public.record_admin_audit(
    'admin_create_campaign', 'promotion', v_promotion_id,
    jsonb_build_object('code', v_coupon_code, 'scope', v_scope,
                       'discount_value', p_discount_value));
  return jsonb_build_object(
    'promotion_id', v_promotion_id,
    'coupon_id', v_coupon_id,
    'coupon_code', v_coupon_code,
    'banner_id', v_banner_id,
    'scope', v_scope);
end;
$$;

-- ------------------------------------------------- promotion kill switch
CREATE OR REPLACE FUNCTION public.admin_set_promotion_active(
    p_promotion_id uuid,
    p_active boolean
) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can toggle promotions';
  end if;

  update public.promotions
     set active = p_active
   where id = p_promotion_id;
  if not found then
    raise exception 'Promotion not found';
  end if;

  perform public.record_admin_audit(
    'admin_set_promotion_active', 'promotion', p_promotion_id,
    jsonb_build_object('active', p_active));
end;
$$;

-- ------------------------------------------- display-only banner creation
-- Restated without target parameters: a promotion-less banner is inert
-- imagery. Targeted banners are campaigns (admin_create_campaign).
CREATE OR REPLACE FUNCTION public.admin_create_banner(
    p_name text,
    p_description text,
    p_image_url text,
    p_ends_at timestamptz DEFAULT NULL
) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
declare
  v_banner_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can create banners';
  end if;

  insert into public.banners
    (created_by, name, description, image_path, ends_at, status)
  values
    (auth.uid(), p_name, p_description, p_image_url, p_ends_at, 'pending')
  returning id into v_banner_id;

  perform public.record_admin_audit(
    'admin_create_banner', 'banner', v_banner_id,
    jsonb_build_object('name', p_name));
  return v_banner_id;
end;
$$;

-- ---------------------------------------------------- order auto-apply
-- Full restatement: identical to 20261013000008 except the coupon block —
-- the temp set gains an `auto` flag and, after the user-code loop, the
-- single best eligible auto_apply coupon joins the set (mirrors
-- preview_cart_discounts).
CREATE OR REPLACE FUNCTION public.create_order_from_cart(
    p_address_id uuid,
    p_payment_method public.payment_method,
    p_coupon_codes text[] DEFAULT '{}',
    p_note text DEFAULT ''
) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_user uuid := auth.uid();
  v_cart_id uuid;
  v_address public.addresses;
  v_settings public.platform_settings;
  v_item_count integer;
  v_valid_item_count integer;
  v_item record;
  v_stock record;
  v_subtotal bigint := 0;
  v_discount_total bigint := 0;
  v_delivery_fee bigint := 0;
  v_order_id uuid;
  v_base bigint;
  v_code text;
  v_coupon record;
  v_coupon_discount bigint;
  v_best_discount bigint := 0;
  v_best_coupon_id uuid;
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

  -- Validity chain: active variant of an active product (server authority,
  -- pivot map §4.3).
  select count(*) into v_valid_item_count
  from public.cart_items ci
  join public.product_variants pv on pv.id = ci.product_variant_id
  join public.products p on p.id = pv.product_id
  where ci.cart_id = v_cart_id
    and pv.status = 'active' and p.status = 'active';
  if v_valid_item_count <> v_item_count then
    raise exception 'Some items in your cart are no longer available';
  end if;

  -- Lock every product referenced by the cart before validating stock
  -- (deterministic order to avoid deadlocks between concurrent checkouts).
  perform 1
  from public.products p
  where p.id in (
    select pv.product_id
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    where ci.cart_id = v_cart_id
  )
  order by p.id
  for update of p;

  -- Stock: wanted quantity must fit within current stock (map §4.3).
  for v_stock in
    select p.id, p.name, p.stock,
           sum(ci.quantity) as wanted
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    join public.products p on p.id = pv.product_id
    where ci.cart_id = v_cart_id
    group by p.id, p.name, p.stock
  loop
    if v_stock.wanted > v_stock.stock then
      raise exception 'Insufficient stock for %', v_stock.name;
    end if;
  end loop;

  -- Price the order from the database — client prices are never trusted.
  for v_item in
    select ci.quantity,
           coalesce(pv.price_minor, p.base_price_minor) as unit_price
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    join public.products p on p.id = pv.product_id
    where ci.cart_id = v_cart_id
  loop
    v_subtotal := v_subtotal + v_item.unit_price * v_item.quantity;
  end loop;

  -- Coupons (map §2/§6): windows live on the coupon; the minimum-order gate
  -- applies to the scope's applicable subtotal. `auto` marks the campaign
  -- coupon picked below (order_coupons records the attribution).
  -- Drop-guard, pg_temp-qualified: the function's search_path is public,
  -- so an unqualified drop would miss the temp table if this RPC ran twice
  -- inside one transaction.
  drop table if exists pg_temp._coupon_discounts;
  create temp table _coupon_discounts (
    coupon_id uuid primary key,
    discount bigint not null,
    auto boolean not null default false
  ) on commit drop;

  foreach v_code in array p_coupon_codes loop
    if coalesce(trim(v_code), '') = '' then
      continue;
    end if;

    select c.id, pr.scope, pr.brand_id,
           pr.discount_type, pr.discount_value, c.min_order_amount_minor
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

    -- Applicable base for the coupon's scope (single-seller: platform or
    -- brand only).
    v_base := case v_coupon.scope
      when 'brand' then (
        select coalesce(sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity), 0)
        from public.cart_items ci
        join public.product_variants pv on pv.id = ci.product_variant_id
        join public.products p on p.id = pv.product_id
        where ci.cart_id = v_cart_id and p.brand_id = v_coupon.brand_id
      )
      else v_subtotal
    end;

    if v_base = 0 then
      raise exception 'Coupon % does not apply to your cart', v_code;
    end if;
    if v_base < v_coupon.min_order_amount_minor then
      raise exception 'Coupon % requires a minimum order of %', v_code,
        v_coupon.min_order_amount_minor;
    end if;

    v_coupon_discount := case v_coupon.discount_type
      when 'fixed' then least(v_coupon.discount_value, v_base)
      else (v_base * v_coupon.discount_value) / 100
    end;

    insert into pg_temp._coupon_discounts (coupon_id, discount)
    values (v_coupon.id, v_coupon_discount);

    v_discount_total := v_discount_total + v_coupon_discount;
  end loop;

  -- Campaign auto-apply (user decision 2026-10-28): the single best
  -- eligible auto_apply coupon joins the discount set unless already
  -- redeemed manually — the selection mirrors preview_cart_discounts.
  v_best_discount := 0;
  for v_coupon in
    select c.id, c.min_order_amount_minor,
           pr.discount_type, pr.discount_value,
           case pr.scope
             when 'brand' then (
               select coalesce(sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity), 0)
               from public.cart_items ci
               join public.product_variants pv on pv.id = ci.product_variant_id
               join public.products p on p.id = pv.product_id
               where ci.cart_id = v_cart_id and p.brand_id = pr.brand_id
             )
             else v_subtotal
           end as base
    from public.coupons c
    join public.promotions pr on pr.id = c.promotion_id
    where c.auto_apply
      and c.active
      and (c.starts_at is null or c.starts_at <= now())
      and (c.ends_at is null or c.ends_at >= now())
      and not exists (
        select 1 from pg_temp._coupon_discounts d where d.coupon_id = c.id
      )
  loop
    if v_coupon.base = 0 or v_coupon.base < v_coupon.min_order_amount_minor then
      continue;
    end if;
    v_coupon_discount := case v_coupon.discount_type
      when 'fixed' then least(v_coupon.discount_value, v_coupon.base)
      else (v_coupon.base * v_coupon.discount_value) / 100
    end;
    if v_coupon_discount > v_best_discount then
      v_best_discount := v_coupon_discount;
      v_best_coupon_id := v_coupon.id;
    end if;
  end loop;
  if v_best_coupon_id is not null then
    insert into pg_temp._coupon_discounts (coupon_id, discount, auto)
    values (v_best_coupon_id, v_best_discount, true);
  end if;
  v_discount_total := least(v_discount_total + v_best_discount, v_subtotal);

  -- Commit path — every insert below is one transaction.
  insert into public.orders (
    customer_id, shipping_recipient_name, shipping_phone, shipping_line1,
    shipping_line2, shipping_city, subtotal_minor, discount_minor,
    delivery_fee_minor, total_minor, note
  ) values (
    v_user, v_address.recipient_name, v_address.phone, v_address.line1,
    v_address.line2, v_address.city, v_subtotal, v_discount_total,
    v_delivery_fee, v_subtotal - v_discount_total + v_delivery_fee, p_note
  ) returning id into v_order_id;

  insert into public.payments (order_id, method, amount_minor, status)
  values (
    v_order_id, p_payment_method, v_subtotal - v_discount_total + v_delivery_fee,
    case when p_payment_method = 'bank_transfer'
         then 'awaiting_payment_verification'::public.payment_status
         else 'pending'::public.payment_status end
  );

  -- Order items hang off the order directly (single lifecycle, map §4.1).
  insert into public.order_items (
    order_id, product_id, product_variant_id, product_name, variant_name,
    unit_price_minor, discount_minor, quantity, line_total_minor
  )
  select
    v_order_id, p.id, ci.product_variant_id, p.name, pv.name,
    coalesce(pv.price_minor, p.base_price_minor), 0, ci.quantity,
    coalesce(pv.price_minor, p.base_price_minor) * ci.quantity
  from public.cart_items ci
  join public.product_variants pv on pv.id = ci.product_variant_id
  join public.products p on p.id = pv.product_id
  where ci.cart_id = v_cart_id;

  -- Set-based stock deduction from the same locked rows (map §4.3).
  update public.products p
     set stock = p.stock - w.wanted
    from (
      select pv.product_id as pid, sum(ci.quantity) as wanted
      from public.cart_items ci
      join public.product_variants pv on pv.id = ci.product_variant_id
      where ci.cart_id = v_cart_id
      group by pv.product_id
    ) w
   where p.id = w.pid;

  -- Historical coupon record (map §4.6): actual discounts even if the
  -- promotion/coupon changes or is deleted later — with auto-apply
  -- attribution.
  insert into public.order_coupons (order_id, coupon_id, discount_minor, auto_applied)
  select v_order_id, coupon_id, discount, auto
  from pg_temp._coupon_discounts;

  delete from public.cart_items where cart_id = v_cart_id;

  return v_order_id;
end;
$$;

-- --------------------------------------------------- checkout preview
-- Same selection as create_order_from_cart's coupon block — the preview
-- shown on the checkout summary can never disagree with placement.
CREATE OR REPLACE FUNCTION public.preview_cart_discounts(
    p_codes text[] DEFAULT '{}'
) RETURNS jsonb
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_user uuid := auth.uid();
  v_cart_id uuid;
  v_subtotal bigint := 0;
  v_base bigint;
  v_code text;
  v_coupon record;
  v_discount bigint;
  v_manual jsonb := '[]'::jsonb;
  v_manual_ids uuid[] := '{}';
  v_total bigint := 0;
  v_best_discount bigint := 0;
  v_best record;
  v_auto jsonb;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;

  select id into v_cart_id from public.carts where user_id = v_user;
  if v_cart_id is null then
    return jsonb_build_object(
      'manual', '[]'::jsonb, 'auto', null, 'total_discount_minor', 0);
  end if;

  select coalesce(sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity), 0)
    into v_subtotal
  from public.cart_items ci
  join public.product_variants pv on pv.id = ci.product_variant_id
  join public.products p on p.id = pv.product_id
  where ci.cart_id = v_cart_id;

  -- Manual codes: invalid ones are skipped (the per-code validate_coupon
  -- RPC already surfaced them at entry time).
  for v_code in select unnest(coalesce(p_codes, '{}')) loop
    if coalesce(trim(v_code), '') = '' then
      continue;
    end if;

    select c.id, pr.scope, pr.brand_id,
           pr.discount_type, pr.discount_value, c.min_order_amount_minor
    into v_coupon
    from public.coupons c
    join public.promotions pr on pr.id = c.promotion_id
    where upper(c.code) = upper(trim(v_code))
      and c.active
      and (c.starts_at is null or c.starts_at <= now())
      and (c.ends_at is null or c.ends_at >= now());
    if not found then
      continue;
    end if;

    v_base := case v_coupon.scope
      when 'brand' then (
        select coalesce(sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity), 0)
        from public.cart_items ci
        join public.product_variants pv on pv.id = ci.product_variant_id
        join public.products p on p.id = pv.product_id
        where ci.cart_id = v_cart_id and p.brand_id = v_coupon.brand_id
      )
      else v_subtotal
    end;
    if v_base = 0 or v_base < v_coupon.min_order_amount_minor then
      continue;
    end if;

    v_discount := case v_coupon.discount_type
      when 'fixed' then least(v_coupon.discount_value, v_base)
      else (v_base * v_coupon.discount_value) / 100
    end;

    v_manual := v_manual || jsonb_build_object(
      'code', v_code, 'discount_minor', v_discount);
    v_manual_ids := v_manual_ids || v_coupon.id;
    v_total := v_total + v_discount;
  end loop;

  -- Campaign auto-apply: the single best eligible coupon (same gates and
  -- tie-break as create_order_from_cart).
  v_best_discount := 0;
  for v_coupon in
    select c.id, c.code, pr.name, pr.scope,
           pr.discount_type, pr.discount_value, c.min_order_amount_minor,
           case pr.scope
             when 'brand' then (
               select coalesce(sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity), 0)
               from public.cart_items ci
               join public.product_variants pv on pv.id = ci.product_variant_id
               join public.products p on p.id = pv.product_id
               where ci.cart_id = v_cart_id and p.brand_id = pr.brand_id
             )
             else v_subtotal
           end as base
    from public.coupons c
    join public.promotions pr on pr.id = c.promotion_id
    where c.auto_apply
      and c.active
      and (c.starts_at is null or c.starts_at <= now())
      and (c.ends_at is null or c.ends_at >= now())
      and not (c.id = any(v_manual_ids))
    order by c.created_at asc
  loop
    if v_coupon.base = 0 or v_coupon.base < v_coupon.min_order_amount_minor then
      continue;
    end if;
    v_discount := case v_coupon.discount_type
      when 'fixed' then least(v_coupon.discount_value, v_coupon.base)
      else (v_coupon.base * v_coupon.discount_value) / 100
    end;
    if v_discount > v_best_discount then
      v_best_discount := v_discount;
      v_best := v_coupon;
    end if;
  end loop;

  if v_best is not null then
    v_auto := jsonb_build_object(
      'code', v_best.code,
      'name', v_best.name,
      'scope', v_best.scope,
      'discount_minor', v_best_discount);
    v_total := v_total + v_best_discount;
  end if;

  return jsonb_build_object(
    'manual', v_manual,
    'auto', v_auto,
    'total_discount_minor', least(v_total, v_subtotal));
end;
$$;
