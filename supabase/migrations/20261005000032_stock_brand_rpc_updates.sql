-- 2-Role Academic Prototype, Section 2d (part 2 of 0031): RPC re-creations.
-- Kept in a separate migration because the 'brand' enum value added in 0031
-- cannot be referenced inside the same transaction that adds it.

-- ---------------------------------------------------------------- checkout
-- Product-wide stock: lock product rows, validate every line's quantity,
-- deduct on commit (§4). Availability stays status-based for the DISABLED
-- dimension (archived products fail the active-product validity check below);
-- stock covers the QUANTITY dimension. Client prices remain untrusted (§50).
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

  -- Coupons (§24–§26 + §2d brand scope): server-authoritative validation;
  -- scoped discounts are tracked per business so each business_order gets
  -- its share.
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

    select c.id, pr.scope, pr.business_id, pr.brand_id,
           pr.discount_type, pr.discount_value
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
      into v_scope_subtotal
      from public.cart_items ci
      join public.product_variants pv on pv.id = ci.product_variant_id
      join public.products p on p.id = pv.product_id
      where ci.cart_id = v_cart_id
        and p.business_id = v_coupon.business_id;
      if v_scope_subtotal = 0 then
        raise exception 'Coupon % does not apply to your cart', v_code;
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
      -- Brand-wide (§2d): eligible lines are the brand's products. The
      -- discount is distributed across the participating businesses in
      -- proportion to their eligible subtotals (integer division; the
      -- rounding remainder goes to the largest share).
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

-- Coupon preview (§25): brand scope mirrors the checkout branch — the
-- discount is computed over the brand's eligible lines only.
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

  select c.id, pr.scope, pr.business_id, pr.brand_id,
         pr.discount_type, pr.discount_value
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
    into v_scope_subtotal
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    join public.products p on p.id = pv.product_id
    where ci.cart_id = v_cart_id and p.business_id = v_coupon.business_id;
    if v_scope_subtotal = 0 then
      return jsonb_build_object('valid', false, 'message', 'Coupon does not apply to your cart');
    end if;
    v_discount := case v_coupon.discount_type
      when 'fixed' then least(v_coupon.discount_value, v_scope_subtotal)
      else (v_scope_subtotal * v_coupon.discount_value) / 100
    end;
  elsif v_coupon.scope = 'brand' then
    select coalesce(sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity), 0)
    into v_scope_subtotal
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    join public.products p on p.id = pv.product_id
    where ci.cart_id = v_cart_id and p.brand_id = v_coupon.brand_id;
    if v_scope_subtotal = 0 then
      return jsonb_build_object('valid', false, 'message', 'Coupon does not apply to your cart');
    end if;
    v_discount := case v_coupon.discount_type
      when 'fixed' then least(v_coupon.discount_value, v_scope_subtotal)
      else (v_scope_subtotal * v_coupon.discount_value) / 100
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

-- Cancellation restores product-wide stock (§2d/§12): only reachable while
-- every business part is pending, i.e. the order was never fulfilled.
create or replace function public.cancel_order(p_order_id uuid)
returns void
language plpgsql
security definer
set search_path = public
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

  -- Stock restore (§2d): quantities come from the historical order items.
  update public.products p
  set stock = p.stock + restored.qty
  from (
    select oi.product_id, sum(oi.quantity) as qty
    from public.order_items oi
    join public.business_orders bo on bo.id = oi.business_order_id
    where bo.order_id = p_order_id
    group by oi.product_id
  ) restored
  where p.id = restored.product_id;

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

-- ------------------------------------------------- admin product management
-- Stock management joins the admin RPCs (§2d): product-wide, manual
-- correction only — no reservations.
create or replace function public.admin_create_product(
  p_business_id uuid,
  p_category_id uuid,
  p_name text,
  p_description text,
  p_base_price_minor bigint,
  p_brand_id uuid default null,
  p_stock integer default 0,
  p_variants jsonb default '[]'::jsonb
)
returns uuid
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
  v_product_id uuid;
  v_variant record;
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage products';
  end if;
  if coalesce(trim(p_name), '') = '' then
    raise exception 'Product name is required';
  end if;
  if p_base_price_minor < 0 then
    raise exception 'Invalid price';
  end if;
  if p_stock < 0 then
    raise exception 'Invalid stock';
  end if;
  if not exists (
    select 1 from public.businesses b where b.id = p_business_id
  ) then
    raise exception 'Business not found';
  end if;
  if not exists (
    select 1 from public.categories c where c.id = p_category_id
  ) then
    raise exception 'Category not found';
  end if;
  if p_brand_id is not null and not exists (
    select 1 from public.brands br where br.id = p_brand_id
  ) then
    raise exception 'Brand not found';
  end if;

  insert into public.products
    (business_id, category_id, brand_id, name, description, base_price_minor, stock)
  values
    (p_business_id, p_category_id, p_brand_id, trim(p_name),
     coalesce(p_description, ''), p_base_price_minor, p_stock)
  returning id into v_product_id;

  if jsonb_array_length(p_variants) = 0 then
    -- Keep carts strictly variant-based: auto 'Default' variant whose null
    -- price falls back to (and keeps tracking) the product's base price.
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

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor, 'admin_product_created', 'product', v_product_id,
          jsonb_build_object('name', trim(p_name), 'business_id', p_business_id));

  return v_product_id;
end;
$$;

create or replace function public.admin_update_product(
  p_product_id uuid,
  p_category_id uuid,
  p_name text,
  p_description text,
  p_base_price_minor bigint,
  p_brand_id uuid default null,
  p_stock integer default null
)
returns void
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage products';
  end if;
  if coalesce(trim(p_name), '') = '' then
    raise exception 'Product name is required';
  end if;
  if p_base_price_minor < 0 then
    raise exception 'Invalid price';
  end if;
  if p_stock is not null and p_stock < 0 then
    raise exception 'Invalid stock';
  end if;
  if p_brand_id is not null and not exists (
    select 1 from public.brands br where br.id = p_brand_id
  ) then
    raise exception 'Brand not found';
  end if;

  update public.products p
  set category_id = p_category_id,
      brand_id = p_brand_id,
      name = trim(p_name),
      description = coalesce(p_description, ''),
      base_price_minor = p_base_price_minor,
      stock = coalesce(p_stock, p.stock),
      updated_at = now()
  where p.id = p_product_id;
  if not found then
    raise exception 'Product not found';
  end if;

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor, 'admin_product_updated', 'product', p_product_id,
          jsonb_build_object('name', trim(p_name)));
end;
$$;

-- Admin promotion/coupon creation now covers platform-wide OR brand-wide
-- scope (§2d): p_brand_id null → platform scope, otherwise brand scope.
create or replace function public.create_platform_promotion(
  p_name text,
  p_description text,
  p_discount_type public.discount_type,
  p_discount_value bigint,
  p_code text,
  p_expires_at timestamptz default null,
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

  insert into public.coupons (promotion_id, code, active, expires_at)
  values (v_promotion_id, upper(trim(p_code)), true, p_expires_at);

  return v_promotion_id;
end;
$$;
