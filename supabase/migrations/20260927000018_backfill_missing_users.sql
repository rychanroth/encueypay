-- Fix: accounts whose public.users row is missing — either created before
-- the handle_new_user trigger existed (migration 20260923000001), or whose
-- row was deleted later (e.g. a supabase db reset that kept a stale app
-- session, or manual test-data cleanup).
--
-- The auth identity survives, so the session works, but any FK-gated write
-- fails: businesses.owner_id references public.users(id), so onboarding's
-- create_business dies with "violates foreign key constraint
-- businesses_owner_id_fkey". A re-login does NOT self-heal — the trigger
-- fires only on auth.users INSERT.
--
-- Backfill mirrors handle_new_user's metadata extraction. Idempotent:
-- no-op for accounts that already have a profile row, and on scratch
-- replays where auth.users is empty. Roles stay 'customer' — promotion
-- still goes through role applications.
insert into public.users (id, full_name, avatar_url)
select
  au.id,
  coalesce(
    au.raw_user_meta_data ->> 'full_name',
    au.raw_user_meta_data ->> 'name',
    au.raw_user_meta_data ->> 'given_name',
    ''
  ),
  au.raw_user_meta_data ->> 'avatar_url'
from auth.users au
where not exists (select 1 from public.users u where u.id = au.id)
on conflict (id) do nothing;
