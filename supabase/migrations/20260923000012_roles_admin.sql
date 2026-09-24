-- Phase 10: role applications (spec §3, §35.4) + admin management.
--
-- Exactly one pending application per user; submitting again replaces the
-- previous pending one. Approval is the ONLY path that changes
-- active_role (blocked elsewhere since Phase 0). Admin gets explicit
-- management authority: categories, platform settings, audit reads —
-- never operational order/delivery overrides.

create type public.role_application_status as enum ('pending', 'approved', 'rejected');

create table public.role_applications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  requested_role public.user_role not null
    check (requested_role in ('business', 'driver')),
  status public.role_application_status not null default 'pending',
  decision_reason text,
  reviewed_by uuid references public.users (id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index role_applications_one_pending
  on public.role_applications (user_id)
  where status = 'pending';

alter table public.role_applications enable row level security;

create policy "role_applications_own_read" on public.role_applications
  for select using (auth.uid() = user_id);

create policy "role_applications_own_insert" on public.role_applications
  for insert with check (auth.uid() = user_id);

create policy "role_applications_admin_read" on public.role_applications
  for select using (public.is_admin());

-- Audit + history: admin read (§46).
create policy "audit_logs_admin_read" on public.audit_logs
  for select using (public.is_admin());

create policy "state_history_admin_read" on public.state_history
  for select using (public.is_admin());

-- Platform settings: admin managed.
create policy "platform_settings_admin_update" on public.platform_settings
  for update using (public.is_admin()) with check (public.is_admin());

-- Categories: admin managed (public read exists since Phase 2).
create policy "categories_admin_insert" on public.categories
  for insert with check (public.is_admin());

create policy "categories_admin_update" on public.categories
  for update using (public.is_admin()) with check (public.is_admin());

create policy "categories_admin_delete" on public.categories
  for delete using (public.is_admin());

create trigger role_applications_touch_updated_at
  before update on public.role_applications
  for each row execute function public.touch_updated_at();

-- Submit a role application (§3). A new submission replaces any previous
-- pending application.
create or replace function public.submit_role_application(p_requested_role text)
returns uuid
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_role public.user_role;
  v_application_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  v_role := coalesce(p_requested_role, '')::public.user_role;
  if v_role not in ('business', 'driver') then
    raise exception 'Invalid requested role';
  end if;
  if exists (
    select 1 from public.users
    where id = v_user and active_role = v_role
  ) then
    raise exception 'You already have this role';
  end if;

  delete from public.role_applications
  where user_id = v_user and status = 'pending';

  insert into public.role_applications (user_id, requested_role)
  values (v_user, v_role)
  returning id into v_application_id;
  return v_application_id;
end;
$$;

-- Admin review: approval flips active_role (security definer — the admin
-- RPC needs to write the users row; the role check is inside).
create or replace function public.review_role_application(
  p_application_id uuid,
  p_approve boolean,
  p_reason text default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_application public.role_applications;
begin
  if not public.is_admin() then
    raise exception 'Only admins can review applications';
  end if;

  select * into v_application
  from public.role_applications
  where id = p_application_id and status = 'pending';
  if not found then
    raise exception 'Application is already decided';
  end if;

  update public.role_applications
  set status = case when p_approve then 'approved'::public.role_application_status
                    else 'rejected'::public.role_application_status end,
      decision_reason = p_reason,
      reviewed_by = auth.uid()
  where id = p_application_id;

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (
    auth.uid(),
    case when p_approve then 'role_application.approved'
         else 'role_application.rejected' end,
    'role_application',
    p_application_id,
    jsonb_build_object('requested_role', v_application.requested_role,
                       'user_id', v_application.user_id)
  );

  if p_approve then
    -- auth.uid() resolves to the CALLER even inside security-definer
    -- functions (JWT claims are connection-scoped), so the role-guard
    -- trigger on users would reject this update. Clear the claims
    -- transaction-locally: the is_admin() check above is the authority.
    perform set_config('request.jwt.claims', '', true);
    update public.users
    set active_role = v_application.requested_role
    where id = v_application.user_id;
  end if;
end;
$$;

-- Admin category management (§2.4).
create or replace function public.create_category(p_name text, p_parent_id uuid default null)
returns uuid
language plpgsql
as $$
declare
  v_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage categories';
  end if;
  if coalesce(trim(p_name), '') = '' then
    raise exception 'Category name is required';
  end if;
  insert into public.categories (name, parent_id)
  values (trim(p_name), p_parent_id)
  returning id into v_id;
  return v_id;
end;
$$;

create or replace function public.rename_category(p_category_id uuid, p_name text)
returns void
language plpgsql
as $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage categories';
  end if;
  update public.categories set name = trim(p_name) where id = p_category_id;
  if not found then
    raise exception 'Category not found';
  end if;
end;
$$;

create or replace function public.delete_category(p_category_id uuid)
returns void
language plpgsql
as $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage categories';
  end if;
  begin
    delete from public.categories where id = p_category_id;
  exception when foreign_key_violation then
    raise exception 'Category is in use by products or has subcategories';
  end;
  if not found then
    raise exception 'Category not found';
  end if;
end;
$$;
