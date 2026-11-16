-- Coupon verdict payload test (migration 20261117000004).
--   bash supabase/testing/run_migrations.sh
--   psql -h /tmp -p 55432 -U postgres -d encueypay_test \
--     -v ON_ERROR_STOP=1 -f supabase/testing/coupon_validation_test.sql
--
-- Guards the regression where the checkout tile said "No minimum spend" for a
-- coupon that has one: validate_coupon had been slimmed to
-- {valid, message, discount_minor}, so every structured field read as 0/null.

insert into auth.users (id, email, raw_user_meta_data) values
  ('11111111-2222-3333-4444-555555555555', 'couponcust@test.dev',
   '{"full_name":"Coupon Customer"}'),
  ('11111111-2222-3333-4444-666666666666', 'couponadm@test.dev',
   '{"full_name":"Coupon Admin"}');
update public.users set active_role = 'admin'
 where id = '11111111-2222-3333-4444-666666666666';

insert into public.categories (id, name)
values ('22222222-3333-4444-5555-666666666666', 'Coupon Cat');

insert into public.products (id, category_id, name, base_price_minor, stock)
values ('33333333-4444-5555-6666-777777777777',
        '22222222-3333-4444-5555-666666666666', 'Coupon Product', 1000, 10);

insert into public.product_variants (id, product_id, name, price_minor, status)
values ('44444444-5555-6666-7777-888888888888',
        '33333333-4444-5555-6666-777777777777', 'Default', 1000, 'active');

insert into public.carts (id, user_id)
values ('55555555-6666-7777-8888-999999999999',
        '11111111-2222-3333-4444-555555555555');

insert into public.cart_items (id, cart_id, product_variant_id, quantity)
values ('66666666-7777-8888-9999-aaaaaaaaaaaa',
        '55555555-6666-7777-8888-999999999999',
        '44444444-5555-6666-7777-888888888888', 2);  -- 2 × 1000 = 2000

-- $25 minimum against a $20 cart, so the verdict is a structured rejection
-- that still has to carry the configured minimum.
insert into public.coupons (id, code, name, discount_type, discount_value,
                            min_order_amount_minor, active)
values ('77777777-8888-9999-aaaa-bbbbbbbbbbbb', 'XXXYYY', 'Twenty Five Off',
        'fixed', 500, 2500, true);

set request.jwt.claims to '{"sub":"11111111-2222-3333-4444-555555555555"}';

-- ------------------------------------------------- rejected but configured
DO $$
declare
  v jsonb := public.validate_coupon('xxxyyy');
begin
  assert (v ->> 'valid')::boolean = false,
    'a $20 cart must not satisfy a $25 minimum';
  assert v ->> 'reason' = 'min_order_not_met', 'structured reason: ' || (v ->> 'reason');
  assert (v ->> 'min_order_amount_minor')::bigint = 2500,
    'the configured minimum must survive the verdict, got '
    || coalesce(v ->> 'min_order_amount_minor', '<null>');
  assert (v ->> 'subtotal_minor')::bigint = 2000,
    'the subtotal the client formats comes from the verdict, got '
    || coalesce(v ->> 'subtotal_minor', '<null>');
  assert v ->> 'name' = 'Twenty Five Off', 'name is part of the payload';
  assert v ->> 'discount_type' = 'fixed', 'discount_type is part of the payload';
  assert (v ->> 'discount_value')::bigint = 500, 'discount_value is the offer';
  assert v ->> 'code' = 'XXXYYY', 'code is echoed back';
end $$;

-- ------------------------------------------------------- valid, selected
DO $$
declare
  v jsonb := public.validate_coupon(
    'XXXYYY',
    array['66666666-7777-8888-9999-aaaaaaaaaaaa']::uuid[]);
begin
  assert (v ->> 'min_order_amount_minor')::bigint = 2500,
    'minimum still reported when the coupon is valid';
end $$;

-- An empty selection prices the whole cart.
update public.cart_items set quantity = 3
 where id = '66666666-7777-8888-9999-aaaaaaaaaaaa';

DO $$
declare
  v jsonb := public.validate_coupon('XXXYYY', array[]::uuid[]);
begin
  assert (v ->> 'subtotal_minor')::bigint = 3000,
    'an empty selection prices the whole cart, got '
    || coalesce(v ->> 'subtotal_minor', '<null>');
end $$;

\echo '=== COUPON VALIDATION PAYLOAD VERIFIED ==='
