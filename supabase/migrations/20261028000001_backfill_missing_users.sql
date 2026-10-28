-- Ghost auth accounts: auth.users rows created before the
-- on_auth_user_created trigger existed (handle_new_user() shipped in the
-- baseline with no trigger attached; the trigger landed in
-- 20261008000001) have no public.users row. The auth repository masks the
-- gap with a fallback profile, but every table keyed on public.users
-- (wishlists.user_id FK) rejects their writes with 23503 — silently, until
-- the wishlist error-surfacing fix. The backfill mirrors
-- handle_new_user()'s exact column mapping and is idempotent; the trigger
-- is re-asserted so the gap cannot silently reappear on any environment.

insert into public.users (id, full_name, avatar_url)
select au.id,
       coalesce(
         au.raw_user_meta_data ->> 'full_name',
         au.raw_user_meta_data ->> 'name',
         au.raw_user_meta_data ->> 'given_name',
         ''
       ),
       au.raw_user_meta_data ->> 'avatar_url'
from auth.users au
where not exists (
  select 1 from public.users u where u.id = au.id
);

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
