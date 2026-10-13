-- Cart voucher scope recognition (DESIGN.md §5.1.3): validate_coupon now
-- returns the promotion scope so the UI can badge 'Platform' vs 'Brand'.
-- Additive key only — existing consumers ignore it.

CREATE OR REPLACE FUNCTION public.validate_coupon(p_code text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_user uuid := auth.uid();
  v_cart_id uuid;
  v_coupon record;
  v_subtotal bigint := 0;
  v_base bigint;
  v_discount bigint;
begin
  if v_user is null then
    return jsonb_build_object('valid', false, 'message', 'Not authenticated');
  end if;
  select id into v_cart_id from public.carts where user_id = v_user;

  select c.id, pr.scope, pr.business_id, pr.brand_id,
         pr.discount_type, pr.discount_value, c.min_order_amount_minor
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

  select coalesce(sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity), 0)
  into v_subtotal
  from public.cart_items ci
  join public.product_variants pv on pv.id = ci.product_variant_id
  join public.products p on p.id = pv.product_id
  where ci.cart_id = v_cart_id;

  v_base := case v_coupon.scope
    when 'business' then (
      select coalesce(sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity), 0)
      from public.cart_items ci
      join public.product_variants pv on pv.id = ci.product_variant_id
      join public.products p on p.id = pv.product_id
      where ci.cart_id = v_cart_id and p.business_id = v_coupon.business_id
    )
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
    return jsonb_build_object('valid', false, 'message', 'Coupon does not apply to your cart');
  end if;
  if v_base < v_coupon.min_order_amount_minor then
    return jsonb_build_object('valid', false, 'message',
      'Coupon requires a minimum order of ' || v_coupon.min_order_amount_minor);
  end if;

  v_discount := case v_coupon.discount_type
    when 'fixed' then least(v_coupon.discount_value, v_base)
    else (v_base * v_coupon.discount_value) / 100
  end;

  return jsonb_build_object(
    'valid', true,
    'discount_minor', v_discount,
    'scope', v_coupon.scope::text
  );
end;
$$;
