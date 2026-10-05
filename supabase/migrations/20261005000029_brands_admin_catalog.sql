-- 2-Role Academic Prototype, Section 2b (living spec Part B §2/§3/§8).
--
-- Brands: the assignment requires brand as a product attribute (§3) and a
-- search/filter dimension (§2). A dedicated brands table keeps brands
-- independent of the bypassed vendor model: the admin populates brands and
-- products; products keep business_id underneath for pricing/checkout.
--
-- Admin product management (spec §8 "manages Products"): the admin creates
-- and edits products under a designated store business, mirroring the
-- business-portal RPC shape (create_product auto-creates a 'Default' variant
-- so carts stay strictly variant-based; the null price tracks the product's
-- base price). The original owner-guarded RPCs remain in force untouched for
-- the (hidden) business portal — ledger L-08/L-09.

-- ------------------------------------------------------------------- brands
create table public.brands (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  description text not null default '',
  status public.product_status not null default 'active',
  created_at timestamptz not null default now()
);

alter table public.brands enable row level security;

-- Customers browse active brands only; the admin manages all (policies are
-- OR'd, mirroring categories_admin_* / products_public_read_active).
create policy "brands_public_read_active" on public.brands
  for select
  using (status = 'active');

create policy "brands_admin_read" on public.brands
  for select
  using (public.is_admin());

create policy "brands_admin_insert" on public.brands
  for insert
  with check (public.is_admin());

create policy "brands_admin_update" on public.brands
  for update
  using (public.is_admin())
  with check (public.is_admin());

create policy "brands_admin_delete" on public.brands
  for delete
  using (public.is_admin());

alter table public.products
  add column brand_id uuid references public.brands (id) on delete set null;

create index products_brand_idx on public.products (brand_id, status);
create index brands_status_idx on public.brands (status, name);

-- Admin reads every product regardless of status (moderation view: archived
-- products stay visible); the public read policy only exposes active ones.
create policy "products_admin_read" on public.products
  for select
  using (public.is_admin());

-- Admin manages product image rows directly (mirrors product_images_owner_all
-- for the store-business owner). The storage-object policies above govern the
-- binaries; this one governs the reference rows.
create policy "product_images_admin_all" on public.product_images
  for all
  using (public.is_admin())
  with check (public.is_admin());

-- ------------------------------------------------- admin product management
-- Explicit admin authority (living spec ledger: L-08 removal). INVOKER on
-- purpose — is_admin() is the security-definer helper from 0019, so the
-- checks cannot recurse.

create or replace function public.admin_create_product(
  p_business_id uuid,
  p_category_id uuid,
  p_name text,
  p_description text,
  p_base_price_minor bigint,
  p_brand_id uuid default null,
  p_variants jsonb default '[]'::jsonb
)
returns uuid
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
  v_product_id uuid;
  v_variant record;
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage products';
  end if;
  if coalesce(trim(p_name), '') = '' then
    raise exception 'Product name is required';
  end if;
  if p_base_price_minor < 0 then
    raise exception 'Invalid price';
  end if;
  if not exists (
    select 1 from public.businesses b where b.id = p_business_id
  ) then
    raise exception 'Business not found';
  end if;
  if not exists (
    select 1 from public.categories c where c.id = p_category_id
  ) then
    raise exception 'Category not found';
  end if;
  if p_brand_id is not null and not exists (
    select 1 from public.brands br where br.id = p_brand_id
  ) then
    raise exception 'Brand not found';
  end if;

  insert into public.products
    (business_id, category_id, brand_id, name, description, base_price_minor)
  values
    (p_business_id, p_category_id, p_brand_id, trim(p_name),
     coalesce(p_description, ''), p_base_price_minor)
  returning id into v_product_id;

  if jsonb_array_length(p_variants) = 0 then
    -- Keep carts strictly variant-based: auto 'Default' variant whose null
    -- price falls back to (and keeps tracking) the product's base price.
    insert into public.product_variants (product_id, name, price_minor)
    values (v_product_id, 'Default', null);
  else
    for v_variant in select * from jsonb_to_recordset(p_variants)
        as x(name text, price_minor bigint)
    loop
      insert into public.product_variants (product_id, name, price_minor)
      values (v_product_id, v_variant.name, v_variant.price_minor);
    end loop;
  end if;

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor, 'admin_product_created', 'product', v_product_id,
          jsonb_build_object('name', trim(p_name), 'business_id', p_business_id));

  return v_product_id;
end;
$$;

create or replace function public.admin_update_product(
  p_product_id uuid,
  p_category_id uuid,
  p_name text,
  p_description text,
  p_base_price_minor bigint,
  p_brand_id uuid default null
)
returns void
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage products';
  end if;
  if coalesce(trim(p_name), '') = '' then
    raise exception 'Product name is required';
  end if;
  if p_base_price_minor < 0 then
    raise exception 'Invalid price';
  end if;
  if p_brand_id is not null and not exists (
    select 1 from public.brands br where br.id = p_brand_id
  ) then
    raise exception 'Brand not found';
  end if;

  update public.products p
  set category_id = p_category_id,
      brand_id = p_brand_id,
      name = trim(p_name),
      description = coalesce(p_description, ''),
      base_price_minor = p_base_price_minor,
      updated_at = now()
  where p.id = p_product_id;
  if not found then
    raise exception 'Product not found';
  end if;

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor, 'admin_product_updated', 'product', p_product_id,
          jsonb_build_object('name', trim(p_name)));
end;
$$;

create or replace function public.admin_set_product_archived(
  p_product_id uuid,
  p_archived boolean
)
returns void
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage products';
  end if;

  update public.products p
  set status = case
        when p_archived then 'archived'::public.product_status
        else 'active'::public.product_status
      end,
      updated_at = now()
  where p.id = p_product_id;
  if not found then
    raise exception 'Product not found';
  end if;

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor,
          case when p_archived then 'admin_product_archived'
               else 'admin_product_activated' end,
          'product', p_product_id, null);
end;
$$;

-- Mirrors add_product_image (0020) with admin authority.
create or replace function public.admin_add_product_image(
  p_product_id uuid,
  p_storage_path text
)
returns uuid
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
  v_image_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage products';
  end if;

  insert into public.product_images (product_id, storage_path, sort_order)
  values (
    p_product_id,
    p_storage_path,
    coalesce((
      select max(sort_order) + 1
      from public.product_images
      where product_id = p_product_id
    ), 0)
  )
  returning id into v_image_id;

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor, 'admin_product_image_added', 'product', p_product_id,
          jsonb_build_object('storage_path', p_storage_path));

  return v_image_id;
end;
$$;

-- Admin uploads product images into the public product_images bucket under
-- any business folder (the {business_id}/... path convention is owned by the
-- designated store business). Additive to 0020's owner policies.
create policy "product_images_admin_write" on storage.objects
  for insert with check (
    bucket_id = 'product_images'
    and public.is_admin()
  );

create policy "product_images_admin_delete" on storage.objects
  for delete using (
    bucket_id = 'product_images'
    and public.is_admin()
  );
