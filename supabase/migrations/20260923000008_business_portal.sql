-- Phase 6: business portal (spec §2.2, §6–§7, §11, §13, §46).
--
-- The spec defines GetMyBusiness/UpdateMyBusiness but no CreateBusiness op —
-- per the ratified decision, a business user completes an onboarding wizard
-- that calls create_business. Product creation auto-creates a 'Default'
-- variant when none is supplied so carts stay strictly variant-based (§8).
-- State transitions are server-validated; rejection releases reserved stock
-- (§13). Audit logs + state history land here (§46).

-- ---------------------------------------------------------------- ownership
create or replace function public.block_business_status_self_change()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is not null
     and new.status is distinct from old.status then
    raise exception 'business status is admin-managed';
  end if;
  return new;
end;
$$;

create trigger businesses_block_status_self_change
  before update on public.businesses
  for each row
  execute function public.block_business_status_self_change();

create policy "businesses_owner_update" on public.businesses
  for update
  using (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);

-- Owner-managed catalog rows (all statuses visible to the owner).
create policy "products_owner_all" on public.products
  for all
  using (exists (select 1 from public.businesses b where b.id = business_id and b.owner_id = auth.uid()))
  with check (exists (select 1 from public.businesses b where b.id = business_id and b.owner_id = auth.uid()));

create policy "product_variants_owner_all" on public.product_variants
  for all
  using (exists (
    select 1 from public.products p
    join public.businesses b on b.id = p.business_id
    where p.id = product_id and b.owner_id = auth.uid()
  ))
  with check (exists (
    select 1 from public.products p
    join public.businesses b on b.id = p.business_id
    where p.id = product_id and b.owner_id = auth.uid()
  ));

create policy "product_images_owner_all" on public.product_images
  for all
  using (exists (
    select 1 from public.products p
    join public.businesses b on b.id = p.business_id
    where p.id = product_id and b.owner_id = auth.uid()
  ))
  with check (exists (
    select 1 from public.products p
    join public.businesses b on b.id = p.business_id
    where p.id = product_id and b.owner_id = auth.uid()
  ));

-- ---------------------------------------------------------------- RPCs
create or replace function public.create_business(p_name text, p_description text, p_image_url text default null)
returns uuid
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  if coalesce(trim(p_name), '') = '' then
    raise exception 'Business name is required';
  end if;

  insert into public.businesses (owner_id, name, description, status, image_url)
  values (v_user, trim(p_name), coalesce(p_description, ''), 'active', p_image_url)
  returning id into v_id;
  return v_id;
end;
$$;

create or replace function public.update_my_business(p_name text, p_description text)
returns void
language plpgsql
as $$
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;
  update public.businesses
  set name = trim(p_name), description = coalesce(p_description, '')
  where owner_id = auth.uid();
  if not found then
    raise exception 'No business found';
  end if;
end;
$$;

create or replace function public.create_product(
  p_category_id uuid,
  p_name text,
  p_description text,
  p_base_price_minor bigint,
  p_stock integer,
  p_variants jsonb default '[]'::jsonb
)
returns uuid
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_business_id uuid;
  v_product_id uuid;
  v_variant record;
  v_total_stock integer := 0;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  select id into v_business_id from public.businesses where owner_id = v_user;
  if v_business_id is null then
    raise exception 'No business found';
  end if;
  if p_base_price_minor < 0 or p_stock < 0 then
    raise exception 'Invalid price or stock';
  end if;

  insert into public.products (business_id, category_id, name, description, base_price_minor, stock)
  values (v_business_id, p_category_id, trim(p_name), coalesce(p_description, ''), p_base_price_minor, p_stock)
  returning id into v_product_id;

  if jsonb_array_length(p_variants) = 0 then
    -- Keep carts strictly variant-based (§8): auto 'Default' variant.
    insert into public.product_variants (product_id, name, price_minor, stock)
    values (v_product_id, 'Default', null, p_stock);
  else
    for v_variant in select * from jsonb_to_recordset(p_variants)
        as x(name text, price_minor bigint, stock integer)
    loop
      if v_variant.stock < 0 then
        raise exception 'Invalid variant stock';
      end if;
      insert into public.product_variants (product_id, name, price_minor, stock)
      values (v_product_id, v_variant.name, v_variant.price_minor, v_variant.stock);
      v_total_stock := v_total_stock + v_variant.stock;
    end loop;
    update public.products set stock = v_total_stock where id = v_product_id;
  end if;

  return v_product_id;
end;
$$;

create or replace function public.update_product(
  p_product_id uuid,
  p_category_id uuid,
  p_name text,
  p_description text,
  p_base_price_minor bigint
)
returns void
language plpgsql
as $$
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;
  update public.products p
  set category_id = p_category_id,
      name = trim(p_name),
      description = coalesce(p_description, ''),
      base_price_minor = p_base_price_minor
  from public.businesses b
  where b.id = p.business_id
    and b.owner_id = auth.uid()
    and p.id = p_product_id;
  if not found then
    raise exception 'Product not found';
  end if;
end;
$$;

create or replace function public.set_product_archived(p_product_id uuid, p_archived boolean)
returns void
language plpgsql
as $$
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;
  update public.products p
  set status = case when p_archived then 'archived'::public.product_status else 'active'::public.product_status end
  from public.businesses b
  where b.id = p.business_id and b.owner_id = auth.uid() and p.id = p_product_id;
  if not found then
    raise exception 'Product not found';
  end if;
end;
$$;

-- Manual stock correction (§7): no external warehouse integration in MVP.
create or replace function public.update_variant_stock(p_variant_id uuid, p_stock integer)
returns void
language plpgsql
as $$
declare
  v_product_id uuid;
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;
  if p_stock < 0 then
    raise exception 'Invalid stock';
  end if;

  select pv.product_id into v_product_id
  from public.product_variants pv
  join public.products p on p.id = pv.product_id
  join public.businesses b on b.id = p.business_id
  where pv.id = p_variant_id and b.owner_id = auth.uid();
  if v_product_id is null then
    raise exception 'Variant not found';
  end if;

  update public.product_variants set stock = p_stock where id = p_variant_id;

  update public.products p
  set stock = coalesce((select sum(v.stock) from public.product_variants v where v.product_id = p.id), 0)
  where p.id = v_product_id;
end;
$$;

-- Business order lifecycle (§11): pending → accepted → preparing → ready.
-- Completion happens when the driver completes the pickup stop (Phase 7).
create or replace function public.transition_business_order(
  p_business_order_id uuid,
  p_target public.business_order_status,
  p_reason text default null
)
returns void
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_current public.business_order_status;
  v_valid boolean;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;

  select bo.status into v_current
  from public.business_orders bo
  join public.businesses b on b.id = bo.business_id
  where bo.id = p_business_order_id and b.owner_id = v_user;
  if not found then
    raise exception 'Business order not found';
  end if;

  v_valid := (v_current, p_target) in
    ( ('pending', 'accepted'),
      ('pending', 'rejected'),
      ('accepted', 'preparing'),
      ('preparing', 'ready') );
  if not v_valid then
    raise exception 'Cannot move business order from % to %', v_current, p_target;
  end if;
  if p_target = 'rejected' and coalesce(trim(p_reason), '') = '' then
    raise exception 'Rejection reason is required';
  end if;

  update public.business_orders
  set status = p_target,
      rejection_reason = p_reason
  where id = p_business_order_id;

  -- Rejection releases reserved stock (§13)...
  if p_target = 'rejected' then
    update public.product_variants pv
    set stock = pv.stock + oi.quantity
    from public.order_items oi
    where oi.business_order_id = p_business_order_id
      and pv.id = oi.product_variant_id;

    -- ...and a verified bank transfer becomes RefundRequired (§13/§21) —
    -- but only when every business portion of the order is dead (no
    -- partial refunds in the MVP).
    update public.payments p
    set status = 'refund_required'::public.payment_status
    where p.order_id = (select order_id from public.business_orders where id = p_business_order_id)
      and p.method = 'bank_transfer'
      and p.status = 'transaction_verified'
      and not exists (
        select 1 from public.business_orders other
        where other.order_id = p.order_id
          and other.id <> p_business_order_id
          and other.status not in ('rejected', 'cancelled')
      );
  end if;
end;
$$;

-- ---------------------------------------------------------------- audit
create table public.audit_logs (
  id uuid primary key default gen_random_uuid(),
  actor uuid,
  action text not null,
  target_type text not null,
  target_id uuid,
  metadata jsonb,
  created_at timestamptz not null default now()
);

create table public.state_history (
  id uuid primary key default gen_random_uuid(),
  entity_type text not null,
  entity_id uuid not null,
  from_state text,
  to_state text not null,
  actor uuid,
  created_at timestamptz not null default now()
);

alter table public.audit_logs enable row level security;
alter table public.state_history enable row level security;
-- No client policies yet — service role + admin reads land in Phase 10.

create or replace function public.record_business_order_state()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.status is distinct from old.status then
    insert into public.state_history (entity_type, entity_id, from_state, to_state, actor)
    values ('business_order', new.id, old.status::text, new.status::text, auth.uid());
    insert into public.audit_logs (actor, action, target_type, target_id)
    values (auth.uid(), 'business_order.' || new.status::text, 'business_order', new.id);
  end if;
  return new;
end;
$$;

create trigger business_orders_record_state
  after update on public.business_orders
  for each row
  execute function public.record_business_order_state();

-- ---------------------------------------------------------------- storage
insert into storage.buckets (id, name, public)
values ('business_images', 'business_images', true)
on conflict (id) do nothing;

create policy "business_images_bucket_read" on storage.objects
  for select using (bucket_id = 'business_images');

create policy "business_images_owner_write" on storage.objects
  for insert with check (
    bucket_id = 'business_images'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "product_images_owner_write" on storage.objects
  for insert with check (
    bucket_id = 'product_images'
    and exists (
      select 1 from public.businesses b
      where b.id::text = (storage.foldername(name))[1]
        and b.owner_id = auth.uid()
    )
  );
