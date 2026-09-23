-- Phase 2: catalog (spec §5, §36–37) — categories, businesses, products,
-- variants, images. Public read for active catalog data; writes arrive with
-- the business portal (Phase 6). Money columns are bigint minor units
-- (spec §22).

create type public.product_status as enum ('active', 'archived');
create type public.business_status as enum ('pending', 'active', 'suspended');

create table public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  parent_id uuid references public.categories (id) on delete set null,
  created_at timestamptz not null default now()
);

create table public.businesses (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null unique references public.users (id) on delete cascade,
  name text not null,
  description text not null default '',
  image_url text,
  status public.business_status not null default 'pending',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.products (
  id uuid primary key default gen_random_uuid(),
  business_id uuid not null references public.businesses (id) on delete cascade,
  category_id uuid not null references public.categories (id) on delete restrict,
  name text not null,
  description text not null default '',
  base_price_minor bigint not null check (base_price_minor >= 0),
  stock integer not null default 0 check (stock >= 0),
  status public.product_status not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.product_variants (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products (id) on delete cascade,
  name text not null,
  attributes jsonb not null default '{}'::jsonb,
  -- null price → falls back to the product's base price (spec §5.3)
  price_minor bigint check (price_minor is null or price_minor >= 0),
  stock integer not null default 0 check (stock >= 0),
  status public.product_status not null default 'active',
  created_at timestamptz not null default now()
);

-- Storage owns the binary file; this table owns the reference (spec §48).
create table public.product_images (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products (id) on delete cascade,
  storage_path text not null,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

create index categories_parent_idx on public.categories (parent_id);
create index products_business_idx on public.products (business_id, status);
create index products_category_idx on public.products (category_id, status);
create index products_created_idx on public.products (status, created_at desc);
create index product_variants_product_idx on public.product_variants (product_id, status);
create index product_images_product_idx on public.product_images (product_id, sort_order);

alter table public.categories enable row level security;
alter table public.businesses enable row level security;
alter table public.products enable row level security;
alter table public.product_variants enable row level security;
alter table public.product_images enable row level security;

create policy "categories_public_read" on public.categories
  for select using (true);

create policy "businesses_public_read_active" on public.businesses
  for select using (status = 'active');

-- Owners must see their own business regardless of status (used by Phase 6).
create policy "businesses_owner_read" on public.businesses
  for select using (auth.uid() = owner_id);

create policy "products_public_read_active" on public.products
  for select using (
    status = 'active'
    and exists (
      select 1 from public.businesses b
      where b.id = business_id and b.status = 'active'
    )
  );

create policy "product_variants_public_read_active" on public.product_variants
  for select using (
    status = 'active'
    and exists (
      select 1 from public.products p
      where p.id = product_id and p.status = 'active'
    )
  );

create policy "product_images_public_read" on public.product_images
  for select using (true);

-- reuse touch_updated_at from migration 0001
create trigger businesses_touch_updated_at
  before update on public.businesses
  for each row execute function public.touch_updated_at();

create trigger products_touch_updated_at
  before update on public.products
  for each row execute function public.touch_updated_at();

-- Public catalog images bucket (uploads gated in Phase 6).
insert into storage.buckets (id, name, public)
values ('product_images', 'product_images', true)
on conflict (id) do nothing;

create policy "product_images_bucket_public_read" on storage.objects
  for select using (bucket_id = 'product_images');
