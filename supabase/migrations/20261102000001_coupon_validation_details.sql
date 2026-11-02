-- Structured coupon validation + preview feedback.
--
-- `validate_coupon` previously collapsed every failure into one message and
-- returned only the coupon name on success. The checkout UI needs the exact
-- requirement (minimum spend / window / inactive) plus the coupon offer so it
-- can render a useful breakdown. The function signature is unchanged, so
-- CREATE OR REPLACE is safe (no new overload).
--
-- `preview_order_totals` gains the same per-code metadata and a `rejected`
-- array: codes that stop qualifying after a cart edit are no longer silently
-- dropped from the summary.
--
-- Amount semantics: fixed `discount_value` is minor units; percent is a whole
-- percentage. The client formats fixed values with Money and percent values as
-- `N% off` — this migration never formats dollars itself.

CREATE OR REPLACE FUNCTION public.validate_coupon(p_code text)
RETURNS jsonb
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_user uuid := auth.uid();
  v_cart_id uuid;
  v_subtotal bigint := 0;
  v_coupon record;
  v_discount bigint;
  v_code text := upper(trim(coalesce(p_code, '')));
  v_base jsonb;
begin
  if v_user is null then
    return jsonb_build_object(
      'valid', false, 'code', v_code, 'reason', 'not_authenticated',
      'message', 'Sign in to use a coupon', 'discount_minor', 0);
  end if;

  select id into v_cart_id from public.carts where user_id = v_user;
  if v_cart_id is null then
    return jsonb_build_object(
      'valid', false, 'code', v_code, 'reason', 'empty_cart',
      'message', 'Your cart is empty', 'discount_minor', 0);
  end if;

  select coalesce(sum(public.best_sale_price_minor(
                     pv.product_id,
                     coalesce(pv.price_minor, p.base_price_minor)) * ci.quantity), 0)
    into v_subtotal
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    join public.products p on p.id = pv.product_id
   where ci.cart_id = v_cart_id;

  v_base := jsonb_build_object(
    'code', v_code, 'valid', false, 'subtotal_minor', v_subtotal,
    'discount_minor', 0);

  if v_code = '' then
    return v_base || jsonb_build_object(
      'reason', 'not_found', 'message', 'Enter a coupon code');
  end if;

  -- Fetch by code only: the failure reason needs the row even when it is
  -- inactive or outside its window.
  select * into v_coupon
    from public.coupons
   where upper(code) = v_code
   limit 1;
  if not found then
    return v_base || jsonb_build_object(
      'reason', 'not_found', 'message', 'Coupon code not found');
  end if;

  v_base := v_base || jsonb_build_object(
    'name', v_coupon.name,
    'discount_type', v_coupon.discount_type,
    'discount_value', v_coupon.discount_value,
    'min_order_amount_minor', v_coupon.min_order_amount_minor,
    'starts_at', v_coupon.starts_at,
    'ends_at', v_coupon.ends_at);

  if not v_coupon.active then
    return v_base || jsonb_build_object(
      'reason', 'inactive', 'message', 'This coupon is no longer active');
  end if;
  if v_coupon.starts_at is not null and v_coupon.starts_at > now() then
    return v_base || jsonb_build_object(
      'reason', 'not_started', 'message', 'This coupon is not active yet');
  end if;
  if v_coupon.ends_at is not null and v_coupon.ends_at < now() then
    return v_base || jsonb_build_object(
      'reason', 'expired', 'message', 'This coupon has expired');
  end if;
  if v_subtotal = 0 then
    return v_base || jsonb_build_object(
      'reason', 'empty_cart', 'message', 'Your cart is empty');
  end if;
  if v_subtotal < v_coupon.min_order_amount_minor then
    return v_base || jsonb_build_object(
      'reason', 'min_order_not_met',
      'message', 'This coupon requires a higher minimum spend');
  end if;

  v_discount := case v_coupon.discount_type
    when 'fixed' then least(v_coupon.discount_value, v_subtotal)
    else (v_subtotal * v_coupon.discount_value) / 100
  end;
  return v_base || jsonb_build_object(
    'valid', true,
    'message', v_coupon.name,
    'discount_minor', v_discount);
end;
$$;

CREATE OR REPLACE FUNCTION public.preview_order_totals(
    p_codes text[] DEFAULT '{}'
) RETURNS jsonb
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_user uuid := auth.uid();
  v_cart_id uuid;
  v_subtotal bigint := 0;
  v_delivery_fee bigint := 0;
  v_code text;
  v_coupon record;
  v_discount bigint;
  v_manual jsonb := '[]'::jsonb;
  v_rejected jsonb := '[]'::jsonb;
  v_total_discount bigint := 0;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  select coalesce(delivery_fee_minor, 0) into v_delivery_fee
    from public.platform_settings where id = 1;

  select id into v_cart_id from public.carts where user_id = v_user;
  if v_cart_id is null then
    return jsonb_build_object(
      'subtotal_minor', 0, 'manual', v_manual, 'rejected', v_rejected,
      'total_discount_minor', 0, 'delivery_fee_minor', v_delivery_fee,
      'total_minor', v_delivery_fee);
  end if;

  select coalesce(sum(public.best_sale_price_minor(
                     pv.product_id,
                     coalesce(pv.price_minor, p.base_price_minor)) * ci.quantity), 0)
    into v_subtotal
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    join public.products p on p.id = pv.product_id
   where ci.cart_id = v_cart_id;

  foreach v_code in array coalesce(p_codes, '{}') loop
    v_code := trim(v_code);
    if coalesce(v_code, '') = '' then
      continue;
    end if;

    select * into v_coupon
      from public.coupons
     where upper(code) = upper(v_code)
     limit 1;
    if not found then
      v_rejected := v_rejected || jsonb_build_array(jsonb_build_object(
        'code', v_code, 'valid', false, 'reason', 'not_found',
        'message', 'Coupon code not found'));
      continue;
    end if;

    if not v_coupon.active then
      v_rejected := v_rejected || jsonb_build_array(jsonb_build_object(
        'code', v_code, 'valid', false, 'reason', 'inactive',
        'message', 'This coupon is no longer active',
        'name', v_coupon.name,
        'discount_type', v_coupon.discount_type,
        'discount_value', v_coupon.discount_value,
        'min_order_amount_minor', v_coupon.min_order_amount_minor,
        'starts_at', v_coupon.starts_at,
        'ends_at', v_coupon.ends_at,
        'subtotal_minor', v_subtotal, 'discount_minor', 0));
      continue;
    end if;
    if v_coupon.starts_at is not null and v_coupon.starts_at > now() then
      v_rejected := v_rejected || jsonb_build_array(jsonb_build_object(
        'code', v_code, 'valid', false, 'reason', 'not_started',
        'message', 'This coupon is not active yet',
        'name', v_coupon.name,
        'discount_type', v_coupon.discount_type,
        'discount_value', v_coupon.discount_value,
        'min_order_amount_minor', v_coupon.min_order_amount_minor,
        'starts_at', v_coupon.starts_at,
        'ends_at', v_coupon.ends_at,
        'subtotal_minor', v_subtotal, 'discount_minor', 0));
      continue;
    end if;
    if v_coupon.ends_at is not null and v_coupon.ends_at < now() then
      v_rejected := v_rejected || jsonb_build_array(jsonb_build_object(
        'code', v_code, 'valid', false, 'reason', 'expired',
        'message', 'This coupon has expired',
        'name', v_coupon.name,
        'discount_type', v_coupon.discount_type,
        'discount_value', v_coupon.discount_value,
        'min_order_amount_minor', v_coupon.min_order_amount_minor,
        'starts_at', v_coupon.starts_at,
        'ends_at', v_coupon.ends_at,
        'subtotal_minor', v_subtotal, 'discount_minor', 0));
      continue;
    end if;
    if v_subtotal = 0 then
      v_rejected := v_rejected || jsonb_build_array(jsonb_build_object(
        'code', v_code, 'valid', false, 'reason', 'empty_cart',
        'message', 'Your cart is empty',
        'subtotal_minor', v_subtotal, 'discount_minor', 0));
      continue;
    end if;
    if v_subtotal < v_coupon.min_order_amount_minor then
      v_rejected := v_rejected || jsonb_build_array(jsonb_build_object(
        'code', v_code, 'valid', false, 'reason', 'min_order_not_met',
        'message', 'This coupon requires a higher minimum spend',
        'name', v_coupon.name,
        'discount_type', v_coupon.discount_type,
        'discount_value', v_coupon.discount_value,
        'min_order_amount_minor', v_coupon.min_order_amount_minor,
        'starts_at', v_coupon.starts_at,
        'ends_at', v_coupon.ends_at,
        'subtotal_minor', v_subtotal, 'discount_minor', 0));
      continue;
    end if;

    v_discount := case v_coupon.discount_type
      when 'fixed' then least(v_coupon.discount_value, v_subtotal)
      else (v_subtotal * v_coupon.discount_value) / 100
    end;
    v_manual := v_manual || jsonb_build_array(jsonb_build_object(
      'code', v_code, 'valid', true, 'name', v_coupon.name,
      'discount_type', v_coupon.discount_type,
      'discount_value', v_coupon.discount_value,
      'min_order_amount_minor', v_coupon.min_order_amount_minor,
      'starts_at', v_coupon.starts_at,
      'ends_at', v_coupon.ends_at,
      'subtotal_minor', v_subtotal,
      'discount_minor', v_discount));
    v_total_discount := v_total_discount + v_discount;
  end loop;
  v_total_discount := least(v_total_discount, v_subtotal);

  return jsonb_build_object(
    'subtotal_minor', v_subtotal,
    'manual', v_manual,
    'rejected', v_rejected,
    'total_discount_minor', v_total_discount,
    'delivery_fee_minor', v_delivery_fee,
    'total_minor', v_subtotal - v_total_discount + v_delivery_fee);
end;
$$;
