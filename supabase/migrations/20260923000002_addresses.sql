-- Phase 1: user addresses (spec §17 — mutable, user-owned records;
-- checkout later copies a snapshot into the order).

create table public.addresses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  label text not null default 'Home',
  recipient_name text not null,
  phone text not null default '',
  line1 text not null,
  line2 text,
  city text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index addresses_user_id_idx on public.addresses (user_id, created_at);

alter table public.addresses enable row level security;

create policy "addresses_select_own" on public.addresses
  for select using (auth.uid() = user_id);

create policy "addresses_insert_own" on public.addresses
  for insert with check (auth.uid() = user_id);

create policy "addresses_update_own" on public.addresses
  for update using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "addresses_delete_own" on public.addresses
  for delete using (auth.uid() = user_id);

-- reuse touch_updated_at from migration 0001
create trigger addresses_touch_updated_at
  before update on public.addresses
  for each row
  execute function public.touch_updated_at();
