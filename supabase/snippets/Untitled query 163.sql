-- Demo imagery refresh — hosted project (run once in the Supabase SQL editor).
--
-- picsum.photos stopped answering over HTTPS, so every seeded product,
-- category and brand image hung the loader. Point those rows at
-- placehold.co PNGs instead (the `.png` matters: Flutter's Image.network
-- cannot render placehold.co's default SVG).
--
-- Idempotent: every UPDATE is keyed on the old picsum URL, so a second run
-- touches nothing. Admin-uploaded rows (catalog_assets / product_images
-- buckets) and approved banners (promo_assets) are left untouched.

begin;

-- ---------------------------------------------------------------- brands
update public.brands b
   set image_path = v.new_path,
       updated_at = now()
  from (values
    ('Acme',     'https://picsum.photos/seed/encuey-acme/320/320',     'https://placehold.co/320x320/png?text=Acme'),
    ('Nordwind', 'https://picsum.photos/seed/encuey-nordwind/320/320', 'https://placehold.co/320x320/png?text=Nordwind'),
    ('Lumina',   'https://picsum.photos/seed/encuey-lumina/320/320',   'https://placehold.co/320x320/png?text=Lumina'),
    ('Verde',    'https://picsum.photos/seed/encuey-verde/320/320',    'https://placehold.co/320x320/png?text=Verde')
  ) as v(name, old_path, new_path)
 where b.name = v.name
   and b.image_path = v.old_path;

-- ------------------------------------------------------------ categories
update public.categories c
   set image_path = v.new_path
  from (values
    ('Electronics',      'https://picsum.photos/seed/encuey-electronics/640/480', 'https://placehold.co/640x480/png?text=Electronics'),
    ('Fashion',          'https://picsum.photos/seed/encuey-fashion/640/480',     'https://placehold.co/640x480/png?text=Fashion'),
    ('Food & Beverages', 'https://picsum.photos/seed/encuey-food/640/480',        'https://placehold.co/640x480/png?text=Food+%26+Beverages'),
    ('Home & Living',    'https://picsum.photos/seed/encuey-home/640/480',        'https://placehold.co/640x480/png?text=Home+%26+Living'),
    ('Beauty',           'https://picsum.photos/seed/encuey-beauty/640/480',      'https://placehold.co/640x480/png?text=Beauty'),
    ('Sports',           'https://picsum.photos/seed/encuey-sports/640/480',      'https://placehold.co/640x480/png?text=Sports')
  ) as v(name, old_path, new_path)
 where c.name = v.name
   and c.image_path = v.old_path;

-- --------------------------------------------------------- product images
update public.product_images pi
   set storage_path = v.new_path
  from (values
    ('Lumina Aurora Table Lamp',    'https://picsum.photos/seed/encuey-p-aurora-1/800/800',   'https://placehold.co/800x800/png?text=Aurora+Lamp+1'),
    ('Lumina Aurora Table Lamp',    'https://picsum.photos/seed/encuey-p-aurora-2/800/800',   'https://placehold.co/800x800/png?text=Aurora+Lamp+2'),
    ('Nordwind Trail Backpack 30L', 'https://picsum.photos/seed/encuey-p-backpack-1/800/800', 'https://placehold.co/800x800/png?text=Trail+Backpack+1'),
    ('Nordwind Trail Backpack 30L', 'https://picsum.photos/seed/encuey-p-backpack-2/800/800', 'https://placehold.co/800x800/png?text=Trail+Backpack+2'),
    ('Acme Ceramic Mug Set',        'https://picsum.photos/seed/encuey-p-mug-1/800/800',      'https://placehold.co/800x800/png?text=Mug+Set+1'),
    ('Acme Ceramic Mug Set',        'https://picsum.photos/seed/encuey-p-mug-2/800/800',      'https://placehold.co/800x800/png?text=Mug+Set+2'),
    ('Lumina Pulse Phone',          'https://picsum.photos/seed/encuey-p-phone-1/800/800',    'https://placehold.co/800x800/png?text=Pulse+Phone+1'),
    ('Lumina Pulse Phone',          'https://picsum.photos/seed/encuey-p-phone-2/800/800',    'https://placehold.co/800x800/png?text=Pulse+Phone+2'),
    ('Nordwind Merino Beanie',      'https://picsum.photos/seed/encuey-p-beanie-1/800/800',   'https://placehold.co/800x800/png?text=Merino+Beanie+1'),
    ('Nordwind Merino Beanie',      'https://picsum.photos/seed/encuey-p-beanie-2/800/800',   'https://placehold.co/800x800/png?text=Merino+Beanie+2'),
    ('Verde Glow Serum',            'https://picsum.photos/seed/encuey-p-serum-1/800/800',    'https://placehold.co/800x800/png?text=Glow+Serum+1'),
    ('Verde Glow Serum',            'https://picsum.photos/seed/encuey-p-serum-2/800/800',    'https://placehold.co/800x800/png?text=Glow+Serum+2'),
    ('Acme Trail Water Bottle',     'https://picsum.photos/seed/encuey-p-bottle-1/800/800',   'https://placehold.co/800x800/png?text=Water+Bottle+1'),
    ('Acme Trail Water Bottle',     'https://picsum.photos/seed/encuey-p-bottle-2/800/800',   'https://placehold.co/800x800/png?text=Water+Bottle+2'),
    ('Lumina Flux Laptop 14',       'https://picsum.photos/seed/encuey-p-laptop-1/800/800',   'https://placehold.co/800x800/png?text=Flux+Laptop+1'),
    ('Lumina Flux Laptop 14',       'https://picsum.photos/seed/encuey-p-laptop-2/800/800',   'https://placehold.co/800x800/png?text=Flux+Laptop+2')
  ) as v(product_name, old_path, new_path),
       public.products p
 where p.name = v.product_name
   and pi.product_id = p.id
   and pi.storage_path = v.old_path;

commit;

-- Sanity check: every count should be 0.
select
  (select count(*) from public.brands         where image_path   like 'https://picsum%') as brand_picsum_rows,
  (select count(*) from public.categories     where image_path   like 'https://picsum%') as category_picsum_rows,
  (select count(*) from public.product_images where storage_path like 'https://picsum%') as product_image_picsum_rows;

-- Kept from this file's previous scratch statement (not run):
-- update users set active_role = 'admin' where id = '4e203494-bec4-4f09-8277-b16e4573c847';
