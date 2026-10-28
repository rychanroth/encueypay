-- Order model simplification (single-vendor prototype — user decision):
--   1. Returns/refunds are removed entirely. The payment flow has no
--      real-money path (sandbox simulator), and customer-service refund
--      handling is out of scope. Tables, RPCs, triggers, notification
--      branches and the return_status type are dropped.
--   2. Customer cancellation rule: cancel_order now rejects QR orders whose
--      payment is no longer pending — a paid QR order cannot be cancelled
--      by the customer because nothing refunds it. COD stays cancellable
--      through 'confirmed' (cash is collected at the door). The admin path
--      (admin_transition_order) is unchanged; a cancelled QR-paid order
--      keeps its payment row as-is (production refunds happen out-of-band
--      in PayWay's portal).
--   3. payments_customer_all narrowed FOR ALL -> SELECT: customers had
--      PostgREST UPDATE on their own payment rows (status included) — the
--      only legit write paths are the SECURITY DEFINER RPCs
--      (confirm_qr_payment, submit_payment_proof).

-- ------------------------------------------------------------ returns: RPCs
DROP FUNCTION IF EXISTS public.request_return(p_order_id uuid, p_items jsonb);
DROP FUNCTION IF EXISTS public.admin_process_return(p_return_id uuid, p_approve boolean);
DROP FUNCTION IF EXISTS public.admin_complete_return(p_return_id uuid);
DROP FUNCTION IF EXISTS public.mark_refunded(p_order_id uuid, p_reference text);

-- --------------------------------------------------- returns: triggers + fns
DROP TRIGGER IF EXISTS notify_on_return_status ON public.return_requests;
DROP TRIGGER IF EXISTS return_requests_record_state ON public.return_requests;
DROP TRIGGER IF EXISTS return_requests_touch_updated_at ON public.return_requests;
DROP FUNCTION IF EXISTS public.notify_customer_on_return();
DROP FUNCTION IF EXISTS public.record_return_state();

-- ------------------------------------------------------- returns: tables
DROP TABLE IF EXISTS public.return_items CASCADE;
DROP TABLE IF EXISTS public.return_requests CASCADE;
DROP TYPE IF EXISTS public.return_status;

-- ------------------------------------------ payments: notify without refunds
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
      else
        return new;
    end case;
    perform public.notify(v_customer, 'order', v_title, v_content);
  end if;
  return new;
end;
$$;

-- ------------------------------------------- orders: notify without returned
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
      else
        -- 'pending' is the creation state; no notification.
        return new;
    end case;
    perform public.notify(new.customer_id, 'order', v_title, v_content);
  end if;
  return new;
end;
$$;

-- ------------------------------------------------- cancel_order: QR-unpaid rule
CREATE OR REPLACE FUNCTION public.cancel_order(
    p_order_id uuid,
    p_reason text DEFAULT 'Cancelled by customer'
) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_user uuid := auth.uid();
  v_status public.order_status;
  v_method public.payment_method;
  v_payment_status public.payment_status;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;

  select o.status, p.method, p.status
    into v_status, v_method, v_payment_status
  from public.orders o
  left join public.payments p on p.order_id = o.id
  where o.id = p_order_id and o.customer_id = v_user;
  if not found then
    raise exception 'Order not found';
  end if;
  if v_status not in ('pending', 'confirmed') then
    raise exception 'Order can no longer be cancelled';
  end if;
  -- A paid QR order cannot be cancelled by the customer: refunds are out
  -- of scope. COD cash is collected at the door; an unpaid QR has nothing
  -- to refund.
  if v_method = 'qr' and v_payment_status <> 'pending' then
    raise exception 'Paid QR orders cannot be cancelled';
  end if;

  update public.orders
     set status = 'cancelled',
         cancellation_reason = coalesce(p_reason, 'Cancelled by customer'),
         cancelled_at = now()
   where id = p_order_id;

  perform public.restore_order_stock(p_order_id);
end;
$$;

-- --------------------------------------------------- payments: RLS narrowed
DROP POLICY "payments_customer_all" ON "public"."payments";
CREATE POLICY "payments_customer_select" ON "public"."payments"
  FOR SELECT
  USING (EXISTS ( SELECT 1
     FROM "public"."orders" "o"
    WHERE (("o"."id" = "payments"."order_id") AND ("o"."customer_id" = "auth"."uid"()))));
