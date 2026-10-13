-- Single-seller schema retirement (2-Role prototype, DESIGN.md §1.1).
-- The branch pivoted from a vendor-capable data model to an admin-centric
-- single-seller application; the auto-provisioned prototype store made the
-- last UX friction vanish, and these columns are now provably dead or
-- constant. This migration removes them so the schema tells the truth.
--
-- Removed: products.business_id, promotions.business_id (always NULL — the
-- 'business' promotion scope is unreachable from the UI),
-- order_coupons.business_id (always NULL copy), order_items.business_name
-- (constant snapshot), and the businesses table itself.
--
-- KEPT: the promotion_scope enum retains its dormant 'business' value
-- (Postgres cannot drop enum values); validate_coupon simply no longer
-- branches on it. Re-enabling multi-vendor later is a data-model addition,
-- not a reconstruction.

-- ------------------------------------------------------------ dead columns
-- Vendor-era read policies gated visibility on the owning business's
-- status; single-seller visibility is product-level (§2d keeps every
-- status browsable — purchase is gated at checkout).
DROP POLICY "products_public_read" ON "public"."products";
CREATE POLICY "products_public_read" ON "public"."products"
  FOR SELECT TO anon, authenticated
  USING (true);

DROP POLICY "product_variants_public_read" ON "public"."product_variants";
CREATE POLICY "product_variants_public_read" ON "public"."product_variants"
  FOR SELECT TO anon, authenticated
  USING (true);

ALTER TABLE "public"."products" DROP COLUMN "business_id";
ALTER TABLE "public"."promotions" DROP COLUMN "business_id";
ALTER TABLE "public"."order_coupons" DROP COLUMN "business_id";
ALTER TABLE "public"."order_items" DROP COLUMN "business_name";

-- ------------------------------------------------- storage policy reworked
-- The product_images admin-insert policy validated the {business_id}/...
-- folder against the businesses table. Product images now upload under
-- {product_id}/... with plain admin authority (no folder check).
DROP POLICY IF EXISTS "product_images_bucket_admin_insert" ON "storage"."objects";
CREATE POLICY "product_images_bucket_admin_insert" ON "storage"."objects"
  FOR INSERT TO authenticated
  WITH CHECK ("bucket_id" = 'product_images' AND "public"."is_admin"());

-- ------------------------------------------------------- businesses table
DROP TABLE "public"."businesses";

-- -------------------------------------------------------------- RPC rework
-- Checkout: the validity chain no longer joins an active business; coupon
-- bookkeeping loses the business dimension; line items lose the (constant)
-- business snapshot.
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
  -- applies to the scope's applicable subtotal.
  create temp table _coupon_discounts (
    coupon_id uuid primary key,
    discount bigint not null
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

    insert into _coupon_discounts (coupon_id, discount)
    values (v_coupon.id, v_coupon_discount);

    v_discount_total := v_discount_total + v_coupon_discount;
  end loop;
  v_discount_total := least(v_discount_total, v_subtotal);

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
  -- promotion/coupon changes or is deleted later.
  insert into public.order_coupons (order_id, coupon_id, discount_minor)
  select v_order_id, coupon_id, discount
  from _coupon_discounts;

  delete from public.cart_items where cart_id = v_cart_id;

  return v_order_id;
end;
$$;

-- Coupon preview: single-seller scopes only (platform | brand).
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

  select c.id, pr.scope, pr.brand_id,
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

-- Product creation: no business dimension.
CREATE OR REPLACE FUNCTION public.admin_create_product(
    p_category_id uuid,
    p_name text,
    p_description text,
    p_base_price_minor bigint,
    p_brand_id uuid DEFAULT NULL,
    p_stock integer DEFAULT 0,
    p_variants jsonb DEFAULT '[]'
) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
declare
  v_product_id uuid;
  v_variant record;
  v_variant_count integer;
begin
  if not public.is_admin() then
    raise exception 'Only admins can create products';
  end if;

  insert into public.products
    (category_id, name, description, base_price_minor, brand_id, stock)
  values
    (p_category_id, p_name, p_description, p_base_price_minor, p_brand_id, p_stock)
  returning id into v_product_id;

  select count(*) into v_variant_count
  from jsonb_to_recordset(p_variants) as x(name text, price_minor bigint);
  if v_variant_count = 0 then
    -- Auto-'Default' variant (null price tracks the base price) — a
    -- variant-less product is un-buyable (map §10.3).
    insert into public.product_variants (product_id, name, attributes)
    values (v_product_id, 'Default', '{}');
  else
    for v_variant in
      select * from jsonb_to_recordset(p_variants) as x(name text, price_minor bigint)
    loop
      insert into public.product_variants (product_id, name, price_minor, attributes)
      values (v_product_id, v_variant.name, v_variant.price_minor, '{}');
    end loop;
  end if;

  perform public.record_admin_audit(
    'admin_create_product', 'product', v_product_id,
    jsonb_build_object('name', p_name, 'stock', p_stock));
  return v_product_id;
end;
$$;
