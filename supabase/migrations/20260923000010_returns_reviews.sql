-- Phase 8: returns (spec §28) + reviews (spec §29) + their audit trail.
--
-- Returns: customer submits after delivery; quantities capped at purchased;
-- the business owning the products decides (§28.1). Approval marks verified
-- bank-transfer payments RefundRequired (actual refunds stay outside the
-- MVP). Reviews: max one per purchased OrderItem, server-verified (§29).

create type public.return_status as enum ('pending', 'approved', 'rejected');

create table public.return_requests (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders (id) on delete cascade,
  customer_id uuid not null references public.users (id),
  status public.return_status not null default 'pending',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.return_items (
  id uuid primary key default gen_random_uuid(),
  return_request_id uuid not null references public.return_requests (id) on delete cascade,
  order_item_id uuid not null references public.order_items (id),
  quantity integer not null check (quantity > 0),
  reason text not null default '',
  status public.return_status not null default 'pending',
  created_at timestamptz not null default now()
);

create table public.reviews (
  id uuid primary key default gen_random_uuid(),
  order_item_id uuid not null unique references public.order_items (id) on delete cascade,
  product_id uuid not null references public.products (id) on delete cascade,
  customer_id uuid not null references public.users (id),
  rating integer not null check (rating between 1 and 5),
  text text not null default '',
  created_at timestamptz not null default now()
);

create index return_requests_order_idx on public.return_requests (order_id);
create index return_items_request_idx on public.return_items (return_request_id);
create index reviews_product_idx on public.reviews (product_id, created_at desc);

alter table public.return_requests enable row level security;
alter table public.return_items enable row level security;
alter table public.reviews enable row level security;

create policy "return_requests_read" on public.return_requests
  for select using (
    auth.uid() = customer_id
    or exists (
      select 1
      from public.return_items ri
      join public.order_items oi on oi.id = ri.order_item_id
      join public.business_orders bo on bo.id = oi.business_order_id
      join public.businesses b on b.id = bo.business_id
      where ri.return_request_id = return_requests.id
        and b.owner_id = auth.uid()
    )
  );
create policy "return_requests_customer_insert" on public.return_requests
  for insert with check (auth.uid() = customer_id);

create policy "return_items_read" on public.return_items
  for select using (
    exists (
      select 1 from public.return_requests rr
      where rr.id = return_request_id
        and (rr.customer_id = auth.uid()
             or exists (
               select 1
               from public.order_items oi
               join public.business_orders bo on bo.id = oi.business_order_id
               join public.businesses b on b.id = bo.business_id
               where oi.id = return_items.order_item_id
                 and b.owner_id = auth.uid()
             ))
    )
  );
create policy "return_items_customer_insert" on public.return_items
  for insert with check (
    exists (
      select 1 from public.return_requests rr
      where rr.id = return_request_id and rr.customer_id = auth.uid()
    )
  );

create policy "reviews_public_read" on public.reviews
  for select using (true);
create policy "reviews_customer_insert" on public.reviews
  for insert with check (auth.uid() = customer_id);

create trigger return_requests_touch_updated_at
  before update on public.return_requests
  for each row execute function public.touch_updated_at();

create or replace function public.record_return_state()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.status is distinct from old.status then
    insert into public.state_history (entity_type, entity_id, from_state, to_state, actor)
    values ('return_request', new.id, old.status::text, new.status::text, auth.uid());
  end if;
  return new;
end;
$$;

create trigger return_requests_record_state
  after update on public.return_requests
  for each row
  execute function public.record_return_state();

-- Customer submits a return (§28): delivered orders only, quantities capped
-- at purchased, items must belong to the caller's order.
create or replace function public.request_return(p_order_id uuid, p_items jsonb)
returns uuid
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_request_id uuid;
  v_item record;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  if not exists (
    select 1 from public.orders o
    join public.deliveries d on d.order_id = o.id
    where o.id = p_order_id
      and o.customer_id = v_user
      and d.status = 'delivered'
  ) then
    raise exception 'Only delivered orders can be returned';
  end if;
  if exists (
    select 1 from public.return_requests
    where order_id = p_order_id and status = 'pending'
  ) then
    raise exception 'A return request is already pending for this order';
  end if;

  insert into public.return_requests (order_id, customer_id)
  values (p_order_id, v_user)
  returning id into v_request_id;

  for v_item in select * from jsonb_to_recordset(p_items)
      as x(order_item_id uuid, quantity integer, reason text)
  loop
    if not exists (
      select 1 from public.order_items oi
      join public.business_orders bo on bo.id = oi.business_order_id
      where oi.id = v_item.order_item_id
        and bo.order_id = p_order_id
        and v_item.quantity > 0
        and v_item.quantity <= oi.quantity
    ) then
      raise exception 'Invalid return quantity';
    end if;
    insert into public.return_items
      (return_request_id, order_item_id, quantity, reason)
    values (v_request_id, v_item.order_item_id, v_item.quantity,
            coalesce(v_item.reason, ''));
  end loop;

  return v_request_id;
end;
$$;

-- The business owning the returned products decides (§28.1).
create or replace function public.process_return(p_return_id uuid, p_approve boolean)
returns void
language plpgsql
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

-- One review per purchased OrderItem, server-verified (§29).
create or replace function public.create_review(
  p_order_item_id uuid,
  p_rating integer,
  p_text text
)
returns uuid
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_product_id uuid;
  v_review_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  if p_rating < 1 or p_rating > 5 then
    raise exception 'Rating must be between 1 and 5';
  end if;

  select oi.product_id into v_product_id
  from public.order_items oi
  join public.business_orders bo on bo.id = oi.business_order_id
  join public.orders o on o.id = bo.order_id
  where oi.id = p_order_item_id and o.customer_id = v_user;
  if not found then
    raise exception 'You can only review purchased items';
  end if;

  insert into public.reviews (order_item_id, product_id, customer_id, rating, text)
  values (p_order_item_id, v_product_id, v_user, p_rating, coalesce(p_text, ''))
  returning id into v_review_id;
  return v_review_id;
end;
$$;
