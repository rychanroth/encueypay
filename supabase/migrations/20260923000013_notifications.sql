-- Phase 11: notifications (spec §30) + device tokens (FCM schema, unused
-- until approved) + realtime publications. Realtime is a synchronization
-- signal, never the source of truth (§31/§54).

create type public.notification_type as enum
  ('order', 'delivery', 'return', 'promotion', 'role', 'system');

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  recipient_id uuid not null references public.users (id) on delete cascade,
  type public.notification_type not null default 'system',
  title text not null,
  content text not null default '',
  read boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.device_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  token text not null unique,
  platform text not null default 'unknown',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index notifications_recipient_idx
  on public.notifications (recipient_id, read, created_at desc);

alter table public.notifications enable row level security;
alter table public.device_tokens enable row level security;

create policy "notifications_own_all" on public.notifications
  for all using (auth.uid() = recipient_id)
  with check (auth.uid() = recipient_id);

create policy "device_tokens_own_all" on public.device_tokens
  for all using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create trigger device_tokens_touch_updated_at
  before update on public.device_tokens
  for each row execute function public.touch_updated_at();

-- Notification dispatcher (§30): domain state changes create records.
create or replace function public.notify(
  p_recipient uuid,
  p_type public.notification_type,
  p_title text,
  p_content text default ''
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_recipient is null then
    return;
  end if;
  insert into public.notifications (recipient_id, type, title, content)
  values (p_recipient, p_type, p_title, p_content);
end;
$$;

-- Business incoming order (§31: realtime area 1).
create or replace function public.notify_business_new_order()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_owner uuid;
  v_customer uuid;
begin
  select b.owner_id into v_owner
  from public.businesses b where b.id = new.business_id;
  select o.customer_id into v_customer
  from public.orders o where o.id = new.order_id;

  perform public.notify(
    v_owner, 'order',
    'New order received',
    'You have a new order to review.'
  );
  perform public.notify(
    v_customer, 'order',
    'Order placed',
    'Your order was sent to the business.'
  );
  return new;
end;
$$;

create trigger notify_on_business_order_created
  after insert on public.business_orders
  for each row
  execute function public.notify_business_new_order();

-- Business order lifecycle changes → customer (§31: realtime area 3).
create or replace function public.notify_customer_on_business_order()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_customer uuid;
begin
  if new.status is distinct from old.status then
    select o.customer_id into v_customer
    from public.orders o where o.id = new.order_id;
    perform public.notify(
      v_customer, 'order',
      'Order update: ' || new.status::text,
      'One of your businesses moved your order to ' || new.status::text || '.'
    );
  end if;
  return new;
end;
$$;

create trigger notify_on_business_order_status
  after update on public.business_orders
  for each row
  execute function public.notify_customer_on_business_order();

-- Delivery assignment/progress → customer (§31: realtime area 4).
create or replace function public.notify_customer_on_delivery()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_customer uuid;
begin
  if new.status is distinct from old.status then
    select o.customer_id into v_customer
    from public.orders o where o.id = new.order_id;
    perform public.notify(
      v_customer, 'delivery',
      'Delivery update: ' || new.status::text,
      'Your delivery status changed.'
    );
  end if;
  return new;
end;
$$;

create trigger notify_on_delivery_status
  after update on public.deliveries
  for each row
  execute function public.notify_customer_on_delivery();

-- Return decisions → customer.
create or replace function public.notify_customer_on_return()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.status is distinct from old.status then
    perform public.notify(
      new.customer_id, 'return',
      'Return ' || new.status::text,
      'Your return request was ' || new.status::text || '.'
    );
  end if;
  return new;
end;
$$;

create trigger notify_on_return_status
  after update on public.return_requests
  for each row
  execute function public.notify_customer_on_return();

-- Mark-read RPCs.
create or replace function public.mark_notification_read(p_notification_id uuid)
returns void
language plpgsql
as $$
begin
  update public.notifications
  set read = true
  where id = p_notification_id and recipient_id = auth.uid();
end;
$$;

create or replace function public.mark_all_notifications_read()
returns void
language plpgsql
as $$
begin
  update public.notifications
  set read = true
  where recipient_id = auth.uid() and not read;
end;
$$;
