-- Demo/dev seed data (idempotent). Auth users cannot be seeded via plain
-- SQL reliably — create test users in the Supabase dashboard
-- (Authentication → Users) and seed roles in `users` directly if needed.
-- Categories are guarded by name so re-running never duplicates.

insert into public.categories (name)
select c.name
from (values
  ('Electronics'),
  ('Fashion'),
  ('Food & Beverages'),
  ('Home & Living'),
  ('Beauty'),
  ('Sports')
) as c(name)
where not exists (
  select 1 from public.categories existing where existing.name = c.name
);
