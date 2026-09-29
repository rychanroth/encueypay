-- EncueYPay RPC smoke test — run against the local harness DB after
-- migrations. Impersonates users via request.jwt.claims (auth.uid() stub).
-- NOTE: psql does not interpolate :vars inside $$ blocks — values are
-- passed through session settings (set_config / current_setting).
\set ON_ERROR_STOP on

-- ---------------------------------------------------------------- fixtures
insert into auth.users (id, email, raw_user_meta_data) values
  ('11111111-1111-1111-1111-111111111111', 'cust@test.dev', '{"full_name":"Customer"}'),
  ('22222222-2222-2222-2222-222222222222', 'biz1@test.dev', '{"full_name":"BizOne"}'),
  ('33333333-3333-3333-3333-333333333333', 'drv@test.dev',  '{"full_name":"Driver"}'),
  ('44444444-4444-4444-4444-444444444444', 'adm@test.dev',  '{"full_name":"Admin"}'),
  ('55555555-5555-5555-5555-555555555555', 'biz2@test.dev', '{"full_name":"BizTwo"}');

DO $$ BEGIN
  assert (select count(*) from public.users) = 5, 'signup trigger should create 5 app users';
  assert (select active_role from public.users where id = '11111111-1111-1111-1111-111111111111') = 'customer',
    'new users default to customer';
END $$;

update public.users set active_role = 'business' where id = '22222222-2222-2222-2222-222222222222';
update public.users set active_role = 'driver'   where id = '33333333-3333-3333-3333-333333333333';
update public.users set active_role = 'admin'    where id = '44444444-4444-4444-4444-444444444444';
update public.users set active_role = 'business' where id = '55555555-5555-5555-5555-555555555555';

update public.platform_settings
set delivery_fee_minor = 200,
    platform_commission_percent = 5,
    driver_commission_percent = 80
where id = 1;

-- category (admin)
set request.jwt.claims to '{"sub":"44444444-4444-4444-4444-444444444444"}';
select public.create_category('Apparel') as cat \gset

-- ---------------------------------------------------------------- business 1
set request.jwt.claims to '{"sub":"22222222-2222-2222-2222-222222222222"}';
select public.create_business('Test Business', 'desc') as b1 \gset
select public.create_product(:'cat', 'T-Shirt', '', 1000,
  '[{"name":"M/Black","price_minor":1000},{"name":"L/Black","price_minor":1200}]'::jsonb) as p1 \gset
select public.create_product(:'cat', 'Mug', '', 500, '[]'::jsonb) as p2 \gset

DO $$ BEGIN
  assert (select count(*) from public.product_variants where product_id = (select id from public.products where name = 'Mug')) = 1,
    'product without variants gets an auto Default variant';
END $$;

select public.add_product_variant((select id from public.products where name = 'T-Shirt'), 'XL/Black', 1400) as v_xl \gset
DO $$ BEGIN
  assert (select count(*) from public.product_variants where product_id = (select id from public.products where name = 'T-Shirt')) = 3,
    'add_product_variant appends to an existing product';
END $$;

select id as variant_m from public.product_variants where name = 'M/Black' \gset
select pv.id as variant_default from public.product_variants pv
  join public.products p on p.id = pv.product_id where p.name = 'Mug' \gset

-- ---------------------------------------------------------------- business 2
set request.jwt.claims to '{"sub":"55555555-5555-5555-5555-555555555555"}';
select public.create_business('Second Shop', 'desc') as b2 \gset
select public.create_product(:'cat', 'Candle', '', 700, '[]'::jsonb) as p3 \gset
select pv.id as variant_candle from public.product_variants pv
  join public.products p on p.id = pv.product_id where p.name = 'Candle' \gset

-- ---------------------------------------------------------------- coupon
set request.jwt.claims to '{"sub":"22222222-2222-2222-2222-222222222222"}';
select public.create_coupon_promotion('Winter', '', 'percent', 10, 'WELCOME10');

-- ---------------------------------------------------------------- customer: cart & checkout
set request.jwt.claims to '{"sub":"11111111-1111-1111-1111-111111111111"}';
insert into public.addresses (user_id, label, recipient_name, phone, line1, city)
values ('11111111-1111-1111-1111-111111111111', 'Home', 'Customer', '0123456789', 'Street 1', 'Phnom Penh');
select id as addr from public.addresses limit 1 \gset

select public.add_cart_item(:'variant_m', 2);
select public.add_cart_item(:'variant_default', 1);
select public.add_cart_item(:'variant_candle', 1);
select public.add_cart_item(:'variant_m', 1);  -- upsert-increment -> qty 3

DO $$ BEGIN
  assert (select quantity from public.cart_items ci
    join public.product_variants pv on pv.id = ci.product_variant_id
    where pv.name = 'M/Black') = 3, 'cart upsert should increment to 3';
END $$;

-- subtotal: 1000*3 + 500 + 700 = 4200; biz1 lines = 3500 -> discount 350
DO $$ BEGIN
  assert (public.validate_coupon('WELCOME10') ->> 'valid') = 'true', 'coupon should be valid';
  assert ((public.validate_coupon('WELCOME10') ->> 'discount_minor')::int) = 350,
    'business coupon discounts only that business lines (10% of 3500)';
END $$;

select public.create_order_from_cart(:'addr', 'cod', array['WELCOME10']) as order1 \gset
select set_config('smoke.order1', :'order1', false) as _ \gset

DO $$ BEGIN
  assert (select count(*) from public.cart_items) = 0, 'cart must be cleared';
  assert (select count(*) from public.business_orders where order_id = current_setting('smoke.order1')::uuid) = 2,
    'two businesses -> two business orders';
  assert (select count(*) from public.order_items oi join public.business_orders bo on bo.id = oi.business_order_id
    where bo.order_id = current_setting('smoke.order1')::uuid) = 3, 'three order items';
  assert (select amount_minor from public.payments where order_id = current_setting('smoke.order1')::uuid) = 4050,
    'payment = 4200 - 350 + 200 delivery fee';
  assert (select status from public.deliveries where order_id = current_setting('smoke.order1')::uuid) = 'available';
  assert (select count(*) from public.pickup_stops ps join public.deliveries d on d.id = ps.delivery_id
    where d.order_id = current_setting('smoke.order1')::uuid) = 2, 'one pickup stop per business order';
  assert (select count(*) from public.order_coupons where order_id = current_setting('smoke.order1')::uuid) = 1,
    'historical coupon record';
  assert (select discount_minor from public.orders where id = current_setting('smoke.order1')::uuid) = 350;
END $$;

select bo.id as bo1 from public.business_orders bo
  join public.businesses b on b.id = bo.business_id
  where bo.order_id = :'order1'::uuid and b.name = 'Test Business' \gset

-- ---------------------------------------------------------------- business lifecycle
set request.jwt.claims to '{"sub":"22222222-2222-2222-2222-222222222222"}';
select public.transition_business_order(:'bo1', 'accepted', null);
select public.transition_business_order(:'bo1', 'preparing', null);
select public.transition_business_order(:'bo1', 'ready', null);

-- invalid state skip (biz2 owns its pending business order: pending -> preparing skips 'accepted')
set request.jwt.claims to '{"sub":"55555555-5555-5555-5555-555555555555"}';
DO $$ BEGIN
  begin
    perform public.transition_business_order(
      (select bo.id from public.business_orders bo
       join public.businesses b on b.id = bo.business_id
       join auth.users au on au.id = b.owner_id
       where au.email = 'biz2@test.dev'), 'preparing', null);
    raise exception 'invalid state transition was allowed!';
  exception when others then
    if sqlerrm not like '%Cannot move%' then raise; end if;
  end;
END $$;

-- ---------------------------------------------------------------- driver flow
set request.jwt.claims to '{"sub":"33333333-3333-3333-3333-333333333333"}';
select id as delivery1 from public.deliveries where order_id = :'order1'::uuid \gset
select set_config('smoke.delivery1', :'delivery1', false) as _ \gset
select public.accept_delivery(:'delivery1');
select public.complete_pickup_stop(ps.id)
from public.pickup_stops ps where ps.delivery_id = :'delivery1'::uuid order by ps.sequence;
select public.start_delivery(:'delivery1');
select public.mark_delivered(:'delivery1');

DO $$ BEGIN
  assert (select status from public.deliveries where id = current_setting('smoke.delivery1')::uuid) = 'delivered';
  assert (select status from public.payments where order_id = (select order_id from public.deliveries where id = current_setting('smoke.delivery1')::uuid)) = 'transaction_verified',
    'COD collected at delivery';
  assert (select paid_at from public.payments where order_id = (select order_id from public.deliveries where id = current_setting('smoke.delivery1')::uuid)) is not null;
  assert (select count(*) from public.notifications where recipient_id = '11111111-1111-1111-1111-111111111111') >= 3,
    'customer notified (order placed, status, delivery)';
  assert (select count(*) from public.notifications where recipient_id = '22222222-2222-2222-2222-222222222222') >= 1,
    'business notified of new order';
END $$;

-- ---------------------------------------------------------------- cancel path
set request.jwt.claims to '{"sub":"11111111-1111-1111-1111-111111111111"}';
select public.add_cart_item(:'variant_m', 2);
select public.create_order_from_cart(:'addr', 'cod', '{}') as order2 \gset
select set_config('smoke.order2', :'order2', false) as _ \gset
select public.cancel_order(:'order2');

DO $$ BEGIN
  assert (select status from public.deliveries where order_id = current_setting('smoke.order2')::uuid) = 'cancelled';
  assert (select count(*) from public.business_orders bo where bo.order_id = current_setting('smoke.order2')::uuid
    and bo.status = 'cancelled') = 1;
END $$;

-- ---------------------------------------------------------------- reject path (bank transfer + refund)
select public.add_cart_item(:'variant_m', 1);
select public.create_order_from_cart(:'addr', 'bank_transfer', '{}') as order3 \gset
select set_config('smoke.order3', :'order3', false) as _ \gset
select id as bo3 from public.business_orders where order_id = :'order3'::uuid limit 1 \gset
select public.submit_payment_proof(:'order3', 'proofs/test.png');

DO $$ BEGIN
  assert (select status from public.payments where order_id = current_setting('smoke.order3')::uuid) = 'transaction_verified',
    'prototype: proof verifies immediately';
END $$;

set request.jwt.claims to '{"sub":"22222222-2222-2222-2222-222222222222"}';
select public.transition_business_order(:'bo3', 'rejected', 'Damaged in handling');

DO $$ BEGIN
  assert (select status from public.payments where order_id = current_setting('smoke.order3')::uuid) = 'refund_required',
    'verified transfer -> refund required on rejection';
END $$;

-- ---------------------------------------------------------------- returns & reviews (delivered order1)
set request.jwt.claims to '{"sub":"11111111-1111-1111-1111-111111111111"}';
select oi.id as item1 from public.order_items oi
  join public.business_orders bo on bo.id = oi.business_order_id
  join public.businesses b on b.id = bo.business_id
  where bo.order_id = :'order1'::uuid and b.name = 'Test Business' limit 1 \gset
select set_config('smoke.item1', :'item1', false) as _ \gset

select public.request_return(:'order1',
  jsonb_build_array(jsonb_build_object('order_item_id', :'item1'::uuid, 'quantity', 1, 'reason', 'too small'))) as ret1 \gset
select set_config('smoke.ret1', :'ret1', false) as _ \gset

DO $$ BEGIN
  begin
    perform public.request_return(current_setting('smoke.order1')::uuid, jsonb_build_array(
      jsonb_build_object('order_item_id', current_setting('smoke.item1')::uuid, 'quantity', 1, 'reason', 'dup')));
    raise exception 'second pending return was allowed';
  exception when others then
    if sqlerrm not like '%already pending%' then raise; end if;
  end;
END $$;

set request.jwt.claims to '{"sub":"22222222-2222-2222-2222-222222222222"}';
select public.process_return(:'ret1', true);

DO $$ BEGIN
  assert (select status from public.return_requests where id = current_setting('smoke.ret1')::uuid) = 'approved';
  assert (select status from public.return_items where return_request_id = current_setting('smoke.ret1')::uuid) = 'approved';
END $$;

set request.jwt.claims to '{"sub":"11111111-1111-1111-1111-111111111111"}';
select public.create_review(:'item1', 5, 'Great product');

DO $$ BEGIN
  begin
    perform public.create_review(current_setting('smoke.item1')::uuid, 3, 'dup');
    raise exception 'duplicate review was allowed';
  exception when others then
    if sqlerrm not like '%duplicate key%' then raise; end if;
  end;
END $$;

-- ---------------------------------------------------------------- role applications
select public.submit_role_application('business');
select public.submit_role_application('driver');  -- replaces pending

DO $$ BEGIN
  assert (select count(*) from public.role_applications
    where user_id = '11111111-1111-1111-1111-111111111111' and status = 'pending') = 1,
    'resubmission replaces pending application';
END $$;

set request.jwt.claims to '{"sub":"44444444-4444-4444-4444-444444444444"}';
select public.review_role_application(
  (select id from public.role_applications
   where user_id = '11111111-1111-1111-1111-111111111111' and status = 'pending' limit 1), true, null);

DO $$ BEGIN
  assert (select active_role from public.users where id = '11111111-1111-1111-1111-111111111111') = 'driver',
    'approval flips active_role (last submitted application was driver)';
  assert (select count(*) from public.audit_logs where action = 'role_application.approved') = 1;
END $$;

-- ---------------------------------------------------------------- negative authorization
set request.jwt.claims to '{"sub":"11111111-1111-1111-1111-111111111111"}';
DO $$ BEGIN
  begin
    perform public.create_platform_promotion('Hack', '', 'fixed', 100, 'HACK');
    raise exception 'non-admin created a platform promotion!';
  exception when others then
    if sqlerrm not like '%Only admins%' then raise; end if;
  end;
END $$;

set request.jwt.claims to '{"sub":"55555555-5555-5555-5555-555555555555"}';
DO $$ BEGIN
  begin
    perform public.accept_delivery('00000000-0000-0000-0000-000000000000'::uuid);
    raise exception 'non-driver accepted a delivery!';
  exception when others then
    if sqlerrm not like '%Only drivers%' then raise; end if;
  end;
END $$;

-- ---------------------------------------------------------------- analytics
set request.jwt.claims to '{"sub":"22222222-2222-2222-2222-222222222222"}';
select public.get_business_analytics();
set request.jwt.claims to '{"sub":"44444444-4444-4444-4444-444444444444"}';
select public.get_platform_report();

\echo '=== ALL SMOKE TESTS PASSED ==='
