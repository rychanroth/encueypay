-- EncueYPay - UI overhaul migration bundle (2026-10-13)
-- Paste into the Supabase dashboard SQL editor and run ONCE.
-- Consolidates supabase/migrations/20261013*_*.sql in order; re-runnable
-- (IF NOT EXISTS / CREATE OR REPLACE / DROP POLICY IF EXISTS guards).
-- After running, re-seed brands/categories imagery: supabase/seed.sql
-- (sections 'categories' and 'brands').

-- ================= 20261013000001_catalog_imagery.sql =================
-- Catalog imagery pipeline (DESIGN.md §2c/§5.1.2/§6.1): brands and
-- categories gain the storage-path convention already used by banners and
-- promotions (image_path in a public bucket, resolved to a public URL at
-- the repository boundary).

-- ------------------------------------------------------------- columns
ALTER TABLE "public"."brands"
  ADD COLUMN IF NOT EXISTS "image_path" "text";
ALTER TABLE "public"."categories"
  ADD COLUMN IF NOT EXISTS "image_path" "text";

-- image_url is deprecated: it was never populated by the seed or the admin
-- forms, and new reads/writes use image_path exclusively. Kept for
-- rollback safety.
COMMENT ON COLUMN "public"."brands"."image_url"
  IS 'DEPRECATED — use image_path (catalog_assets storage convention)';
COMMENT ON COLUMN "public"."categories"."image_url"
  IS 'DEPRECATED — use image_path (catalog_assets storage convention)';

-- -------------------------------------------------------------- storage
-- catalog_assets: brand/category imagery. Public read; admin-only writes
-- (same authority shape as promo_assets).
INSERT INTO "storage"."buckets" ("id", "name", "public")
VALUES ('catalog_assets', 'catalog_assets', true)
ON CONFLICT ("id") DO NOTHING;

DROP POLICY IF EXISTS "catalog_assets_bucket_public_read" ON "storage"."objects";
CREATE POLICY "catalog_assets_bucket_public_read" ON "storage"."objects"
  FOR SELECT TO anon, authenticated
  USING ("bucket_id" = 'catalog_assets');

DROP POLICY IF EXISTS "catalog_assets_bucket_admin_insert" ON "storage"."objects";
CREATE POLICY "catalog_assets_bucket_admin_insert" ON "storage"."objects"
  FOR INSERT TO authenticated
  WITH CHECK ("bucket_id" = 'catalog_assets' AND "public"."is_admin"());

DROP POLICY IF EXISTS "catalog_assets_bucket_admin_update" ON "storage"."objects";
CREATE POLICY "catalog_assets_bucket_admin_update" ON "storage"."objects"
  FOR UPDATE TO authenticated
  USING ("bucket_id" = 'catalog_assets' AND "public"."is_admin"())
  WITH CHECK ("bucket_id" = 'catalog_assets' AND "public"."is_admin"());

DROP POLICY IF EXISTS "catalog_assets_bucket_admin_delete" ON "storage"."objects";
CREATE POLICY "catalog_assets_bucket_admin_delete" ON "storage"."objects"
  FOR DELETE TO authenticated
  USING ("bucket_id" = 'catalog_assets' AND "public"."is_admin"());

-- ----------------------------------------------------------------- rpcs
-- Category management RPCs move from image_url to image_path (the client
-- uploads into catalog_assets first, then hands over the path). Old
-- signatures are dropped so the named-arg binding stays unambiguous.
DROP FUNCTION IF EXISTS "public"."create_category"(text, uuid, text);
CREATE OR REPLACE FUNCTION "public"."create_category"(
    p_name text,
    p_parent_id uuid DEFAULT NULL,
    p_image_path text DEFAULT NULL
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

  insert into public.categories (name, parent_id, image_path)
  values (p_name, p_parent_id, p_image_path)
  returning id into v_category_id;

  perform public.record_admin_audit(
    'create_category', 'category', v_category_id, jsonb_build_object('name', p_name));
  return v_category_id;
end;
$$;

DROP FUNCTION IF EXISTS "public"."rename_category"(uuid, text, text);
CREATE OR REPLACE FUNCTION "public"."rename_category"(
    p_category_id uuid,
    p_name text,
    p_image_path text DEFAULT NULL
) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can rename categories';
  end if;

  update public.categories
     set name = p_name,
         image_path = coalesce(p_image_path, image_path)
   where id = p_category_id;
  if not found then
    raise exception 'Category not found';
  end if;

  perform public.record_admin_audit(
    'rename_category', 'category', p_category_id, jsonb_build_object('name', p_name));
end;
$$;

-- ================= 20261013000002_cart_coupon_scope.sql =================
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

-- ================= 20261013000003_sales_report_extras.sql =================
-- Executive report extras (DESIGN.md §5.2.4): get_sales_report gains
-- additive keys — payment gateway distribution (KHQR vs COD), brand revenue
-- rankings, inventory capital valuation, and the net settled balance.
-- Existing keys are preserved verbatim.

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
    ), '[]'::jsonb),
    -- Payment gateway distribution (§5.2.4): realized orders only, split by
    -- the order's payment method row.
    'payment_split', coalesce((
      select jsonb_build_object(
        'qr_count', count(*) filter (where pm.method = 'qr'),
        'cod_count', count(*) filter (where pm.method = 'cod'),
        'qr_amount_minor', coalesce(sum(pm.amount_minor) filter (where pm.method = 'qr'), 0),
        'cod_amount_minor', coalesce(sum(pm.amount_minor) filter (where pm.method = 'cod'), 0)
      )
      from public.payments pm
      join public.orders o on o.id = pm.order_id
      where o.created_at >= p_from and o.created_at < p_to + 1
        and o.status not in ('cancelled', 'returned')
    ), jsonb_build_object(
      'qr_count', 0, 'cod_count', 0, 'qr_amount_minor', 0, 'cod_amount_minor', 0
    )),
    -- Brand revenue rankings (§5.2.4): realized order items joined to the
    -- catalog brand.
    'brand_revenue', coalesce((
      select jsonb_agg(jsonb_build_object('name', t.name, 'revenue_minor', t.revenue_minor))
      from (
        select coalesce(b.name, 'Unbranded') as name,
               sum(oi.line_total_minor) as revenue_minor
        from public.order_items oi
        join public.orders o on o.id = oi.order_id
        join public.products p on p.id = oi.product_id
        left join public.brands b on b.id = p.brand_id
        where o.created_at >= p_from and o.created_at < p_to + 1
          and o.status not in ('cancelled', 'returned')
        group by coalesce(b.name, 'Unbranded')
        order by revenue_minor desc
        limit 5
      ) t
    ), '[]'::jsonb),
    -- Inventory capital valuation (§5.2.4): active stock × base price.
    'inventory_valuation_minor', coalesce((
      select sum(p.stock * p.base_price_minor)
      from public.products p
      where p.status = 'active'
    ), 0),
    -- Net settled balance (§5.2.4): verified gateway settlements in range.
    'net_settled_minor', coalesce((
      select sum(pm.amount_minor)
      from public.payments pm
      join public.orders o on o.id = pm.order_id
      where o.created_at >= p_from and o.created_at < p_to + 1
        and pm.status = 'transaction_verified'
    ), 0)
  );
end;
$$;

-- ================= 20261013000004_admin_stock_adjust.sql =================
-- Admin inline stock adjustment (DESIGN.md §5.2.2): quick [- Stock +]
-- controls on the admin products list. Server-authoritative — the client
-- never writes stock directly; the products_stock_check constraint still
-- guards negatives.

CREATE OR REPLACE FUNCTION public.admin_adjust_product_stock(
    p_product_id uuid,
    p_new_stock integer
) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage products';
  end if;
  if p_new_stock < 0 then
    raise exception 'Stock cannot be negative';
  end if;

  update public.products
     set stock = p_new_stock,
         updated_at = now()
   where id = p_product_id;
  if not found then
    raise exception 'Product not found';
  end if;

  perform public.record_admin_audit(
    'adjust_product_stock', 'product', p_product_id,
    jsonb_build_object('stock', p_new_stock));
end;
$$;

-- ================= 20261013000005_product_ratings_view.sql =================
-- Card ratings (DESIGN.md §6.1) without PostgREST aggregate selects: this
-- backend's PostgREST does not support inline aggregates in the select
-- parameter (≥ v12, opt-in), so the aggregation lives in a plain SQL view.
-- PostgREST detects the products → product_ratings relationship through the
-- underlying reviews.product_id FK, making `product_ratings(rating_avg,
-- review_count)` an ordinary (cheap) embed. security_invoker keeps the view
-- under the reviews RLS (reviews_public_read), so no privilege widening.

CREATE OR REPLACE VIEW "public"."product_ratings"
WITH (security_invoker = true) AS
SELECT
    "r"."product_id",
    avg("r"."rating")::double precision AS "rating_avg",
    count(*)::integer AS "review_count"
FROM "public"."reviews" "r"
GROUP BY "r"."product_id";

GRANT SELECT ON "public"."product_ratings" TO anon, authenticated;

-- ================= backfill: demo imagery on existing rows =================
-- seed.sql is name-guarded (inserts only missing rows), so rows that already
-- existed before the imagery pipeline get their image_path here. Re-runnable.
update public.categories
   set image_path = v.image_path
  from (values
    ('Electronics', 'https://picsum.photos/seed/encuey-electronics/640/480'),
    ('Fashion', 'https://picsum.photos/seed/encuey-fashion/640/480'),
    ('Food & Beverages', 'https://picsum.photos/seed/encuey-food/640/480'),
    ('Home & Living', 'https://picsum.photos/seed/encuey-home/640/480'),
    ('Beauty', 'https://picsum.photos/seed/encuey-beauty/640/480'),
    ('Sports', 'https://picsum.photos/seed/encuey-sports/640/480')
  ) as v(name, image_path)
  where categories.name = v.name
    and categories.image_path is null;

update public.brands
   set image_path = v.image_path
  from (values
    ('Acme', 'https://picsum.photos/seed/encuey-acme/320/320'),
    ('Nordwind', 'https://picsum.photos/seed/encuey-nordwind/320/320'),
    ('Lumina', 'https://picsum.photos/seed/encuey-lumina/320/320'),
    ('Verde', 'https://picsum.photos/seed/encuey-verde/320/320')
  ) as v(name, image_path)
  where brands.name = v.name
    and brands.image_path is null;

-- ================= 20261013000006_drop_deprecated_image_url.sql =================

-- Drops the deprecated brands/categories image_url columns (DESIGN.md
-- imagery pipeline, migration 20261013000001). The columns were created by
-- the M3 schema evolution (20261008000003) mirroring the "store the full
-- URL" idea, but nothing ever wrote or read them — the imagery pipeline
-- uses image_path (bare storage path or http passthrough, resolved at the
-- repository boundary). Safe: zero data (always NULL), zero consumers.

ALTER TABLE "public"."brands" DROP COLUMN IF EXISTS "image_url";
ALTER TABLE "public"."categories" DROP COLUMN IF EXISTS "image_url";

-- ================= 20261013000007_prototype_business.sql =================

-- 2-Role prototype: the product form no longer asks for a store
-- (DESIGN.md §1.1 — "Catalog ownership is retained under the hood
-- (products.business_id pointing to a seeded prototype business), but the
-- customer experiences a unified store without vendor fragmentation").
--
-- admin_create_product makes p_business_id optional: when omitted it
-- resolves the singleton active prototype business, provisioning it owned
-- by the calling admin on first use. Explicit ids still validate as before,
-- so the multi-vendor data model stays intact for future re-enablement.

CREATE OR REPLACE FUNCTION public.admin_create_product(
    p_business_id uuid DEFAULT NULL,
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
  v_business_id uuid := p_business_id;
  v_variant record;
  v_variant_count integer;
begin
  if not public.is_admin() then
    raise exception 'Only admins can create products';
  end if;

  if v_business_id is null then
    -- Resolve the singleton prototype business; provision it on first use
    -- (the seed cannot: businesses.owner_id references an auth user).
    select id into v_business_id
      from public.businesses
     where status = 'active'
     order by created_at
     limit 1;
    if v_business_id is null then
      insert into public.businesses (owner_id, name, description, status)
      values (
        auth.uid(),
        'EncueYPay Prototype Store',
        'Auto-provisioned prototype catalog owner (2-role simplification).',
        'active'
      )
      returning id into v_business_id;
    end if;
  elsif not exists (
    select 1 from public.businesses where id = v_business_id
  ) then
    raise exception 'Business not found';
  end if;

  insert into public.products
    (business_id, category_id, name, description, base_price_minor, brand_id, stock)
  values
    (v_business_id, p_category_id, p_name, p_description, p_base_price_minor, p_brand_id, p_stock)
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

-- ================= 20261013000008_single_seller_retirement.sql =================

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
