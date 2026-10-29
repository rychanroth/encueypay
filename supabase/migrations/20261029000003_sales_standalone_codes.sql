-- Sales + standalone codes: promotions / coupons / banners untangled.
--
-- `promotions` becomes `sales` — group-targeted pricing (platform | brand |
-- category), percent or fixed dollar amount, with its own window and kill
-- switch. A sale is PRICING: order lines are charged at the best applicable
-- sale price (best_sale_price_minor), so no ledger is needed for sales.
-- `coupons` become standalone cart-wide codes that stack on top of the
-- sale-applied subtotal; the auto-apply campaign machinery is retired.
-- `banners` keep an optional soft link to a sale used only for the tap
-- target; the client hides a banner whose sale is not live.
--
-- Overload discipline (see 20261029000001): every function whose SIGNATURE
-- changes is explicitly dropped before its restatement; same-signature
-- restatements use CREATE OR REPLACE safely.

-- ----------------------------------------------------------------- sales
ALTER TABLE public.promotions RENAME TO sales;
ALTER TYPE public.promotion_scope RENAME TO sale_scope;

-- The window moves back onto the sale (it lived on the coupon under the
-- coupon-backed model). Policy names keep their legacy `promotions_*`
-- names — policies cannot be renamed and the expressions are unchanged.
ALTER TABLE public.sales
  ADD COLUMN starts_at timestamptz,
  ADD COLUMN ends_at timestamptz,
  ADD COLUMN category_id uuid REFERENCES public.categories (id)
    ON DELETE CASCADE;

-- The old promotions_check gated the retired 'business' scope — vacuous
-- since its column was dropped. Positivity returns as a hard constraint
-- (it was enforced only in RPCs since 20261028000004).
ALTER TABLE public.sales DROP CONSTRAINT IF EXISTS promotions_check;
ALTER TABLE public.sales
  ADD CONSTRAINT sales_discount_value_check CHECK (discount_value > 0);

ALTER TABLE public.banners RENAME COLUMN promotion_id TO sale_id;

-- The old campaign data was authored against the broken feature (its
-- banner creation never succeeded end-to-end), so it is wiped rather than
-- migrated — the admin recreates live campaigns under the new model.
-- order_coupons goes with coupons (FK); past orders keep their aggregate
-- discount_minor, only the per-code breakdown rows go.
TRUNCATE public.sales, public.coupons, public.banners, public.order_coupons;

-- --------------------------------------------------- standalone coupons
ALTER TABLE public.coupons
  ADD COLUMN name text NOT NULL,
  ADD COLUMN discount_type public.discount_type NOT NULL,
  ADD COLUMN discount_value bigint NOT NULL,
  ADD CONSTRAINT coupons_discount_value_check CHECK (discount_value > 0);

-- The creator policy subqueried coupons.promotion_id — it must go BEFORE
-- the column drop (policies block column drops), and codes are now
-- standalone, so writes gate on admin instead.
DROP POLICY IF EXISTS coupons_creator_write ON public.coupons;
CREATE POLICY coupons_admin_write ON public.coupons
  FOR ALL TO authenticated
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

ALTER TABLE public.coupons DROP CONSTRAINT coupons_promotion_id_fkey;
ALTER TABLE public.coupons DROP COLUMN promotion_id;
ALTER TABLE public.coupons DROP COLUMN auto_apply;

-- ----------------------------------------------------- live-sale rule
-- The single definition of "currently live": active and within its window.
-- The client's chip/price fetch reads this view and the order RPCs read it
-- through best_sale_price_minor, so the eligibility logic exists exactly
-- once. security_invoker keeps the base table's RLS in force.
CREATE VIEW public.active_sales WITH (security_invoker = true) AS
  SELECT id, created_by, scope, brand_id, category_id, name, description,
         discount_type, discount_value, active, starts_at, ends_at,
         created_at, updated_at
    FROM public.sales
   WHERE active
     AND (starts_at IS NULL OR starts_at <= now())
     AND (ends_at IS NULL OR ends_at >= now());

GRANT SELECT ON public.active_sales TO anon, authenticated;

-- Best price the customer pays for one unit: the lowest price any
-- applicable live sale produces (a percent sale and a dollar sale compare
-- by outcome). Percent math truncates like every other discount here
-- ((price * value) / 100); fixed floors at zero.
CREATE OR REPLACE FUNCTION public.best_sale_price_minor(
  p_product_id uuid,
  p_price_minor bigint
) RETURNS bigint
  LANGUAGE sql STABLE
  SET search_path TO 'public'
  AS $$
  SELECT least(
    p_price_minor,
    coalesce(min(CASE s.discount_type
      WHEN 'percent' THEN p_price_minor - (p_price_minor * s.discount_value) / 100
      ELSE greatest(p_price_minor - s.discount_value, 0)
    END), p_price_minor))
    FROM public.active_sales s
   WHERE s.scope = 'platform'
      OR (s.scope = 'brand'
          AND s.brand_id = (SELECT p.brand_id FROM public.products p
                             WHERE p.id = p_product_id))
      OR (s.scope = 'category'
          AND s.category_id = (SELECT p.category_id FROM public.products p
                                WHERE p.id = p_product_id));
$$;

-- --------------------------------------------------------- sale admin
CREATE OR REPLACE FUNCTION public.admin_create_sale(
    p_name text,
    p_description text,
    p_discount_type public.discount_type,
    p_discount_value bigint,
    p_scope public.sale_scope,
    p_brand_id uuid DEFAULT NULL,
    p_category_id uuid DEFAULT NULL,
    p_starts_at timestamptz DEFAULT NULL,
    p_ends_at timestamptz DEFAULT NULL,
    p_image_path text DEFAULT NULL
) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
declare
  v_sale_id uuid;
  v_banner_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can create sales';
  end if;
  if coalesce(trim(p_name), '') = '' then
    raise exception 'Sale name is required';
  end if;
  if p_discount_value is null or p_discount_value <= 0 then
    raise exception 'Sale discount must be positive';
  end if;
  if p_discount_type = 'percent' and p_discount_value > 100 then
    raise exception 'Percent discounts are capped at 100';
  end if;
  if p_scope = 'brand' then
    if p_brand_id is null then
      raise exception 'A brand is required for a brand sale';
    end if;
    if not exists (select 1 from public.brands where id = p_brand_id) then
      raise exception 'Brand not found';
    end if;
  elsif p_scope = 'category' then
    if p_category_id is null then
      raise exception 'A category is required for a category sale';
    end if;
    if not exists (select 1 from public.categories where id = p_category_id) then
      raise exception 'Category not found';
    end if;
  end if;

  insert into public.sales
    (created_by, scope, brand_id, category_id, name, description,
     discount_type, discount_value, starts_at, ends_at, active)
  values
    (auth.uid(), p_scope,
     case when p_scope = 'brand' then p_brand_id end,
     case when p_scope = 'category' then p_category_id end,
     p_name, coalesce(p_description, ''), p_discount_type, p_discount_value,
     p_starts_at, p_ends_at, true)
  returning id into v_sale_id;

  -- Optional banner in the same step (the one-step campaign UX): live
  -- immediately (single-admin prototype), linked to the sale for its tap
  -- target only — moderation actions remain for reject/disable later.
  if coalesce(trim(p_image_path), '') <> '' then
    insert into public.banners
      (created_by, name, description, image_path, ends_at, status, sale_id)
    values
      (auth.uid(), p_name, coalesce(p_description, ''), p_image_path,
       p_ends_at, 'approved', v_sale_id)
    returning id into v_banner_id;
  end if;

  perform public.record_admin_audit('admin_create_sale', 'sale', v_sale_id,
    jsonb_build_object('scope', p_scope, 'banner_id', v_banner_id));
  return jsonb_build_object('sale_id', v_sale_id, 'banner_id', v_banner_id);
end;
$$;

CREATE OR REPLACE FUNCTION public.admin_set_sale_active(
    p_sale_id uuid,
    p_active boolean
) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can toggle sales';
  end if;
  update public.sales set active = p_active where id = p_sale_id;
  perform public.record_admin_audit('admin_set_sale_active', 'sale', p_sale_id,
    jsonb_build_object('active', p_active));
end;
$$;

-- ------------------------------------------------------- coupon admin
CREATE OR REPLACE FUNCTION public.admin_create_coupon(
    p_name text,
    p_code text,
    p_discount_type public.discount_type,
    p_discount_value bigint,
    p_min_order_amount_minor bigint DEFAULT 0,
    p_starts_at timestamptz DEFAULT NULL,
    p_ends_at timestamptz DEFAULT NULL
) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
declare
  v_coupon_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can create coupons';
  end if;
  if coalesce(trim(p_code), '') = '' then
    raise exception 'Coupon code is required';
  end if;
  if p_discount_value is null or p_discount_value <= 0 then
    raise exception 'Coupon discount must be positive';
  end if;
  if p_discount_type = 'percent' and p_discount_value > 100 then
    raise exception 'Percent discounts are capped at 100';
  end if;
  if p_min_order_amount_minor is null or p_min_order_amount_minor < 0 then
    raise exception 'Minimum order amount cannot be negative';
  end if;

  insert into public.coupons
    (name, code, discount_type, discount_value, min_order_amount_minor,
     starts_at, ends_at, active)
  values
    (coalesce(p_name, ''), upper(trim(p_code)), p_discount_type,
     p_discount_value, p_min_order_amount_minor, p_starts_at, p_ends_at, true)
  returning id into v_coupon_id;

  perform public.record_admin_audit('admin_create_coupon', 'coupon',
    v_coupon_id, jsonb_build_object('code', upper(trim(p_code))));
  return v_coupon_id;
end;
$$;

-- ------------------------------------------------------- checkout SQL
-- Codes are validated standalone: cart-wide, on the sale-applied subtotal.
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
                     pv.product_id,
                     coalesce(pv.price_minor, p.base_price_minor)) * ci.quantity), 0)
    into v_subtotal
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    join public.products p on p.id = pv.product_id
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

-- Checkout preview: sale-applied subtotal, stacked code discounts, delivery
-- fee and grand total — the same numbers placement produces, so the summary
-- the customer approves is the summary they are charged.
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
                     pv.product_id,
                     coalesce(pv.price_minor, p.base_price_minor)) * ci.quantity), 0)
    into v_subtotal
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    join public.products p on p.id = pv.product_id
   where ci.cart_id = v_cart_id;

  -- Invalid codes are skipped here; validate_coupon already surfaced them
  -- at entry time.
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

-- Placement: lines priced by best_sale_price_minor (sales are the price the
-- customer pays — the historical record lives in the line prices), then the
-- code loop on the sale-applied subtotal. The auto-apply block is retired.
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
  -- Sales are pricing: each line takes the best applicable live sale, so
  -- the unit price IS what the customer pays (map §4.1).
  for v_item in
    select ci.quantity,
           public.best_sale_price_minor(
             p.id, coalesce(pv.price_minor, p.base_price_minor)) as unit_price
    from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    join public.products p on p.id = pv.product_id
    where ci.cart_id = v_cart_id
  loop
    v_subtotal := v_subtotal + v_item.unit_price * v_item.quantity;
  end loop;

  -- Standalone codes: cart-wide, stacked on the sale-applied subtotal,
  -- gated by each code's minimum order, capped at the subtotal.
  -- pg_temp-qualified drop guard: the function's search_path is public, so
  -- an unqualified drop would miss the temp table on a second call in one
  -- transaction.
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

  -- Order items hang off the order directly (single lifecycle, map §4.1) —
  -- at the sale-applied unit price, which is the historical truth.
  insert into public.order_items (
    order_id, product_id, product_variant_id, product_name, variant_name,
    unit_price_minor, discount_minor, quantity, line_total_minor
  )
  select
    v_order_id, p.id, ci.product_variant_id, p.name, pv.name,
    public.best_sale_price_minor(p.id, coalesce(pv.price_minor, p.base_price_minor)),
    0, ci.quantity,
    public.best_sale_price_minor(p.id, coalesce(pv.price_minor, p.base_price_minor))
      * ci.quantity
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

  -- Historical code record (map §4.6): actual discounts even if the coupon
  -- changes or is deleted later. Sales need no ledger — they live in the
  -- line prices themselves.
  insert into public.order_coupons (order_id, coupon_id, discount_minor)
  select v_order_id, coupon_id, discount
  from pg_temp._coupon_discounts;

  delete from public.cart_items where cart_id = v_cart_id;

  return v_order_id;
end;
$$;

-- ------------------------------------------------------------ retirement
DROP FUNCTION IF EXISTS public.admin_create_campaign(
  text, text, text, public.discount_type, bigint, bigint,
  timestamptz, timestamptz, uuid);
DROP FUNCTION IF EXISTS public.admin_set_promotion_active(uuid, boolean);
DROP FUNCTION IF EXISTS public.create_platform_promotion(
  text, text, public.discount_type, bigint, text, bigint,
  timestamptz, timestamptz, uuid);
DROP FUNCTION IF EXISTS public.preview_cart_discounts(text[]);
