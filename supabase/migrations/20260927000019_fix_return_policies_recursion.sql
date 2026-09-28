-- Fix: "infinite recursion detected in policy" on return_requests/return_items
-- and stack-depth exhaustion in is_admin()/is_driver() for non-admins.
--
-- 1. return_requests_read USING-subqueried return_items, and return_items_read
--    USING-subqueried return_requests. RLS applies to every table referenced
--    inside a policy expression, so each policy re-entered the other's policy
--    forever — any authenticated select on either table raised "infinite
--    recursion detected in policy". The owner path (the only multi-table
--    branch) moves into a SECURITY DEFINER helper: queries inside it run as
--    the owner (RLS bypassed), terminating the cycle. The customer branch
--    stays an inline column check — see the note in section 1 for why.
--
-- 2. is_admin()/is_driver() are language sql functions reading the
--    RLS-protected public.users, and users_admin_read's USING calls
--    is_admin(). For a non-admin, evaluating any other user's row re-entered
--    is_admin() → users scan → is_admin() … until "stack depth limit
--    exceeded". Making them SECURITY DEFINER (with a pinned search_path, per
--    the Supabase function-hardening lint) reads users exactly once.
--
-- 3. process_return updates return_requests, return_items and payments, but
--    none of those tables have UPDATE policies — as SECURITY INVOKER the
--    updates matched zero rows, so Approve/Reject silently did nothing. The
--    function already authorizes the caller (owner of a business referenced
--    by a returned item, §28.1), so it runs as definer. auth.uid() inside
--    still resolves from the request JWT, not the definer role.

-- ─────────────────────────────────────────────────────────────────────────────
-- 1. Returns visibility helper + cycle-free policies
--
-- The customer branch stays an INLINE column check (not inside the helper):
-- request_return inserts with `insert ... returning id`, and RETURNING
-- evaluates the SELECT policy against the not-yet-committed row within the
-- statement snapshot — a stable helper cannot see that row, so the helper
-- only ever handles the owner path, which reads committed data.
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.owns_returned_items(p_return_request_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.return_items ri
    join public.order_items oi on oi.id = ri.order_item_id
    join public.business_orders bo on bo.id = oi.business_order_id
    join public.businesses b on b.id = bo.business_id
    where ri.return_request_id = p_return_request_id
      and b.owner_id = auth.uid()
  );
$$;

drop policy if exists "return_requests_read" on public.return_requests;
drop policy if exists "return_items_read" on public.return_items;
-- interim helper from this migration's first draft (superseded below)
drop function if exists public.can_view_return_request(uuid);

create policy "return_requests_read" on public.return_requests
  for select using (
    auth.uid() = customer_id
    or public.owns_returned_items(id)
  );

create policy "return_items_read" on public.return_items
  for select using (
    exists (
      select 1 from public.return_requests rr
      where rr.id = return_request_id and rr.customer_id = auth.uid()
    )
    or public.owns_returned_items(return_request_id)
  );

-- ─────────────────────────────────────────────────────────────────────────────
-- 2. Policy helpers must not re-enter RLS on the tables they read
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.users
    where id = auth.uid() and active_role = 'admin'
  );
$$;

create or replace function public.is_driver()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.users
    where id = auth.uid() and active_role = 'driver'
  );
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- 3. process_return must be able to persist its decision
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.process_return(p_return_id uuid, p_approve boolean)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user uuid := auth.uid();
  v_order_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;

  -- The caller must own a business referenced by at least one returned item.
  if not exists (
    select 1
    from public.return_items ri
    join public.order_items oi on oi.id = ri.order_item_id
    join public.business_orders bo on bo.id = oi.business_order_id
    join public.businesses b on b.id = bo.business_id
    where ri.return_request_id = p_return_id
      and b.owner_id = v_user
  ) then
    raise exception 'Return request not found';
  end if;

  select order_id into v_order_id
  from public.return_requests
  where id = p_return_id and status = 'pending';
  if not found then
    raise exception 'Return request is already decided';
  end if;

  update public.return_requests
  set status = case when p_approve then 'approved'::public.return_status
                    else 'rejected'::public.return_status end
  where id = p_return_id;

  update public.return_items
  set status = case when p_approve then 'approved'::public.return_status
                    else 'rejected'::public.return_status end
  where return_request_id = p_return_id and status = 'pending';

  if p_approve then
    update public.payments p
    set status = 'refund_required'::public.payment_status
    where p.order_id = v_order_id
      and p.method = 'bank_transfer'
      and p.status = 'transaction_verified';
  end if;
end;
$$;
