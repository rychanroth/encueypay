-- Auto-expire unpaid QR orders.
--
-- A QR order is created `pending` with a `pending` payment so PayWay has an
-- order id and amount to reference. If the customer abandons the QR screen,
-- that order would otherwise hold stock indefinitely. This function cancels
-- only stale unpaid QR orders (never COD, bank-transfer, or paid QR rows)
-- and restores their reserved stock. Paid/verified payments are untouched.
--
-- Invocation: the app calls it lazily when the orders list loads; the
-- guarded pg_cron registration below adds a 5-minute schedule where the
-- extension is available (Supabase). No schedule is created on plain
-- PostgreSQL, where the lazy call remains the fallback.

CREATE OR REPLACE FUNCTION public.expire_unpaid_qr_orders(
    p_after interval DEFAULT '60 minutes'
) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_id uuid;
  v_count integer := 0;
  v_cutoff timestamptz := now()
    - greatest(coalesce(p_after, interval '60 minutes'), interval '1 minute');
begin
  for v_id in
    select o.id
      from public.orders o
      join public.payments p on p.order_id = o.id
     where o.status = 'pending'
       and p.method = 'qr'
       and p.status = 'pending'
       and o.created_at < v_cutoff
     order by o.created_at
     -- Serialize against confirm_qr_payment: a verified payment must never
     -- be cancelled by the cleanup pass.
     for update of o, p skip locked
  loop
    update public.orders
       set status = 'cancelled',
           cancellation_reason = 'QR payment expired',
           cancelled_at = now()
     where id = v_id
       and status = 'pending';
    if found then
      perform public.restore_order_stock(v_id);
      v_count := v_count + 1;
    end if;
  end loop;
  return v_count;
end;
$$;

REVOKE EXECUTE ON FUNCTION public.expire_unpaid_qr_orders(interval) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.expire_unpaid_qr_orders(interval)
  TO authenticated, service_role;

DO $$
begin
  if exists (select 1 from pg_available_extensions where name = 'pg_cron') then
    begin
      execute 'create extension if not exists pg_cron with schema extensions';
      execute $cron$select cron.schedule(
        'expire-unpaid-qr-orders',
        '*/5 * * * *',
        'select public.expire_unpaid_qr_orders()'
      )$cron$;
    exception when others then
      -- The app's lazy call still runs the cleanup; scheduling is optional.
      raise notice 'pg_cron scheduling unavailable: %', sqlerrm;
    end;
  end if;
end
$$;
