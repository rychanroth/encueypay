-- Fix: RLS applies to embedded tables. The admin applications screen embeds
-- users(full_name) off role_applications_admin_read, but users only allowed
-- select-own, so every embedded applicant resolved to null ("Applicant").
create policy "users_admin_read" on public.users
  for select
  using (public.is_admin());
