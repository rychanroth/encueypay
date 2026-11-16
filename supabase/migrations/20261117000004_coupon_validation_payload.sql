-- Restore the structured coupon-verdict payload (2026-11-17).
--
-- `20261116000001` redefined `validate_coupon` for selected cart lines and
-- dropped everything but {valid, message, discount_minor}, so the checkout
-- UI rendered blanks and zeros from a payload that no longer carried them:
-- "No minimum spend" for a coupon that has one (min_order_amount_minor read as
-- 0), no name, no offer line, "your subtotal is $0.00" on a minimum-spend
-- rejection, and no structured reason to tell "not started" from "expired".
--
-- The client contract (`_couponFromJson` + `_couponRequirement`) expects the
-- 20261102000001 shape:
--   code, valid, reason, message, subtotal_minor, discount_minor,
--   name, discount_type, discount_value,
--   min_order_amount_minor, starts_at, ends_at
-- Same signature as the live function (p_item_ids included), so this is a
-- plain CREATE OR REPLACE — no overload.

create or replace function public.validate_coupon(
    p_code text,
    p_item_ids uuid[] default null
) returns jsonb
    language plpgsql stable security definer
    set search_path to 'public'
    as $$
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

  -- Selected lines only: checkout prices and charges the ticked lines, so the
  -- minimum-spend check must use the same subtotal.
  select coalesce(sum(public.best_sale_price_minor(
                     pv.product_id, pv.price_minor) * ci.quantity), 0)
    into v_subtotal
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
   where ci.cart_id = v_cart_id
     and (p_item_ids is null
          or cardinality(p_item_ids) = 0
          or ci.id = any(p_item_ids));

  v_base := jsonb_build_object(
    'code', v_code, 'valid', false, 'subtotal_minor', v_subtotal,
    'discount_minor', 0);

  if v_code = '' then
    return v_base || jsonb_build_object(
      'reason', 'not_found', 'message', 'Enter a coupon code');
  end if;

  -- Fetch by code only: the failure reason needs the row even when it is
  -- inactive, archived or outside its window.
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

  if not v_coupon.active or v_coupon.archived_at is not null then
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
    'valid', true, 'discount_minor', v_discount,
    'message', v_coupon.name);
end;
$$;
