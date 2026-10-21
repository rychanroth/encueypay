-- Edge functions reach PostgREST as service_role. The QR payment flow
-- (payway-create stores the payload; payway-webhook reads the amount and
-- confirms) needs SELECT and UPDATE on payments, but the baseline's grant
-- round-up left service_role with only Dxtm — every function-side read
-- failed with 42501, silently swallowed by the old poller's ignored error.
GRANT SELECT, UPDATE ON TABLE public.payments TO service_role;
