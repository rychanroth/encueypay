-- Archive-state regression test (migration 20261117000003).
-- Run on a fresh scratch DB after the migration replay:
--   bash supabase/testing/run_migrations.sh
--   psql -h /tmp -p 55432 -U postgres -d encueypay_test \
--     -v ON_ERROR_STOP=1 -f supabase/testing/promotion_archive_test.sql
--
-- Proves the distinction the admin UI now relies on: disabling is a status
-- that keeps the row listed; only the archive action retires it.

insert into auth.users (id, email, raw_user_meta_data) values
  ('eeeeeeee-0000-0000-0000-000000000001', 'archadm@test.dev',
   '{"full_name":"Archive Admin"}');
update public.users set active_role = 'admin'
 where id = 'eeeeeeee-0000-0000-0000-000000000001';

insert into public.sales (id, created_by, scope, name, discount_type,
                          discount_value, active)
values ('ffffffff-0000-0000-0000-000000000001',
        'eeeeeeee-0000-0000-0000-000000000001', 'platform', 'Archive Sale',
        'percent', 10, true);

insert into public.coupons (id, code, name, discount_type, discount_value,
                            active)
values ('ffffffff-0000-0000-0000-000000000002', 'ARCH10', 'Archive Code',
        'percent', 10, true);

set request.jwt.claims to '{"sub":"eeeeeeee-0000-0000-0000-000000000001"}';

-- ------------------------------------------------- disable != archive
DO $$ BEGIN
  perform public.admin_set_sale_active(
    'ffffffff-0000-0000-0000-000000000001', false);

  assert (select active from public.sales
           where id = 'ffffffff-0000-0000-0000-000000000001') = false,
    'kill switch clears active';
  assert (select archived_at from public.sales
           where id = 'ffffffff-0000-0000-0000-000000000001') is null,
    'disabling a sale must not archive it';

  -- A disabled sale still prices nothing.
  assert not exists (select 1 from public.active_sales
                      where id = 'ffffffff-0000-0000-0000-000000000001'),
    'a disabled sale is not live';
END $$;

-- ------------------------------------------------- archive + restore
DO $$ BEGIN
  perform public.admin_set_sale_archived(
    'ffffffff-0000-0000-0000-000000000001', true);

  assert (select archived_at from public.sales
           where id = 'ffffffff-0000-0000-0000-000000000001') is not null,
    'archive action stamps archived_at';
  assert (select active from public.sales
           where id = 'ffffffff-0000-0000-0000-000000000001') = false,
    'archiving also switches the sale off';

  -- An archived sale refuses the kill switch (restore first).
  begin
    perform public.admin_set_sale_active(
      'ffffffff-0000-0000-0000-000000000001', true);
    raise exception 'archived sale accepted a status toggle!';
  exception when others then
    if sqlerrm not like '%archived%' then raise; end if;
  end;

  perform public.admin_set_sale_archived(
    'ffffffff-0000-0000-0000-000000000001', false);

  assert (select archived_at from public.sales
           where id = 'ffffffff-0000-0000-0000-000000000001') is null,
    'restore clears archived_at';
  assert (select active from public.sales
           where id = 'ffffffff-0000-0000-0000-000000000001') = false,
    'restore returns the sale as disabled, not live';

  perform public.admin_set_sale_active(
    'ffffffff-0000-0000-0000-000000000001', true);
  assert exists (select 1 from public.active_sales
                  where id = 'ffffffff-0000-0000-0000-000000000001'),
    'a restored, re-enabled sale prices again';
END $$;

-- ------------------------------------------------------- coupons
DO $$ BEGIN
  perform public.set_coupon_active(
    'ffffffff-0000-0000-0000-000000000002', false);

  assert (select archived_at from public.coupons
           where id = 'ffffffff-0000-0000-0000-000000000002') is null,
    'disabling a coupon must not archive it';

  perform public.admin_set_coupon_archived(
    'ffffffff-0000-0000-0000-000000000002', true);

  assert (select archived_at from public.coupons
           where id = 'ffffffff-0000-0000-0000-000000000002') is not null,
    'archive action stamps archived_at';
  assert (select active from public.coupons
           where id = 'ffffffff-0000-0000-0000-000000000002') = false,
    'archiving also switches the code off';

  perform public.admin_set_coupon_archived(
    'ffffffff-0000-0000-0000-000000000002', false);
  perform public.set_coupon_active(
    'ffffffff-0000-0000-0000-000000000002', true);

  assert (select active from public.coupons
           where id = 'ffffffff-0000-0000-0000-000000000002') = true,
    'a restored code can be switched back on';
END $$;

\echo '=== PROMOTION ARCHIVE STATE VERIFIED ==='
