-- Customer onboarding completion (first-run explainer + name/phone step).
--
-- Null means the customer has never finished onboarding; the router redirects
-- them to `/onboarding` after sign-in. Admins/staff are never gated.
--
-- Backfill existing identities so only genuinely new customers see the intro
-- on their next session. New rows keep the column's null default (the
-- `handle_new_user()` trigger does not set it).

alter table public.users
  add column if not exists onboarded_at timestamp with time zone;

comment on column public.users.onboarded_at is
  'When the customer completed the first-run onboarding. Null = not yet onboarded.';

update public.users
set onboarded_at = now()
where onboarded_at is null;
