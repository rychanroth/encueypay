-- 2-Role Academic Prototype, Section 9b (living spec removal record): the
-- obsolete actor infrastructure is REMOVED (user mandate change 2026-10-05 —
-- obsolete code is deleted, not preserved for legacy compatibility).
--
-- Removed actors: Business Owner portal, Driver portal, role applications.
-- Kept (load-bearing, admin-driven): businesses, business_orders,
-- deliveries, pickup_stops — the fulfillment + tracking engine the customer
-- still sees and the admin still drives.
--
-- NOTE: this migration also fixes a latent gap — the admin orders oversight
-- embedded business_orders/deliveries/pickup_stops/return_requests without
-- admin SELECT policies, so those embeds came back empty. Admin read
-- branches are added here.

-- ------------------------------------------------ admin read/write authority
-- The admin fulfillment RPCs are INVOKER functions with explicit is_admin()
-- checks; they need row policies now that the owner policies are dropped.
create policy "products_admin_all" on public.products
  for all
  using (public.is_admin())
  with check (public.is_admin());

create policy "product_variants_admin_all" on public.product_variants
  for all
  using (public.is_admin())
  with check (public.is_admin());

create policy "businesses_admin_all" on public.businesses
  for all
  using (public.is_admin())
  with check (public.is_admin());

create policy "business_orders_admin_read" on public.business_orders
  for select
  using (public.is_admin());

create policy "deliveries_admin_read" on public.deliveries
  for select
  using (public.is_admin());

create policy "pickup_stops_admin_read" on public.pickup_stops
  for select
  using (public.is_admin());

create policy "return_requests_admin_read" on public.return_requests
  for select
  using (public.is_admin());

create policy "return_items_admin_read" on public.return_items
  for select
  using (public.is_admin());

-- ------------------------------------------------------- owner policy drops
drop policy if exists "products_owner_all" on public.products;
drop policy if exists "product_variants_owner_all" on public.product_variants;
drop policy if exists "product_images_owner_all" on public.product_images;
drop policy if exists "businesses_owner_update" on public.businesses;
drop policy if exists "businesses_owner_insert" on public.businesses;
drop policy if exists "business_orders_owner_update" on public.business_orders;
drop policy if exists "business_orders_driver_update" on public.business_orders;
drop policy if exists "deliveries_driver_update" on public.deliveries;
drop policy if exists "pickup_stops_driver_update" on public.pickup_stops;
drop policy if exists "payments_driver_update" on public.payments;
drop policy if exists "orders_driver_select" on public.orders;
drop policy if exists "business_orders_driver_select" on public.business_orders;
drop policy if exists "users_driver_read" on public.users;

drop policy if exists "product_images_owner_write" on storage.objects;
drop policy if exists "product_images_owner_delete" on storage.objects;

-- Driver branches removed from the shared read policies; customer access is
-- untouched, admin gains its (previously missing) branch.
drop policy if exists "deliveries_read" on public.deliveries;
create policy "deliveries_read" on public.deliveries
  for select using (
    exists (select 1 from public.orders o where o.id = order_id and o.customer_id = auth.uid())
    or public.is_admin()
  );

drop policy if exists "pickup_stops_read" on public.pickup_stops;
create policy "pickup_stops_read" on public.pickup_stops
  for select using (
    exists (
      select 1 from public.deliveries d
      join public.orders o on o.id = d.order_id
      where d.id = delivery_id
        and (o.customer_id = auth.uid() or public.is_admin())
    )
  );

-- --------------------------------------------------- superseded RPC removals
-- Business portal (superseded by the admin catalog/fulfillment RPCs):
drop function if exists public.create_business(text, text, text);
drop function if exists public.update_my_business(text, text);
drop function if exists public.create_product(uuid, text, text, bigint, jsonb);
drop function if exists public.update_product(uuid, uuid, text, text, bigint);
drop function if exists public.set_product_archived(uuid, boolean);
drop function if exists public.add_product_variant(uuid, text, bigint);
drop function if exists public.update_product_variant(uuid, text, bigint);
drop function if exists public.set_variant_image(uuid, text);
drop function if exists public.add_product_image(uuid, text);
drop function if exists public.transition_business_order(uuid, public.business_order_status, text);
drop function if exists public.get_business_analytics();
drop function if exists public.get_business_transactions(date);
drop function if exists public.create_coupon_promotion(text, text, public.discount_type, bigint, text, timestamptz);

-- Driver portal (superseded by admin_ship_order / admin_complete_order):
drop function if exists public.accept_delivery(uuid);
drop function if exists public.reject_delivery(uuid);
drop function if exists public.complete_pickup_stop(uuid);
drop function if exists public.start_delivery(uuid);
drop function if exists public.mark_delivered(uuid);
drop function if exists public.get_driver_transactions(date);

-- Business return processing (superseded by admin_process_return) and the
-- business banner submission path (superseded by admin_create_banner below):
drop function if exists public.process_return(uuid, boolean);
drop function if exists public.submit_banner(text, text, text, timestamptz);

-- Driver helpers and visibility functions:
drop function if exists public.driver_can_view_delivery(uuid);
drop function if exists public.driver_can_view_order(uuid);
drop function if exists public.driver_can_view_user(uuid);
drop function if exists public.driver_can_view_business_order(uuid);
drop function if exists public.is_driver();

-- ------------------------------------------------------------- notifications
-- The business-owner "New order received" insert had no recipient once the
-- portal was removed; the customer notification stays.
create or replace function public.notify_on_business_order_created()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_customer uuid;
begin
  select customer_id into v_customer from public.orders where id = new.order_id;
  perform public.notify(
    v_customer, 'order', 'Order placed',
    'Your order has been received and is awaiting confirmation.');
  return new;
end;
$$;

-- -------------------------------------------------------- platform report
-- pending_applications is gone with the applications flow.
create or replace function public.get_platform_report()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'order_count', (select count(*) from public.orders),
    'gmv_minor', (select coalesce(sum(total_minor), 0) from public.orders),
    'delivery_fees_minor', (
      select coalesce(sum(delivery_fee_minor), 0) from public.orders
    ),
    'active_businesses', (
      select count(*) from public.businesses where status = 'active'
    ),
    'active_products', (
      select count(*) from public.products where status = 'active'
    )
  );
$$;

-- ------------------------------------------------------ admin banner upload
-- With the business portal removed the admin creates home banners directly
-- (approved on creation; moderation remains available).
create or replace function public.admin_create_banner(
  p_name text,
  p_description text,
  p_image_url text,
  p_starts_at timestamptz default null,
  p_ends_at timestamptz default null
)
returns uuid
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
  v_banner_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can create banners';
  end if;
  if coalesce(trim(p_name), '') = '' then
    raise exception 'Banner name is required';
  end if;

  insert into public.banners
    (created_by, name, description, image_path, starts_at, ends_at, status)
  values
    (v_actor, trim(p_name), coalesce(p_description, ''), p_image_url,
     p_starts_at, p_ends_at, 'approved')
  returning id into v_banner_id;

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor, 'admin_banner_created', 'banner', v_banner_id,
          jsonb_build_object('name', trim(p_name)));

  return v_banner_id;
end;
$$;
