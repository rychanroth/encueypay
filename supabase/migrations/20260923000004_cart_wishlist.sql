-- Phase 3: shopping (spec §8, §38) — one active cart per customer, no
-- duplicate variant per cart; wishlists. Mutations that need get-or-create
-- or quantity arithmetic run through RPCs; RLS still scopes every row
-- (functions run as invoker).

create table public.carts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references public.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.cart_items (
  id uuid primary key default gen_random_uuid(),
  cart_id uuid not null references public.carts (id) on delete cascade,
  product_variant_id uuid not null references public.product_variants (id) on delete cascade,
  quantity integer not null check (quantity > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (cart_id, product_variant_id)
);

create table public.wishlists (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references public.users (id) on delete cascade,
  created_at timestamptz not null default now()
);

create table public.wishlist_items (
  id uuid primary key default gen_random_uuid(),
  wishlist_id uuid not null references public.wishlists (id) on delete cascade,
  product_id uuid not null references public.products (id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (wishlist_id, product_id)
);

alter table public.carts enable row level security;
alter table public.cart_items enable row level security;
alter table public.wishlists enable row level security;
alter table public.wishlist_items enable row level security;

create policy "carts_own_all" on public.carts
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "cart_items_own_all" on public.cart_items
  for all
  using (exists (select 1 from public.carts c where c.id = cart_id and c.user_id = auth.uid()))
  with check (exists (select 1 from public.carts c where c.id = cart_id and c.user_id = auth.uid()));

create policy "wishlists_own_all" on public.wishlists
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "wishlist_items_own_all" on public.wishlist_items
  for all
  using (exists (select 1 from public.wishlists w where w.id = wishlist_id and w.user_id = auth.uid()))
  with check (exists (select 1 from public.wishlists w where w.id = wishlist_id and w.user_id = auth.uid()));

-- Get-or-create the user's cart, then upsert-increment the item, capping at
-- available stock. Server-authoritative: only active variants of active
-- products at active businesses are addable (spec §53).
create or replace function public.add_cart_item(p_variant_id uuid, p_quantity integer)
returns void
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_cart uuid;
  v_stock integer;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  if p_quantity is null or p_quantity < 1 then
    raise exception 'Invalid quantity';
  end if;

  select pv.stock into v_stock
  from public.product_variants pv
  join public.products p on p.id = pv.product_id
  join public.businesses b on b.id = p.business_id
  where pv.id = p_variant_id
    and pv.status = 'active'
    and p.status = 'active'
    and b.status = 'active';
  if not found then
    raise exception 'Product is unavailable';
  end if;

  select id into v_cart from public.carts where user_id = v_user;
  if v_cart is null then
    insert into public.carts (user_id) values (v_user) returning id into v_cart;
  end if;

  insert into public.cart_items (cart_id, product_variant_id, quantity)
  values (v_cart, p_variant_id, least(p_quantity, v_stock))
  on conflict (cart_id, product_variant_id)
  do update set quantity = least(public.cart_items.quantity + excluded.quantity, v_stock);
end;
$$;

create or replace function public.update_cart_item(p_item_id uuid, p_quantity integer)
returns void
language plpgsql
as $$
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;
  if p_quantity is null or p_quantity < 1 then
    raise exception 'Invalid quantity';
  end if;

  update public.cart_items ci
  set quantity = p_quantity
  from public.carts c
  where c.id = ci.cart_id
    and c.user_id = auth.uid()
    and ci.id = p_item_id;
end;
$$;

create or replace function public.remove_cart_item(p_item_id uuid)
returns void
language plpgsql
as $$
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;

  delete from public.cart_items ci
  using public.carts c
  where c.id = ci.cart_id
    and c.user_id = auth.uid()
    and ci.id = p_item_id;
end;
$$;

create or replace function public.clear_cart()
returns void
language plpgsql
as $$
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;

  delete from public.cart_items ci
  using public.carts c
  where c.id = ci.cart_id
    and c.user_id = auth.uid();
end;
$$;

create trigger carts_touch_updated_at
  before update on public.carts
  for each row execute function public.touch_updated_at();

create trigger cart_items_touch_updated_at
  before update on public.cart_items
  for each row execute function public.touch_updated_at();
