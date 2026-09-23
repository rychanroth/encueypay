-- Phase 0: application users (spec §36 `users`, §3 role model).
--
-- Every new auth account gets an application user row with
-- active_role = customer. Roles change ONLY through role applications
-- (Phase 10) — end users cannot alter active_role/account_status directly.

create type public.user_role as enum ('customer', 'business', 'driver', 'admin');
create type public.account_status as enum ('active', 'suspended', 'banned');

create table public.users (
  id uuid primary key references auth.users (id) on delete cascade,
  full_name text not null default '',
  avatar_url text,
  phone text,
  active_role public.user_role not null default 'customer',
  account_status public.account_status not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.users enable row level security;

-- Users see and edit their own profile. Insert happens only via the
-- security-definer trigger below; role/status changes are blocked by
-- trigger for end users (service role bypasses RLS for admin flows).
create policy "users_select_own" on public.users
  for select
  using (auth.uid() = id);

create policy "users_update_own" on public.users
  for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- Keep updated_at honest.
create or replace function public.touch_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger users_touch_updated_at
  before update on public.users
  for each row
  execute function public.touch_updated_at();

-- Create the application user when an auth user signs up (spec §57:
-- Registration -> Supabase Auth -> Application User -> active_role=customer).
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (id, full_name, avatar_url)
  values (
    new.id,
    coalesce(
      new.raw_user_meta_data ->> 'full_name',
      new.raw_user_meta_data ->> 'name',
      new.raw_user_meta_data ->> 'given_name',
      ''
    ),
    new.raw_user_meta_data ->> 'avatar_url'
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row
  execute function public.handle_new_user();

-- Authorization is server-side (spec §35): authenticated end users must not
-- be able to escalate their own role or flip account_status. Service-role
-- contexts (auth.uid() is null) pass through for admin flows.
create or replace function public.block_role_self_change()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is not null
     and (new.active_role, new.account_status)
         is distinct from (old.active_role, old.account_status) then
    raise exception
      'active_role/account_status can only change via role applications';
  end if;
  return new;
end;
$$;

create trigger users_block_role_self_change
  before update on public.users
  for each row
  execute function public.block_role_self_change();
