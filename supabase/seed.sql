-- Demo/dev seed data (idempotent), aligned with the single-seller schema
-- (migrations 0001–0009). Auth users cannot be seeded via plain SQL —
-- create test users in the Supabase dashboard (Authentication → Users) and
-- seed roles in `users` directly if needed. Banners and promotions are
-- likewise authored in-app (created_by references auth users).
--
-- The vendor model is retired (0008): products no longer belong to a
-- business, so the seed ships a complete demo catalog — categories
-- (2-level taxonomy, §2c), brands, products with variants and imagery, and
-- the platform settings row the checkout/QR flow reads.

-- ------------------------------------------------------------- categories
-- Parents first; children reference them by name (guarded by name so
-- re-running never duplicates).
insert into public.categories (name, image_path)
select c.name, c.image_path
from (values
  ('Electronics', 'https://picsum.photos/seed/encuey-electronics/640/480'),
  ('Fashion', 'https://picsum.photos/seed/encuey-fashion/640/480'),
  ('Food & Beverages', 'https://picsum.photos/seed/encuey-food/640/480'),
  ('Home & Living', 'https://picsum.photos/seed/encuey-home/640/480'),
  ('Beauty', 'https://picsum.photos/seed/encuey-beauty/640/480'),
  ('Sports', 'https://picsum.photos/seed/encuey-sports/640/480')
) as c(name, image_path)
where not exists (
  select 1 from public.categories existing where existing.name = c.name
);

-- Subcategories (Section 2c): Discovery on the parent aggregates their
-- products automatically.
insert into public.categories (name, parent_id)
select c.name, p.id
from (values
  ('Phones', 'Electronics'),
  ('Laptops', 'Electronics')
) as c(name, parent_name)
join public.categories p on p.name = c.parent_name
where not exists (
  select 1 from public.categories existing where existing.name = c.name
);

-- ----------------------------------------------------------------- brands
insert into public.brands (name, description, image_path)
select b.name, b.description, b.image_path
from (values
  ('Acme', 'Reliable everyday essentials.', 'https://picsum.photos/seed/encuey-acme/320/320'),
  ('Nordwind', 'Outdoor and adventure gear.', 'https://picsum.photos/seed/encuey-nordwind/320/320'),
  ('Lumina', 'Modern lighting and electronics.', 'https://picsum.photos/seed/encuey-lumina/320/320'),
  ('Verde', 'Natural beauty and wellness.', 'https://picsum.photos/seed/encuey-verde/320/320')
) as b(name, description, image_path)
where not exists (
  select 1 from public.brands existing where existing.name = b.name
);

-- --------------------------------------------------------------- products
-- base_price_minor is integer minor units (spec §22: never floats).
-- Curated demo states: two low-stock items (≤5 → Critical Stock Alert),
-- one out-of-stock item (Unavailable badge + Out of Stock filter), and
-- child-category items (aggregate under Electronics via §2c).
insert into public.products (category_id, brand_id, name, description, base_price_minor, stock)
select cat.id, b.id, v.name, v.description, v.base_price_minor, v.stock
from (values
  ('Lumina Aurora Table Lamp', 'Home & Living', 'Lumina',
   'Warm-dimming table lamp with a brushed-steel stem and linen shade.',
   4500, 12),
  ('Nordwind Trail Backpack 30L', 'Sports', 'Nordwind',
   'Weatherproof 30L daypack with a padded laptop sleeve and hip belt.',
   5999, 7),
  ('Acme Ceramic Mug Set', 'Home & Living', 'Acme',
   'Set of four stoneware mugs, dishwasher and microwave safe.',
   1850, 30),
  ('Lumina Pulse Phone', 'Phones', 'Lumina',
   'Compact 6.1" OLED phone with three years of security updates.',
   32900, 5),
  ('Nordwind Merino Beanie', 'Fashion', 'Nordwind',
   'Double-layer merino beanie, itch-free and machine washable.',
   2400, 18),
  ('Verde Glow Serum', 'Beauty', 'Verde',
   'Vitamin-C brightening serum with hyaluronic acid, 30 ml.',
   3275, 3),
  ('Acme Trail Water Bottle', 'Sports', 'Acme',
   'Insulated 750 ml steel bottle, 24 h cold / 12 h hot.',
   1225, 0),
  ('Lumina Flux Laptop 14', 'Laptops', 'Lumina',
   '14" aluminium ultrabook — 16 GB RAM, 512 GB NVMe, 1.2 kg.',
   89900, 6)
) as v(name, category_name, brand_name, description, base_price_minor, stock)
join public.categories cat on cat.name = v.category_name
left join public.brands b on b.name = v.brand_name
where not exists (
  select 1 from public.products existing where existing.name = v.name
);

-- --------------------------------------------------------------- variants
-- Every product gets the auto-'Default' variant (null price tracks the
-- base price — a variant-less product is un-buyable, map §10.3).
insert into public.product_variants (product_id, name, attributes)
select p.id, 'Default', '{}'::jsonb
from public.products p
where not exists (
  select 1 from public.product_variants pv
   where pv.product_id = p.id and pv.name = 'Default'
);

-- A few priced variants to exercise the variant picker and the server rule
-- coalesce(variant.price, product.base_price) (§1.2).
insert into public.product_variants (product_id, name, price_minor, attributes)
select p.id, v.name, v.price_minor, v.attributes::jsonb
from (values
  ('Nordwind Trail Backpack 30L', 'Olive', 6499, '{"color": "Olive"}'),
  ('Nordwind Trail Backpack 30L', 'Sand', 5999, '{"color": "Sand"}'),
  ('Lumina Pulse Phone', 'Midnight', 32900, '{"color": "Midnight"}'),
  ('Lumina Pulse Phone', 'Glacier', 34900, '{"color": "Glacier"}'),
  ('Nordwind Merino Beanie', 'Rust', 2600, '{"color": "Rust"}')
) as v(product_name, name, price_minor, attributes)
join public.products p on p.name = v.product_name
where not exists (
  select 1 from public.product_variants pv
   where pv.product_id = p.id and pv.name = v.name
);

-- ----------------------------------------------------------------- images
-- storage_path may be a bare catalog path or a full http(s) URL (the
-- repository passes URLs through — same convention as banners and
-- catalog_assets). Placeholder URLs keep the demo presentable; the client's
-- monogram fallback covers offline runs.
insert into public.product_images (product_id, storage_path, sort_order)
select p.id, v.storage_path, v.sort_order
from (values
  ('Lumina Aurora Table Lamp', 'https://picsum.photos/seed/encuey-p-aurora-1/800/800', 0),
  ('Lumina Aurora Table Lamp', 'https://picsum.photos/seed/encuey-p-aurora-2/800/800', 1),
  ('Nordwind Trail Backpack 30L', 'https://picsum.photos/seed/encuey-p-backpack-1/800/800', 0),
  ('Nordwind Trail Backpack 30L', 'https://picsum.photos/seed/encuey-p-backpack-2/800/800', 1),
  ('Acme Ceramic Mug Set', 'https://picsum.photos/seed/encuey-p-mug-1/800/800', 0),
  ('Acme Ceramic Mug Set', 'https://picsum.photos/seed/encuey-p-mug-2/800/800', 1),
  ('Lumina Pulse Phone', 'https://picsum.photos/seed/encuey-p-phone-1/800/800', 0),
  ('Lumina Pulse Phone', 'https://picsum.photos/seed/encuey-p-phone-2/800/800', 1),
  ('Nordwind Merino Beanie', 'https://picsum.photos/seed/encuey-p-beanie-1/800/800', 0),
  ('Nordwind Merino Beanie', 'https://picsum.photos/seed/encuey-p-beanie-2/800/800', 1),
  ('Verde Glow Serum', 'https://picsum.photos/seed/encuey-p-serum-1/800/800', 0),
  ('Verde Glow Serum', 'https://picsum.photos/seed/encuey-p-serum-2/800/800', 1),
  ('Acme Trail Water Bottle', 'https://picsum.photos/seed/encuey-p-bottle-1/800/800', 0),
  ('Acme Trail Water Bottle', 'https://picsum.photos/seed/encuey-p-bottle-2/800/800', 1),
  ('Lumina Flux Laptop 14', 'https://picsum.photos/seed/encuey-p-laptop-1/800/800', 0),
  ('Lumina Flux Laptop 14', 'https://picsum.photos/seed/encuey-p-laptop-2/800/800', 1)
) as v(product_name, storage_path, sort_order)
join public.products p on p.name = v.product_name
where not exists (
  select 1 from public.product_images pi
   where pi.product_id = p.id and pi.storage_path = v.storage_path
);

-- ------------------------------------------------------ platform settings
-- The checkout reads the delivery fee here; the QR flow reads the demo
-- Bakong account id (any placeholder settles via simulate_qr_payment).
insert into public.platform_settings
  (id, delivery_fee_minor, platform_commission_percent, payment_account, qr_account_id)
values (1, 250, 0, 'demo-payment-desk', '000216394701253')
on conflict (id) do nothing;

-- NOT seeded (require auth users — create them in the dashboard):
--   * banners            → created_by references users
--   * promotions/coupons → created_by references users (demo coupons are
--     authored in the admin Promotions screen after signing in)
