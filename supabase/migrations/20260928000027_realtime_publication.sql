-- Realtime postgres_changes only delivers for tables in the
-- supabase_realtime publication — and no table was ever added to it. Every
-- .stream() subscription (notifications, order/delivery watch signals)
-- therefore errored seconds after its initial PostgREST snapshot: the
-- notifications screen showed its rows briefly, then "No notifications yet."
-- when the channel error arrived masked as an empty state. Add the four
-- streamed tables. RLS continues to gate what each subscriber receives.
do $$
declare
  t text;
begin
  -- The publication exists in a real Supabase stack; the scratch harness
  -- (vanilla Postgres + stub) needs it created.
  if not exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    create publication supabase_realtime;
  end if;
  foreach t in array array['notifications', 'orders', 'deliveries', 'business_orders'] loop
    if not exists (
      select 1 from pg_publication_tables
      where pubname = 'supabase_realtime'
        and schemaname = 'public'
        and tablename = t
    ) then
      execute format('alter publication supabase_realtime add table public.%I', t);
    end if;
  end loop;
end
$$;
