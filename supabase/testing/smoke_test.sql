-- EncueYPay RPC smoke test — single-seller (customer + admin) surface.
--
-- Runs against the local harness DB after every migration:
--   bash supabase/testing/run.sh
-- Impersonates users via request.jwt.claims (the auth.uid() stub).
-- NOTE: psql does not interpolate :vars inside $$ blocks — values are passed
-- through session settings (set_config / current_setting).
\set ON_ERROR_STOP on

-- ---------------------------------------------------------------- fixtures
insert into auth.users (id, email, raw_user_meta_data) values
  ('11111111-1111-1111-1111-111111111111', 'cust@test.dev', '{"full_name":"Customer"}'),
  ('22222222-2222-2222-2222-222222222222', 'other@test.dev', '{"full_name":"Other Customer"}'),
  ('44444444-4444-4444-4444-444444444444', 'adm@test.dev', '{"full_name":"Admin"}');

DO $$ BEGIN
  assert (select count(*) from public.users) = 3,
    'signup trigger should create 3 app users';
  assert (select count(*) from public.users where active_role = 'customer') = 3,
    'new users default to customer';
  assert (select count(*) from public.users where onboarded_at is not null) = 0,
    'new customers start un-onboarded';
END $$;

-- Roles are set outside impersonation — the self-change guard blocks them
-- while auth.uid() is present.
update public.users set active_role = 'admin'
 where id = '44444444-4444-4444-4444-444444444444';

update public.platform_settings
   set delivery_fee_minor = 200,
       platform_commission_percent = 5
 where id = 1;

-- The onboarding write lands on the new column (app does this via update).
set request.jwt.claims to '{"sub":"11111111-1111-1111-1111-111111111111"}';
update public.users
   set full_name = 'Customer',
       phone = '0123456789',
       onboarded_at = now()
 where id = '11111111-1111-1111-1111-111111111111';

DO $$ BEGIN
  assert (select onboarded_at from public.users
           where id = '11111111-1111-1111-1111-111111111111') is not null,
    'onboarding completion stamps onboarded_at';
END $$;

-- ---------------------------------------------------------------- catalog (admin)
set request.jwt.claims to '{"sub":"44444444-4444-4444-4444-444444444444"}';

select public.create_category('Apparel', null, null) as cat \gset
insert into public.brands (name, description)
values ('R67 Home', 'Prototype brand')
returning id as brand \gset

select public.admin_create_product(
  :'cat', 'T-Shirt', 'Cotton tee', :'brand', 10,
  '[{"name":"M","price_minor":1000},{"name":"L","price_minor":1200}]'::jsonb
) as p_tee \gset

select public.admin_create_product(
  :'cat', 'Tote Bag', 'Canvas tote', :'brand', 5,
  '[{"name":"Standard","price_minor":500}]'::jsonb
) as p_tote \gset

select set_config('smoke.cat', :'cat', false) as _ \gset
select set_config('smoke.brand', :'brand', false) as _ \gset
select set_config('smoke.p_tee', :'p_tee', false) as _ \gset
select set_config('smoke.p_tote', :'p_tote', false) as _ \gset

DO $$ BEGIN
  assert (select count(*) from public.product_variants
           where product_id = current_setting('smoke.p_tee')::uuid) = 2,
    'both explicit variants were created';
  assert (select base_price_minor from public.products
           where id = current_setting('smoke.p_tee')::uuid) = 1000,
    'base price is the cheapest variant';

  -- Explicit variants are required: an empty variant list is rejected.
  begin
    perform public.admin_create_product(
      current_setting('smoke.cat')::uuid, 'No Variants', '', null, 5, '[]'::jsonb);
    raise exception 'product without variants was allowed';
  exception when others then
    if sqlerrm not like '%least one variant%' then raise; end if;
  end;

  -- Non-admins cannot reach admin RPCs.
  perform set_config('request.jwt.claims', '{"sub":"11111111-1111-1111-1111-111111111111"}', true);
  begin
    perform public.admin_create_product(
      current_setting('smoke.cat')::uuid, 'Hack', '', null, 1,
      '[{"name":"X","price_minor":100}]'::jsonb);
    raise exception 'non-admin created a product';
  exception when others then
    if sqlerrm not like '%Only admins%' then raise; end if;
  end;
  perform set_config('request.jwt.claims', '{"sub":"44444444-4444-4444-4444-444444444444"}', true);
END $$;

select pv.id as v_tee
  from public.product_variants pv
 where pv.product_id = :'p_tee'::uuid and pv.name = 'M' \gset
select pv.id as v_tote
  from public.product_variants pv
 where pv.product_id = :'p_tote'::uuid \gset

select set_config('smoke.v_tee', :'v_tee', false) as _ \gset
select set_config('smoke.v_tote', :'v_tote', false) as _ \gset

-- ---------------------------------------------------------------- coupon (admin)
select public.admin_create_coupon(
  'Welcome', 'WELCOME10', 'percent', 10, 0, null, null
) as coupon \gset
select set_config('smoke.coupon', :'coupon', false) as _ \gset

DO $$ BEGIN
  begin
    perform public.admin_create_coupon('Bad', 'BAD', 'fixed', 0, 0, null, null);
    raise exception 'zero-value coupon was allowed';
  exception when others then
    if sqlerrm not like '%must be positive%' then raise; end if;
  end;
END $$;

-- ---------------------------------------------------------------- cart & selection
set request.jwt.claims to '{"sub":"11111111-1111-1111-1111-111111111111"}';

insert into public.addresses (user_id, label, recipient_name, phone, line1, city)
values ('11111111-1111-1111-1111-111111111111', 'Home', 'Customer',
        '0123456789', 'Street 1', 'Phnom Penh')
returning id as addr \gset

select public.add_cart_item(:'v_tee', 2);
select public.add_cart_item(:'v_tote', 1);
select public.add_cart_item(:'v_tee', 1);  -- upsert-increment -> qty 3

DO $$ BEGIN
  assert (select quantity from public.cart_items ci
           join public.product_variants pv on pv.id = ci.product_variant_id
          where pv.id = current_setting('smoke.v_tee')::uuid) = 3,
    'cart upsert increments the existing line';
  assert ((public.validate_coupon('WELCOME10') ->> 'discount_minor')::int) = 350,
    '10% of the 3500 cart';
  assert ((public.preview_order_totals(array['WELCOME10']) ->> 'total_minor')::int) = 3350,
    '3500 - 350 + 200 delivery';
END $$;

select ci.id as tee_line
  from public.cart_items ci
 where ci.product_variant_id = :'v_tee'::uuid \gset
select ci.id as tote_line
  from public.cart_items ci
 where ci.product_variant_id = :'v_tote'::uuid \gset

select set_config('smoke.tote_line', :'tote_line', false) as _ \gset

-- Checkout only the tote: the ticked-line model is part of the contract.
select public.create_order_from_cart(
  :'addr', 'cod', '{}', '', array[:'tote_line']::uuid[]
) as order1 \gset
select set_config('smoke.order1', :'order1', false) as _ \gset

DO $$ BEGIN
  assert (select count(*) from public.cart_items) = 1,
    'unselected lines stay in the cart';
  assert (select stock from public.products
           where id = current_setting('smoke.p_tote')::uuid) = 4,
    'only the selected product stock was deducted';
  assert (select stock from public.products
           where id = current_setting('smoke.p_tee')::uuid) = 10,
    'unselected product stock is untouched';
  assert (select subtotal_minor from public.orders
           where id = current_setting('smoke.order1')::uuid) = 500;
  assert (select total_minor from public.orders
           where id = current_setting('smoke.order1')::uuid) = 700,
    '500 + 200 delivery';
  assert (select count(*) from public.order_items
           where order_id = current_setting('smoke.order1')::uuid) = 1;
  assert (select amount_minor from public.payments
           where order_id = current_setting('smoke.order1')::uuid) = 700;
  assert (select status from public.payments
           where order_id = current_setting('smoke.order1')::uuid) = 'pending';
END $$;

-- A consumed selection is stale and must be rejected.
DO $$ BEGIN
  begin
    perform public.create_order_from_cart(
      (select id from public.addresses
        where user_id = '11111111-1111-1111-1111-111111111111' limit 1),
      'cod', '{}', '', array[current_setting('smoke.tote_line')::uuid]);
    raise exception 'stale selection was allowed';
  exception when others then
    if sqlerrm not like '%no longer in your cart%' then raise; end if;
  end;
END $$;

-- ---------------------------------------------------------------- order 2 (remaining cart + coupon)
select public.create_order_from_cart(
  :'addr', 'cod', array['WELCOME10'], 'Leave at the door'
) as order2 \gset
select set_config('smoke.order2', :'order2', false) as _ \gset

DO $$ BEGIN
  assert (select count(*) from public.cart_items) = 0, 'cart must be cleared';
  assert (select subtotal_minor from public.orders
           where id = current_setting('smoke.order2')::uuid) = 3000;
  assert (select discount_minor from public.orders
           where id = current_setting('smoke.order2')::uuid) = 300;
  assert (select total_minor from public.orders
           where id = current_setting('smoke.order2')::uuid) = 2900,
    '3000 - 300 + 200 delivery';
  assert (select note from public.orders
           where id = current_setting('smoke.order2')::uuid) = 'Leave at the door';
  assert (select count(*) from public.order_coupons
           where order_id = current_setting('smoke.order2')::uuid) = 1;
  assert (select discount_minor from public.order_coupons
           where order_id = current_setting('smoke.order2')::uuid) = 300;
  assert (select stock from public.products
           where id = current_setting('smoke.p_tee')::uuid) = 7;
END $$;

-- ---------------------------------------------------------------- order lifecycle
set request.jwt.claims to '{"sub":"44444444-4444-4444-4444-444444444444"}';

DO $$ BEGIN
  -- Skip a step → rejected.
  begin
    perform public.admin_transition_order(
      current_setting('smoke.order1')::uuid, 'processing', null);
    raise exception 'invalid transition was allowed';
  exception when others then
    if sqlerrm not like '%Cannot transition%' then raise; end if;
  end;

  -- Cash cannot be recorded before delivery.
  begin
    perform public.admin_mark_cod_paid(current_setting('smoke.order1')::uuid);
    raise exception 'COD was marked paid before delivery';
  exception when others then
    if sqlerrm not like '%when the order is delivered%' then raise; end if;
  end;
END $$;

select public.admin_transition_order(:'order1', 'confirmed', null);
select public.admin_transition_order(:'order1', 'processing', null);
select public.admin_transition_order(:'order1', 'packed', null);
select public.admin_transition_order(:'order1', 'shipped', null);
select public.admin_transition_order(:'order1', 'out_for_delivery', null);
select public.admin_transition_order(:'order1', 'delivered', null);
select public.admin_mark_cod_paid(:'order1');

DO $$ BEGIN
  assert (select status from public.orders
           where id = current_setting('smoke.order1')::uuid) = 'delivered';
  assert (select status from public.payments
           where order_id = current_setting('smoke.order1')::uuid) = 'transaction_verified',
    'cash collected on delivery';
  assert (select paid_at from public.payments
           where order_id = current_setting('smoke.order1')::uuid) is not null;
  assert (select count(*) from public.notifications
           where recipient_id = '11111111-1111-1111-1111-111111111111') >= 7,
    'order status + payment notifications reached the customer';
  assert (select count(*) from public.audit_logs
           where action = 'admin_transition_order') = 6;
END $$;

-- ---------------------------------------------------------------- reviews (delivered order)
set request.jwt.claims to '{"sub":"11111111-1111-1111-1111-111111111111"}';

select oi.id as item1 from public.order_items oi
 where oi.order_id = :'order1'::uuid limit 1 \gset
select set_config('smoke.item1', :'item1', false) as _ \gset

select public.create_review(:'item1', 5, 'Great product');

DO $$ BEGIN
  begin
    perform public.create_review(current_setting('smoke.item1')::uuid, 3, 'dup');
    raise exception 'duplicate review was allowed';
  exception when others then
    if sqlerrm not like '%duplicate key%' then raise; end if;
  end;
END $$;

-- ---------------------------------------------------------------- cancel path restores stock
select public.cancel_order(:'order2', 'Changed my mind');

DO $$ BEGIN
  assert (select status from public.orders
           where id = current_setting('smoke.order2')::uuid) = 'cancelled';
  assert (select cancellation_reason from public.orders
           where id = current_setting('smoke.order2')::uuid) = 'Changed my mind';
  assert (select stock from public.products
           where id = current_setting('smoke.p_tee')::uuid) = 10,
    'cancellation restores stock';
END $$;

DO $$ BEGIN
  begin
    perform public.cancel_order(current_setting('smoke.order1')::uuid, 'late');
    raise exception 'delivered order was cancelled';
  exception when others then
    if sqlerrm not like '%can no longer be cancelled%' then raise; end if;
  end;
END $$;

-- ---------------------------------------------------------------- authorization
set request.jwt.claims to '{"sub":"22222222-2222-2222-2222-222222222222"}';
DO $$ BEGIN
  begin
    perform public.cancel_order(current_setting('smoke.order2')::uuid, 'not mine');
    raise exception 'another customer cancelled the order';
  exception when others then
    if sqlerrm not like '%Order not found%' then raise; end if;
  end;
END $$;

set request.jwt.claims to '{"sub":"11111111-1111-1111-1111-111111111111"}';
DO $$ BEGIN
  begin
    update public.users set active_role = 'admin'
     where id = '11111111-1111-1111-1111-111111111111';
    raise exception 'self-promotion was allowed';
  exception when others then
    if sqlerrm not like '%can only change via role applications%' then raise; end if;
  end;

  begin
    perform public.admin_mark_cod_paid(current_setting('smoke.order1')::uuid);
    raise exception 'non-admin marked cash paid';
  exception when others then
    if sqlerrm not like '%Only admins%' then raise; end if;
  end;

  begin
    perform public.get_sales_report(current_date, current_date);
    raise exception 'non-admin read the sales report';
  exception when others then
    if sqlerrm not like '%Only admins%' then raise; end if;
  end;
END $$;

-- ---------------------------------------------------------------- archived product is not purchasable
set request.jwt.claims to '{"sub":"44444444-4444-4444-4444-444444444444"}';
select public.admin_set_product_archived(:'p_tote', true);

set request.jwt.claims to '{"sub":"11111111-1111-1111-1111-111111111111"}';
DO $$ BEGIN
  begin
    perform public.add_cart_item(current_setting('smoke.v_tote')::uuid, 1);
    raise exception 'archived product was added to the cart';
  exception when others then
    if sqlerrm not like '%unavailable%' then raise; end if;
  end;
END $$;

set request.jwt.claims to '{"sub":"44444444-4444-4444-4444-444444444444"}';
select public.admin_set_product_archived(:'p_tote', false);

-- ---------------------------------------------------------------- admin search & reports
DO $$ BEGIN
  assert ((public.admin_search_products('Tote', null, null, null, null, null, null, null, null, null, 25, 0) ->> 'total_count')::int) = 1,
    'admin product search finds the tote';
  assert ((public.admin_search_orders('T-Shirt', null, null, null, null, null, null, null, null, null, false, false, 'newest', 25, 0) ->> 'total_count')::int) = 1,
    'admin order search matches the archived-then-live product line';
  assert ((public.admin_search_orders(null, null, null, array['delivered'], null, null, null, null, null, null, false, false, 'newest', 25, 0) ->> 'total_count')::int) = 1,
    'delivered filter returns the realized order';
END $$;

select public.get_admin_kpis() as kpis \gset
select set_config('smoke.kpis', :'kpis', false) as _ \gset
select public.get_sales_report(
  (now() at time zone public.store_timezone())::date,
  (now() at time zone public.store_timezone())::date
) as report \gset
select set_config('smoke.report', :'report', false) as _ \gset

DO $$ BEGIN
  assert (current_setting('smoke.kpis')::jsonb ->> 'total_orders')::int = 2;
  assert (current_setting('smoke.kpis')::jsonb ->> 'total_sales_minor')::int = 700,
    'revenue counts realized orders only';

  assert (current_setting('smoke.report')::jsonb ->> 'total_orders')::int = 2;
  assert (current_setting('smoke.report')::jsonb ->> 'completed_orders')::int = 1;
  assert (current_setting('smoke.report')::jsonb ->> 'cancelled_orders')::int = 1;
  assert (current_setting('smoke.report')::jsonb ->> 'realized_orders')::int = 1;
  assert (current_setting('smoke.report')::jsonb ->> 'total_sales_minor')::int = 700;
END $$;

\echo '=== ALL SMOKE TESTS PASSED ==='
