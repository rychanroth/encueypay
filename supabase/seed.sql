-- Demo/dev seed data (idempotent). Auth users cannot be seeded via plain
-- SQL reliably — create test users in the Supabase dashboard
-- (Authentication → Users) and seed roles in `users` directly if needed.
-- Categories are guarded by name so re-running never duplicates.

-- Categories carry demo imagery via the catalog_assets convention
-- (DESIGN.md imagery pipeline): image_path may be a bare storage path or a
-- full http(s) URL — the client passes URLs through, bare paths resolve
-- against the public bucket. Placeholder URLs keep the demo catalog
-- presentable; the client's monogram fallback covers offline runs.
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

-- Brands (Section 2b): the admin populates these through the Products tab;
-- this seed gives the demo catalog a starting set. Guarded by name.
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

-- Prototype store + admin (Sections 2b/3; pivot map §9 — manual steps).
-- Businesses require an auth user as owner and auth users cannot be seeded
-- via plain SQL — create two users in the dashboard (Authentication →
-- Users), then run these in the SQL editor:
--
--   -- the store owner (any role; its portal is bypassed in the prototype)
--   insert into public.businesses (owner_id, name, description, status)
--     select id, 'Prototype Store', '2-role prototype catalog', 'active'
--     from public.users u join auth.users a on a.id = u.id
--     where a.email = '<store-owner-email>';
--
--   -- the administrator (living spec Part A.2)
--   update public.users set active_role = 'admin'
--     where id in (select id from auth.users where email = '<admin-email>');
