-- 2-Role Academic Prototype, Section 6b (living spec Part B §6/§7):
-- checkout wizard + status clarification.
--
-- 1. Order note (assignment §6 checkout step): orders.note, plumbed through
--    create_order_from_cart.
-- 2. Status ownership clarified (user decision): the four state families
--    stay on their four entities — admin manages business-order, delivery,
--    and pickup-stop states; payment states are system/webhook-driven.
--    admin_complete_order previously jumped ready → delivered in one click;
--    a new admin_ship_order (delivery → delivery_in_progress) gives the
--    customer timeline the full assignment §7 progression
--    (Pending → … → Packed → Shipped → Out for delivery → Delivered).

-- ------------------------------------------------------- order note (§6)
alter table public.orders add column note text not null default '';

-- ------------------------------------------------ administrative ship step
create or replace function public.admin_ship_order(p_order_id uuid)
returns void
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage orders';
  end if;

  if exists (
    select 1 from public.business_orders
    where order_id = p_order_id and status = 'pending'
  ) then
    raise exception 'Accept or reject every business order first';
  end if;

  -- Hand over to transport: the delivery leaves the claimable pool. The
  -- (bypassed) driver pipeline's assignment/pickup gating stays out of the
  -- administrative flow — pickup stops complete at handover (§6b).
  update public.deliveries d
  set status = 'delivery_in_progress',
      updated_at = now()
  where d.order_id = p_order_id
    and d.status = 'available';
  if not found then
    raise exception 'Order cannot be shipped';
  end if;

  update public.pickup_stops ps
  set status = 'completed',
      completed_at = now()
  from public.deliveries d
  where d.id = ps.delivery_id
    and d.order_id = p_order_id
    and ps.status = 'pending';

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor, 'admin_order_shipped', 'order', p_order_id, null);
end;
$$;

-- Completion now requires the shipped state (timeline coherence, §6b).
create or replace function public.admin_complete_order(p_order_id uuid)
returns void
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
  v_delivery_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage orders';
  end if;

  if exists (
    select 1 from public.business_orders
    where order_id = p_order_id and status = 'pending'
  ) then
    raise exception 'Accept or reject every business order first';
  end if;

  update public.deliveries d
  set status = 'delivered',
      delivered_at = now()
  where d.order_id = p_order_id
    and d.status = 'delivery_in_progress'
  returning d.id into v_delivery_id;
  if not found then
    raise exception 'Ship the order before completing it';
  end if;

  update public.business_orders bo
  set status = 'completed',
      completed_at = now()
  where bo.order_id = p_order_id
    and bo.status in ('accepted', 'preparing', 'ready');

  -- COD is collected on successful delivery (§20.1).
  update public.payments p
  set status = 'transaction_verified',
      paid_at = now()
  where p.order_id = p_order_id
    and p.method = 'cod'
    and p.status = 'pending';

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor, 'admin_order_completed', 'order', p_order_id,
          jsonb_build_object('delivery_id', v_delivery_id));
end;
$$;

-- --------------------------------------------------- checkout (note param)
-- Identical to the 0036 body plus the order note. Regenerated in full so
-- the live definition is exactly this one.
create or replace function public.create_order_from_cart(
  p_address_id uuid,
  p_payment_method public.payment_method,
  p_coupon_codes text[] default '{}',
  p_note text default ''
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
    delivery_fee_minor, total_minor, note
  ) values (
    v_user, v_address.recipient_name, v_address.phone, v_address.line1,
    v_address.line2, v_address.city, v_subtotal, v_discount_total,
    v_delivery_fee, v_subtotal - v_discount_total + v_delivery_fee,
    coalesce(p_note, '')
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
