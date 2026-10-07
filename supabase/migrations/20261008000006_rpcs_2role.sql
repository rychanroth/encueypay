-- Bridge M6/6 — the 2-role RPC surface (pivot map §6, §4 chokepoints).
--
-- Authority model (map §0/§5): is_admin() at the top of every admin RPC;
-- audit-log insert in every admin mutation; auth.uid() at the top of every
-- customer RPC; SD reserved for the primitives that must bypass RLS:
-- cancel_order, confirm_qr_payment, validate_coupon (reads promotions,
-- which are RPC-only with no public read policy), the report/dashboard
-- builders, notify_*, plus — deliberate deviation, documented —
-- create_order_from_cart, whose set-based stock deduction (UPDATE
-- products) cannot run INVOKER as a customer without either an unsafe
-- products policy or a silent no-op.
--
-- ENUM values added in M3 ('qr', 'brand', 'completed') are first used here —
-- a separate transaction from M3, per the map §0 rule.

-- ============================================================= audit helper
-- INVOKER admin mutations cannot insert into audit_logs directly (it has no
-- INSERT policy by design — append-only via definer). This SD helper keeps
-- the append path definer-only and admin-gated.
CREATE OR REPLACE FUNCTION public.record_admin_audit(
    p_action text,
    p_target_type text,
    p_target_id uuid DEFAULT NULL,
    p_metadata jsonb DEFAULT NULL
) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can record audit entries';
  end if;
  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (auth.uid(), p_action, p_target_type, p_target_id, p_metadata);
end;
$$;

-- =================================================================== checkout

-- INVOKER admin lifecycle RPCs need write paths on order-family rows
-- (policies deliberately narrow: UPDATE only, admin-gated).
CREATE POLICY "orders_admin_update" ON "public"."orders"
  FOR UPDATE USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());
CREATE POLICY "payments_admin_update" ON "public"."payments"
  FOR UPDATE USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());
CREATE POLICY "return_requests_admin_update" ON "public"."return_requests"
  FOR UPDATE USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());

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

  -- Validity chain: active variant of an active product at an active
  -- business (server authority, pivot map §4.3).
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
    business_id uuid,
    discount bigint not null
  ) on commit drop;

  foreach v_code in array p_coupon_codes loop
    if coalesce(trim(v_code), '') = '' then
      continue;
    end if;

    select c.id, pr.scope, pr.business_id, pr.brand_id,
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

    -- Applicable base for the coupon's scope.
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

    insert into _coupon_discounts (coupon_id, business_id, discount)
    values (v_coupon.id, v_coupon.business_id, v_coupon_discount);

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

  -- Order items hang off the order directly (single lifecycle, map §4.1);
  -- business_name remains a display snapshot.
  insert into public.order_items (
    order_id, product_id, product_variant_id, product_name, variant_name,
    business_name, unit_price_minor, discount_minor, quantity, line_total_minor
  )
  select
    v_order_id, p.id, ci.product_variant_id, p.name, pv.name, b.name,
    coalesce(pv.price_minor, p.base_price_minor), 0, ci.quantity,
    coalesce(pv.price_minor, p.base_price_minor) * ci.quantity
  from public.cart_items ci
  join public.product_variants pv on pv.id = ci.product_variant_id
  join public.products p on p.id = pv.product_id
  join public.businesses b on b.id = p.business_id
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
  insert into public.order_coupons (order_id, coupon_id, business_id, discount_minor)
  select v_order_id, coupon_id, business_id, discount
  from _coupon_discounts;

  delete from public.cart_items where cart_id = v_cart_id;

  return v_order_id;
end;
$$;

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

  return jsonb_build_object('valid', true, 'discount_minor', v_discount);
end;
$$;

-- Customer cancel: pending/confirmed only; restores stock; a verified
-- payment becomes refund_required (map §4.3/§4.5).
CREATE OR REPLACE FUNCTION public.cancel_order(
    p_order_id uuid,
    p_reason text DEFAULT 'Cancelled by customer'
) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_user uuid := auth.uid();
  v_status public.order_status;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;

  select status into v_status
  from public.orders
  where id = p_order_id and customer_id = v_user;
  if not found then
    raise exception 'Order not found';
  end if;
  if v_status not in ('pending', 'confirmed') then
    raise exception 'Order can no longer be cancelled';
  end if;

  update public.payments
     set status = 'refund_required'
   where order_id = p_order_id
     and status = 'transaction_verified';

  update public.orders
     set status = 'cancelled',
         cancellation_reason = coalesce(p_reason, 'Cancelled by customer'),
         cancelled_at = now()
   where id = p_order_id;

  perform public.restore_order_stock(p_order_id);
end;
$$;

-- Stock restore helper (cancel + admin-cancel); set-based from order_items.
CREATE OR REPLACE FUNCTION public.restore_order_stock(p_order_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  update public.products p
     set stock = p.stock + w.restored
    from (
      select oi.product_id as pid, sum(oi.quantity) as restored
      from public.order_items oi
      where oi.order_id = p_order_id
      group by oi.product_id
    ) w
   where p.id = w.pid;
end;
$$;

-- ====================================================================== QR

-- Customer registers the KHQR payload for a pending QR payment. The md5 is
-- computed server-side, never client-supplied (map §10.4). Status stays
-- 'pending' — confirm_qr_payment owns the pending → verified transition.
CREATE OR REPLACE FUNCTION public.register_qr_payment(p_order_id uuid, p_payload text)
RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
  v_user uuid := auth.uid();
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;

  update public.payments p
     set qr_payload = p_payload,
         qr_md5 = md5(p_payload)
    from public.orders o
   where o.id = p.order_id
     and o.id = p_order_id
     and o.customer_id = v_user
     and p.method = 'qr'
     and p.status = 'pending';
  if not found then
    raise exception 'QR payment cannot be registered';
  end if;
end;
$$;

-- SD: called by the bakong-check / payway-webhook edge functions (service
-- role) and by simulate_qr_payment. Idempotent for already-verified rows.
CREATE OR REPLACE FUNCTION public.confirm_qr_payment(p_order_id uuid, p_reference text)
RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
begin
  update public.payments
     set status = 'transaction_verified',
         paid_at = now(),
         transaction_reference = p_reference
   where order_id = p_order_id
     and method = 'qr'
     and status = 'pending';

  if not found and not exists (
    select 1 from public.payments
     where order_id = p_order_id and method = 'qr' and status = 'transaction_verified'
  ) then
    raise exception 'Payment cannot be confirmed';
  end if;
end;
$$;

-- Demo path: admin simulates a successful QR payment.
CREATE OR REPLACE FUNCTION public.simulate_qr_payment(p_order_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can simulate payments';
  end if;
  perform public.confirm_qr_payment(p_order_id, 'simulated');
  perform public.record_admin_audit(
    'simulate_qr_payment', 'payment', p_order_id);
end;
$$;

-- =========================================================== admin: catalog

CREATE OR REPLACE FUNCTION public.admin_create_product(
    p_business_id uuid,
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
  if not exists (select 1 from public.businesses where id = p_business_id) then
    raise exception 'Business not found';
  end if;

  insert into public.products
    (business_id, category_id, name, description, base_price_minor, brand_id, stock)
  values
    (p_business_id, p_category_id, p_name, p_description, p_base_price_minor, p_brand_id, p_stock)
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

CREATE OR REPLACE FUNCTION public.admin_update_product(
    p_product_id uuid,
    p_category_id uuid,
    p_name text,
    p_description text,
    p_base_price_minor bigint,
    p_brand_id uuid DEFAULT NULL,
    p_stock integer DEFAULT 0
) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can update products';
  end if;

  update public.products
     set category_id = p_category_id,
         name = p_name,
         description = p_description,
         base_price_minor = p_base_price_minor,
         brand_id = p_brand_id,
         stock = p_stock
   where id = p_product_id;
  if not found then
    raise exception 'Product not found';
  end if;

  perform public.record_admin_audit(
    'admin_update_product', 'product', p_product_id,
    jsonb_build_object('name', p_name, 'stock', p_stock));
end;
$$;

CREATE OR REPLACE FUNCTION public.admin_set_product_archived(p_product_id uuid, p_archived boolean)
RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can archive products';
  end if;

  update public.products
     set status = case when p_archived then 'archived' else 'active' end::public.product_status
   where id = p_product_id;
  if not found then
    raise exception 'Product not found';
  end if;

  perform public.record_admin_audit(
    'admin_set_product_archived', 'product', p_product_id,
    jsonb_build_object('archived', p_archived));
end;
$$;

CREATE OR REPLACE FUNCTION public.admin_add_product_image(p_product_id uuid, p_storage_path text)
RETURNS uuid
    LANGUAGE plpgsql
    AS $$
declare
  v_image_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can add product images';
  end if;
  if not exists (select 1 from public.products where id = p_product_id) then
    raise exception 'Product not found';
  end if;

  insert into public.product_images (product_id, storage_path)
  values (p_product_id, p_storage_path)
  returning id into v_image_id;

  perform public.record_admin_audit(
    'admin_add_product_image', 'product', p_product_id,
    jsonb_build_object('storage_path', p_storage_path));
  return v_image_id;
end;
$$;

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

  insert into public.banners (created_by, name, description, image_path, ends_at, status)
  values (auth.uid(), p_name, p_description, p_image_url, p_ends_at, 'pending')
  returning id into v_banner_id;

  perform public.record_admin_audit(
    'admin_create_banner', 'banner', v_banner_id,
    jsonb_build_object('name', p_name));
  return v_banner_id;
end;
$$;

CREATE OR REPLACE FUNCTION public.moderate_banner(p_banner_id uuid, p_action text)
RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can moderate banners';
  end if;
  if p_action not in ('approve', 'reject', 'disable') then
    raise exception 'Unknown moderation action';
  end if;

  update public.banners
     set status = case p_action
       when 'approve' then 'approved'::public.banner_status
       when 'reject' then 'rejected'::public.banner_status
       else 'disabled'::public.banner_status
     end
   where id = p_banner_id;
  if not found then
    raise exception 'Banner not found';
  end if;

  perform public.record_admin_audit(
    'moderate_banner', 'banner', p_banner_id, jsonb_build_object('action', p_action));
end;
$$;

-- ========================================================= admin: lifecycle

-- Forward chain pending→confirmed→processing→packed→shipped→
-- out_for_delivery→delivered, plus pending/confirmed→cancelled
-- (reason required, stock restored). State history + customer notification
-- fire via the M5 triggers.
CREATE OR REPLACE FUNCTION public.admin_transition_order(
    p_order_id uuid,
    p_status public.order_status,
    p_reason text DEFAULT NULL
) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
  v_current public.order_status;
begin
  if not public.is_admin() then
    raise exception 'Only admins can transition orders';
  end if;

  select status into v_current from public.orders where id = p_order_id;
  if not found then
    raise exception 'Order not found';
  end if;

  if not (
    (v_current = 'pending' and p_status in ('confirmed', 'cancelled'))
    or (v_current = 'confirmed' and p_status in ('processing', 'cancelled'))
    or (v_current = 'processing' and p_status = 'packed')
    or (v_current = 'packed' and p_status = 'shipped')
    or (v_current = 'shipped' and p_status = 'out_for_delivery')
    or (v_current = 'out_for_delivery' and p_status = 'delivered')
  ) then
    raise exception 'Cannot transition order from % to %', v_current, p_status;
  end if;

  if p_status = 'cancelled' and coalesce(trim(p_reason), '') = '' then
    raise exception 'A reason is required to cancel an order';
  end if;

  update public.orders
     set status = p_status,
         cancelled_at = case when p_status = 'cancelled' then now() else cancelled_at end,
         cancellation_reason = case
           when p_status = 'cancelled' then coalesce(p_reason, '')
           else cancellation_reason end
   where id = p_order_id;

  if p_status = 'cancelled' then
    perform public.restore_order_stock(p_order_id);
  end if;

  perform public.record_admin_audit(
    'admin_transition_order', 'order', p_order_id,
    jsonb_build_object('from', v_current, 'to', p_status, 'reason', p_reason));
end;
$$;

-- Approval routes any verified payment to refund_required (map §4.5);
-- state + customer notification fire via the baseline return triggers.
CREATE OR REPLACE FUNCTION public.admin_process_return(p_return_id uuid, p_approve boolean)
RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
  v_order_id uuid;
  v_status public.return_status;
begin
  if not public.is_admin() then
    raise exception 'Only admins can process returns';
  end if;

  select order_id, status into v_order_id, v_status
  from public.return_requests
  where id = p_return_id;
  if not found then
    raise exception 'Return request not found';
  end if;
  if v_status <> 'pending' then
    raise exception 'Return request was already processed';
  end if;

  update public.return_requests
     set status = case when p_approve then 'approved' else 'rejected' end::public.return_status
   where id = p_return_id;

  if p_approve then
    update public.payments
       set status = 'refund_required'
     where order_id = v_order_id
       and status = 'transaction_verified';
  end if;

  perform public.record_admin_audit(
    'admin_process_return', 'return_request', p_return_id,
    jsonb_build_object('approved', p_approve));
end;
$$;

CREATE OR REPLACE FUNCTION public.admin_complete_return(p_return_id uuid)
RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
  v_order_id uuid;
  v_status public.return_status;
begin
  if not public.is_admin() then
    raise exception 'Only admins can complete returns';
  end if;

  select order_id, status into v_order_id, v_status
  from public.return_requests
  where id = p_return_id;
  if not found then
    raise exception 'Return request not found';
  end if;
  if v_status <> 'approved' then
    raise exception 'Only approved returns can be completed';
  end if;

  update public.return_requests
     set status = 'completed'
   where id = p_return_id;

  update public.orders
     set status = 'returned'
   where id = v_order_id;

  perform public.record_admin_audit(
    'admin_complete_return', 'return_request', p_return_id,
    jsonb_build_object('order_id', v_order_id));
end;
$$;

CREATE OR REPLACE FUNCTION public.mark_refunded(p_order_id uuid, p_reference text DEFAULT NULL)
RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can mark refunds';
  end if;

  update public.payments
     set status = 'refunded',
         transaction_reference = coalesce(p_reference, transaction_reference)
   where order_id = p_order_id
     and status = 'refund_required';
  if not found then
    raise exception 'No refund-required payment for this order';
  end if;

  perform public.record_admin_audit(
    'mark_refunded', 'payment', p_order_id,
    jsonb_build_object('reference', p_reference));
end;
$$;

-- ======================================================= admin: management

CREATE OR REPLACE FUNCTION public.create_category(
    p_name text,
    p_parent_id uuid DEFAULT NULL,
    p_image_url text DEFAULT NULL
) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
declare
  v_category_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can create categories';
  end if;
  if p_parent_id is not null and not exists (
    select 1 from public.categories where id = p_parent_id
  ) then
    raise exception 'Parent category not found';
  end if;

  insert into public.categories (name, parent_id, image_url)
  values (p_name, p_parent_id, p_image_url)
  returning id into v_category_id;

  perform public.record_admin_audit(
    'create_category', 'category', v_category_id, jsonb_build_object('name', p_name));
  return v_category_id;
end;
$$;

CREATE OR REPLACE FUNCTION public.rename_category(
    p_category_id uuid,
    p_name text,
    p_image_url text DEFAULT NULL
) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can rename categories';
  end if;

  update public.categories
     set name = p_name,
         image_url = coalesce(p_image_url, image_url)
   where id = p_category_id;
  if not found then
    raise exception 'Category not found';
  end if;

  perform public.record_admin_audit(
    'rename_category', 'category', p_category_id, jsonb_build_object('name', p_name));
end;
$$;

CREATE OR REPLACE FUNCTION public.delete_category(p_category_id uuid)
RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can delete categories';
  end if;

  delete from public.categories where id = p_category_id;
  if not found then
    raise exception 'Category not found';
  end if;

  perform public.record_admin_audit(
    'delete_category', 'category', p_category_id, NULL);
end;
$$;

-- Atomic rule + coupon creation (map §6). Brand-scoped when a brand is
-- given, platform otherwise; the legacy 'business' scope stays
-- validate-only (never created here).
CREATE OR REPLACE FUNCTION public.create_platform_promotion(
    p_name text,
    p_description text,
    p_discount_type public.discount_type,
    p_discount_value bigint,
    p_code text,
    p_min_order_amount_minor bigint DEFAULT 0,
    p_starts_at timestamptz DEFAULT NULL,
    p_ends_at timestamptz DEFAULT NULL,
    p_brand_id uuid DEFAULT NULL
) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
declare
  v_promotion_id uuid;
  v_scope public.promotion_scope;
begin
  if not public.is_admin() then
    raise exception 'Only admins can create promotions';
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
    (created_by, scope, brand_id, name, description, discount_type, discount_value)
  values
    (auth.uid(), v_scope, p_brand_id, p_name, p_description, p_discount_type, p_discount_value)
  returning id into v_promotion_id;

  insert into public.coupons
    (promotion_id, code, min_order_amount_minor, starts_at, ends_at)
  values
    (v_promotion_id, p_code, p_min_order_amount_minor, p_starts_at, p_ends_at);

  perform public.record_admin_audit(
    'create_platform_promotion', 'promotion', v_promotion_id,
    jsonb_build_object('code', p_code, 'scope', v_scope));
  return v_promotion_id;
end;
$$;

CREATE OR REPLACE FUNCTION public.set_coupon_active(p_coupon_id uuid, p_active boolean)
RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can toggle coupons';
  end if;

  update public.coupons
     set active = p_active
   where id = p_coupon_id;
  if not found then
    raise exception 'Coupon not found';
  end if;

  perform public.record_admin_audit(
    'set_coupon_active', 'coupon', p_coupon_id, jsonb_build_object('active', p_active));
end;
$$;

CREATE OR REPLACE FUNCTION public.register_device_token(p_token text, p_platform text)
RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
  v_user uuid := auth.uid();
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;

  insert into public.device_tokens (user_id, token, platform)
  values (v_user, p_token, p_platform)
  on conflict (token) do update
    set user_id = excluded.user_id,
        platform = excluded.platform,
        updated_at = now();
end;
$$;

-- Clears-then-sets the one default per user (map §4.4); the partial unique
-- index is the race backstop.
CREATE OR REPLACE FUNCTION public.set_default_address(p_address_id uuid)
RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
  v_user uuid := auth.uid();
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  if not exists (
    select 1 from public.addresses
     where id = p_address_id and user_id = v_user
  ) then
    raise exception 'Address not found';
  end if;

  update public.addresses set is_default = false where user_id = v_user;
  update public.addresses set is_default = true where id = p_address_id;
end;
$$;

-- ==================================================================== reports

CREATE OR REPLACE FUNCTION public.get_customer_dashboard() RETURNS jsonb
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_user uuid := auth.uid();
  v_cart_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  select id into v_cart_id from public.carts where user_id = v_user;

  return jsonb_build_object(
    'active_orders', (
      select count(*) from public.orders
       where customer_id = v_user
         and status in ('pending','confirmed','processing','packed','shipped','out_for_delivery')
    ),
    'completed_orders', (
      select count(*) from public.orders
       where customer_id = v_user and status = 'delivered'
    ),
    'cancelled_orders', (
      select count(*) from public.orders
       where customer_id = v_user and status = 'cancelled'
    ),
    'total_orders', (
      select count(*) from public.orders where customer_id = v_user
    ),
    'wishlist_count', (
      select count(*) from public.wishlist_items wi
        join public.wishlists w on w.id = wi.wishlist_id
       where w.user_id = v_user
    ),
    'cart_items', (
      select count(*) from public.cart_items where cart_id = v_cart_id
    ),
    'cart_subtotal_minor', coalesce((
      select sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity)
      from public.cart_items ci
      join public.product_variants pv on pv.id = ci.product_variant_id
      join public.products p on p.id = pv.product_id
      where ci.cart_id = v_cart_id
    ), 0),
    'total_spending_minor', coalesce((
      select sum(o.total_minor) from public.orders o
       where o.customer_id = v_user
         and o.status not in ('cancelled', 'returned')
    ), 0),
    'recent_orders', coalesce((
      select jsonb_agg(jsonb_build_object(
               'id', o.id, 'total_minor', o.total_minor,
               'created_at', o.created_at, 'state', o.status::text))
      from (
        select id, total_minor, created_at, status
        from public.orders
        where customer_id = v_user
        order by created_at desc
        limit 5
      ) o
    ), '[]'::jsonb)
  );
end;
$$;

CREATE OR REPLACE FUNCTION public.get_admin_kpis() RETURNS jsonb
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can view reports';
  end if;

  return jsonb_build_object(
    'total_products', (select count(*) from public.products),
    'active_products', (
      select count(*) from public.products where status = 'active'
    ),
    'total_orders', (select count(*) from public.orders),
    'total_customers', (select count(*) from public.users),
    'total_sales_minor', coalesce((
      select sum(o.total_minor) from public.orders o
       where o.status not in ('cancelled', 'returned')
    ), 0),
    'low_stock_products', (
      select count(*) from public.products
       where status = 'active' and stock > 0 and stock <= 5
    ),
    'out_of_stock_products', (
      select count(*) from public.products
       where status = 'active' and stock = 0
    ),
    'best_sellers', coalesce((
      select jsonb_agg(jsonb_build_object('name', t.name, 'units', t.units))
      from (
        select oi.product_name as name, sum(oi.quantity) as units
        from public.order_items oi
        join public.orders o on o.id = oi.order_id
        where o.status not in ('cancelled', 'returned')
        group by oi.product_name
        order by units desc
        limit 5
      ) t
    ), '[]'::jsonb),
    'sales_trend', coalesce((
      select jsonb_agg(jsonb_build_object(
               'day', t.day, 'orders', t.orders, 'sales_minor', t.sales_minor)
               order by t.day)
      from (
        select date_trunc('day', o.created_at)::date as day,
               count(*) as orders,
               coalesce(sum(o.total_minor), 0) as sales_minor
        from public.orders o
        where o.created_at >= now() - interval '7 days'
          and o.status not in ('cancelled', 'returned')
        group by date_trunc('day', o.created_at)::date
      ) t
    ), '[]'::jsonb)
  );
end;
$$;

CREATE OR REPLACE FUNCTION public.get_sales_report(p_from date, p_to date) RETURNS jsonb
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can view reports';
  end if;

  return jsonb_build_object(
    'from', p_from::text,
    'to', p_to::text,
    'total_orders', (
      select count(*) from public.orders o
       where o.created_at >= p_from and o.created_at < p_to + 1
    ),
    'completed_orders', (
      select count(*) from public.orders o
       where o.created_at >= p_from and o.created_at < p_to + 1
         and o.status = 'delivered'
    ),
    'cancelled_orders', (
      select count(*) from public.orders o
       where o.created_at >= p_from and o.created_at < p_to + 1
         and o.status = 'cancelled'
    ),
    'total_sales_minor', coalesce((
      select sum(o.total_minor) from public.orders o
       where o.created_at >= p_from and o.created_at < p_to + 1
         and o.status not in ('cancelled', 'returned')
    ), 0),
    'average_order_value_minor', coalesce((
      select sum(o.total_minor) / greatest(count(*), 1)
      from public.orders o
       where o.created_at >= p_from and o.created_at < p_to + 1
         and o.status not in ('cancelled', 'returned')
    ), 0),
    'low_stock_products', (
      select count(*) from public.products
       where status = 'active' and stock > 0 and stock <= 5
    ),
    'out_of_stock_products', (
      select count(*) from public.products
       where status = 'active' and stock = 0
    ),
    'best_sellers', coalesce((
      select jsonb_agg(jsonb_build_object('name', t.name, 'units', t.units))
      from (
        select oi.product_name as name, sum(oi.quantity) as units
        from public.order_items oi
        join public.orders o on o.id = oi.order_id
        where o.created_at >= p_from and o.created_at < p_to + 1
          and o.status not in ('cancelled', 'returned')
        group by oi.product_name
        order by units desc
        limit 5
      ) t
    ), '[]'::jsonb),
    'top_categories', coalesce((
      select jsonb_agg(jsonb_build_object('name', t.name, 'units', t.units))
      from (
        select c.name, sum(oi.quantity) as units
        from public.order_items oi
        join public.orders o on o.id = oi.order_id
        join public.products p on p.id = oi.product_id
        join public.categories c on c.id = p.category_id
        where o.created_at >= p_from and o.created_at < p_to + 1
          and o.status not in ('cancelled', 'returned')
        group by c.name
        order by units desc
        limit 5
      ) t
    ), '[]'::jsonb),
    'purchase_frequency', coalesce((
      select jsonb_agg(jsonb_build_object('name', t.name, 'orders', t.orders))
      from (
        select u.full_name as name, count(*) as orders
        from public.orders o
        join public.users u on u.id = o.customer_id
        where o.created_at >= p_from and o.created_at < p_to + 1
        group by u.full_name
        order by orders desc
        limit 5
      ) t
    ), '[]'::jsonb)
  );
end;
$$;

CREATE OR REPLACE FUNCTION public.get_platform_report() RETURNS jsonb
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can view reports';
  end if;

  return jsonb_build_object(
    'order_count', (select count(*) from public.orders),
    'gmv_minor', coalesce((
      select sum(o.total_minor) from public.orders o
       where o.status not in ('cancelled', 'returned')
    ), 0),
    'delivery_fees_minor', coalesce((
      select sum(o.delivery_fee_minor) from public.orders o
       where o.status not in ('cancelled', 'returned')
    ), 0),
    'active_businesses', (
      select count(*) from public.businesses where status = 'active'
    ),
    'active_products', (
      select count(*) from public.products where status = 'active'
    )
  );
end;
$$;

-- ================================================== rewrites (same signature)

-- Return gating moves to orders.status = 'delivered'; ownership joins
-- order_items → orders directly (map §10.2); the M3 unique constraint
-- enforces one return per order item.
CREATE OR REPLACE FUNCTION public.request_return(p_order_id uuid, p_items jsonb)
RETURNS uuid
    LANGUAGE plpgsql
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
     where o.id = p_order_id
       and o.customer_id = v_user
       and o.status = 'delivered'
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
       where oi.id = v_item.order_item_id
         and oi.order_id = p_order_id
         and v_item.quantity > 0
         and v_item.quantity <= oi.quantity
    ) then
      raise exception 'Invalid return quantity';
    end if;
    if exists (
      select 1 from public.return_items ri
       where ri.order_item_id = v_item.order_item_id
    ) then
      raise exception 'Item has already been returned';
    end if;

    insert into public.return_items
      (return_request_id, order_item_id, quantity, reason)
    values (v_request_id, v_item.order_item_id, v_item.quantity,
            coalesce(v_item.reason, ''));
  end loop;

  return v_request_id;
end;
$$;

-- Ownership verified via the direct order_items → orders join (map §10.2).
CREATE OR REPLACE FUNCTION public.create_review(p_order_item_id uuid, p_rating integer, p_text text)
RETURNS uuid
    LANGUAGE plpgsql
    AS $$
declare
  v_user uuid := auth.uid();
  v_product_id uuid;
  v_review_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;

  select oi.product_id into v_product_id
  from public.order_items oi
  join public.orders o on o.id = oi.order_id
  where oi.id = p_order_item_id
    and o.customer_id = v_user;
  if not found then
    raise exception 'You can only review items you purchased';
  end if;
  if p_rating < 1 or p_rating > 5 then
    raise exception 'Rating must be between 1 and 5';
  end if;

  insert into public.reviews (order_item_id, product_id, customer_id, rating, text)
  values (p_order_item_id, v_product_id, v_user, p_rating, p_text)
  returning id into v_review_id;

  return v_review_id;
end;
$$;
