-- Explicit variants only.
--
-- The implicit null-price "Default" placeholder is retired. Every product
-- must be authored with at least one real, priced variant; a business that
-- wants a "Default" option creates and manages that variant itself.
--
-- products.base_price_minor stays as a server-maintained cache of the
-- cheapest active variant (catalog price sorting, admin analytics). It is
-- no longer a pricing fallback and is never an admin input.

-- ------------------------------------------------------- data cleanup
-- Convert any legacy placeholder rows to explicit prices before enforcing
-- NOT NULL. Existing carts/orders keep their variant references.
update public.product_variants pv
   set price_minor = p.base_price_minor
  from public.products p
 where pv.product_id = p.id
   and pv.price_minor is null;

alter table public.product_variants
  alter column price_minor set not null;

drop index if exists public.product_variants_one_placeholder_idx;

-- Recompute the cached from-price from the visible (active) variants.
update public.products p
   set base_price_minor = coalesce(
     (select min(pv.price_minor)
        from public.product_variants pv
       where pv.product_id = p.id
         and pv.status = 'active'),
     p.base_price_minor);

-- ------------------------------------------------------- admin: create
-- Signature change (p_base_price_minor removed) — drop the old overload.
drop function if exists public.admin_create_product(
  uuid, text, text, bigint, uuid, integer, jsonb);

create or replace function public.admin_create_product(
    p_category_id uuid,
    p_name text,
    p_description text,
    p_brand_id uuid default null,
    p_stock integer default 0,
    p_variants jsonb default null
) returns uuid
    language plpgsql
    as $$
declare
  v_product_id uuid;
  v_variant record;
  v_base bigint;
begin
  if not public.is_admin() then
    raise exception 'Only admins can create products';
  end if;
  if p_variants is null or jsonb_array_length(p_variants) = 0 then
    raise exception 'Add at least one variant';
  end if;

  for v_variant in
    select * from jsonb_to_recordset(p_variants)
      as x(name text, price_minor bigint, image_path text)
  loop
    if coalesce(trim(v_variant.name), '') = '' then
      raise exception 'Variant name is required';
    end if;
    if v_variant.price_minor is null then
      raise exception 'Variant price is required';
    end if;
    if v_variant.price_minor < 0 then
      raise exception 'Variant price cannot be negative';
    end if;
  end loop;

  select min((v->>'price_minor')::bigint)
    into v_base
    from jsonb_array_elements(p_variants) v;

  insert into public.products
    (category_id, name, description, base_price_minor, brand_id, stock)
  values
    (p_category_id, p_name, p_description, v_base, p_brand_id, p_stock)
  returning id into v_product_id;

  for v_variant in
    select * from jsonb_to_recordset(p_variants)
      as x(name text, price_minor bigint, image_path text)
  loop
    insert into public.product_variants
      (product_id, name, price_minor, image_path)
    values
      (v_product_id, v_variant.name, v_variant.price_minor,
       v_variant.image_path);
  end loop;

  perform public.record_admin_audit(
    'admin_create_product', 'product', v_product_id,
    jsonb_build_object('name', p_name, 'stock', p_stock));
  return v_product_id;
end;
$$;

-- ------------------------------------------------------- admin: update
-- No implicit placeholder: archive only variants absent from the authored
-- list, and derive the cached base from the active rows that remain.
drop function if exists public.admin_update_product(
  uuid, uuid, text, text, bigint, uuid, integer, jsonb);

create or replace function public.admin_update_product(
    p_product_id uuid,
    p_category_id uuid,
    p_name text,
    p_description text,
    p_brand_id uuid default null,
    p_stock integer default 0,
    p_variants jsonb default null
) returns void
    language plpgsql
    as $$
declare
  v_variant record;
  v_active_count integer;
  v_base bigint;
begin
  if not public.is_admin() then
    raise exception 'Only admins can update products';
  end if;

  update public.products
     set category_id = p_category_id,
         name = p_name,
         description = p_description,
         brand_id = p_brand_id,
         stock = p_stock
   where id = p_product_id;
  if not found then
    raise exception 'Product not found';
  end if;

  if p_variants is not null then
    if jsonb_array_length(p_variants) = 0 then
      raise exception 'Add at least one variant';
    end if;

    for v_variant in
      select * from jsonb_to_recordset(p_variants)
        as x(id uuid, name text, price_minor bigint, image_path text)
    loop
      if coalesce(trim(v_variant.name), '') = '' then
        raise exception 'Variant name is required';
      end if;
      if v_variant.price_minor is null then
        raise exception 'Variant price is required';
      end if;
      if v_variant.price_minor < 0 then
        raise exception 'Variant price cannot be negative';
      end if;
    end loop;

    -- Ids surviving this sync (updated in place OR freshly inserted).
    drop table if exists _variant_keep;
    create temp table _variant_keep (id uuid primary key) on commit drop;

    for v_variant in
      select * from jsonb_to_recordset(p_variants)
        as x(id uuid, name text, price_minor bigint, image_path text)
    loop
      if v_variant.id is null then
        insert into public.product_variants
          (product_id, name, price_minor, image_path)
        values
          (p_product_id, v_variant.name, v_variant.price_minor,
           v_variant.image_path)
        returning id into v_variant.id;
      else
        update public.product_variants
           set name = v_variant.name,
               price_minor = v_variant.price_minor,
               image_path = v_variant.image_path
         where id = v_variant.id
           and product_id = p_product_id;
        if not found then
          raise exception 'Variant does not belong to this product';
        end if;
      end if;
      insert into _variant_keep (id) values (v_variant.id);
    end loop;

    -- Archive active variants absent from the authored list (never delete:
    -- orders and carts reference these rows).
    update public.product_variants
       set status = 'archived'
     where product_id = p_product_id
       and status = 'active'
       and not exists (
         select 1 from _variant_keep k where k.id = product_variants.id
       );

    select count(*), min(price_minor)
      into v_active_count, v_base
      from public.product_variants
     where product_id = p_product_id
       and status = 'active';
    if v_active_count = 0 then
      raise exception 'A product needs at least one active variant';
    end if;

    update public.products
       set base_price_minor = v_base
     where id = p_product_id;
  end if;

  perform public.record_admin_audit(
    'admin_update_product', 'product', p_product_id,
    jsonb_build_object('name', p_name, 'stock', p_stock,
                       'variants_synced', p_variants is not null));
end;
$$;

-- ------------------------------------------------------- cart line view
create or replace view public.cart_item_details
  with (security_invoker = true) as
select
  ci.id,
  ci.cart_id,
  ci.created_at,
  ci.updated_at,
  ci.quantity,
  pv.id as variant_id,
  pv.name as variant_name,
  p.id as product_id,
  p.name as product_name,
  p.stock,
  p.brand_id,
  p.category_id,
  pv.price_minor as unit_price_minor,
  public.best_sale_price_minor(p.id, pv.price_minor) as sale_unit_price_minor,
  (
    select pi.storage_path
      from public.product_images pi
     where pi.product_id = p.id
     order by pi.sort_order
     limit 1
  ) as image_storage_path
from public.cart_items ci
join public.product_variants pv on pv.id = ci.product_variant_id
join public.products p on p.id = pv.product_id;

grant select on public.cart_item_details to authenticated;

comment on view public.cart_item_details is
  'Cart/checkout line read model with server-authoritative sale pricing.';

-- ------------------------------------------------------- coupon preview
create or replace function public.validate_coupon(p_code text)
returns jsonb
    language plpgsql stable security definer
    set search_path to 'public'
    as $$
declare
  v_user uuid := auth.uid();
  v_cart_id uuid;
  v_subtotal bigint := 0;
  v_coupon record;
  v_discount bigint;
begin
  if v_user is null then
    return jsonb_build_object('valid', false, 'message', 'Not authenticated',
                              'discount_minor', 0);
  end if;
  select id into v_cart_id from public.carts where user_id = v_user;
  if v_cart_id is null then
    return jsonb_build_object('valid', false, 'message', 'Cart is empty',
                              'discount_minor', 0);
  end if;

  select coalesce(sum(public.best_sale_price_minor(
                     pv.product_id, pv.price_minor) * ci.quantity), 0)
    into v_subtotal
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
   where ci.cart_id = v_cart_id;

  select * into v_coupon
    from public.coupons
   where upper(code) = upper(trim(p_code))
     and active
     and (starts_at is null or starts_at <= now())
     and (ends_at is null or ends_at >= now())
   limit 1;
  if not found then
    return jsonb_build_object('valid', false,
      'message', 'Coupon is invalid or expired', 'discount_minor', 0);
  end if;
  if v_subtotal = 0 then
    return jsonb_build_object('valid', false, 'message', 'Cart is empty',
                              'discount_minor', 0);
  end if;
  if v_subtotal < v_coupon.min_order_amount_minor then
    return jsonb_build_object('valid', false,
      'message', 'Coupon requires a minimum order of $'
                 || (v_coupon.min_order_amount_minor / 100)::text,
      'discount_minor', 0);
  end if;

  v_discount := case v_coupon.discount_type
    when 'fixed' then least(v_coupon.discount_value, v_subtotal)
    else (v_subtotal * v_coupon.discount_value) / 100
  end;
  return jsonb_build_object('valid', true, 'message', v_coupon.name,
                            'discount_minor', v_discount);
end;
$$;

create or replace function public.preview_order_totals(
    p_codes text[] default '{}'
) returns jsonb
    language plpgsql stable security definer
    set search_path to 'public'
    as $$
declare
  v_user uuid := auth.uid();
  v_cart_id uuid;
  v_subtotal bigint := 0;
  v_delivery_fee bigint := 0;
  v_code text;
  v_coupon record;
  v_discount bigint;
  v_manual jsonb := '[]'::jsonb;
  v_total_discount bigint := 0;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  select coalesce(delivery_fee_minor, 0) into v_delivery_fee
    from public.platform_settings where id = 1;

  select id into v_cart_id from public.carts where user_id = v_user;
  if v_cart_id is null then
    return jsonb_build_object('subtotal_minor', 0, 'manual', v_manual,
      'total_discount_minor', 0, 'delivery_fee_minor', v_delivery_fee,
      'total_minor', v_delivery_fee);
  end if;

  select coalesce(sum(public.best_sale_price_minor(
                     pv.product_id, pv.price_minor) * ci.quantity), 0)
    into v_subtotal
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
   where ci.cart_id = v_cart_id;

  -- Invalid codes are skipped here; validate_coupon surfaced them at entry.
  foreach v_code in array coalesce(p_codes, '{}') loop
    if coalesce(trim(v_code), '') = '' then
      continue;
    end if;
    select * into v_coupon
      from public.coupons
     where upper(code) = upper(trim(v_code))
       and active
       and (starts_at is null or starts_at <= now())
       and (ends_at is null or ends_at >= now())
     limit 1;
    if not found then
      continue;
    end if;
    if v_subtotal = 0 or v_subtotal < v_coupon.min_order_amount_minor then
      continue;
    end if;
    v_discount := case v_coupon.discount_type
      when 'fixed' then least(v_coupon.discount_value, v_subtotal)
      else (v_subtotal * v_coupon.discount_value) / 100
    end;
    v_manual := v_manual || jsonb_build_object('code', trim(v_code),
                                               'discount_minor', v_discount);
    v_total_discount := v_total_discount + v_discount;
  end loop;
  v_total_discount := least(v_total_discount, v_subtotal);

  return jsonb_build_object(
    'subtotal_minor', v_subtotal,
    'manual', v_manual,
    'total_discount_minor', v_total_discount,
    'delivery_fee_minor', v_delivery_fee,
    'total_minor', v_subtotal - v_total_discount + v_delivery_fee);
end;
$$;

-- ------------------------------------------------------- order placement
create or replace function public.create_order_from_cart(
    p_address_id uuid,
    p_payment_method public.payment_method,
    p_coupon_codes text[] default '{}',
    p_note text default ''
) returns uuid
    language plpgsql security definer
    set search_path to 'public'
    as $$
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

  -- Lock every product referenced by the cart before validating stock.
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
           public.best_sale_price_minor(p.id, pv.price_minor) as unit_price
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    join public.products p on p.id = pv.product_id
    where ci.cart_id = v_cart_id
  loop
    v_subtotal := v_subtotal + v_item.unit_price * v_item.quantity;
  end loop;

  drop table if exists pg_temp._coupon_discounts;
  create temp table _coupon_discounts (
    coupon_id uuid primary key,
    discount bigint not null
  ) on commit drop;

  foreach v_code in array p_coupon_codes loop
    if coalesce(trim(v_code), '') = '' then
      continue;
    end if;

    select c.id, c.discount_type, c.discount_value, c.min_order_amount_minor
    into v_coupon
    from public.coupons c
    where upper(c.code) = upper(trim(v_code))
      and c.active
      and (c.starts_at is null or c.starts_at <= now())
      and (c.ends_at is null or c.ends_at >= now());
    if not found then
      raise exception 'Coupon % is invalid or expired', v_code;
    end if;
    if v_subtotal = 0 then
      raise exception 'Coupon % does not apply to your cart', v_code;
    end if;
    if v_subtotal < v_coupon.min_order_amount_minor then
      raise exception 'Coupon % requires a minimum order of %', v_code,
        v_coupon.min_order_amount_minor;
    end if;

    v_coupon_discount := case v_coupon.discount_type
      when 'fixed' then least(v_coupon.discount_value, v_subtotal)
      else (v_subtotal * v_coupon.discount_value) / 100
    end;

    insert into pg_temp._coupon_discounts (coupon_id, discount)
    values (v_coupon.id, v_coupon_discount);
    v_discount_total := v_discount_total + v_coupon_discount;
  end loop;
  v_discount_total := least(v_discount_total, v_subtotal);

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

  insert into public.order_items (
    order_id, product_id, product_variant_id, product_name, variant_name,
    unit_price_minor, discount_minor, quantity, line_total_minor
  )
  select
    v_order_id, p.id, ci.product_variant_id, p.name, pv.name,
    public.best_sale_price_minor(p.id, pv.price_minor),
    0, ci.quantity,
    public.best_sale_price_minor(p.id, pv.price_minor) * ci.quantity
  from public.cart_items ci
  join public.product_variants pv on pv.id = ci.product_variant_id
  join public.products p on p.id = pv.product_id
  where ci.cart_id = v_cart_id;

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

  insert into public.order_coupons (order_id, coupon_id, discount_minor)
  select v_order_id, coupon_id, discount
  from pg_temp._coupon_discounts;

  delete from public.cart_items where cart_id = v_cart_id;

  return v_order_id;
end;
$$;
