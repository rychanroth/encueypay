-- Phase 5a: terminal delivery state for cancelled orders (customer
-- cancellation, §12). Separate migration because PostgreSQL cannot use an
-- enum value in the same transaction that adds it.

alter type public.delivery_status add value if not exists 'cancelled' after 'delivered';
