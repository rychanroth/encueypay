# Handoff — QR payments: ABA PayWay (direct-Bakong path retired)

Read this before touching the QR payment flow. It records why the Bakong
polling path was retired, what the PayWay integration is pinned to, the
current state, and what remains. Supersedes the Bakong-era notes
(git history, ≤ `0ec1433`).

## 1. Why the Bakong path never confirmed — the full root-cause record

The symptom was always "scan → pay → the screen never flips". The QR
payload itself was fine (SDK-vector-pinned). Every failure was server-side
and invisible, because **every error was swallowed into `paid: false`**:

1. `BAKONG_TOKEN` never reached the edge function (it sat in app
   dart-defines) → `bakong-check` answered `configured: false` forever.
2. Even with a token, its MD5 lookup used the inline PostgREST expression
   `md5(qr_payload)` (forbidden by DATA-09) and ignored the response error.
3. Its success gate required `result.data.paid === true` — a field real
   Bakong responses do not carry (verified against three independent
   integrations; paid is `responseCode: 0`).
4. The kicker, found while wiring PayWay: **`service_role` had no
   SELECT/UPDATE grants on `payments`** (baseline left it `Dxtm` only), so
   every service-role read of the table failed with 42501 — silently.
   Fixed in `20261021000001_grant_service_role_payments.sql`.

Retirement is deliberate: PayWay is the production path (merchant account,
webhooks, no personal-account compliance problem). `KhqrGenerator` and
`bakong_account.dart` remain as test-covered units (admin settings still
validates with the latter); `bakong-check` and the client poll are gone.

## 2. Verification record (against AI-sourced advice)

- The "Bakong Open API: no webhooks, poll `check_transaction_by_md5`"
  write-up was **architecturally accurate** and matched what was built —
  the failure was wiring, not design. Nuances it omitted: `errorCode`
  semantics (1 not-found, 6 bad token) and out-of-Cambodia geo-blocking.
- The "July 2026 policy update / 100-transaction cap / NBC killed polling"
  write-up was **not verifiable** anywhere checkable (no NBC statement, no
  GitHub chatter, no quota error code in any SDK). The cited TFDevs video
  is real and says the free API was *restricted*, not removed. Its
  production recommendation (bank gateway + webhooks) was sound regardless
  — that is what this repo now does. Moral: verify specifics before
  architecting around them.

## 3. The PayWay flow (current design)

Pinned to the official Developer Suite: **developer.payway.com.kh**
(Apidog site — public; pages also serve `.md` versions).

```
Checkout (method=qr) → RPC create_order_from_cart → payments row (pending)
  └─ OrderPlacedScreen (one-shot, never from build())
       └─ payway-create (edge fn, service role)
            ├─ POST {PAYWAY_BASE_URL}/api/payment-gateway/v1/payments/generate-qr
            │    hash = base64(HMAC-SHA512(posted params in canonical order, API key))
            │    tran_id = first 20 chars of orderId minus dashes (PayWay cap)
            │    return_params = {"order_id": …}   ← echoed by the callback
            ├─ stores the returned KHQR on payments.qr_payload
            └─ returns it for immediate render (stream is the fallback path)
  └─ customer scans with any KHQR-supported banking app
  └─ payway-webhook (edge fn) ← PayWay JSON callback
       ├─ verifies X-PayWay-HMAC-SHA512 over values sorted by key
       ├─ maps order via return_params (never parses tran_id)
       ├─ amount check vs payments.amount_minor
       └─ confirm_qr_payment RPC (idempotent, pending-guarded)
            └─ realtime + 3s refetch → screen: "Payment received"
```

Update 2026-10-21: the admin "Simulate QR payment" path was removed
(migration `20261021000002` drops the RPC); `confirm_qr_payment` is now
service-role-only and the webhook is the sole settlement path.

## 4. Current state (verified against the local stack)

- Commits `091f0c4` (gitignore), `9b8e46b` (payway-create),
  `3f80889` (webhook rewrite + app rewiring + bakong-check deleted).
- `flutter analyze` clean; 35 tests pass (KHQR generator + TLV units
  untouched); `deno check` clean on both functions.
- Migration `20261021000001` applied locally (service_role grants).
- `supabase/config.toml` `[edge_runtime.secrets]` maps the four
  `PAYWAY_*` names to host env vars — **`supabase start` does not read
  `supabase/functions/.env` on its own**; start with:
  `set -a; source supabase/functions/.env; set +a; supabase start`.
  (Verified: with this, secrets DO reach the function container.)
- `supabase/functions/.env`: `PAYWAY_BASE_URL` correct
  (`https://checkout-sandbox.payway.com.kh`), `PAYWAY_MERCHANT_ID` set,
  **`PAYWAY_API_KEY` still empty — the one missing credential**.
- Smoke-test row seeded in the local DB: order
  `6c07040e-b093-4b07-8789-7036579cca5b` ($1.00, pending QR payment,
  throwaway user `payway-smoke@test.local`) — reuse it for the first
  invoke; delete the user/order afterwards.

## 5. Remaining steps (in order)

1. **Fill `PAYWAY_API_KEY`** in `supabase/functions/.env` — the portal
   field is confusingly labelled; PayWay's own PHP samples say
   `$api_key = "API KEY PROVIDED BY ABA BANK"` under a
   `// public key provided by ABA Bank` comment. The RSA keys are NOT it.
2. Restart as above → invoke locally:
   `curl -s -X POST http://127.0.0.1:54321/functions/v1/payway-create
   -H "Authorization: Bearer <anon>" -H 'Content-Type: application/json'
   -d '{"orderId":"6c07040e-…"}'`
   Expect `{configured:true, qrPayload:"000201…"}`. Failure reasons are
   explicit (`payway_error` + code): 1 wrong hash, 6/81 whitelist,
   23 option not enabled (→ profile lacks the QR API service; pivot to
   Purchase `abapay_khqr_deeplink`, same file), 403 duplicate tran_id.
3. Webhook dry-run: sign a callback body with the API key (HMAC-SHA512
   base64 over values sorted by key) and POST it with the
   `x-payway-hmac-sha512` header → payments row must flip to
   `transaction_verified`.
4. Real-scan test: the QR from step 2 is a live sandbox KHQR — scan it
   with a banking app → PayWay must POST the callback (needs the hosted
   deploy or a tunnel; sandbox callback_url is baked base64 into the
   generate-qr request, so set `PAYWAY_CALLBACK_URL` for tunnels).
5. Production checklist: hosted deploy (`REMOTE_SETUP.md` Phase 6:
   `supabase functions deploy payway-create payway-webhook` +
   `supabase secrets set …`), callback URL in the ABA portal, callback
   domain whitelisted with PayWay, production base URL + credentials,
   one real low-value transaction.

## 6. Gotchas

- **"Public Key" ≠ RSA public key** in PayWay-land — see step 1 above.
- `tran_id` ≤ 20 chars; UUIDs must be derived, and the callback mapping
  goes through `return_params`, never the truncated id.
- Success `status.code` is `"0"` (QR API) but `"00"` (Purchase JSON) —
  accept both.
- The callback signature concatenates JSON values sorted by key; number
  stringification must match PayWay's (PHP strval of the decoded JSON) —
  both sides round-trip the same JSON text, which is why amounts are sent
  as JSON numbers.
- Errors 6/81/102 = whitelisting; contact the PayWay integration team.
- Sandbox registration: sandbox.payway.com.kh → Merchant ID + API key by
  email. `check-transaction-2` (reconciliation, 600 req/s) is documented
  but intentionally not wired — the webhook is the confirmation path.
- KHQR display guidelines: the existing `KhqrCard` header already follows
  the red KHQR/BAKONG branding; PayWay also ships Figma templates if the
  store ever wants their `qrImage` (up to 0.5 MB — render `qrString`
  locally instead).

## 7. Key files

| Purpose | Path |
|---|---|
| QR initiation (signed generate-qr) | `supabase/functions/payway-create/index.ts` |
| Callback verifier (HMAC header, amount check, confirm) | `supabase/functions/payway-webhook/index.ts` |
| Repository method invoking the function | `lib/features/checkout/data/repository/checkout_repository_impl.dart` (`createPaywayQr`) |
| One-shot creation + stream (realtime + 3s refetch) | `lib/features/checkout/presentation/controllers/order_payment_controller.dart` |
| Payment screen (states, creation-failure notice, retry) | `lib/features/checkout/presentation/screens/order_placed_screen.dart` |
| Local secrets wiring | `supabase/config.toml` `[edge_runtime.secrets]` + `supabase/functions/.env` (gitignored) |
| service_role grants fix | `supabase/migrations/20261021000001_grant_service_role_payments.sql` |
| Retired-but-kept units | `lib/features/checkout/data/khqr_generator.dart`, `lib/core/domain/bakong_account.dart` (+ their tests) |
| PayWay docs (official, public) | https://developer.payway.com.kh — QR API, Purchase, Check transaction, Ecommerce Checkout |
