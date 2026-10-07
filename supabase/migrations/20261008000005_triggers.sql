-- Bridge M5/6 — order-lifecycle triggers (pivot map §7).
--
-- The baseline recorded state and notified customers through the
-- business_orders/deliveries tables; those are gone. The single lifecycle
-- now lives on orders.status, and payments carry their own refund states.
--
-- Kept from the baseline: record_return_state + notify_customer_on_return
-- (return_requests triggers) and all *_touch_updated_at triggers. New:
-- brands gets the touch trigger alongside its updated_at column.

-- -------------------------------------------------------- orders: state
CREATE OR REPLACE FUNCTION "public"."orders_record_state"() RETURNS trigger
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
begin
  if new.status is distinct from old.status then
    insert into public.state_history (entity_type, entity_id, from_state, to_state, actor)
    values ('order', new.id, old.status::text, new.status::text, auth.uid());
  end if;
  return new;
end;
$$;

-- ------------------------------------------------- orders: customer notify
CREATE OR REPLACE FUNCTION "public"."orders_notify_status"() RETURNS trigger
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
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
      when 'returned' then
        v_title := 'Order returned';
        v_content := 'Your order was returned.';
      else
        -- 'pending' is the creation state; no notification.
        return new;
    end case;
    perform public.notify(new.customer_id, 'order', v_title, v_content);
  end if;
  return new;
end;
$$;

-- ----------------------------------------------- payments: customer notify
CREATE OR REPLACE FUNCTION "public"."payments_notify_status"() RETURNS trigger
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
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
      when 'refund_required' then
        v_title := 'Refund pending';
        v_content := 'A refund is pending for your order.';
      when 'refunded' then
        v_title := 'Refund recorded';
        v_content := 'Your refund was recorded.';
      else
        return new;
    end case;
    perform public.notify(v_customer, 'order', v_title, v_content);
  end if;
  return new;
end;
$$;

-- ------------------------------------------------------- attach triggers
CREATE OR REPLACE TRIGGER "orders_record_state"
  AFTER UPDATE ON "public"."orders" FOR EACH ROW
  EXECUTE FUNCTION "public"."orders_record_state"();

CREATE OR REPLACE TRIGGER "orders_notify_status"
  AFTER UPDATE ON "public"."orders" FOR EACH ROW
  EXECUTE FUNCTION "public"."orders_notify_status"();

CREATE OR REPLACE TRIGGER "payments_notify_status"
  AFTER UPDATE ON "public"."payments" FOR EACH ROW
  EXECUTE FUNCTION "public"."payments_notify_status"();

-- ------------------------------------------------------- brands: touch
CREATE OR REPLACE TRIGGER "brands_touch_updated_at" BEFORE UPDATE ON "public"."brands"
  FOR EACH ROW EXECUTE FUNCTION "public"."touch_updated_at"();
