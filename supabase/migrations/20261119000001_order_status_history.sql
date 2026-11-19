-- Customer-visible order status history (2026-11-19).
--
-- state_history already records every orders.status transition
-- (entity_type = 'order', from_state/to_state, created_at) through the
-- orders_record_state trigger, but its RLS policy is admin-only. The customer
-- timeline could therefore show the lifecycle without saying when each step
-- happened. This SECURITY DEFINER read exposes the same rows, scoped to the
-- caller's own order (admins may read any order).
--
-- The initial 'pending' state produces no transition row (the trigger fires
-- only on a status change), so it is synthesized from orders.created_at.

CREATE OR REPLACE FUNCTION public.get_order_status_history(p_order_id uuid)
RETURNS TABLE (status text, changed_at timestamp with time zone)
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  with target as (
    select o.id, o.created_at
    from public.orders o
    where o.id = p_order_id
      and (o.customer_id = auth.uid() or public.is_admin())
  ),
  transitions as (
    select h.to_state::text as status, h.created_at as changed_at
    from public.state_history h
    join target t on t.id = h.entity_id
    where h.entity_type = 'order'
  ),
  seeded as (
    select 'pending'::text as status, t.created_at as changed_at
    from target t
    where not exists (
      select 1 from transitions where transitions.status = 'pending'
    )
  )
  select status, changed_at from transitions
  union all
  select status, changed_at from seeded
  order by changed_at;
$$;

comment on function public.get_order_status_history(uuid) is
  'Order lifecycle transitions with their timestamps, readable by the order owner and admins. Synthesizes the initial pending state from orders.created_at.';
