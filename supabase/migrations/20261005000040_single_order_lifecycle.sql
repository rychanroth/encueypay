-- 2-Role Academic Prototype, Section 7A (living spec Part B §7): ONE order
-- lifecycle. Decision (user, 2026-10-05): single-seller e-commerce exposes
-- ONE order status; the per-business split existed for independent
-- fulfillers that no longer exist.
--
-- orders.status adopts the assignment's own vocabulary:
--   pending → confirmed → processing → packed → shipped → out_for_delivery
--   → delivered, plus cancelled and returned.
-- business_orders, deliveries and pickup_stops are DROPPED (pickup stops
-- permanently omitted per user decision); order_items reference orders
-- directly and keep the business-name snapshot for display. Payment stays
-- its own flow. The admin transitions orders.status directly; the customer
-- timeline reads it verbatim — no derivation.

-- ------------------------------------------------------------ new lifecycle
create type public.order_status as enum (
  'pending', 'confirmed', 'processing', 'packed',
  'shipped', 'out_for_delivery', 'delivered', 'cancelled', 'returned'
);

alter table public.orders
  add column status public.order_status not null default 'pending',
  add column cancelled_at timestamptz,
  add column cancellation_reason text not null default '';

-- order_items move to the order directly (business name snapshot kept).
alter table public.order_items
  add column order_id uuid references public.orders (id) on delete cascade;

update public.order_items oi
set order_id = bo.order_id
from public.business_orders bo
where bo.id = oi.business_order_id;

alter table public.order_items
  alter column order_id set not null;

create index order_items_order_idx on public.order_items (order_id);

-- State history now records the order lifecycle.
create or replace function public.record_order_state()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.state_history (entity_type, entity_id, from_state, to_state, actor)
  values ('order', new.id, old.status::text, new.status::text, auth.uid());
  return new;
end;
$$;

create trigger orders_record_state
  after update of status on public.orders
  for each row
  execute function public.record_order_state();

-- Customer notification on every lifecycle step (replaces the per-family
-- notification triggers, which are dropped with their tables).
create or replace function public.notify_customer_on_order_status()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_title text := case new.status::text
    when 'confirmed' then 'Order confirmed'
    when 'processing' then 'Order is being processed'
    when 'packed' then 'Order packed'
    when 'shipped' then 'Order shipped'
    when 'out_for_delivery' then 'Out for delivery'
    when 'delivered' then 'Order delivered'
    when 'cancelled' then 'Order cancelled'
    when 'returned' then 'Order returned'
    else 'Order update'
  end;
begin
  if old.status is distinct from new.status then
    perform public.notify(
      new.customer_id, 'order', v_title,
      'Order ' || new.id::text || ' is now ' || replace(new.status::text, '_', ' ') || '.');
  end if;
  return new;
end;
$$;

create trigger orders_notify_status
  after update of status on public.orders
  for each row
  execute function public.notify_customer_on_order_status();

-- ---------------------------------------------------------- RPC rewrites
-- Placement: same validations and pricing as 0037; items land on the order
-- directly and no fulfillment tables are written.
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
  v_code text;
  v_coupon record;
  v_coupon_discount bigint;
  v_scope_subtotal bigint;
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
  -- an active business (server authority, §53).
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

  -- Lock product rows, validate product-wide stock, price from the DB (§2d).
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

  -- Coupons (§24–§26 + §2d brand scope + §5b windows/min-order).
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
      -- Single lifecycle: no per-business split — the brand discount applies
      -- to the order as one amount (§7A).
      v_coupon_discount := case v_coupon.discount_type
        when 'fixed' then least(v_coupon.discount_value, v_scope_subtotal)
        else (v_scope_subtotal * v_coupon.discount_value) / 100
      end;

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
    delivery_fee_minor, total_minor, note, status
  ) values (
    v_user, v_address.recipient_name, v_address.phone, v_address.line1,
    v_address.line2, v_address.city, v_subtotal, v_discount_total,
    v_delivery_fee, v_subtotal - v_discount_total + v_delivery_fee,
    coalesce(p_note, ''), 'pending'
  ) returning id into v_order_id;

  insert into public.payments (order_id, method, amount_minor, status)
  values (
    v_order_id, p_payment_method, v_subtotal - v_discount_total + v_delivery_fee,
    case when p_payment_method = 'bank_transfer'
         then 'awaiting_payment_verification'::public.payment_status
         else 'pending'::public.payment_status end
  );

  for v_item in
    select ci.product_variant_id, ci.quantity, pv.name as variant_name,
           coalesce(pv.price_minor, p.base_price_minor) as unit_price,
           p.id as product_id, p.name as product_name,
           b.name as business_name
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    join public.products p on p.id = pv.product_id
    join public.businesses b on b.id = p.business_id
    where ci.cart_id = v_cart_id
  loop
    insert into public.order_items (
      order_id, product_id, product_variant_id, product_name,
      variant_name, business_name, unit_price_minor, discount_minor,
      quantity, line_total_minor
    ) values (
      v_order_id, v_item.product_id, v_item.product_variant_id,
      v_item.product_name, v_item.variant_name, v_item.business_name,
      v_item.unit_price, 0, v_item.quantity,
      v_item.unit_price * v_item.quantity
    );
  end loop;

  -- Historical coupon record (§26).
  insert into public.order_coupons (order_id, coupon_id, business_id, discount_minor)
  select v_order_id, coupon_id, business_id, discount
  from _coupon_discounts;

  -- Product-wide stock deduction (§2d/§4); rows locked above.
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

-- Cancellation (customer): pending only; records reason/date, restores
-- product-wide stock, and routes verified transfers to refund-required
-- (§7D refines the paid-QR path).
create or replace function public.cancel_order(p_order_id uuid, p_reason text default 'Cancelled by customer')
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
    select 1 from public.orders
    where id = p_order_id
      and status not in ('pending', 'confirmed')
  ) then
    raise exception 'Order can no longer be cancelled';
  end if;

  update public.orders
  set status = 'cancelled',
      cancelled_at = now(),
      cancellation_reason = coalesce(nullif(trim(p_reason), ''), 'Cancelled by customer')
  where id = p_order_id;

  -- Stock restore (§2d): quantities come from the historical order items.
  update public.products p
  set stock = p.stock + restored.qty
  from (
    select oi.product_id, sum(oi.quantity) as qty
    from public.order_items oi
    where oi.order_id = p_order_id
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
end;
$$;

-- Admin transitions the ONE machine forward; cancelling a pending order is
-- the rejection equivalent (reason recorded).
create or replace function public.admin_transition_order(
  p_order_id uuid,
  p_status public.order_status,
  p_reason text default null
)
returns void
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
  v_current public.order_status;
  v_valid boolean;
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage orders';
  end if;

  select status into v_current from public.orders where id = p_order_id;
  if not found then
    raise exception 'Order not found';
  end if;

  -- Forward progression along the chain, plus administrative cancellation
  -- of not-yet-shipped orders. delivered → returned lands with slice 7E.
  v_valid := (v_current, p_status) in (
    ('pending', 'confirmed'), ('confirmed', 'processing'),
    ('processing', 'packed'), ('packed', 'shipped'),
    ('shipped', 'out_for_delivery'), ('out_for_delivery', 'delivered'),
    ('pending', 'cancelled'), ('confirmed', 'cancelled')
  );
  if not v_valid then
    raise exception 'Cannot move order from % to %', v_current, p_status;
  end if;
  if p_status = 'cancelled' and coalesce(trim(p_reason), '') = '' then
    raise exception 'Cancellation reason is required';
  end if;

  update public.orders
  set status = p_status,
      cancelled_at = case when p_status = 'cancelled' then now() else cancelled_at end,
      cancellation_reason = case
        when p_status = 'cancelled' then coalesce(p_reason, '')
        else cancellation_reason end
  where id = p_order_id;

  -- Cancellation restores product-wide stock (§2d).
  if p_status = 'cancelled' then
    update public.products p
    set stock = p.stock + restored.qty
    from (
      select oi.product_id, sum(oi.quantity) as qty
      from public.order_items oi
      where oi.order_id = p_order_id
      group by oi.product_id
    ) restored
    where p.id = restored.product_id;
  end if;
end;
$$;

-- Returns RPCs move to the direct order reference (0010 rewrote).
create or replace function public.request_return(
  p_order_id uuid,
  p_items jsonb
)
returns uuid
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_request_id uuid;
  v_item record;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;

  if not exists (
    select 1 from public.orders
    where id = p_order_id and customer_id = v_user and status = 'delivered'
  ) then
    raise exception 'Only delivered orders can be returned';
  end if;

  insert into public.return_requests (order_id, customer_id, status)
  values (p_order_id, v_user, 'pending')
  returning id into v_request_id;

  for v_item in select * from jsonb_to_recordset(p_items)
      as x(order_item_id uuid, quantity integer, reason text)
  loop
    -- The line must belong to the caller's order; quantity cannot exceed
    -- the purchased quantity (§28).
    if not exists (
      select 1 from public.order_items oi
      where oi.id = v_item.order_item_id
        and oi.order_id = p_order_id
        and v_item.quantity <= oi.quantity
    ) then
      raise exception 'Invalid return item';
    end if;

    insert into public.return_items
      (return_request_id, order_item_id, quantity, reason, status)
    values
      (v_request_id, v_item.order_item_id, v_item.quantity,
       coalesce(v_item.reason, ''), 'pending');
  end loop;

  return v_request_id;
end;
$$;

-- Reviews move to the direct order reference (0010 rewrote).
create or replace function public.create_review(
  p_order_item_id uuid,
  p_rating integer,
  p_text text
)
returns uuid
language plpgsql
as $$
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
  join public.orders o on o.id = oi.order_id
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

-- Customer dashboard buckets rewrite to the single lifecycle (§7A).
create or replace function public.get_customer_dashboard()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  with my_orders as (
    select o.*
    from public.orders o
    where o.customer_id = auth.uid()
  )
  select jsonb_build_object(
    'active_orders', (
      select count(*) from my_orders o
      where o.status in ('pending', 'confirmed', 'processing', 'packed',
                         'shipped', 'out_for_delivery')
    ),
    'wishlist_count', (
      select count(*) from public.wishlist_items wi
      join public.wishlists w on w.id = wi.wishlist_id
      where w.user_id = auth.uid()
    ),
    'cart_items', (
      select coalesce(sum(ci.quantity), 0) from public.cart_items ci
      join public.carts c on c.id = ci.cart_id
      where c.user_id = auth.uid()
    ),
    'total_spending_minor', (
      select coalesce(sum(total_minor), 0) from my_orders
    ),
    'recent_orders', (
      select coalesce(jsonb_agg(jsonb_build_object(
               'id', recent.id,
               'total_minor', recent.total_minor,
               'created_at', recent.created_at,
               'state', recent.state
             ) order by recent.created_at desc), '[]'::jsonb)
      from (
        select o.id, o.total_minor, o.created_at,
               case
                 when o.status in ('pending', 'confirmed', 'processing',
                                   'packed', 'shipped', 'out_for_delivery')
                   then 'active'
                 when o.status in ('cancelled', 'returned') then 'cancelled'
                 else 'completed'
               end as state
        from my_orders o
        order by o.created_at desc
        limit 5
      ) recent
    )
  );
$$;

-- --------------------------------------------- fulfillment tables removal
drop trigger if exists notify_on_business_order_created on public.business_orders;
drop trigger if exists notify_on_business_order_status on public.business_orders;
drop trigger if exists notify_on_delivery_status on public.deliveries;
drop trigger if exists business_orders_record_state on public.business_orders;
drop function if exists public.notify_business_new_order();
drop function if exists public.notify_customer_on_business_order();
drop function if exists public.notify_customer_on_delivery();
drop function if exists public.record_business_order_state();
drop function if exists public.admin_ship_order(uuid);
drop function if exists public.admin_complete_order(uuid);

drop table if exists public.pickup_stops cascade;
drop table if exists public.deliveries cascade;
drop table if exists public.business_orders cascade;

drop type if exists public.pickup_stop_status;
drop type if exists public.delivery_status;
drop type if exists public.business_order_status;

-- Dead settings field (driver earnings were a delivery-table concept).
alter table public.platform_settings drop column driver_commission_percent;
