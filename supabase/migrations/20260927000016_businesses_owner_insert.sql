-- Fix: onboarding RPC create_business inserts as the calling `authenticated`
-- user (invoker's rights); businesses had SELECT/UPDATE policies but no
-- INSERT policy, so every onboarding submit failed with "new row violates
-- row-level security policy for table businesses".
create policy "businesses_owner_insert" on public.businesses
  for insert
  with check (auth.uid() = owner_id);
