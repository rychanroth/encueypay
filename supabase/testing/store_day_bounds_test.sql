-- Store-local day bounds regression test (migration 20261117000001).
--
-- The admin/customer date filters take a bare `date` (the device-local
-- calendar day). They must resolve it as the *store's* day (UTC+07), never as
-- the database session's day — hosted Supabase runs UTC, and that mismatch
-- emptied the admin "Today" filter for everything ordered before 07:00 local.
--
-- Run on a fresh scratch database, with the session pinned to UTC:
--   bash supabase/testing/run_migrations.sh
--   psql -h /tmp -p 55432 -U postgres -d encueypay_test \
--     -v ON_ERROR_STOP=1 -f supabase/testing/store_day_bounds_test.sql

set timezone to 'UTC';

insert into auth.users (id, email, raw_user_meta_data) values
  ('aaaaaaaa-0000-0000-0000-000000000001', 'tzcust@test.dev',
   '{"full_name":"TZ Customer"}'),
  ('aaaaaaaa-0000-0000-0000-000000000002', 'tzadmin@test.dev',
   '{"full_name":"TZ Admin"}');
update public.users set active_role = 'admin'
 where id = 'aaaaaaaa-0000-0000-0000-000000000002';

insert into public.categories (id, name)
values ('bbbbbbbb-0000-0000-0000-000000000001', 'TZ Cat');

-- 2025-06-09 18:00Z = 2025-06-10 01:00 store time; 16:30Z = 23:30 store time.
insert into public.products (id, category_id, name, base_price_minor, created_at)
values
  ('cccccccc-0000-0000-0000-000000000001',
   'bbbbbbbb-0000-0000-0000-000000000001', 'Early product', 100,
   timestamptz '2025-06-09 18:00:00+00'),
  ('cccccccc-0000-0000-0000-000000000002',
   'bbbbbbbb-0000-0000-0000-000000000001', 'Late product', 100,
   timestamptz '2025-06-09 16:30:00+00');

insert into public.orders
  (id, customer_id, shipping_recipient_name, shipping_line1, shipping_city,
   subtotal_minor, total_minor, created_at, status)
values
  ('dddddddd-0000-0000-0000-000000000001',
   'aaaaaaaa-0000-0000-0000-000000000001', 'A', 'L', 'C', 1000, 1000,
   timestamptz '2025-06-09 18:00:00+00', 'pending'),
  ('dddddddd-0000-0000-0000-000000000002',
   'aaaaaaaa-0000-0000-0000-000000000001', 'A', 'L', 'C', 1000, 1000,
   timestamptz '2025-06-09 16:30:00+00', 'pending'),
  -- 01:00 store time today, delivered so the realized-only 14-day dashboard
  -- trend sees it.
  ('dddddddd-0000-0000-0000-000000000003',
   'aaaaaaaa-0000-0000-0000-000000000001', 'A', 'L', 'C', 1000, 1000,
   public.store_day_start((now() at time zone public.store_timezone())::date)
     + interval '1 hour', 'delivered');

-- ------------------------------------------------------------ day bounds
DO $$ BEGIN
  assert public.store_day_start('2026-11-17'::date)
         = timestamptz '2026-11-16 17:00:00+00',
    'store day starts at local midnight (+07) under a UTC session';
  assert public.store_day_start('2026-11-18'::date)
         = timestamptz '2026-11-17 17:00:00+00',
    'store day end is the next local midnight';
  assert public.store_day_start(null::date) is null,
    'an absent filter stays unbounded';
END $$;

-- --------------------------------------------------------- admin orders
set request.jwt.claims to '{"sub":"aaaaaaaa-0000-0000-0000-000000000002"}';

DO $$
declare
  v_ids text[];
begin
  select array_agg(o ->> 'id')
    into v_ids
    from jsonb_array_elements(
           public.admin_search_orders(
             p_from => '2025-06-10'::date, p_to => '2025-06-10'::date)
             -> 'orders') o;

  assert 'dddddddd-0000-0000-0000-000000000001' = any(v_ids),
    'order at 01:00 store time belongs to that store day';
  assert not ('dddddddd-0000-0000-0000-000000000002' = any(v_ids)),
    'order at 23:30 the evening before does not';
end $$;

-- ------------------------------------------------------- admin products
DO $$
declare
  v_ids text[];
begin
  select array_agg(p ->> 'id')
    into v_ids
    from jsonb_array_elements(
           public.admin_search_products(
             p_from => '2025-06-10'::date, p_to => '2025-06-10'::date)
             -> 'products') p;

  assert 'cccccccc-0000-0000-0000-000000000001' = any(v_ids),
    'product created 01:00 store time belongs to that store day';
  assert not ('cccccccc-0000-0000-0000-000000000002' = any(v_ids)),
    'product created 23:30 the evening before does not';
end $$;

-- -------------------------------------------------------- sales report
DO $$
declare
  v_report jsonb := public.get_sales_report('2025-06-10', '2025-06-10');
begin
  assert (v_report ->> 'total_orders')::int = 1,
    'the report window counts the same store-local day, got '
    || (v_report ->> 'total_orders');
end $$;

-- ------------------------------------------------------ dashboard trend
DO $$
declare
  v_day text := (now() at time zone public.store_timezone())::date::text;
  v_days text[];
begin
  select array_agg(t ->> 'day')
    into v_days
    from jsonb_array_elements(public.get_admin_kpis() -> 'sales_trend') t;

  assert v_day = any(v_days),
    'trend bars bucket on the store day (' || v_day || '), got '
    || coalesce(array_to_string(v_days, ','), '<none>');
end $$;

-- ----------------------------------------------------- customer history
set request.jwt.claims to '{"sub":"aaaaaaaa-0000-0000-0000-000000000001"}';

DO $$
declare
  v_ids text[];
begin
  select array_agg(o ->> 'id')
    into v_ids
    from jsonb_array_elements(
           public.customer_search_orders(
             p_from => '2025-06-10'::date, p_to => '2025-06-10'::date)) o;

  assert 'dddddddd-0000-0000-0000-000000000001' = any(v_ids),
    'customer history uses the same store day';
  assert not ('dddddddd-0000-0000-0000-000000000002' = any(v_ids)),
    'customer history excludes the previous store day';
end $$;

\echo '=== STORE DAY BOUNDS VERIFIED ==='
