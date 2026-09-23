-- Phase 4: orders, payment, delivery + atomic checkout (spec §9–§23, §39–§41,
-- §44, §47, §50–§51).
--
-- State ownership (§52): the overall Order has NO status column —
-- operational state lives on business_orders / payments / deliveries and
-- the customer-facing status is derived. Money is bigint minor units (§22).
-- Historical snapshots (§17/§18/§19): address, business identity and
-- product/variant/price data are copied into the order records.

create type public.business_order_status as enum
  ('pending', 'accepted', 'rejected', 'preparing', 'ready', 'completed', 'cancelled');

create type public.payment_method as enum ('cod', 'bank_transfer');

create type public.payment_status as enum
  ('pending', 'awaiting_payment_verification', 'transaction_verified', 'refund_required', 'refunded');

create type public.delivery_status as enum
  ('available', 'assigned', 'pickup_in_progress', 'delivery_in_progress', 'delivered');

create type public.pickup_stop_status as enum ('pending', 'completed');

create type public.promotion_scope as enum ('business', 'platform');

create type public.discount_type as enum ('fixed', 'percent');

create type public.banner_status as enum ('none', 'pending', 'approved', 'rejected', 'disabled');

create table public.orders (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.users (id),
  -- shipping address snapshot (§17)
  shipping_recipient_name text not null,
  shipping_phone text not null default '',
  shipping_line1 text not null,
  shipping_line2 text,
  shipping_city text not null,
  subtotal_minor bigint not null check (subtotal_minor >= 0),
  discount_minor bigint not null default 0 check (discount_minor >= 0),
  delivery_fee_minor bigint not null default 0 check (delivery_fee_minor >= 0),
  total_minor bigint not null check (total_minor >= 0),
  created_at timestamptz not null default now()
);

create table public.business_orders (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders (id) on delete cascade,
  business_id uuid not null references public.businesses (id),
  subtotal_minor bigint not null check (subtotal_minor >= 0),
  discount_minor bigint not null default 0 check (discount_minor >= 0),
  status public.business_order_status not null default 'pending',
  rejection_reason text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.order_items (
  id uuid primary key default gen_random_uuid(),
  business_order_id uuid not null references public.business_orders (id) on delete cascade,
  product_id uuid not null references public.products (id),
  product_variant_id uuid not null references public.product_variants (id),
  -- historical product/variant snapshots (§19) — later catalog edits must
  -- not rewrite purchase history
  product_name text not null,
  variant_name text,
  business_name text not null,
  unit_price_minor bigint not null check (unit_price_minor >= 0),
  discount_minor bigint not null default 0 check (discount_minor >= 0),
  quantity integer not null check (quantity > 0),
  line_total_minor bigint not null check (line_total_minor >= 0),
  created_at timestamptz not null default now()
);

create table public.payments (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null unique references public.orders (id) on delete cascade,
  method public.payment_method not null,
  amount_minor bigint not null check (amount_minor >= 0),
  status public.payment_status not null default 'pending',
  -- Storage owns the binary; this record owns the reference (§48)
  proof_path text,
  paid_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.deliveries (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null unique references public.orders (id) on delete cascade,
  driver_id uuid references public.users (id),
  status public.delivery_status not null default 'available',
  delivery_fee_minor bigint not null default 0 check (delivery_fee_minor >= 0),
  driver_earning_minor bigint not null default 0 check (driver_earning_minor >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.pickup_stops (
  id uuid primary key default gen_random_uuid(),
  delivery_id uuid not null references public.deliveries (id) on delete cascade,
  business_order_id uuid not null unique references public.business_orders (id) on delete cascade,
  sequence integer not null,
  status public.pickup_stop_status not null default 'pending',
  completed_at timestamptz,
  created_at timestamptz not null default now()
);

-- Promotions/coupons schema now (management UI in Phase 9); checkout needs
-- them to apply codes (§24–§26).
create table public.promotions (
  id uuid primary key default gen_random_uuid(),
  created_by uuid not null references public.users (id),
  scope public.promotion_scope not null,
  business_id uuid references public.businesses (id),
  name text not null,
  description text not null default '',
  discount_type public.discount_type not null,
  -- minor units for 'fixed', whole percent (1..100) for 'percent'
  discount_value bigint not null check (discount_value > 0),
  starts_at timestamptz,
  ends_at timestamptz,
  banner_image_path text,
  banner_status public.banner_status not null default 'none',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (scope <> 'business' or business_id is not null)
);

create table public.coupons (
  id uuid primary key default gen_random_uuid(),
  promotion_id uuid not null references public.promotions (id) on delete cascade,
  code text not null unique,
  active boolean not null default true,
  expires_at timestamptz,
  created_at timestamptz not null default now()
);

-- Historical coupon application (§26): the actual discount amount is
-- retained even if the promotion changes later.
create table public.order_coupons (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders (id) on delete cascade,
  coupon_id uuid not null references public.coupons (id),
  business_id uuid references public.businesses (id),
  discount_minor bigint not null check (discount_minor >= 0),
  created_at timestamptz not null default now()
);

create table public.platform_settings (
  id integer primary key default 1 check (id = 1),
  delivery_fee_minor bigint not null default 0 check (delivery_fee_minor >= 0),
  platform_commission_percent integer not null default 0
    check (platform_commission_percent between 0 and 100),
  driver_commission_percent integer not null default 0
    check (driver_commission_percent between 0 and 100),
  payment_account text not null default '',
  updated_at timestamptz not null default now()
);

insert into public.platform_settings (id) values (1) on conflict do nothing;

create index orders_customer_idx on public.orders (customer_id, created_at desc);
create index business_orders_business_idx on public.business_orders (business_id, status);
create index business_orders_order_idx on public.business_orders (order_id);
create index order_items_biz_order_idx on public.order_items (business_order_id);
create index deliveries_status_idx on public.deliveries (status);
create index deliveries_driver_idx on public.deliveries (driver_id, status);
create index pickup_stops_delivery_idx on public.pickup_stops (delivery_id, sequence);

alter table public.orders enable row level security;
alter table public.business_orders enable row level security;
alter table public.order_items enable row level security;
alter table public.payments enable row level security;
alter table public.deliveries enable row level security;
alter table public.pickup_stops enable row level security;
alter table public.promotions enable row level security;
alter table public.coupons enable row level security;
alter table public.order_coupons enable row level security;
alter table public.platform_settings enable row level security;

-- Orders: customer reads own; inserts happen as the customer through the
-- checkout RPC (invoker) — authorization enforced server-side (§35).
create policy "orders_customer_select" on public.orders
  for select using (auth.uid() = customer_id);
create policy "orders_customer_insert" on public.orders
  for insert with check (auth.uid() = customer_id);

create policy "business_orders_participant_select" on public.business_orders
  for select using (
    exists (select 1 from public.orders o where o.id = order_id and o.customer_id = auth.uid())
    or exists (select 1 from public.businesses b where b.id = business_id and b.owner_id = auth.uid())
  );
create policy "business_orders_customer_insert" on public.business_orders
  for insert with check (
    exists (select 1 from public.orders o where o.id = order_id and o.customer_id = auth.uid())
  );

create policy "order_items_participant_select" on public.order_items
  for select using (
    exists (
      select 1 from public.business_orders bo
      join public.orders o on o.id = bo.order_id
      where bo.id = business_order_id
        and (o.customer_id = auth.uid()
             or exists (select 1 from public.businesses b where b.id = bo.business_id and b.owner_id = auth.uid()))
    )
  );
create policy "order_items_customer_insert" on public.order_items
  for insert with check (
    exists (
      select 1 from public.business_orders bo
      join public.orders o on o.id = bo.order_id
      where bo.id = business_order_id and o.customer_id = auth.uid()
    )
  );

create policy "payments_customer_all" on public.payments
  for all
  using (exists (select 1 from public.orders o where o.id = order_id and o.customer_id = auth.uid()))
  with check (exists (select 1 from public.orders o where o.id = order_id and o.customer_id = auth.uid()));

create policy "deliveries_read" on public.deliveries
  for select using (
    exists (select 1 from public.orders o where o.id = order_id and o.customer_id = auth.uid())
    or driver_id = auth.uid()
    -- available deliveries are visible to drivers (Phase 7 adds role check)
    or (status = 'available' and exists (
      select 1 from public.users u where u.id = auth.uid() and u.active_role = 'driver'
    ))
  );
create policy "deliveries_customer_insert" on public.deliveries
  for insert with check (
    exists (select 1 from public.orders o where o.id = order_id and o.customer_id = auth.uid())
  );

create policy "pickup_stops_read" on public.pickup_stops
  for select using (
    exists (
      select 1 from public.deliveries d
      join public.orders o on o.id = d.order_id
      where d.id = delivery_id
        and (o.customer_id = auth.uid() or d.driver_id = auth.uid())
    )
    or exists (
      select 1 from public.deliveries d
      join public.orders o on o.id = d.order_id
      join public.business_orders bo on bo.id = business_order_id
      join public.businesses b on b.id = bo.business_id
      where d.id = delivery_id and b.owner_id = auth.uid()
    )
  );
create policy "pickup_stops_customer_insert" on public.pickup_stops
  for insert with check (
    exists (
      select 1 from public.deliveries d
      join public.orders o on o.id = d.order_id
      where d.id = delivery_id and o.customer_id = auth.uid()
    )
  );

create policy "promotions_public_read" on public.promotions
  for select using (true);
create policy "promotions_creator_all" on public.promotions
  for all using (auth.uid() = created_by) with check (auth.uid() = created_by);

create policy "coupons_public_read" on public.coupons
  for select using (true);

create policy "order_coupons_customer_read" on public.order_coupons
  for select using (
    exists (select 1 from public.orders o where o.id = order_id and o.customer_id = auth.uid())
  );
create policy "order_coupons_customer_insert" on public.order_coupons
  for insert with check (
    exists (select 1 from public.orders o where o.id = order_id and o.customer_id = auth.uid())
  );

create policy "platform_settings_public_read" on public.platform_settings
  for select using (true);

create trigger business_orders_touch_updated_at
  before update on public.business_orders
  for each row execute function public.touch_updated_at();

create trigger payments_touch_updated_at
  before update on public.payments
  for each row execute function public.touch_updated_at();

create trigger deliveries_touch_updated_at
  before update on public.deliveries
  for each row execute function public.touch_updated_at();

create trigger promotions_touch_updated_at
  before update on public.promotions
  for each row execute function public.touch_updated_at();

-- ============================================================================
-- Atomic checkout (§23/§51): validate -> lock -> reserve -> create every
-- record -> clear cart. Any failure rolls the whole thing back; a partial
-- checkout cannot be left behind.
-- ============================================================================
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
  v_business uuid;
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

  -- Lock variant rows for the transaction, validate stock, price the order
  -- from the database — client prices are never trusted (§50).
  for v_item in
    select ci.product_variant_id, ci.quantity, pv.stock,
           coalesce(pv.price_minor, p.base_price_minor) as unit_price
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    join public.products p on p.id = pv.product_id
    where ci.cart_id = v_cart_id
    for update of pv
  loop
    if v_item.quantity > v_item.stock then
      raise exception 'Insufficient stock';
    end if;
    v_subtotal := v_subtotal + v_item.unit_price * v_item.quantity;
  end loop;

  -- Coupons (§24–§26): server-authoritative validation; per-business
  -- discounts are tracked so each business_order gets its share.
  create temp table _biz_discount (
    business_id uuid primary key,
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

    v_discount_total := v_discount_total + v_coupon_discount;
  end loop;
  v_discount_total := least(v_discount_total, v_subtotal);

  -- Commit path — every insert below is one transaction with the stock
  -- reservations above (§51).
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
    select coalesce(discount, 0) into v_biz_discount
    from _biz_discount where business_id = v_business.business_id;

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

      -- Reserve/consume stock atomically with the order (§7, §50).
      update public.product_variants
      set stock = stock - v_item.quantity
      where id = v_item.product_variant_id;
    end loop;

    -- One PickupStop per participating BusinessOrder (§14/§16).
    insert into public.pickup_stops (delivery_id, business_order_id, sequence, status)
    values (v_delivery_id, v_business_order_id, v_seq, 'pending');
  end loop;

  -- Historical coupon record (§26).
  foreach v_code in array p_coupon_codes loop
    if coalesce(trim(v_code), '') = '' then
      continue;
    end if;
    select c.id, pr.scope, pr.business_id into v_coupon
    from public.coupons c
    join public.promotions pr on pr.id = c.promotion_id
    where upper(c.code) = upper(trim(v_code)) and c.active;
    -- Discount per coupon was computed in the first pass; recompute for the
    -- record (same inputs, same transaction).
    if v_coupon.scope = 'business' then
      select coalesce(sum(coalesce(pv.price_minor, p.base_price_minor) * ci.quantity), 0)
      into v_biz_subtotal
      from public.cart_items ci
      join public.product_variants pv on pv.id = ci.product_variant_id
      join public.products p on p.id = pv.product_id
      where ci.cart_id = v_cart_id and p.business_id = v_coupon.business_id;
      v_coupon_discount := case v_coupon.discount_type
        when 'fixed' then least(v_coupon.discount_value, v_biz_subtotal)
        else (v_biz_subtotal * v_coupon.discount_value) / 100
      end;
      v_business := null;
      insert into public.order_coupons (order_id, coupon_id, business_id, discount_minor)
      values (v_order_id, v_coupon.id, v_coupon.business_id, v_coupon_discount);
    else
      v_coupon_discount := case v_coupon.discount_type
        when 'fixed' then least(v_coupon.discount_value, v_subtotal)
        else (v_subtotal * v_coupon.discount_value) / 100
      end;
      insert into public.order_coupons (order_id, coupon_id, business_id, discount_minor)
      values (v_order_id, v_coupon.id, null, v_coupon_discount);
    end if;
  end loop;

  delete from public.cart_items where cart_id = v_cart_id;

  return v_order_id;
end;
$$;

-- Coupon preview for the checkout screen — never raises; the client shows
-- the message. The authoritative recalculation happens in
-- create_order_from_cart (§25).
create or replace function public.validate_coupon(p_code text)
returns jsonb
language plpgsql
as $$
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

-- Bank-transfer proof (§20.2/§48): the prototype transitions straight to
-- TransactionVerified after a valid submission; awaiting state remains for
-- real verification later.
create or replace function public.submit_payment_proof(p_order_id uuid, p_path text)
returns void
language plpgsql
as $$
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

-- Payment proofs bucket (private; §48 — access protected by policies).
insert into storage.buckets (id, name, public)
values ('payment_proofs', 'payment_proofs', false)
on conflict (id) do nothing;

create policy "payment_proofs_customer_write" on storage.objects
  for insert with check (
    bucket_id = 'payment_proofs'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "payment_proofs_customer_read" on storage.objects
  for select using (
    bucket_id = 'payment_proofs'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
