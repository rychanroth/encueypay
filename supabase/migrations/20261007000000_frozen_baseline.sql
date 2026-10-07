


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."account_status" AS ENUM (
    'active',
    'suspended',
    'banned'
);


ALTER TYPE "public"."account_status" OWNER TO "postgres";


CREATE TYPE "public"."banner_status" AS ENUM (
    'none',
    'pending',
    'approved',
    'rejected',
    'disabled'
);


ALTER TYPE "public"."banner_status" OWNER TO "postgres";


CREATE TYPE "public"."business_order_status" AS ENUM (
    'pending',
    'accepted',
    'rejected',
    'preparing',
    'ready',
    'completed',
    'cancelled'
);


ALTER TYPE "public"."business_order_status" OWNER TO "postgres";


CREATE TYPE "public"."business_status" AS ENUM (
    'pending',
    'active',
    'suspended'
);


ALTER TYPE "public"."business_status" OWNER TO "postgres";


CREATE TYPE "public"."delivery_status" AS ENUM (
    'available',
    'assigned',
    'pickup_in_progress',
    'delivery_in_progress',
    'delivered',
    'cancelled'
);


ALTER TYPE "public"."delivery_status" OWNER TO "postgres";


CREATE TYPE "public"."discount_type" AS ENUM (
    'fixed',
    'percent'
);


ALTER TYPE "public"."discount_type" OWNER TO "postgres";


CREATE TYPE "public"."notification_type" AS ENUM (
    'order',
    'delivery',
    'return',
    'promotion',
    'role',
    'system'
);


ALTER TYPE "public"."notification_type" OWNER TO "postgres";


CREATE TYPE "public"."payment_method" AS ENUM (
    'cod',
    'bank_transfer'
);


ALTER TYPE "public"."payment_method" OWNER TO "postgres";


CREATE TYPE "public"."payment_status" AS ENUM (
    'pending',
    'awaiting_payment_verification',
    'transaction_verified',
    'refund_required',
    'refunded'
);


ALTER TYPE "public"."payment_status" OWNER TO "postgres";


CREATE TYPE "public"."pickup_stop_status" AS ENUM (
    'pending',
    'completed'
);


ALTER TYPE "public"."pickup_stop_status" OWNER TO "postgres";


CREATE TYPE "public"."product_status" AS ENUM (
    'active',
    'archived'
);


ALTER TYPE "public"."product_status" OWNER TO "postgres";


CREATE TYPE "public"."promotion_scope" AS ENUM (
    'business',
    'platform'
);


ALTER TYPE "public"."promotion_scope" OWNER TO "postgres";


CREATE TYPE "public"."return_status" AS ENUM (
    'pending',
    'approved',
    'rejected'
);


ALTER TYPE "public"."return_status" OWNER TO "postgres";


CREATE TYPE "public"."role_application_status" AS ENUM (
    'pending',
    'approved',
    'rejected'
);


ALTER TYPE "public"."role_application_status" OWNER TO "postgres";


CREATE TYPE "public"."user_role" AS ENUM (
    'customer',
    'business',
    'driver',
    'admin'
);


ALTER TYPE "public"."user_role" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."accept_delivery"("p_delivery_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  if not public.is_driver() then
    raise exception 'Only drivers can accept deliveries';
  end if;

  -- Atomic claim: only a still-available row can transition (§15.1).
  update public.deliveries
  set driver_id = auth.uid(),
      status = 'assigned'
  where id = p_delivery_id
    and status = 'available'
    and driver_id is null;
  if not found then
    raise exception 'Delivery is no longer available';
  end if;
end;
$$;


ALTER FUNCTION "public"."accept_delivery"("p_delivery_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."add_cart_item"("p_variant_id" "uuid", "p_quantity" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
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


ALTER FUNCTION "public"."add_cart_item"("p_variant_id" "uuid", "p_quantity" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."add_product_image"("p_product_id" "uuid", "p_storage_path" "text") RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_user uuid := auth.uid();
  v_image_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  if not exists (
    select 1
    from public.products p
    join public.businesses b on b.id = p.business_id
    where p.id = p_product_id and b.owner_id = v_user
  ) then
    raise exception 'Product not found';
  end if;

  insert into public.product_images (product_id, storage_path, sort_order)
  values (
    p_product_id,
    p_storage_path,
    coalesce((
      select max(sort_order) + 1
      from public.product_images
      where product_id = p_product_id
    ), 0)
  )
  returning id into v_image_id;
  return v_image_id;
end;
$$;


ALTER FUNCTION "public"."add_product_image"("p_product_id" "uuid", "p_storage_path" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."add_product_variant"("p_product_id" "uuid", "p_name" "text", "p_price_minor" bigint) RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_user uuid := auth.uid();
  v_variant_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  if not exists (
    select 1
    from public.products p
    join public.businesses b on b.id = p.business_id
    where p.id = p_product_id and b.owner_id = v_user
  ) then
    raise exception 'Product not found';
  end if;
  if p_price_minor is not null and p_price_minor < 0 then
    raise exception 'Invalid price';
  end if;
  if exists (
    select 1 from public.product_variants
    where product_id = p_product_id and name = trim(p_name)
  ) then
    raise exception 'Variant name already exists';
  end if;

  insert into public.product_variants (product_id, name, price_minor)
  values (p_product_id, trim(p_name), p_price_minor)
  returning id into v_variant_id;
  return v_variant_id;
end;
$$;


ALTER FUNCTION "public"."add_product_variant"("p_product_id" "uuid", "p_name" "text", "p_price_minor" bigint) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."block_business_status_self_change"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
begin
  if auth.uid() is not null
     and new.status is distinct from old.status then
    raise exception 'business status is admin-managed';
  end if;
  return new;
end;
$$;


ALTER FUNCTION "public"."block_business_status_self_change"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."block_role_self_change"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
begin
  if auth.uid() is not null
     and (new.active_role, new.account_status)
         is distinct from (old.active_role, old.account_status) then
    raise exception
      'active_role/account_status can only change via role applications';
  end if;
  return new;
end;
$$;


ALTER FUNCTION "public"."block_role_self_change"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."cancel_order"("p_order_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
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


ALTER FUNCTION "public"."cancel_order"("p_order_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."clear_cart"() RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;

  delete from public.cart_items ci
  using public.carts c
  where c.id = ci.cart_id
    and c.user_id = auth.uid();
end;
$$;


ALTER FUNCTION "public"."clear_cart"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."complete_pickup_stop"("p_stop_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_delivery_id uuid;
begin
  update public.pickup_stops ps
  set status = 'completed',
      completed_at = now()
  from public.deliveries d
  where ps.id = p_stop_id
    and d.id = ps.delivery_id
    and d.driver_id = auth.uid()
    and ps.status = 'pending'
    and d.status in ('assigned', 'pickup_in_progress')
  returning ps.delivery_id into v_delivery_id;
  if not found then
    raise exception 'Pickup stop cannot be completed';
  end if;

  -- The business portion is picked up → its lifecycle completes (§11).
  update public.business_orders bo
  set status = 'completed',
      completed_at = now()
  from public.pickup_stops ps
  where ps.id = p_stop_id
    and ps.business_order_id = bo.id;

  update public.deliveries
  set status = 'pickup_in_progress'
  where id = v_delivery_id and status = 'assigned';
end;
$$;


ALTER FUNCTION "public"."complete_pickup_stop"("p_stop_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_business"("p_name" "text", "p_description" "text", "p_image_url" "text" DEFAULT NULL::"text") RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_user uuid := auth.uid();
  v_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  if coalesce(trim(p_name), '') = '' then
    raise exception 'Business name is required';
  end if;

  insert into public.businesses (owner_id, name, description, status, image_url)
  values (v_user, trim(p_name), coalesce(p_description, ''), 'active', p_image_url)
  returning id into v_id;
  return v_id;
end;
$$;


ALTER FUNCTION "public"."create_business"("p_name" "text", "p_description" "text", "p_image_url" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_category"("p_name" "text", "p_parent_id" "uuid" DEFAULT NULL::"uuid") RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage categories';
  end if;
  if coalesce(trim(p_name), '') = '' then
    raise exception 'Category name is required';
  end if;
  insert into public.categories (name, parent_id)
  values (trim(p_name), p_parent_id)
  returning id into v_id;
  return v_id;
end;
$$;


ALTER FUNCTION "public"."create_category"("p_name" "text", "p_parent_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_coupon_promotion"("p_name" "text", "p_description" "text", "p_discount_type" "public"."discount_type", "p_discount_value" bigint, "p_code" "text", "p_expires_at" timestamp with time zone DEFAULT NULL::timestamp with time zone) RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$
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


ALTER FUNCTION "public"."create_coupon_promotion"("p_name" "text", "p_description" "text", "p_discount_type" "public"."discount_type", "p_discount_value" bigint, "p_code" "text", "p_expires_at" timestamp with time zone) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_order_from_cart"("p_address_id" "uuid", "p_payment_method" "public"."payment_method", "p_coupon_codes" "text"[] DEFAULT '{}'::"text"[]) RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$
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


ALTER FUNCTION "public"."create_order_from_cart"("p_address_id" "uuid", "p_payment_method" "public"."payment_method", "p_coupon_codes" "text"[]) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_platform_promotion"("p_name" "text", "p_description" "text", "p_discount_type" "public"."discount_type", "p_discount_value" bigint, "p_code" "text", "p_expires_at" timestamp with time zone DEFAULT NULL::timestamp with time zone) RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$
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


ALTER FUNCTION "public"."create_platform_promotion"("p_name" "text", "p_description" "text", "p_discount_type" "public"."discount_type", "p_discount_value" bigint, "p_code" "text", "p_expires_at" timestamp with time zone) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_product"("p_category_id" "uuid", "p_name" "text", "p_description" "text", "p_base_price_minor" bigint, "p_variants" "jsonb" DEFAULT '[]'::"jsonb") RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$
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


ALTER FUNCTION "public"."create_product"("p_category_id" "uuid", "p_name" "text", "p_description" "text", "p_base_price_minor" bigint, "p_variants" "jsonb") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_review"("p_order_item_id" "uuid", "p_rating" integer, "p_text" "text") RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_user uuid := auth.uid();
  v_product_id uuid;
  v_review_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  if p_rating < 1 or p_rating > 5 then
    raise exception 'Rating must be between 1 and 5';
  end if;

  select oi.product_id into v_product_id
  from public.order_items oi
  join public.business_orders bo on bo.id = oi.business_order_id
  join public.orders o on o.id = bo.order_id
  where oi.id = p_order_item_id and o.customer_id = v_user;
  if not found then
    raise exception 'You can only review purchased items';
  end if;

  insert into public.reviews (order_item_id, product_id, customer_id, rating, text)
  values (p_order_item_id, v_product_id, v_user, p_rating, coalesce(p_text, ''))
  returning id into v_review_id;
  return v_review_id;
end;
$$;


ALTER FUNCTION "public"."create_review"("p_order_item_id" "uuid", "p_rating" integer, "p_text" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."delete_category"("p_category_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage categories';
  end if;
  begin
    delete from public.categories where id = p_category_id;
  exception when foreign_key_violation then
    raise exception 'Category is in use by products or has subcategories';
  end;
  if not found then
    raise exception 'Category not found';
  end if;
end;
$$;


ALTER FUNCTION "public"."delete_category"("p_category_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."driver_can_view_business_order"("p_business_order_id" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  select exists (
    select 1
    from public.deliveries d
    join public.pickup_stops ps on ps.delivery_id = d.id
    where ps.business_order_id = p_business_order_id
      and (d.driver_id = auth.uid() or d.status = 'available')
  );
$$;


ALTER FUNCTION "public"."driver_can_view_business_order"("p_business_order_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."driver_can_view_delivery"("p_delivery_id" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  select exists (
    select 1 from public.deliveries
    where id = p_delivery_id
      and (driver_id = auth.uid() or status = 'available')
  );
$$;


ALTER FUNCTION "public"."driver_can_view_delivery"("p_delivery_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."driver_can_view_order"("p_order_id" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  select exists (
    select 1 from public.deliveries
    where order_id = p_order_id
      and (driver_id = auth.uid() or status = 'available')
  );
$$;


ALTER FUNCTION "public"."driver_can_view_order"("p_order_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."driver_can_view_user"("p_user_id" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  select exists (
    select 1
    from public.deliveries d
    join public.orders o on o.id = d.order_id
    where o.customer_id = p_user_id
      and d.driver_id = auth.uid()
  );
$$;


ALTER FUNCTION "public"."driver_can_view_user"("p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_business_analytics"() RETURNS "jsonb"
    LANGUAGE "plpgsql" STABLE
    AS $$
declare
  v_user uuid := auth.uid();
  v_business_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  select id into v_business_id from public.businesses where owner_id = v_user;
  if v_business_id is null then
    raise exception 'No business found';
  end if;

  return jsonb_build_object(
    'total_sales_minor', coalesce((
      select sum(bo.subtotal_minor - bo.discount_minor)
      from public.business_orders bo
      where bo.business_id = v_business_id
        and bo.status in ('completed', 'ready', 'preparing', 'accepted')
    ), 0),
    'order_count', coalesce((
      select count(*) from public.business_orders bo
      where bo.business_id = v_business_id
    ), 0),
    'pending_count', coalesce((
      select count(*) from public.business_orders bo
      where bo.business_id = v_business_id and bo.status = 'pending'
    ), 0),
    'completed_count', coalesce((
      select count(*) from public.business_orders bo
      where bo.business_id = v_business_id and bo.status = 'completed'
    ), 0),
    'rejected_count', coalesce((
      select count(*) from public.business_orders bo
      where bo.business_id = v_business_id
        and bo.status in ('rejected', 'cancelled')
    ), 0),
    'top_products', coalesce((
      select jsonb_agg(jsonb_build_object(
        'name', t.name, 'quantity', t.qty, 'revenue_minor', t.revenue
      ) order by t.revenue desc)
      from (
        select oi.product_name as name, sum(oi.quantity) as qty,
               sum(oi.line_total_minor) as revenue
        from public.order_items oi
        join public.business_orders bo on bo.id = oi.business_order_id
        where bo.business_id = v_business_id
        group by oi.product_name
        order by revenue desc
        limit 5
      ) t
    ), '[]'::jsonb)
  );
end;
$$;


ALTER FUNCTION "public"."get_business_analytics"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_business_transactions"("p_day" "date") RETURNS TABLE("id" "uuid", "occurred_at" timestamp with time zone, "amount" bigint, "label" "text")
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  select bo.id, bo.completed_at, bo.subtotal_minor - bo.discount_minor,
         coalesce(u.full_name, 'Customer')
  from public.business_orders bo
  join public.orders o on o.id = bo.order_id
  join public.users u on u.id = o.customer_id
  where bo.business_id = (
      select b.id from public.businesses b where b.owner_id = auth.uid()
    )
    and bo.status = 'completed'
    and bo.completed_at is not null
    and bo.completed_at::date = p_day
  order by bo.completed_at desc;
$$;


ALTER FUNCTION "public"."get_business_transactions"("p_day" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_driver_transactions"("p_day" "date") RETURNS TABLE("id" "uuid", "occurred_at" timestamp with time zone, "amount" bigint, "label" "text")
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  select d.id, d.delivered_at, d.driver_earning_minor,
         coalesce(o.shipping_city, 'Delivery')
  from public.deliveries d
  join public.orders o on o.id = d.order_id
  where d.driver_id = auth.uid()
    and d.status = 'delivered'
    and d.delivered_at is not null
    and d.delivered_at::date = p_day
  order by d.delivered_at desc;
$$;


ALTER FUNCTION "public"."get_driver_transactions"("p_day" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_platform_report"() RETURNS "jsonb"
    LANGUAGE "plpgsql" STABLE
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can view reports';
  end if;

  return jsonb_build_object(
    'order_count', coalesce((select count(*) from public.orders), 0),
    'gmv_minor', coalesce((
      select sum(o.total_minor) from public.orders o
      where exists (
        select 1 from public.business_orders bo
        where bo.order_id = o.id
          and bo.status not in ('rejected', 'cancelled')
      )
    ), 0),
    'delivery_fees_minor', coalesce((
      select sum(o.delivery_fee_minor) from public.orders o
      where exists (
        select 1 from public.business_orders bo
        where bo.order_id = o.id
          and bo.status not in ('rejected', 'cancelled')
      )
    ), 0),
    'active_businesses', coalesce((
      select count(*) from public.businesses where status = 'active'
    ), 0),
    'active_products', coalesce((
      select count(*) from public.products where status = 'active'
    ), 0),
    'pending_applications', coalesce((
      select count(*) from public.role_applications where status = 'pending'
    ), 0)
  );
end;
$$;


ALTER FUNCTION "public"."get_platform_report"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
begin
  insert into public.users (id, full_name, avatar_url)
  values (
    new.id,
    coalesce(
      new.raw_user_meta_data ->> 'full_name',
      new.raw_user_meta_data ->> 'name',
      new.raw_user_meta_data ->> 'given_name',
      ''
    ),
    new.raw_user_meta_data ->> 'avatar_url'
  );
  return new;
end;
$$;


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_admin"() RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  select exists (
    select 1 from public.users
    where id = auth.uid() and active_role = 'admin'
  );
$$;


ALTER FUNCTION "public"."is_admin"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_driver"() RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  select exists (
    select 1 from public.users
    where id = auth.uid() and active_role = 'driver'
  );
$$;


ALTER FUNCTION "public"."is_driver"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."mark_all_notifications_read"() RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  update public.notifications
  set read = true
  where recipient_id = auth.uid() and not read;
end;
$$;


ALTER FUNCTION "public"."mark_all_notifications_read"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."mark_delivered"("p_delivery_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_order_id uuid;
begin
  update public.deliveries d
  set status = 'delivered',
      delivered_at = now()
  where d.id = p_delivery_id
    and d.driver_id = auth.uid()
    and d.status = 'delivery_in_progress'
  returning d.order_id into v_order_id;
  if not found then
    raise exception 'Delivery cannot be completed';
  end if;

  -- COD is collected on successful delivery (§20.1).
  update public.payments p
  set status = 'transaction_verified',
      paid_at = now()
  where p.order_id = v_order_id
    and p.method = 'cod'
    and p.status = 'pending';
end;
$$;


ALTER FUNCTION "public"."mark_delivered"("p_delivery_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."mark_notification_read"("p_notification_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  update public.notifications
  set read = true
  where id = p_notification_id and recipient_id = auth.uid();
end;
$$;


ALTER FUNCTION "public"."mark_notification_read"("p_notification_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."moderate_banner"("p_promotion_id" "uuid", "p_action" "text") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
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


ALTER FUNCTION "public"."moderate_banner"("p_promotion_id" "uuid", "p_action" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."notify"("p_recipient" "uuid", "p_type" "public"."notification_type", "p_title" "text", "p_content" "text" DEFAULT ''::"text") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
begin
  if p_recipient is null then
    return;
  end if;
  insert into public.notifications (recipient_id, type, title, content)
  values (p_recipient, p_type, p_title, p_content);
end;
$$;


ALTER FUNCTION "public"."notify"("p_recipient" "uuid", "p_type" "public"."notification_type", "p_title" "text", "p_content" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."notify_business_new_order"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_owner uuid;
  v_customer uuid;
begin
  select b.owner_id into v_owner
  from public.businesses b where b.id = new.business_id;
  select o.customer_id into v_customer
  from public.orders o where o.id = new.order_id;

  perform public.notify(
    v_owner, 'order',
    'New order received',
    'You have a new order to review.'
  );
  perform public.notify(
    v_customer, 'order',
    'Order placed',
    'Your order was sent to the business.'
  );
  return new;
end;
$$;


ALTER FUNCTION "public"."notify_business_new_order"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."notify_customer_on_business_order"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_customer uuid;
begin
  if new.status is distinct from old.status then
    select o.customer_id into v_customer
    from public.orders o where o.id = new.order_id;
    perform public.notify(
      v_customer, 'order',
      'Order update: ' || new.status::text,
      'One of your businesses moved your order to ' || new.status::text || '.'
    );
  end if;
  return new;
end;
$$;


ALTER FUNCTION "public"."notify_customer_on_business_order"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."notify_customer_on_delivery"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_customer uuid;
begin
  if new.status is distinct from old.status then
    select o.customer_id into v_customer
    from public.orders o where o.id = new.order_id;
    perform public.notify(
      v_customer, 'delivery',
      'Delivery update: ' || new.status::text,
      'Your delivery status changed.'
    );
  end if;
  return new;
end;
$$;


ALTER FUNCTION "public"."notify_customer_on_delivery"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."notify_customer_on_return"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
begin
  if new.status is distinct from old.status then
    perform public.notify(
      new.customer_id, 'return',
      'Return ' || new.status::text,
      'Your return request was ' || new.status::text || '.'
    );
  end if;
  return new;
end;
$$;


ALTER FUNCTION "public"."notify_customer_on_return"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."owns_business_order_driver"("p_business_order_id" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  select exists (
    select 1
    from public.deliveries d
    join public.pickup_stops ps on ps.delivery_id = d.id
    where ps.business_order_id = p_business_order_id
      and d.driver_id = auth.uid()
  );
$$;


ALTER FUNCTION "public"."owns_business_order_driver"("p_business_order_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."owns_product_image_object"("p_object_name" "text") RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  select exists (
    select 1 from public.businesses b
    where b.id::text = (storage.foldername(p_object_name))[1]
      and b.owner_id = auth.uid()
  );
$$;


ALTER FUNCTION "public"."owns_product_image_object"("p_object_name" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."owns_returned_items"("p_return_request_id" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  select exists (
    select 1
    from public.return_items ri
    join public.order_items oi on oi.id = ri.order_item_id
    join public.business_orders bo on bo.id = oi.business_order_id
    join public.businesses b on b.id = bo.business_id
    where ri.return_request_id = p_return_request_id
      and b.owner_id = auth.uid()
  );
$$;


ALTER FUNCTION "public"."owns_returned_items"("p_return_request_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."process_return"("p_return_id" "uuid", "p_approve" boolean) RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_user uuid := auth.uid();
  v_order_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;

  -- The caller must own a business referenced by at least one returned item.
  if not exists (
    select 1
    from public.return_items ri
    join public.order_items oi on oi.id = ri.order_item_id
    join public.business_orders bo on bo.id = oi.business_order_id
    join public.businesses b on b.id = bo.business_id
    where ri.return_request_id = p_return_id
      and b.owner_id = v_user
  ) then
    raise exception 'Return request not found';
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
      and p.method = 'bank_transfer'
      and p.status = 'transaction_verified';
  end if;
end;
$$;


ALTER FUNCTION "public"."process_return"("p_return_id" "uuid", "p_approve" boolean) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."record_business_order_state"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
begin
  if new.status is distinct from old.status then
    insert into public.state_history (entity_type, entity_id, from_state, to_state, actor)
    values ('business_order', new.id, old.status::text, new.status::text, auth.uid());
    insert into public.audit_logs (actor, action, target_type, target_id)
    values (auth.uid(), 'business_order.' || new.status::text, 'business_order', new.id);
  end if;
  return new;
end;
$$;


ALTER FUNCTION "public"."record_business_order_state"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."record_return_state"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
begin
  if new.status is distinct from old.status then
    insert into public.state_history (entity_type, entity_id, from_state, to_state, actor)
    values ('return_request', new.id, old.status::text, new.status::text, auth.uid());
  end if;
  return new;
end;
$$;


ALTER FUNCTION "public"."record_return_state"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."reject_delivery"("p_delivery_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  update public.deliveries
  set driver_id = null,
      status = 'available'
  where id = p_delivery_id
    and driver_id = auth.uid()
    and status = 'assigned';
  if not found then
    raise exception 'Delivery cannot be rejected';
  end if;
end;
$$;


ALTER FUNCTION "public"."reject_delivery"("p_delivery_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."remove_cart_item"("p_item_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;

  delete from public.cart_items ci
  using public.carts c
  where c.id = ci.cart_id
    and c.user_id = auth.uid()
    and ci.id = p_item_id;
end;
$$;


ALTER FUNCTION "public"."remove_cart_item"("p_item_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."rename_category"("p_category_id" "uuid", "p_name" "text") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage categories';
  end if;
  update public.categories set name = trim(p_name) where id = p_category_id;
  if not found then
    raise exception 'Category not found';
  end if;
end;
$$;


ALTER FUNCTION "public"."rename_category"("p_category_id" "uuid", "p_name" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."request_return"("p_order_id" "uuid", "p_items" "jsonb") RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_user uuid := auth.uid();
  v_request_id uuid;
  v_item record;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  if not exists (
    select 1 from public.orders o
    join public.deliveries d on d.order_id = o.id
    where o.id = p_order_id
      and o.customer_id = v_user
      and d.status = 'delivered'
  ) then
    raise exception 'Only delivered orders can be returned';
  end if;
  if exists (
    select 1 from public.return_requests
    where order_id = p_order_id and status = 'pending'
  ) then
    raise exception 'A return request is already pending for this order';
  end if;

  insert into public.return_requests (order_id, customer_id)
  values (p_order_id, v_user)
  returning id into v_request_id;

  for v_item in select * from jsonb_to_recordset(p_items)
      as x(order_item_id uuid, quantity integer, reason text)
  loop
    if not exists (
      select 1 from public.order_items oi
      join public.business_orders bo on bo.id = oi.business_order_id
      where oi.id = v_item.order_item_id
        and bo.order_id = p_order_id
        and v_item.quantity > 0
        and v_item.quantity <= oi.quantity
    ) then
      raise exception 'Invalid return quantity';
    end if;
    insert into public.return_items
      (return_request_id, order_item_id, quantity, reason)
    values (v_request_id, v_item.order_item_id, v_item.quantity,
            coalesce(v_item.reason, ''));
  end loop;

  return v_request_id;
end;
$$;


ALTER FUNCTION "public"."request_return"("p_order_id" "uuid", "p_items" "jsonb") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."review_role_application"("p_application_id" "uuid", "p_approve" boolean, "p_reason" "text" DEFAULT NULL::"text") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_application public.role_applications;
begin
  if not public.is_admin() then
    raise exception 'Only admins can review applications';
  end if;

  select * into v_application
  from public.role_applications
  where id = p_application_id and status = 'pending';
  if not found then
    raise exception 'Application is already decided';
  end if;

  update public.role_applications
  set status = case when p_approve then 'approved'::public.role_application_status
                    else 'rejected'::public.role_application_status end,
      decision_reason = p_reason,
      reviewed_by = auth.uid()
  where id = p_application_id;

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (
    auth.uid(),
    case when p_approve then 'role_application.approved'
         else 'role_application.rejected' end,
    'role_application',
    p_application_id,
    jsonb_build_object('requested_role', v_application.requested_role,
                       'user_id', v_application.user_id)
  );

  if p_approve then
    -- auth.uid() resolves to the CALLER even inside security-definer
    -- functions (JWT claims are connection-scoped), so the role-guard
    -- trigger on users would reject this update. Clear the claims
    -- transaction-locally: the is_admin() check above is the authority.
    perform set_config('request.jwt.claims', '', true);
    update public.users
    set active_role = v_application.requested_role
    where id = v_application.user_id;
  end if;
end;
$$;


ALTER FUNCTION "public"."review_role_application"("p_application_id" "uuid", "p_approve" boolean, "p_reason" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_coupon_active"("p_coupon_id" "uuid", "p_active" boolean) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
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


ALTER FUNCTION "public"."set_coupon_active"("p_coupon_id" "uuid", "p_active" boolean) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_product_archived"("p_product_id" "uuid", "p_archived" boolean) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;
  update public.products p
  set status = case when p_archived then 'archived'::public.product_status else 'active'::public.product_status end
  from public.businesses b
  where b.id = p.business_id and b.owner_id = auth.uid() and p.id = p_product_id;
  if not found then
    raise exception 'Product not found';
  end if;
end;
$$;


ALTER FUNCTION "public"."set_product_archived"("p_product_id" "uuid", "p_archived" boolean) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_variant_image"("p_variant_id" "uuid", "p_image_path" "text") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
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


ALTER FUNCTION "public"."set_variant_image"("p_variant_id" "uuid", "p_image_path" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."start_delivery"("p_delivery_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  -- §16: cannot proceed until the appropriate stops are satisfied.
  update public.deliveries d
  set status = 'delivery_in_progress'
  where d.id = p_delivery_id
    and d.driver_id = auth.uid()
    and d.status = 'pickup_in_progress'
    and not exists (
      select 1 from public.pickup_stops ps
      where ps.delivery_id = d.id and ps.status = 'pending'
    );
  if not found then
    raise exception 'Complete all pickup stops first';
  end if;
end;
$$;


ALTER FUNCTION "public"."start_delivery"("p_delivery_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."submit_banner"("p_name" "text", "p_description" "text", "p_image_url" "text", "p_ends_at" timestamp with time zone DEFAULT NULL::timestamp with time zone) RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$
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


ALTER FUNCTION "public"."submit_banner"("p_name" "text", "p_description" "text", "p_image_url" "text", "p_ends_at" timestamp with time zone) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."submit_payment_proof"("p_order_id" "uuid", "p_path" "text") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;

  update public.payments p
  set proof_path = p_path,
      status = 'transaction_verified',
      paid_at = now()
  from public.orders o
  where o.id = p.order_id
    and o.id = p_order_id
    and o.customer_id = auth.uid()
    and p.method = 'bank_transfer'
    and p.status in ('pending', 'awaiting_payment_verification');
  if not found then
    raise exception 'Payment cannot be updated';
  end if;
end;
$$;


ALTER FUNCTION "public"."submit_payment_proof"("p_order_id" "uuid", "p_path" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."submit_role_application"("p_requested_role" "text") RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_user uuid := auth.uid();
  v_role public.user_role;
  v_application_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  v_role := coalesce(p_requested_role, '')::public.user_role;
  if v_role not in ('business', 'driver') then
    raise exception 'Invalid requested role';
  end if;
  if exists (
    select 1 from public.users
    where id = v_user and active_role = v_role
  ) then
    raise exception 'You already have this role';
  end if;

  delete from public.role_applications
  where user_id = v_user and status = 'pending';

  insert into public.role_applications (user_id, requested_role)
  values (v_user, v_role)
  returning id into v_application_id;
  return v_application_id;
end;
$$;


ALTER FUNCTION "public"."submit_role_application"("p_requested_role" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."touch_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  new.updated_at = now();
  return new;
end;
$$;


ALTER FUNCTION "public"."touch_updated_at"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."transition_business_order"("p_business_order_id" "uuid", "p_target" "public"."business_order_status", "p_reason" "text" DEFAULT NULL::"text") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
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


ALTER FUNCTION "public"."transition_business_order"("p_business_order_id" "uuid", "p_target" "public"."business_order_status", "p_reason" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_cart_item"("p_item_id" "uuid", "p_quantity" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;
  if p_quantity is null or p_quantity < 1 then
    raise exception 'Invalid quantity';
  end if;

  update public.cart_items ci
  set quantity = p_quantity
  from public.carts c
  where c.id = ci.cart_id
    and c.user_id = auth.uid()
    and ci.id = p_item_id;
end;
$$;


ALTER FUNCTION "public"."update_cart_item"("p_item_id" "uuid", "p_quantity" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_my_business"("p_name" "text", "p_description" "text") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;
  update public.businesses
  set name = trim(p_name), description = coalesce(p_description, '')
  where owner_id = auth.uid();
  if not found then
    raise exception 'No business found';
  end if;
end;
$$;


ALTER FUNCTION "public"."update_my_business"("p_name" "text", "p_description" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_product"("p_product_id" "uuid", "p_category_id" "uuid", "p_name" "text", "p_description" "text", "p_base_price_minor" bigint) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;
  update public.products p
  set category_id = p_category_id,
      name = trim(p_name),
      description = coalesce(p_description, ''),
      base_price_minor = p_base_price_minor
  from public.businesses b
  where b.id = p.business_id
    and b.owner_id = auth.uid()
    and p.id = p_product_id;
  if not found then
    raise exception 'Product not found';
  end if;
end;
$$;


ALTER FUNCTION "public"."update_product"("p_product_id" "uuid", "p_category_id" "uuid", "p_name" "text", "p_description" "text", "p_base_price_minor" bigint) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_product_variant"("p_variant_id" "uuid", "p_name" "text", "p_price_minor" bigint) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_user uuid := auth.uid();
  v_product_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  select product_id into v_product_id
  from public.product_variants
  where id = p_variant_id;
  if v_product_id is null or not exists (
    select 1
    from public.products p
    join public.businesses b on b.id = p.business_id
    where p.id = v_product_id and b.owner_id = v_user
  ) then
    raise exception 'Variant not found';
  end if;
  if p_price_minor is not null and p_price_minor < 0 then
    raise exception 'Invalid price';
  end if;
  if exists (
    select 1 from public.product_variants
    where product_id = v_product_id
      and id <> p_variant_id
      and name = trim(p_name)
  ) then
    raise exception 'Variant name already exists';
  end if;

  update public.product_variants
  set name = trim(p_name), price_minor = p_price_minor
  where id = p_variant_id;
end;
$$;


ALTER FUNCTION "public"."update_product_variant"("p_variant_id" "uuid", "p_name" "text", "p_price_minor" bigint) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."validate_coupon"("p_code" "text") RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_user uuid := auth.uid();
  v_cart_id uuid;
  v_coupon record;
  v_subtotal bigint := 0;
  v_biz_subtotal bigint;
  v_discount bigint;
begin
  if v_user is null then
    return jsonb_build_object('valid', false, 'message', 'Not authenticated');
  end if;
  select id into v_cart_id from public.carts where user_id = v_user;

  select c.id, pr.scope, pr.business_id, pr.discount_type, pr.discount_value
  into v_coupon
  from public.coupons c
  join public.promotions pr on pr.id = c.promotion_id
  where upper(c.code) = upper(trim(p_code))
    and c.active
    and (c.expires_at is null or c.expires_at > now())
    and (pr.starts_at is null or pr.starts_at <= now())
    and (pr.ends_at is null or pr.ends_at >= now());
  if not found then
    return jsonb_build_object('valid', false, 'message', 'Invalid or expired coupon');
  end if;

  select coalesce(sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity), 0)
  into v_subtotal
  from public.cart_items ci
  join public.product_variants pv on pv.id = ci.product_variant_id
  join public.products p on p.id = pv.product_id
  where ci.cart_id = v_cart_id;

  if v_coupon.scope = 'business' then
    select coalesce(sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity), 0)
    into v_biz_subtotal
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    join public.products p on p.id = pv.product_id
    where ci.cart_id = v_cart_id and p.business_id = v_coupon.business_id;
    if v_biz_subtotal = 0 then
      return jsonb_build_object('valid', false, 'message', 'Coupon does not apply to your cart');
    end if;
    v_discount := case v_coupon.discount_type
      when 'fixed' then least(v_coupon.discount_value, v_biz_subtotal)
      else (v_biz_subtotal * v_coupon.discount_value) / 100
    end;
  else
    v_discount := case v_coupon.discount_type
      when 'fixed' then least(v_coupon.discount_value, v_subtotal)
      else (v_subtotal * v_coupon.discount_value) / 100
    end;
  end if;

  return jsonb_build_object('valid', true, 'discount_minor', v_discount);
end;
$$;


ALTER FUNCTION "public"."validate_coupon"("p_code" "text") OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."addresses" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "label" "text" DEFAULT 'Home'::"text" NOT NULL,
    "recipient_name" "text" NOT NULL,
    "phone" "text" DEFAULT ''::"text" NOT NULL,
    "line1" "text" NOT NULL,
    "line2" "text",
    "city" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."addresses" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."audit_logs" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "actor" "uuid",
    "action" "text" NOT NULL,
    "target_type" "text" NOT NULL,
    "target_id" "uuid",
    "metadata" "jsonb",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."audit_logs" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."business_orders" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "order_id" "uuid" NOT NULL,
    "business_id" "uuid" NOT NULL,
    "subtotal_minor" bigint NOT NULL,
    "discount_minor" bigint DEFAULT 0 NOT NULL,
    "status" "public"."business_order_status" DEFAULT 'pending'::"public"."business_order_status" NOT NULL,
    "rejection_reason" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "completed_at" timestamp with time zone,
    CONSTRAINT "business_orders_discount_minor_check" CHECK (("discount_minor" >= 0)),
    CONSTRAINT "business_orders_subtotal_minor_check" CHECK (("subtotal_minor" >= 0))
);


ALTER TABLE "public"."business_orders" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."businesses" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "owner_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "description" "text" DEFAULT ''::"text" NOT NULL,
    "image_url" "text",
    "status" "public"."business_status" DEFAULT 'pending'::"public"."business_status" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."businesses" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."cart_items" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "cart_id" "uuid" NOT NULL,
    "product_variant_id" "uuid" NOT NULL,
    "quantity" integer NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "cart_items_quantity_check" CHECK (("quantity" > 0))
);


ALTER TABLE "public"."cart_items" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."carts" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."carts" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."categories" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "parent_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."categories" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."coupons" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "promotion_id" "uuid" NOT NULL,
    "code" "text" NOT NULL,
    "active" boolean DEFAULT true NOT NULL,
    "expires_at" timestamp with time zone,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."coupons" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."deliveries" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "order_id" "uuid" NOT NULL,
    "driver_id" "uuid",
    "status" "public"."delivery_status" DEFAULT 'available'::"public"."delivery_status" NOT NULL,
    "delivery_fee_minor" bigint DEFAULT 0 NOT NULL,
    "driver_earning_minor" bigint DEFAULT 0 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "delivered_at" timestamp with time zone,
    CONSTRAINT "deliveries_delivery_fee_minor_check" CHECK (("delivery_fee_minor" >= 0)),
    CONSTRAINT "deliveries_driver_earning_minor_check" CHECK (("driver_earning_minor" >= 0))
);


ALTER TABLE "public"."deliveries" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."device_tokens" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "token" "text" NOT NULL,
    "platform" "text" DEFAULT 'unknown'::"text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."device_tokens" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."notifications" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "recipient_id" "uuid" NOT NULL,
    "type" "public"."notification_type" DEFAULT 'system'::"public"."notification_type" NOT NULL,
    "title" "text" NOT NULL,
    "content" "text" DEFAULT ''::"text" NOT NULL,
    "read" boolean DEFAULT false NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."notifications" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."order_coupons" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "order_id" "uuid" NOT NULL,
    "coupon_id" "uuid" NOT NULL,
    "business_id" "uuid",
    "discount_minor" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "order_coupons_discount_minor_check" CHECK (("discount_minor" >= 0))
);


ALTER TABLE "public"."order_coupons" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."order_items" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "business_order_id" "uuid" NOT NULL,
    "product_id" "uuid" NOT NULL,
    "product_variant_id" "uuid" NOT NULL,
    "product_name" "text" NOT NULL,
    "variant_name" "text",
    "business_name" "text" NOT NULL,
    "unit_price_minor" bigint NOT NULL,
    "discount_minor" bigint DEFAULT 0 NOT NULL,
    "quantity" integer NOT NULL,
    "line_total_minor" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "order_items_discount_minor_check" CHECK (("discount_minor" >= 0)),
    CONSTRAINT "order_items_line_total_minor_check" CHECK (("line_total_minor" >= 0)),
    CONSTRAINT "order_items_quantity_check" CHECK (("quantity" > 0)),
    CONSTRAINT "order_items_unit_price_minor_check" CHECK (("unit_price_minor" >= 0))
);


ALTER TABLE "public"."order_items" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."orders" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "customer_id" "uuid" NOT NULL,
    "shipping_recipient_name" "text" NOT NULL,
    "shipping_phone" "text" DEFAULT ''::"text" NOT NULL,
    "shipping_line1" "text" NOT NULL,
    "shipping_line2" "text",
    "shipping_city" "text" NOT NULL,
    "subtotal_minor" bigint NOT NULL,
    "discount_minor" bigint DEFAULT 0 NOT NULL,
    "delivery_fee_minor" bigint DEFAULT 0 NOT NULL,
    "total_minor" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "orders_delivery_fee_minor_check" CHECK (("delivery_fee_minor" >= 0)),
    CONSTRAINT "orders_discount_minor_check" CHECK (("discount_minor" >= 0)),
    CONSTRAINT "orders_subtotal_minor_check" CHECK (("subtotal_minor" >= 0)),
    CONSTRAINT "orders_total_minor_check" CHECK (("total_minor" >= 0))
);


ALTER TABLE "public"."orders" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."payments" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "order_id" "uuid" NOT NULL,
    "method" "public"."payment_method" NOT NULL,
    "amount_minor" bigint NOT NULL,
    "status" "public"."payment_status" DEFAULT 'pending'::"public"."payment_status" NOT NULL,
    "proof_path" "text",
    "paid_at" timestamp with time zone,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "payments_amount_minor_check" CHECK (("amount_minor" >= 0))
);


ALTER TABLE "public"."payments" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."pickup_stops" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "delivery_id" "uuid" NOT NULL,
    "business_order_id" "uuid" NOT NULL,
    "sequence" integer NOT NULL,
    "status" "public"."pickup_stop_status" DEFAULT 'pending'::"public"."pickup_stop_status" NOT NULL,
    "completed_at" timestamp with time zone,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."pickup_stops" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."platform_settings" (
    "id" integer DEFAULT 1 NOT NULL,
    "delivery_fee_minor" bigint DEFAULT 0 NOT NULL,
    "platform_commission_percent" integer DEFAULT 0 NOT NULL,
    "driver_commission_percent" integer DEFAULT 0 NOT NULL,
    "payment_account" "text" DEFAULT ''::"text" NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "platform_settings_delivery_fee_minor_check" CHECK (("delivery_fee_minor" >= 0)),
    CONSTRAINT "platform_settings_driver_commission_percent_check" CHECK ((("driver_commission_percent" >= 0) AND ("driver_commission_percent" <= 100))),
    CONSTRAINT "platform_settings_id_check" CHECK (("id" = 1)),
    CONSTRAINT "platform_settings_platform_commission_percent_check" CHECK ((("platform_commission_percent" >= 0) AND ("platform_commission_percent" <= 100)))
);


ALTER TABLE "public"."platform_settings" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."product_images" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "product_id" "uuid" NOT NULL,
    "storage_path" "text" NOT NULL,
    "sort_order" integer DEFAULT 0 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."product_images" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."product_variants" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "product_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "attributes" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "price_minor" bigint,
    "status" "public"."product_status" DEFAULT 'active'::"public"."product_status" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "image_path" "text",
    CONSTRAINT "product_variants_price_minor_check" CHECK ((("price_minor" IS NULL) OR ("price_minor" >= 0)))
);


ALTER TABLE "public"."product_variants" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."products" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "business_id" "uuid" NOT NULL,
    "category_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "description" "text" DEFAULT ''::"text" NOT NULL,
    "base_price_minor" bigint NOT NULL,
    "status" "public"."product_status" DEFAULT 'active'::"public"."product_status" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "products_base_price_minor_check" CHECK (("base_price_minor" >= 0))
);


ALTER TABLE "public"."products" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."promotions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_by" "uuid" NOT NULL,
    "scope" "public"."promotion_scope" NOT NULL,
    "business_id" "uuid",
    "name" "text" NOT NULL,
    "description" "text" DEFAULT ''::"text" NOT NULL,
    "discount_type" "public"."discount_type" NOT NULL,
    "discount_value" bigint NOT NULL,
    "starts_at" timestamp with time zone,
    "ends_at" timestamp with time zone,
    "banner_image_path" "text",
    "banner_status" "public"."banner_status" DEFAULT 'none'::"public"."banner_status" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "promotions_check" CHECK ((("scope" <> 'business'::"public"."promotion_scope") OR ("business_id" IS NOT NULL))),
    CONSTRAINT "promotions_discount_value_check" CHECK ((("discount_value" > 0) OR ("banner_status" <> 'none'::"public"."banner_status")))
);


ALTER TABLE "public"."promotions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."return_items" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "return_request_id" "uuid" NOT NULL,
    "order_item_id" "uuid" NOT NULL,
    "quantity" integer NOT NULL,
    "reason" "text" DEFAULT ''::"text" NOT NULL,
    "status" "public"."return_status" DEFAULT 'pending'::"public"."return_status" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "return_items_quantity_check" CHECK (("quantity" > 0))
);


ALTER TABLE "public"."return_items" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."return_requests" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "order_id" "uuid" NOT NULL,
    "customer_id" "uuid" NOT NULL,
    "status" "public"."return_status" DEFAULT 'pending'::"public"."return_status" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."return_requests" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."reviews" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "order_item_id" "uuid" NOT NULL,
    "product_id" "uuid" NOT NULL,
    "customer_id" "uuid" NOT NULL,
    "rating" integer NOT NULL,
    "text" "text" DEFAULT ''::"text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "reviews_rating_check" CHECK ((("rating" >= 1) AND ("rating" <= 5)))
);


ALTER TABLE "public"."reviews" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."role_applications" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "requested_role" "public"."user_role" NOT NULL,
    "status" "public"."role_application_status" DEFAULT 'pending'::"public"."role_application_status" NOT NULL,
    "decision_reason" "text",
    "reviewed_by" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "role_applications_requested_role_check" CHECK (("requested_role" = ANY (ARRAY['business'::"public"."user_role", 'driver'::"public"."user_role"])))
);


ALTER TABLE "public"."role_applications" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."state_history" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "entity_type" "text" NOT NULL,
    "entity_id" "uuid" NOT NULL,
    "from_state" "text",
    "to_state" "text" NOT NULL,
    "actor" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."state_history" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" "uuid" NOT NULL,
    "full_name" "text" DEFAULT ''::"text" NOT NULL,
    "avatar_url" "text",
    "phone" "text",
    "active_role" "public"."user_role" DEFAULT 'customer'::"public"."user_role" NOT NULL,
    "account_status" "public"."account_status" DEFAULT 'active'::"public"."account_status" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."users" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."wishlist_items" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "wishlist_id" "uuid" NOT NULL,
    "product_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."wishlist_items" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."wishlists" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."wishlists" OWNER TO "postgres";


ALTER TABLE ONLY "public"."addresses"
    ADD CONSTRAINT "addresses_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."audit_logs"
    ADD CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."business_orders"
    ADD CONSTRAINT "business_orders_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."businesses"
    ADD CONSTRAINT "businesses_owner_id_key" UNIQUE ("owner_id");



ALTER TABLE ONLY "public"."businesses"
    ADD CONSTRAINT "businesses_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."cart_items"
    ADD CONSTRAINT "cart_items_cart_id_product_variant_id_key" UNIQUE ("cart_id", "product_variant_id");



ALTER TABLE ONLY "public"."cart_items"
    ADD CONSTRAINT "cart_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."carts"
    ADD CONSTRAINT "carts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."carts"
    ADD CONSTRAINT "carts_user_id_key" UNIQUE ("user_id");



ALTER TABLE ONLY "public"."categories"
    ADD CONSTRAINT "categories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."coupons"
    ADD CONSTRAINT "coupons_code_key" UNIQUE ("code");



ALTER TABLE ONLY "public"."coupons"
    ADD CONSTRAINT "coupons_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."deliveries"
    ADD CONSTRAINT "deliveries_order_id_key" UNIQUE ("order_id");



ALTER TABLE ONLY "public"."deliveries"
    ADD CONSTRAINT "deliveries_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."device_tokens"
    ADD CONSTRAINT "device_tokens_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."device_tokens"
    ADD CONSTRAINT "device_tokens_token_key" UNIQUE ("token");



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."order_coupons"
    ADD CONSTRAINT "order_coupons_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."order_items"
    ADD CONSTRAINT "order_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."payments"
    ADD CONSTRAINT "payments_order_id_key" UNIQUE ("order_id");



ALTER TABLE ONLY "public"."payments"
    ADD CONSTRAINT "payments_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."pickup_stops"
    ADD CONSTRAINT "pickup_stops_business_order_id_key" UNIQUE ("business_order_id");



ALTER TABLE ONLY "public"."pickup_stops"
    ADD CONSTRAINT "pickup_stops_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."platform_settings"
    ADD CONSTRAINT "platform_settings_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."product_images"
    ADD CONSTRAINT "product_images_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."product_variants"
    ADD CONSTRAINT "product_variants_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."promotions"
    ADD CONSTRAINT "promotions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."return_items"
    ADD CONSTRAINT "return_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."return_requests"
    ADD CONSTRAINT "return_requests_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."reviews"
    ADD CONSTRAINT "reviews_order_item_id_key" UNIQUE ("order_item_id");



ALTER TABLE ONLY "public"."reviews"
    ADD CONSTRAINT "reviews_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."role_applications"
    ADD CONSTRAINT "role_applications_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."state_history"
    ADD CONSTRAINT "state_history_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."wishlist_items"
    ADD CONSTRAINT "wishlist_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."wishlist_items"
    ADD CONSTRAINT "wishlist_items_wishlist_id_product_id_key" UNIQUE ("wishlist_id", "product_id");



ALTER TABLE ONLY "public"."wishlists"
    ADD CONSTRAINT "wishlists_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."wishlists"
    ADD CONSTRAINT "wishlists_user_id_key" UNIQUE ("user_id");



CREATE INDEX "addresses_user_id_idx" ON "public"."addresses" USING "btree" ("user_id", "created_at");



CREATE INDEX "business_orders_business_idx" ON "public"."business_orders" USING "btree" ("business_id", "status");



CREATE INDEX "business_orders_order_idx" ON "public"."business_orders" USING "btree" ("order_id");



CREATE INDEX "categories_parent_idx" ON "public"."categories" USING "btree" ("parent_id");



CREATE INDEX "deliveries_driver_idx" ON "public"."deliveries" USING "btree" ("driver_id", "status");



CREATE INDEX "deliveries_status_idx" ON "public"."deliveries" USING "btree" ("status");



CREATE INDEX "notifications_recipient_idx" ON "public"."notifications" USING "btree" ("recipient_id", "read", "created_at" DESC);



CREATE INDEX "order_items_biz_order_idx" ON "public"."order_items" USING "btree" ("business_order_id");



CREATE INDEX "orders_customer_idx" ON "public"."orders" USING "btree" ("customer_id", "created_at" DESC);



CREATE INDEX "pickup_stops_delivery_idx" ON "public"."pickup_stops" USING "btree" ("delivery_id", "sequence");



CREATE INDEX "product_images_product_idx" ON "public"."product_images" USING "btree" ("product_id", "sort_order");



CREATE INDEX "product_variants_product_idx" ON "public"."product_variants" USING "btree" ("product_id", "status");



CREATE INDEX "products_business_idx" ON "public"."products" USING "btree" ("business_id", "status");



CREATE INDEX "products_category_idx" ON "public"."products" USING "btree" ("category_id", "status");



CREATE INDEX "products_created_idx" ON "public"."products" USING "btree" ("status", "created_at" DESC);



CREATE INDEX "return_items_request_idx" ON "public"."return_items" USING "btree" ("return_request_id");



CREATE INDEX "return_requests_order_idx" ON "public"."return_requests" USING "btree" ("order_id");



CREATE INDEX "reviews_product_idx" ON "public"."reviews" USING "btree" ("product_id", "created_at" DESC);



CREATE UNIQUE INDEX "role_applications_one_pending" ON "public"."role_applications" USING "btree" ("user_id") WHERE ("status" = 'pending'::"public"."role_application_status");



CREATE OR REPLACE TRIGGER "addresses_touch_updated_at" BEFORE UPDATE ON "public"."addresses" FOR EACH ROW EXECUTE FUNCTION "public"."touch_updated_at"();



CREATE OR REPLACE TRIGGER "business_orders_record_state" AFTER UPDATE ON "public"."business_orders" FOR EACH ROW EXECUTE FUNCTION "public"."record_business_order_state"();



CREATE OR REPLACE TRIGGER "business_orders_touch_updated_at" BEFORE UPDATE ON "public"."business_orders" FOR EACH ROW EXECUTE FUNCTION "public"."touch_updated_at"();



CREATE OR REPLACE TRIGGER "businesses_block_status_self_change" BEFORE UPDATE ON "public"."businesses" FOR EACH ROW EXECUTE FUNCTION "public"."block_business_status_self_change"();



CREATE OR REPLACE TRIGGER "businesses_touch_updated_at" BEFORE UPDATE ON "public"."businesses" FOR EACH ROW EXECUTE FUNCTION "public"."touch_updated_at"();



CREATE OR REPLACE TRIGGER "cart_items_touch_updated_at" BEFORE UPDATE ON "public"."cart_items" FOR EACH ROW EXECUTE FUNCTION "public"."touch_updated_at"();



CREATE OR REPLACE TRIGGER "carts_touch_updated_at" BEFORE UPDATE ON "public"."carts" FOR EACH ROW EXECUTE FUNCTION "public"."touch_updated_at"();



CREATE OR REPLACE TRIGGER "deliveries_touch_updated_at" BEFORE UPDATE ON "public"."deliveries" FOR EACH ROW EXECUTE FUNCTION "public"."touch_updated_at"();



CREATE OR REPLACE TRIGGER "device_tokens_touch_updated_at" BEFORE UPDATE ON "public"."device_tokens" FOR EACH ROW EXECUTE FUNCTION "public"."touch_updated_at"();



CREATE OR REPLACE TRIGGER "notify_on_business_order_created" AFTER INSERT ON "public"."business_orders" FOR EACH ROW EXECUTE FUNCTION "public"."notify_business_new_order"();



CREATE OR REPLACE TRIGGER "notify_on_business_order_status" AFTER UPDATE ON "public"."business_orders" FOR EACH ROW EXECUTE FUNCTION "public"."notify_customer_on_business_order"();



CREATE OR REPLACE TRIGGER "notify_on_delivery_status" AFTER UPDATE ON "public"."deliveries" FOR EACH ROW EXECUTE FUNCTION "public"."notify_customer_on_delivery"();



CREATE OR REPLACE TRIGGER "notify_on_return_status" AFTER UPDATE ON "public"."return_requests" FOR EACH ROW EXECUTE FUNCTION "public"."notify_customer_on_return"();



CREATE OR REPLACE TRIGGER "payments_touch_updated_at" BEFORE UPDATE ON "public"."payments" FOR EACH ROW EXECUTE FUNCTION "public"."touch_updated_at"();



CREATE OR REPLACE TRIGGER "products_touch_updated_at" BEFORE UPDATE ON "public"."products" FOR EACH ROW EXECUTE FUNCTION "public"."touch_updated_at"();



CREATE OR REPLACE TRIGGER "promotions_touch_updated_at" BEFORE UPDATE ON "public"."promotions" FOR EACH ROW EXECUTE FUNCTION "public"."touch_updated_at"();



CREATE OR REPLACE TRIGGER "return_requests_record_state" AFTER UPDATE ON "public"."return_requests" FOR EACH ROW EXECUTE FUNCTION "public"."record_return_state"();



CREATE OR REPLACE TRIGGER "return_requests_touch_updated_at" BEFORE UPDATE ON "public"."return_requests" FOR EACH ROW EXECUTE FUNCTION "public"."touch_updated_at"();



CREATE OR REPLACE TRIGGER "role_applications_touch_updated_at" BEFORE UPDATE ON "public"."role_applications" FOR EACH ROW EXECUTE FUNCTION "public"."touch_updated_at"();



CREATE OR REPLACE TRIGGER "users_block_role_self_change" BEFORE UPDATE ON "public"."users" FOR EACH ROW EXECUTE FUNCTION "public"."block_role_self_change"();



CREATE OR REPLACE TRIGGER "users_touch_updated_at" BEFORE UPDATE ON "public"."users" FOR EACH ROW EXECUTE FUNCTION "public"."touch_updated_at"();



ALTER TABLE ONLY "public"."addresses"
    ADD CONSTRAINT "addresses_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."business_orders"
    ADD CONSTRAINT "business_orders_business_id_fkey" FOREIGN KEY ("business_id") REFERENCES "public"."businesses"("id");



ALTER TABLE ONLY "public"."business_orders"
    ADD CONSTRAINT "business_orders_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."businesses"
    ADD CONSTRAINT "businesses_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."cart_items"
    ADD CONSTRAINT "cart_items_cart_id_fkey" FOREIGN KEY ("cart_id") REFERENCES "public"."carts"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."cart_items"
    ADD CONSTRAINT "cart_items_product_variant_id_fkey" FOREIGN KEY ("product_variant_id") REFERENCES "public"."product_variants"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."carts"
    ADD CONSTRAINT "carts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."categories"
    ADD CONSTRAINT "categories_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "public"."categories"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."coupons"
    ADD CONSTRAINT "coupons_promotion_id_fkey" FOREIGN KEY ("promotion_id") REFERENCES "public"."promotions"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."deliveries"
    ADD CONSTRAINT "deliveries_driver_id_fkey" FOREIGN KEY ("driver_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."deliveries"
    ADD CONSTRAINT "deliveries_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."device_tokens"
    ADD CONSTRAINT "device_tokens_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_recipient_id_fkey" FOREIGN KEY ("recipient_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."order_coupons"
    ADD CONSTRAINT "order_coupons_business_id_fkey" FOREIGN KEY ("business_id") REFERENCES "public"."businesses"("id");



ALTER TABLE ONLY "public"."order_coupons"
    ADD CONSTRAINT "order_coupons_coupon_id_fkey" FOREIGN KEY ("coupon_id") REFERENCES "public"."coupons"("id");



ALTER TABLE ONLY "public"."order_coupons"
    ADD CONSTRAINT "order_coupons_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."order_items"
    ADD CONSTRAINT "order_items_business_order_id_fkey" FOREIGN KEY ("business_order_id") REFERENCES "public"."business_orders"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."order_items"
    ADD CONSTRAINT "order_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id");



ALTER TABLE ONLY "public"."order_items"
    ADD CONSTRAINT "order_items_product_variant_id_fkey" FOREIGN KEY ("product_variant_id") REFERENCES "public"."product_variants"("id");



ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."payments"
    ADD CONSTRAINT "payments_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."pickup_stops"
    ADD CONSTRAINT "pickup_stops_business_order_id_fkey" FOREIGN KEY ("business_order_id") REFERENCES "public"."business_orders"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."pickup_stops"
    ADD CONSTRAINT "pickup_stops_delivery_id_fkey" FOREIGN KEY ("delivery_id") REFERENCES "public"."deliveries"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."product_images"
    ADD CONSTRAINT "product_images_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."product_variants"
    ADD CONSTRAINT "product_variants_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_business_id_fkey" FOREIGN KEY ("business_id") REFERENCES "public"."businesses"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."promotions"
    ADD CONSTRAINT "promotions_business_id_fkey" FOREIGN KEY ("business_id") REFERENCES "public"."businesses"("id");



ALTER TABLE ONLY "public"."promotions"
    ADD CONSTRAINT "promotions_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."return_items"
    ADD CONSTRAINT "return_items_order_item_id_fkey" FOREIGN KEY ("order_item_id") REFERENCES "public"."order_items"("id");



ALTER TABLE ONLY "public"."return_items"
    ADD CONSTRAINT "return_items_return_request_id_fkey" FOREIGN KEY ("return_request_id") REFERENCES "public"."return_requests"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."return_requests"
    ADD CONSTRAINT "return_requests_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."return_requests"
    ADD CONSTRAINT "return_requests_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."reviews"
    ADD CONSTRAINT "reviews_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."reviews"
    ADD CONSTRAINT "reviews_order_item_id_fkey" FOREIGN KEY ("order_item_id") REFERENCES "public"."order_items"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."reviews"
    ADD CONSTRAINT "reviews_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."role_applications"
    ADD CONSTRAINT "role_applications_reviewed_by_fkey" FOREIGN KEY ("reviewed_by") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."role_applications"
    ADD CONSTRAINT "role_applications_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."wishlist_items"
    ADD CONSTRAINT "wishlist_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."wishlist_items"
    ADD CONSTRAINT "wishlist_items_wishlist_id_fkey" FOREIGN KEY ("wishlist_id") REFERENCES "public"."wishlists"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."wishlists"
    ADD CONSTRAINT "wishlists_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE "public"."addresses" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "addresses_delete_own" ON "public"."addresses" FOR DELETE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "addresses_insert_own" ON "public"."addresses" FOR INSERT WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "addresses_select_own" ON "public"."addresses" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "addresses_update_own" ON "public"."addresses" FOR UPDATE USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



ALTER TABLE "public"."audit_logs" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "audit_logs_admin_read" ON "public"."audit_logs" FOR SELECT USING ("public"."is_admin"());



ALTER TABLE "public"."business_orders" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "business_orders_customer_insert" ON "public"."business_orders" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."orders" "o"
  WHERE (("o"."id" = "business_orders"."order_id") AND ("o"."customer_id" = "auth"."uid"())))));



CREATE POLICY "business_orders_driver_select" ON "public"."business_orders" FOR SELECT USING ("public"."driver_can_view_business_order"("id"));



CREATE POLICY "business_orders_driver_update" ON "public"."business_orders" FOR UPDATE USING ("public"."owns_business_order_driver"("id")) WITH CHECK ("public"."owns_business_order_driver"("id"));



CREATE POLICY "business_orders_owner_update" ON "public"."business_orders" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM "public"."businesses" "b"
  WHERE (("b"."id" = "business_orders"."business_id") AND ("b"."owner_id" = "auth"."uid"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."businesses" "b"
  WHERE (("b"."id" = "business_orders"."business_id") AND ("b"."owner_id" = "auth"."uid"())))));



CREATE POLICY "business_orders_participant_select" ON "public"."business_orders" FOR SELECT USING (((EXISTS ( SELECT 1
   FROM "public"."orders" "o"
  WHERE (("o"."id" = "business_orders"."order_id") AND ("o"."customer_id" = "auth"."uid"())))) OR (EXISTS ( SELECT 1
   FROM "public"."businesses" "b"
  WHERE (("b"."id" = "business_orders"."business_id") AND ("b"."owner_id" = "auth"."uid"()))))));



ALTER TABLE "public"."businesses" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "businesses_owner_insert" ON "public"."businesses" FOR INSERT WITH CHECK (("auth"."uid"() = "owner_id"));



CREATE POLICY "businesses_owner_read" ON "public"."businesses" FOR SELECT USING (("auth"."uid"() = "owner_id"));



CREATE POLICY "businesses_owner_update" ON "public"."businesses" FOR UPDATE USING (("auth"."uid"() = "owner_id")) WITH CHECK (("auth"."uid"() = "owner_id"));



CREATE POLICY "businesses_public_read_active" ON "public"."businesses" FOR SELECT USING (("status" = 'active'::"public"."business_status"));



ALTER TABLE "public"."cart_items" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "cart_items_own_all" ON "public"."cart_items" USING ((EXISTS ( SELECT 1
   FROM "public"."carts" "c"
  WHERE (("c"."id" = "cart_items"."cart_id") AND ("c"."user_id" = "auth"."uid"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."carts" "c"
  WHERE (("c"."id" = "cart_items"."cart_id") AND ("c"."user_id" = "auth"."uid"())))));



ALTER TABLE "public"."carts" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "carts_own_all" ON "public"."carts" USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



ALTER TABLE "public"."categories" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "categories_admin_delete" ON "public"."categories" FOR DELETE USING ("public"."is_admin"());



CREATE POLICY "categories_admin_insert" ON "public"."categories" FOR INSERT WITH CHECK ("public"."is_admin"());



CREATE POLICY "categories_admin_update" ON "public"."categories" FOR UPDATE USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());



CREATE POLICY "categories_public_read" ON "public"."categories" FOR SELECT USING (true);



ALTER TABLE "public"."coupons" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "coupons_creator_write" ON "public"."coupons" USING ((EXISTS ( SELECT 1
   FROM "public"."promotions" "p"
  WHERE (("p"."id" = "coupons"."promotion_id") AND ("p"."created_by" = "auth"."uid"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."promotions" "p"
  WHERE (("p"."id" = "coupons"."promotion_id") AND ("p"."created_by" = "auth"."uid"())))));



CREATE POLICY "coupons_public_read" ON "public"."coupons" FOR SELECT USING (true);



ALTER TABLE "public"."deliveries" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "deliveries_customer_insert" ON "public"."deliveries" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."orders" "o"
  WHERE (("o"."id" = "deliveries"."order_id") AND ("o"."customer_id" = "auth"."uid"())))));



CREATE POLICY "deliveries_driver_update" ON "public"."deliveries" FOR UPDATE USING ((("driver_id" = "auth"."uid"()) OR (("status" = 'available'::"public"."delivery_status") AND ("driver_id" IS NULL) AND "public"."is_driver"()))) WITH CHECK ((("driver_id" = "auth"."uid"()) OR (("status" = 'available'::"public"."delivery_status") AND ("driver_id" IS NULL) AND "public"."is_driver"())));



CREATE POLICY "deliveries_read" ON "public"."deliveries" FOR SELECT USING (((EXISTS ( SELECT 1
   FROM "public"."orders" "o"
  WHERE (("o"."id" = "deliveries"."order_id") AND ("o"."customer_id" = "auth"."uid"())))) OR ("driver_id" = "auth"."uid"()) OR (("status" = 'available'::"public"."delivery_status") AND "public"."is_driver"())));



ALTER TABLE "public"."device_tokens" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "device_tokens_own_all" ON "public"."device_tokens" USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



ALTER TABLE "public"."notifications" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "notifications_own_all" ON "public"."notifications" USING (("auth"."uid"() = "recipient_id")) WITH CHECK (("auth"."uid"() = "recipient_id"));



ALTER TABLE "public"."order_coupons" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "order_coupons_customer_insert" ON "public"."order_coupons" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."orders" "o"
  WHERE (("o"."id" = "order_coupons"."order_id") AND ("o"."customer_id" = "auth"."uid"())))));



CREATE POLICY "order_coupons_customer_read" ON "public"."order_coupons" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."orders" "o"
  WHERE (("o"."id" = "order_coupons"."order_id") AND ("o"."customer_id" = "auth"."uid"())))));



ALTER TABLE "public"."order_items" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "order_items_customer_insert" ON "public"."order_items" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."business_orders" "bo"
     JOIN "public"."orders" "o" ON (("o"."id" = "bo"."order_id")))
  WHERE (("bo"."id" = "order_items"."business_order_id") AND ("o"."customer_id" = "auth"."uid"())))));



CREATE POLICY "order_items_participant_select" ON "public"."order_items" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."business_orders" "bo"
     JOIN "public"."orders" "o" ON (("o"."id" = "bo"."order_id")))
  WHERE (("bo"."id" = "order_items"."business_order_id") AND (("o"."customer_id" = "auth"."uid"()) OR (EXISTS ( SELECT 1
           FROM "public"."businesses" "b"
          WHERE (("b"."id" = "bo"."business_id") AND ("b"."owner_id" = "auth"."uid"())))))))));



ALTER TABLE "public"."orders" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "orders_customer_insert" ON "public"."orders" FOR INSERT WITH CHECK (("auth"."uid"() = "customer_id"));



CREATE POLICY "orders_customer_select" ON "public"."orders" FOR SELECT USING (("auth"."uid"() = "customer_id"));



CREATE POLICY "orders_driver_select" ON "public"."orders" FOR SELECT USING ("public"."driver_can_view_order"("id"));



ALTER TABLE "public"."payments" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "payments_customer_all" ON "public"."payments" USING ((EXISTS ( SELECT 1
   FROM "public"."orders" "o"
  WHERE (("o"."id" = "payments"."order_id") AND ("o"."customer_id" = "auth"."uid"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."orders" "o"
  WHERE (("o"."id" = "payments"."order_id") AND ("o"."customer_id" = "auth"."uid"())))));



CREATE POLICY "payments_driver_update" ON "public"."payments" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM "public"."deliveries" "d"
  WHERE (("d"."order_id" = "payments"."order_id") AND ("d"."driver_id" = "auth"."uid"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."deliveries" "d"
  WHERE (("d"."order_id" = "payments"."order_id") AND ("d"."driver_id" = "auth"."uid"())))));



ALTER TABLE "public"."pickup_stops" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "pickup_stops_customer_insert" ON "public"."pickup_stops" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."deliveries" "d"
     JOIN "public"."orders" "o" ON (("o"."id" = "d"."order_id")))
  WHERE (("d"."id" = "pickup_stops"."delivery_id") AND ("o"."customer_id" = "auth"."uid"())))));



CREATE POLICY "pickup_stops_driver_update" ON "public"."pickup_stops" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM "public"."deliveries" "d"
  WHERE (("d"."id" = "pickup_stops"."delivery_id") AND ("d"."driver_id" = "auth"."uid"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."deliveries" "d"
  WHERE (("d"."id" = "pickup_stops"."delivery_id") AND ("d"."driver_id" = "auth"."uid"())))));



CREATE POLICY "pickup_stops_read" ON "public"."pickup_stops" FOR SELECT USING (((EXISTS ( SELECT 1
   FROM ("public"."deliveries" "d"
     JOIN "public"."orders" "o" ON (("o"."id" = "d"."order_id")))
  WHERE (("d"."id" = "pickup_stops"."delivery_id") AND (("o"."customer_id" = "auth"."uid"()) OR ("d"."driver_id" = "auth"."uid"()))))) OR "public"."driver_can_view_delivery"("delivery_id") OR (EXISTS ( SELECT 1
   FROM ((("public"."deliveries" "d"
     JOIN "public"."orders" "o" ON (("o"."id" = "d"."order_id")))
     JOIN "public"."business_orders" "bo" ON (("bo"."id" = "pickup_stops"."business_order_id")))
     JOIN "public"."businesses" "b" ON (("b"."id" = "bo"."business_id")))
  WHERE (("d"."id" = "pickup_stops"."delivery_id") AND ("b"."owner_id" = "auth"."uid"()))))));



ALTER TABLE "public"."platform_settings" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "platform_settings_admin_update" ON "public"."platform_settings" FOR UPDATE USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());



CREATE POLICY "platform_settings_public_read" ON "public"."platform_settings" FOR SELECT USING (true);



ALTER TABLE "public"."product_images" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "product_images_owner_all" ON "public"."product_images" USING ((EXISTS ( SELECT 1
   FROM ("public"."products" "p"
     JOIN "public"."businesses" "b" ON (("b"."id" = "p"."business_id")))
  WHERE (("p"."id" = "product_images"."product_id") AND ("b"."owner_id" = "auth"."uid"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."products" "p"
     JOIN "public"."businesses" "b" ON (("b"."id" = "p"."business_id")))
  WHERE (("p"."id" = "product_images"."product_id") AND ("b"."owner_id" = "auth"."uid"())))));



CREATE POLICY "product_images_public_read" ON "public"."product_images" FOR SELECT USING (true);



ALTER TABLE "public"."product_variants" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "product_variants_owner_all" ON "public"."product_variants" USING ((EXISTS ( SELECT 1
   FROM ("public"."products" "p"
     JOIN "public"."businesses" "b" ON (("b"."id" = "p"."business_id")))
  WHERE (("p"."id" = "product_variants"."product_id") AND ("b"."owner_id" = "auth"."uid"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."products" "p"
     JOIN "public"."businesses" "b" ON (("b"."id" = "p"."business_id")))
  WHERE (("p"."id" = "product_variants"."product_id") AND ("b"."owner_id" = "auth"."uid"())))));



CREATE POLICY "product_variants_public_read_active" ON "public"."product_variants" FOR SELECT USING ((("status" = 'active'::"public"."product_status") AND (EXISTS ( SELECT 1
   FROM "public"."products" "p"
  WHERE (("p"."id" = "product_variants"."product_id") AND ("p"."status" = 'active'::"public"."product_status"))))));



ALTER TABLE "public"."products" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "products_owner_all" ON "public"."products" USING ((EXISTS ( SELECT 1
   FROM "public"."businesses" "b"
  WHERE (("b"."id" = "products"."business_id") AND ("b"."owner_id" = "auth"."uid"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."businesses" "b"
  WHERE (("b"."id" = "products"."business_id") AND ("b"."owner_id" = "auth"."uid"())))));



CREATE POLICY "products_public_read_active" ON "public"."products" FOR SELECT USING ((("status" = 'active'::"public"."product_status") AND (EXISTS ( SELECT 1
   FROM "public"."businesses" "b"
  WHERE (("b"."id" = "products"."business_id") AND ("b"."status" = 'active'::"public"."business_status"))))));



ALTER TABLE "public"."promotions" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "promotions_admin_read" ON "public"."promotions" FOR SELECT USING ("public"."is_admin"());



CREATE POLICY "promotions_admin_update" ON "public"."promotions" FOR UPDATE USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());



CREATE POLICY "promotions_creator_all" ON "public"."promotions" USING (("auth"."uid"() = "created_by")) WITH CHECK (("auth"."uid"() = "created_by"));



CREATE POLICY "promotions_public_read" ON "public"."promotions" FOR SELECT USING (true);



ALTER TABLE "public"."return_items" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "return_items_customer_insert" ON "public"."return_items" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."return_requests" "rr"
  WHERE (("rr"."id" = "return_items"."return_request_id") AND ("rr"."customer_id" = "auth"."uid"())))));



CREATE POLICY "return_items_read" ON "public"."return_items" FOR SELECT USING (((EXISTS ( SELECT 1
   FROM "public"."return_requests" "rr"
  WHERE (("rr"."id" = "return_items"."return_request_id") AND ("rr"."customer_id" = "auth"."uid"())))) OR "public"."owns_returned_items"("return_request_id")));



ALTER TABLE "public"."return_requests" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "return_requests_customer_insert" ON "public"."return_requests" FOR INSERT WITH CHECK (("auth"."uid"() = "customer_id"));



CREATE POLICY "return_requests_read" ON "public"."return_requests" FOR SELECT USING ((("auth"."uid"() = "customer_id") OR "public"."owns_returned_items"("id")));



ALTER TABLE "public"."reviews" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "reviews_customer_insert" ON "public"."reviews" FOR INSERT WITH CHECK (("auth"."uid"() = "customer_id"));



CREATE POLICY "reviews_public_read" ON "public"."reviews" FOR SELECT USING (true);



ALTER TABLE "public"."role_applications" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "role_applications_admin_read" ON "public"."role_applications" FOR SELECT USING ("public"."is_admin"());



CREATE POLICY "role_applications_own_insert" ON "public"."role_applications" FOR INSERT WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "role_applications_own_read" ON "public"."role_applications" FOR SELECT USING (("auth"."uid"() = "user_id"));



ALTER TABLE "public"."state_history" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "state_history_admin_read" ON "public"."state_history" FOR SELECT USING ("public"."is_admin"());



ALTER TABLE "public"."users" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "users_admin_read" ON "public"."users" FOR SELECT USING ("public"."is_admin"());



CREATE POLICY "users_driver_read" ON "public"."users" FOR SELECT USING ("public"."driver_can_view_user"("id"));



CREATE POLICY "users_select_own" ON "public"."users" FOR SELECT USING (("auth"."uid"() = "id"));



CREATE POLICY "users_update_own" ON "public"."users" FOR UPDATE USING (("auth"."uid"() = "id")) WITH CHECK (("auth"."uid"() = "id"));



ALTER TABLE "public"."wishlist_items" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "wishlist_items_own_all" ON "public"."wishlist_items" USING ((EXISTS ( SELECT 1
   FROM "public"."wishlists" "w"
  WHERE (("w"."id" = "wishlist_items"."wishlist_id") AND ("w"."user_id" = "auth"."uid"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."wishlists" "w"
  WHERE (("w"."id" = "wishlist_items"."wishlist_id") AND ("w"."user_id" = "auth"."uid"())))));



ALTER TABLE "public"."wishlists" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "wishlists_own_all" ON "public"."wishlists" USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));





ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."business_orders";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."deliveries";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."notifications";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."orders";






GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";











































































































































































GRANT ALL ON TABLE "public"."addresses" TO "anon";
GRANT ALL ON TABLE "public"."addresses" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."addresses" TO "service_role";



GRANT ALL ON TABLE "public"."audit_logs" TO "anon";
GRANT ALL ON TABLE "public"."audit_logs" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."audit_logs" TO "service_role";



GRANT ALL ON TABLE "public"."business_orders" TO "anon";
GRANT ALL ON TABLE "public"."business_orders" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."business_orders" TO "service_role";



GRANT ALL ON TABLE "public"."businesses" TO "anon";
GRANT ALL ON TABLE "public"."businesses" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."businesses" TO "service_role";



GRANT ALL ON TABLE "public"."cart_items" TO "anon";
GRANT ALL ON TABLE "public"."cart_items" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."cart_items" TO "service_role";



GRANT ALL ON TABLE "public"."carts" TO "anon";
GRANT ALL ON TABLE "public"."carts" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."carts" TO "service_role";



GRANT ALL ON TABLE "public"."categories" TO "anon";
GRANT ALL ON TABLE "public"."categories" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."categories" TO "service_role";



GRANT ALL ON TABLE "public"."coupons" TO "anon";
GRANT ALL ON TABLE "public"."coupons" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."coupons" TO "service_role";



GRANT ALL ON TABLE "public"."deliveries" TO "anon";
GRANT ALL ON TABLE "public"."deliveries" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."deliveries" TO "service_role";



GRANT ALL ON TABLE "public"."device_tokens" TO "anon";
GRANT ALL ON TABLE "public"."device_tokens" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."device_tokens" TO "service_role";



GRANT ALL ON TABLE "public"."notifications" TO "anon";
GRANT ALL ON TABLE "public"."notifications" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."notifications" TO "service_role";



GRANT ALL ON TABLE "public"."order_coupons" TO "anon";
GRANT ALL ON TABLE "public"."order_coupons" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."order_coupons" TO "service_role";



GRANT ALL ON TABLE "public"."order_items" TO "anon";
GRANT ALL ON TABLE "public"."order_items" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."order_items" TO "service_role";



GRANT ALL ON TABLE "public"."orders" TO "anon";
GRANT ALL ON TABLE "public"."orders" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."orders" TO "service_role";



GRANT ALL ON TABLE "public"."payments" TO "anon";
GRANT ALL ON TABLE "public"."payments" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."payments" TO "service_role";



GRANT ALL ON TABLE "public"."pickup_stops" TO "anon";
GRANT ALL ON TABLE "public"."pickup_stops" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."pickup_stops" TO "service_role";



GRANT ALL ON TABLE "public"."platform_settings" TO "anon";
GRANT ALL ON TABLE "public"."platform_settings" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."platform_settings" TO "service_role";



GRANT ALL ON TABLE "public"."product_images" TO "anon";
GRANT ALL ON TABLE "public"."product_images" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."product_images" TO "service_role";



GRANT ALL ON TABLE "public"."product_variants" TO "anon";
GRANT ALL ON TABLE "public"."product_variants" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."product_variants" TO "service_role";



GRANT ALL ON TABLE "public"."products" TO "anon";
GRANT ALL ON TABLE "public"."products" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."products" TO "service_role";



GRANT ALL ON TABLE "public"."promotions" TO "anon";
GRANT ALL ON TABLE "public"."promotions" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."promotions" TO "service_role";



GRANT ALL ON TABLE "public"."return_items" TO "anon";
GRANT ALL ON TABLE "public"."return_items" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."return_items" TO "service_role";



GRANT ALL ON TABLE "public"."return_requests" TO "anon";
GRANT ALL ON TABLE "public"."return_requests" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."return_requests" TO "service_role";



GRANT ALL ON TABLE "public"."reviews" TO "anon";
GRANT ALL ON TABLE "public"."reviews" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."reviews" TO "service_role";



GRANT ALL ON TABLE "public"."role_applications" TO "anon";
GRANT ALL ON TABLE "public"."role_applications" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."role_applications" TO "service_role";



GRANT ALL ON TABLE "public"."state_history" TO "anon";
GRANT ALL ON TABLE "public"."state_history" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."state_history" TO "service_role";



GRANT ALL ON TABLE "public"."users" TO "anon";
GRANT ALL ON TABLE "public"."users" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."users" TO "service_role";



GRANT ALL ON TABLE "public"."wishlist_items" TO "anon";
GRANT ALL ON TABLE "public"."wishlist_items" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."wishlist_items" TO "service_role";



GRANT ALL ON TABLE "public"."wishlists" TO "anon";
GRANT ALL ON TABLE "public"."wishlists" TO "authenticated";
GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE "public"."wishlists" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT UPDATE ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLES TO "service_role";































