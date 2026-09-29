-- Remove stock tracking (out of scope for this phase) and add per-variant
-- images (one Storage reference per variant, kept in the product_images
-- bucket so the existing path-ownership policies apply).
--
-- The stock columns are dropped; every RPC that validated, reserved,
-- released or rolled up stock is rewritten without those parts. Pricing,
-- availability checks (active variant/product/business), coupon and payment
-- logic are untouched.

alter table public.products drop column if exists stock;
alter table public.product_variants drop column if exists stock;
alter table public.product_variants add column if not exists image_path text;

-- ─────────────────────────────────────────────────────────────────────────────
-- Business portal: create_product without stock
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.create_product(
  p_category_id uuid,
  p_name text,
  p_description text,
  p_base_price_minor bigint,
  p_variants jsonb default '[]'::jsonb
)
returns uuid
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_business_id uuid;
  v_product_id uuid;
  v_variant record;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  select id into v_business_id from public.businesses where owner_id = v_user;
  if v_business_id is null then
    raise exception 'No business found';
  end if;
  if p_base_price_minor < 0 then
    raise exception 'Invalid price';
  end if;

  insert into public.products (business_id, category_id, name, description, base_price_minor)
  values (v_business_id, p_category_id, trim(p_name), coalesce(p_description, ''), p_base_price_minor)
  returning id into v_product_id;

  if jsonb_array_length(p_variants) = 0 then
    -- Keep carts strictly variant-based (§8): auto 'Default' variant.
    insert into public.product_variants (product_id, name, price_minor)
    values (v_product_id, 'Default', null);
  else
    for v_variant in select * from jsonb_to_recordset(p_variants)
        as x(name text, price_minor bigint)
    loop
      insert into public.product_variants (product_id, name, price_minor)
      values (v_product_id, v_variant.name, v_variant.price_minor);
    end loop;
  end if;

  return v_product_id;
end;
$$;

-- Manual stock correction is gone with stock tracking.
drop function if exists public.update_variant_stock(uuid, integer);

-- The pre-migration create_product overload (with p_stock) must go — it
-- shadows the new signature for positional calls and its body references
-- the dropped stock columns.
drop function if exists public.create_product(uuid, text, text, bigint, integer, jsonb);

-- Variant image (§48: Storage owns the binary; the variant owns one
-- reference). SECURITY INVOKER — RLS gates the update; the explicit
-- ownership check keeps the error actionable. null clears the reference.
create or replace function public.set_variant_image(
  p_variant_id uuid,
  p_image_path text
)
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
    select 1
    from public.product_variants pv
    join public.products p on p.id = pv.product_id
    join public.businesses b on b.id = p.business_id
    where pv.id = p_variant_id and b.owner_id = v_user
  ) then
    raise exception 'Variant not found';
  end if;

  update public.product_variants
  set image_path = p_image_path
  where id = p_variant_id;
end;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- Cart: availability stays, the stock clamp is gone
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.add_cart_item(p_variant_id uuid, p_quantity integer)
returns void
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_cart uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  if p_quantity is null or p_quantity < 1 then
    raise exception 'Invalid quantity';
  end if;

  -- Server-authoritative: only active variants of active products at active
  -- businesses are addable (spec §53).
  if not exists (
    select 1
    from public.product_variants pv
    join public.products p on p.id = pv.product_id
    join public.businesses b on b.id = p.business_id
    where pv.id = p_variant_id
      and pv.status = 'active'
      and p.status = 'active'
      and b.status = 'active'
  ) then
    raise exception 'Product is unavailable';
  end if;

  select id into v_cart from public.carts where user_id = v_user;
  if v_cart is null then
    insert into public.carts (user_id) values (v_user) returning id into v_cart;
  end if;

  insert into public.cart_items (cart_id, product_variant_id, quantity)
  values (v_cart, p_variant_id, p_quantity)
  on conflict (cart_id, product_variant_id)
  do update set quantity = public.cart_items.quantity + excluded.quantity;
end;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- Checkout: same pricing/coupon/payment flow, no stock reservation
-- ─────────────────────────────────────────────────────────────────────────────

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

  -- Every cart line must still be an active variant of an active product
  -- at an active business (server authority, §53).
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

  -- Price the order from the database — client prices are never trusted
  -- (§50).
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

  -- Coupons (§24–§26): server-authoritative validation; per-business
  -- discounts are tracked so each business_order gets its share.
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

    select c.id, pr.scope, pr.business_id, pr.discount_type, pr.discount_value
    into v_coupon
    from public.coupons c
    join public.promotions pr on pr.id = c.promotion_id
    where upper(c.code) = upper(trim(v_code))
      and c.active
      and (c.expires_at is null or c.expires_at > now())
      and (pr.starts_at is null or pr.starts_at <= now())
      and (pr.ends_at is null or pr.ends_at >= now());
    if not found then
      raise exception 'Coupon % is invalid or expired', v_code;
    end if;

    if v_coupon.scope = 'business' then
      select coalesce(sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity), 0)
      into v_biz_subtotal
      from public.cart_items ci
      join public.product_variants pv on pv.id = ci.product_variant_id
      join public.products p on p.id = pv.product_id
      where ci.cart_id = v_cart_id
        and p.business_id = v_coupon.business_id;
      if v_biz_subtotal = 0 then
        raise exception 'Coupon % does not apply to your cart', v_code;
      end if;
      v_coupon_discount := case v_coupon.discount_type
        when 'fixed' then least(v_coupon.discount_value, v_biz_subtotal)
        else (v_biz_subtotal * v_coupon.discount_value) / 100
      end;
      insert into _biz_discount (business_id, discount)
      values (v_coupon.business_id, v_coupon_discount)
      on conflict (business_id)
      do update set discount = _biz_discount.discount + excluded.discount;
    else
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

  delete from public.cart_items where cart_id = v_cart_id;

  return v_order_id;
end;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- Cancellation/rejection: payment consequences stay, stock restore is gone
-- ─────────────────────────────────────────────────────────────────────────────

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

-- Business order lifecycle (§11): pending → accepted → preparing → ready.
-- Completion happens when the driver completes the pickup stop (Phase 7).
create or replace function public.transition_business_order(
  p_business_order_id uuid,
  p_target public.business_order_status,
  p_reason text default null
)
returns void
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_current public.business_order_status;
  v_valid boolean;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;

  select bo.status into v_current
  from public.business_orders bo
  join public.businesses b on b.id = bo.business_id
  where bo.id = p_business_order_id and b.owner_id = v_user;
  if not found then
    raise exception 'Business order not found';
  end if;

  v_valid := (v_current, p_target) in
    ( ('pending', 'accepted'),
      ('pending', 'rejected'),
      ('accepted', 'preparing'),
      ('preparing', 'ready') );
  if not v_valid then
    raise exception 'Cannot move business order from % to %', v_current, p_target;
  end if;
  if p_target = 'rejected' and coalesce(trim(p_reason), '') = '' then
    raise exception 'Rejection reason is required';
  end if;

  update public.business_orders
  set status = p_target,
      rejection_reason = p_reason
  where id = p_business_order_id;

  if p_target = 'rejected' then
    -- A verified bank transfer becomes RefundRequired (§13/§21) — but only
    -- when every business portion of the order is dead (no partial refunds
    -- in the MVP).
    update public.payments p
    set status = 'refund_required'::public.payment_status
    where p.order_id = (select order_id from public.business_orders where id = p_business_order_id)
      and p.method = 'bank_transfer'
      and p.status = 'transaction_verified'
      and not exists (
        select 1 from public.business_orders other
        where other.order_id = p.order_id
          and other.id <> p_business_order_id
          and other.status not in ('rejected', 'cancelled')
      );
  end if;
end;
$$;
