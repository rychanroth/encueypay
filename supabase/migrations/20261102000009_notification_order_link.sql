-- Notifications gain an optional order link so an order notification can
-- deep-link straight to its OrderDetail. Existing rows keep NULL (they still
-- open the inbox); every new order/payment notification carries the id.
--
-- The lifecycle is unchanged: a verified QR payment still only flips the
-- payment row; an admin manually moves the order pending → confirmed →
-- processing.

ALTER TABLE "public"."notifications"
  ADD COLUMN IF NOT EXISTS "order_id" uuid
  REFERENCES "public"."orders"("id") ON DELETE SET NULL;

-- Signature change: drop the old 4-arg overload first (CREATE OR REPLACE
-- would add an overload and break the call sites).
DROP FUNCTION IF EXISTS "public"."notify"(uuid, "public"."notification_type", text, text);

CREATE OR REPLACE FUNCTION "public"."notify"(
    "p_recipient" uuid,
    "p_type" "public"."notification_type",
    "p_title" text,
    "p_content" text DEFAULT ''::text,
    "p_order_id" uuid DEFAULT NULL
) RETURNS void
    LANGUAGE plpgsql
    SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
begin
  if p_recipient is null then
    return;
  end if;
  insert into public.notifications (recipient_id, type, title, content, order_id)
  values (p_recipient, p_type, p_title, p_content, p_order_id);
end;
$$;

-- ---------------------------------------------------- orders: customer notify
CREATE OR REPLACE FUNCTION "public"."orders_notify_status"() RETURNS trigger
    LANGUAGE plpgsql
    SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_title text;
  v_content text;
begin
  if new.status is distinct from old.status then
    case new.status
      when 'confirmed' then
        v_title := 'Order confirmed';
        v_content := 'Your order has been confirmed.';
      when 'processing' then
        v_title := 'Order processing';
        v_content := 'Your order is being processed.';
      when 'packed' then
        v_title := 'Order packed';
        v_content := 'Your order has been packed.';
      when 'shipped' then
        v_title := 'Order shipped';
        v_content := 'Your order has shipped.';
      when 'out_for_delivery' then
        v_title := 'Out for delivery';
        v_content := 'Your order is out for delivery.';
      when 'delivered' then
        v_title := 'Order delivered';
        v_content := 'Your order was delivered.';
      when 'cancelled' then
        v_title := 'Order cancelled';
        v_content := 'Your order was cancelled.';
      else
        -- 'pending' is the creation state; no notification.
        return new;
    end case;
    perform public.notify(
      new.customer_id, 'order', v_title, v_content, new.id);
  end if;
  return new;
end;
$$;

-- ----------------------------------------------- payments: customer notify
CREATE OR REPLACE FUNCTION "public"."payments_notify_status"() RETURNS trigger
    LANGUAGE plpgsql
    SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_customer uuid;
  v_title text;
  v_content text;
begin
  if new.status is distinct from old.status then
    select o.customer_id into v_customer
      from public.orders o
     where o.id = new.order_id;

    if v_customer is null then
      return new;
    end if;

    case new.status
      when 'transaction_verified' then
        v_title := 'Payment received';
        v_content := 'We received your payment.';
      else
        return new;
    end case;
    perform public.notify(
      v_customer, 'order', v_title, v_content, new.order_id);
  end if;
  return new;
end;
$$;
