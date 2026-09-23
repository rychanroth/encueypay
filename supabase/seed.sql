-- Demo/dev seed data (idempotent). Auth users cannot be seeded via plain
-- SQL reliably — create test users in the Supabase dashboard
-- (Authentication → Users) and seed roles in `users` directly if needed.
-- Categories are safe to seed unconditionally.

insert into public.categories (name) values
  ('Electronics'),
  ('Fashion'),
  ('Food & Beverages'),
  ('Home & Living'),
  ('Beauty'),
  ('Sports')
on conflict do nothing;
