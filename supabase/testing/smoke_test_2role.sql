-- 2-role bridge smoke test — exercises pivot map §4 chokepoints end-to-end.
-- Run: psql "postgresql://postgres:postgres@127.0.0.1:54322/postgres" -v ON_ERROR_STOP=1 -f /tmp/smoke_2role.sql

\set ON_ERROR_STOP on

-- helper: assert two text values equal
create or replace function pg_temp.assert_eq(actual text, expected text, label text) returns text
language plpgsql as $$
begin
  if actual is distinct from expected then
    raise exception 'SMOKE FAIL [%]: expected %, got %', label, expected, actual;
  end if;
  raise notice 'ok - %', label;
  return actual;
end $$;


-- ================================================================== fixtures
insert into auth.users (id, aud, role, email, encrypted_password, email_confirmed_at, raw_user_meta_data, created_at, updated_at)
values
  ('11111111-1111-1111-1111-111111111111', 'authenticated', 'authenticated', 'cust@smoke.test', crypt('secret123', gen_random_uuid()::text), now(), '{"full_name":"Smoke Customer"}'::jsonb, now(), now()),
  ('22222222-2222-2222-2222-222222222222', 'authenticated', 'authenticated', 'adm@smoke.test',  crypt('secret123', gen_random_uuid()::text), now(), '{"full_name":"Smoke Admin"}'::jsonb,    now(), now()),
  ('33333333-3333-3333-3333-333333333333', 'authenticated', 'authenticated', 'own@smoke.test',  crypt('secret123', gen_random_uuid()::text), now(), '{"full_name":"Store Owner"}'::jsonb,   now(), now());

-- signup trigger created profile rows
select pg_temp.assert_eq((select count(*) from public.users where id in ('11111111-1111-1111-1111-111111111111','22222222-2222-2222-2222-222222222222','33333333-3333-3333-3333-333333333333'))::text, '3', 'handle_new_user fired');
select pg_temp.assert_eq((select full_name from public.users where id='11111111-1111-1111-1111-111111111111'), 'Smoke Customer', 'profile metadata captured');

-- static promotion (SQL-editor path; auth.uid() is null here → allowed)
update public.users set active_role = 'admin' where id = '22222222-2222-2222-2222-222222222222';

insert into public.businesses (owner_id, name, status)
values ('33333333-3333-3333-3333-333333333333', 'Smoke Store', 'active');

-- ======================================================== admin: catalog
BEGIN;
SET LOCAL role authenticated;
SET LOCAL request.jwt.claims = '{"sub":"22222222-2222-2222-2222-222222222222","role":"authenticated"}';

select pg_temp.assert_eq((select public.is_admin()::text), 'true', 'admin role recognized');

insert into public.brands (name) values ('Smoke Brand');
select pg_temp.assert_eq((select count(*) from public.brands)::text, '1', 'admin inserts brand directly');

select public.create_category('Smoke Cat') as cat_id \gset

select public.admin_create_product(
  (select id from public.businesses limit 1),
  :'cat_id'::uuid,
  'Smoke Product', 'desc', 10000,
  (select id from public.brands limit 1),
  10, '[]'::jsonb) as product_id \gset

select pg_temp.assert_eq((select count(*) from public.product_variants where product_id=:'product_id'::uuid)::text, '1', 'auto Default variant created');
select pg_temp.assert_eq((select (price_minor is null)::text from public.product_variants where product_id=:'product_id'::uuid), 'true', 'Default variant price is null');
select (select id from public.product_variants where product_id=:'product_id'::uuid) as variant_id \gset
select (select id from public.brands limit 1) as brand_id \gset

select public.admin_create_product(
  (select id from public.businesses limit 1), :'cat_id'::uuid,
  'Cheap Product', 'desc', 5000, NULL, 100, '[]'::jsonb) as product2_id \gset

select public.create_platform_promotion('Smoke Promo','d','percent',10,'SMOKE10',0,NULL,NULL,NULL) as promo_id \gset
select pg_temp.assert_eq((select count(*) from public.coupons where code='SMOKE10')::text, '1', 'promotion+coupon atomic');

select public.create_platform_promotion('Min Promo','d','fixed',500,'SMOKE500',50000,NULL,NULL,NULL) as promo_min_id \gset
select public.create_platform_promotion('Brand Promo','d','percent',20,'BRAND20',0,NULL,NULL,:'brand_id'::uuid) as promo_brand_id \gset
select pg_temp.assert_eq((select scope::text from public.promotions where id=:'promo_brand_id'::uuid), 'brand', 'brand scope derived');

select public.admin_create_banner('Smoke Banner','d','https://example.com/b.png',NULL) as banner_id \gset
select pg_temp.assert_eq((select status::text from public.banners where id=:'banner_id'::uuid), 'pending', 'banner starts pending');
select public.moderate_banner(:'banner_id'::uuid, 'approve');
select pg_temp.assert_eq((select status::text from public.banners where id=:'banner_id'::uuid), 'approved', 'banner approved');

update public.platform_settings set delivery_fee_minor = 2000, qr_account_id = 'smoke-qr@bank' where id = 1;
select pg_temp.assert_eq((select count(*) from public.audit_logs)::text, '8', 'admin mutations audited');
COMMIT;

-- RLS: customer cannot read audit logs or others' orders
BEGIN;
SET LOCAL role authenticated;
SET LOCAL request.jwt.claims = '{"sub":"11111111-1111-1111-1111-111111111111","role":"authenticated"}';
select pg_temp.assert_eq((select count(*) from public.audit_logs)::text, '0', 'customer blocked from audit_logs');
select pg_temp.assert_eq((select count(*) from public.orders)::text, '0', 'customer sees no orders yet');
COMMIT;

-- ==================================================== customer: checkout
BEGIN;
SET LOCAL role authenticated;
SET LOCAL request.jwt.claims = '{"sub":"11111111-1111-1111-1111-111111111111","role":"authenticated"}';

insert into public.addresses (user_id, label, recipient_name, phone, line1, city)
values (auth.uid(), 'Home', 'Smoke Customer', '0123', '1 Smoke St', 'Phnom Penh');
select (select id from public.addresses where recipient_name='Smoke Customer' order by created_at limit 1) as addr_id \gset

-- below-minimum coupon rejected with message
select pg_temp.assert_eq((select (public.validate_coupon('SMOKE500')->>'valid')), 'false', 'min-order coupon invalid');
select pg_temp.assert_eq((select (public.validate_coupon('NOPE')->>'valid')), 'false', 'unknown coupon invalid');

select public.add_cart_item(:'variant_id'::uuid, 3);
select pg_temp.assert_eq((select (public.validate_coupon('SMOKE10')->>'valid')), 'true', 'percent coupon valid');
select pg_temp.assert_eq((select (public.validate_coupon('SMOKE10')->>'discount_minor')), '3000', 'percent discount = 3000');

select public.create_order_from_cart(:'addr_id'::uuid, 'qr', ARRAY['SMOKE10'], 'leave at door') as order1 \gset

select pg_temp.assert_eq((select status::text from public.orders where id=:'order1'::uuid), 'pending', 'order starts pending');
select pg_temp.assert_eq((select note from public.orders where id=:'order1'::uuid), 'leave at door', 'order note stored');
select pg_temp.assert_eq((select subtotal_minor::text from public.orders where id=:'order1'::uuid), '30000', 'subtotal from DB prices');
select pg_temp.assert_eq((select discount_minor::text from public.orders where id=:'order1'::uuid), '3000', 'order discount recorded');
select pg_temp.assert_eq((select total_minor::text from public.orders where id=:'order1'::uuid), '29000', 'total = subtotal - discount + fee');
select pg_temp.assert_eq((select method::text || ':' || status::text || ':' || amount_minor::text from public.payments where order_id=:'order1'::uuid), 'qr:pending:29000', 'qr payment pending');
select pg_temp.assert_eq((select count(*) from public.order_items where order_id=:'order1'::uuid)::text, '1', 'order_items on order directly');
select pg_temp.assert_eq((select business_name from public.order_items where order_id=:'order1'::uuid), 'Smoke Store', 'business_name snapshot');
select pg_temp.assert_eq((select discount_minor::text from public.order_coupons where order_id=:'order1'::uuid), '3000', 'historical coupon record');
select pg_temp.assert_eq((select stock::text from public.products where id=:'product_id'::uuid), '7', 'stock deducted 10→7');
select pg_temp.assert_eq((select count(*) from public.cart_items)::text, '0', 'cart cleared');
select pg_temp.assert_eq((select count(*)::text from pg_tables where schemaname='public' and tablename='business_orders'), '0', 'no business_orders anywhere');
select pg_temp.assert_eq((select count(*) from public.notifications)::text, '0', 'no notifications yet');

select (select id from public.order_items where order_id=:'order1'::uuid) as oi_id \gset

-- QR flow: register payload → admin simulates
select public.register_qr_payment(:'order1'::uuid, '00020101021SmokePayload');
select pg_temp.assert_eq((select qr_md5 from public.payments where order_id=:'order1'::uuid), md5('00020101021SmokePayload'), 'qr_md5 computed server-side');
select pg_temp.assert_eq((select status::text from public.payments where order_id=:'order1'::uuid), 'pending', 'register keeps status pending');
COMMIT;

-- ==================================================== admin: fulfillment
BEGIN;
SET LOCAL role authenticated;
SET LOCAL request.jwt.claims = '{"sub":"22222222-2222-2222-2222-222222222222","role":"authenticated"}';

select public.simulate_qr_payment(:'order1'::uuid);
select pg_temp.assert_eq((select status::text from public.payments where order_id=:'order1'::uuid), 'transaction_verified', 'simulated payment verified');
select pg_temp.assert_eq((select transaction_reference from public.payments where order_id=:'order1'::uuid), 'simulated', 'simulation reference recorded');

-- invalid transition rejected
DO $outer$
declare v_order uuid;
begin
  select id into v_order from public.orders where status = 'delivered' limit 1;
  begin
    perform public.admin_transition_order(v_order, 'delivered', NULL);
    raise exception 'NO-ERROR-SENTINEL';
  exception when others then
    if sqlerrm = 'NO-ERROR-SENTINEL' then
      raise exception 'SMOKE FAIL: invalid transition was allowed';
    end if;
  end;
end $outer$;

select public.admin_transition_order(:'order1'::uuid, 'confirmed', NULL);
select public.admin_transition_order(:'order1'::uuid, 'processing', NULL);
select public.admin_transition_order(:'order1'::uuid, 'packed', NULL);
select public.admin_transition_order(:'order1'::uuid, 'shipped', NULL);
select public.admin_transition_order(:'order1'::uuid, 'out_for_delivery', NULL);
select public.admin_transition_order(:'order1'::uuid, 'delivered', NULL);
select pg_temp.assert_eq((select status::text from public.orders where id=:'order1'::uuid), 'delivered', 'order delivered through chain');
select pg_temp.assert_eq((select count(*) from public.state_history where entity_type='order' and entity_id=:'order1'::uuid)::text, '6', 'state history recorded');
COMMIT;

-- notifications: status chain + payment received
select pg_temp.assert_eq((select count(*) from public.notifications)::text, '7', 'customer notified per status + payment');
BEGIN;
SET LOCAL role authenticated;
SET LOCAL request.jwt.claims = '{"sub":"22222222-2222-2222-2222-222222222222","role":"authenticated"}';
select pg_temp.assert_eq((select (public.get_admin_kpis()->>'total_sales_minor')), '29000', 'kpis sales = delivered order before return');
COMMIT;

BEGIN;
SET LOCAL role authenticated;
SET LOCAL request.jwt.claims = '{"sub":"11111111-1111-1111-1111-111111111111","role":"authenticated"}';
select pg_temp.assert_eq((select (public.get_customer_dashboard()->>'total_spending_minor')), '29000', 'dashboard spending counts delivered order');
COMMIT;

-- ====================================================== customer: return
BEGIN;
SET LOCAL role authenticated;
SET LOCAL request.jwt.claims = '{"sub":"11111111-1111-1111-1111-111111111111","role":"authenticated"}';

select public.request_return(:'order1'::uuid,
  jsonb_build_array(jsonb_build_object('order_item_id', :'oi_id'::uuid, 'quantity', 1, 'reason', 'broken'))) as ret_id \gset

DO $outer$
declare v_new_request uuid; v_order uuid; v_oi uuid;
begin
  select id into v_order from public.orders where status = 'delivered' limit 1;
  select id into v_oi from public.order_items where order_id = v_order limit 1;
  begin
    -- second return of the same item must fail (one return per item)
    insert into public.return_requests (order_id, customer_id)
    values (v_order, auth.uid()) returning id into v_new_request;
    insert into public.return_items (return_request_id, order_item_id, quantity)
    values (v_new_request, v_oi, 1);
    raise exception 'NO-ERROR-SENTINEL';
  exception when unique_violation then
    raise notice 'ok - one return per order item enforced';
  when others then
    if sqlerrm = 'NO-ERROR-SENTINEL' then
      raise exception 'SMOKE FAIL: duplicate return item allowed';
    end if;
  end;
end $outer$;
COMMIT;

-- ================================================= admin: return + refund
BEGIN;
SET LOCAL role authenticated;
SET LOCAL request.jwt.claims = '{"sub":"22222222-2222-2222-2222-222222222222","role":"authenticated"}';

select public.admin_process_return(:'ret_id'::uuid, true);
select pg_temp.assert_eq((select status::text from public.payments where order_id=:'order1'::uuid), 'refund_required', 'verified payment routed to refund_required');
select public.mark_refunded(:'order1'::uuid, 'REF123');
select pg_temp.assert_eq((select status::text from public.payments where order_id=:'order1'::uuid), 'refunded', 'refund recorded');
select public.admin_complete_return(:'ret_id'::uuid);
select pg_temp.assert_eq((select status::text from public.return_requests where id=:'ret_id'::uuid), 'completed', 'return completed');
select pg_temp.assert_eq((select status::text from public.orders where id=:'order1'::uuid), 'returned', 'order marked returned');
COMMIT;

-- ==================================================== customer: cancel path
BEGIN;
SET LOCAL role authenticated;
SET LOCAL request.jwt.claims = '{"sub":"11111111-1111-1111-1111-111111111111","role":"authenticated"}';

insert into public.addresses (user_id, label, recipient_name, phone, line1, city)
values (auth.uid(), 'Work', 'Smoke Customer', '0123', '2 Smoke St', 'Phnom Penh');
select (select id from public.addresses where line1='2 Smoke St') as addr2_id \gset

select public.set_default_address(:'addr2_id'::uuid);
select pg_temp.assert_eq((select count(*) from public.addresses where user_id=auth.uid() and is_default)::text, '1', 'exactly one default address');
select public.set_default_address(:'addr_id'::uuid);
select pg_temp.assert_eq((select is_default::text from public.addresses where id=:'addr2_id'::uuid), 'false', 'default moved back');

select public.add_cart_item(:'variant_id'::uuid, 2);
select public.create_order_from_cart(:'addr_id'::uuid, 'cod', ARRAY[]::text[], '') as order2 \gset
select pg_temp.assert_eq((select stock::text from public.products where id=:'product_id'::uuid), '5', 'stock 7→5 for second order');
select pg_temp.assert_eq((select status::text from public.payments where order_id=:'order2'::uuid), 'pending', 'cod payment pending');

select public.cancel_order(:'order2'::uuid);
select pg_temp.assert_eq((select status::text from public.orders where id=:'order2'::uuid), 'cancelled', 'order cancelled');
select pg_temp.assert_eq((select cancellation_reason from public.orders where id=:'order2'::uuid), 'Cancelled by customer', 'cancel reason default');
select pg_temp.assert_eq((select stock::text from public.products where id=:'product_id'::uuid), '7', 'stock restored on cancel');

-- second cancel must fail
DO $outer$
declare v_order uuid;
begin
  select id into v_order from public.orders where status = 'cancelled' limit 1;
  begin
    perform public.cancel_order(v_order);
    raise exception 'NO-ERROR-SENTINEL';
  exception when others then
    if sqlerrm = 'NO-ERROR-SENTINEL' then
      raise exception 'SMOKE FAIL: double cancel allowed';
    end if;
  end;
end $outer$;

-- insufficient stock must fail checkout
DO $outer$
declare v_variant uuid; v_addr uuid;
begin
  select id into v_variant from public.product_variants
    where product_id = (select id from public.products where name = 'Smoke Product') limit 1;
  select id into v_addr from public.addresses where line1 = '1 Smoke St' limit 1;
  begin
    perform public.add_cart_item(v_variant, 1000);
    perform public.create_order_from_cart(v_addr, 'cod', ARRAY[]::text[], '');
    raise exception 'NO-ERROR-SENTINEL';
  exception when others then
    if sqlerrm = 'NO-ERROR-SENTINEL' then
      raise exception 'SMOKE FAIL: oversell allowed';
    end if;
    raise notice 'ok - oversell blocked (%)', sqlerrm;
  end;
end $outer$;

select public.create_review(:'oi_id'::uuid, 5, 'great');
select pg_temp.assert_eq((select count(*) from public.reviews where customer_id=auth.uid())::text, '1', 'review created via direct join');
COMMIT;

-- ============================================================ reports
BEGIN;
SET LOCAL role authenticated;
SET LOCAL request.jwt.claims = '{"sub":"22222222-2222-2222-2222-222222222222","role":"authenticated"}';
select pg_temp.assert_eq((select (public.get_platform_report()->>'order_count')), '2', 'platform report order count');
select pg_temp.assert_eq((select (public.get_admin_kpis()->>'total_orders')), '2', 'kpis order count');
select pg_temp.assert_eq((select (public.get_admin_kpis()->>'total_sales_minor')), '0', 'kpis sales exclude returned + cancelled');
select pg_temp.assert_eq((select (public.get_sales_report(current_date, current_date)->>'total_orders')), '2', 'sales report orders');
COMMIT;

BEGIN;
SET LOCAL role authenticated;
SET LOCAL request.jwt.claims = '{"sub":"11111111-1111-1111-1111-111111111111","role":"authenticated"}';
select pg_temp.assert_eq((select (public.get_customer_dashboard()->>'total_orders')), '2', 'dashboard total orders');
select pg_temp.assert_eq((select (public.get_customer_dashboard()->>'total_spending_minor')), '0', 'dashboard spending excludes returned + cancelled');
COMMIT;

select 'SMOKE TEST PASSED' as result;
