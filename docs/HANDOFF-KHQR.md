# Handoff — QR payments: ABA PayWay

Read this before touching the QR payment flow. It records the design
decision, what is pinned to the official docs, the current state, and what
remains.

## 1. Design decision (why PayWay)

QR settlement runs through **ABA PayWay** (merchant gateway, webhook push).
The earlier direct-Bakong polling path never produced a confirmation in
practice — unwired token, a DATA-09-breaking MD5 select, an impossible
response gate, and service_role grants missing on `payments` (fixed in
`20261021000001`) — and a merchant gateway is the correct production path
anyway. Decision 2026-10-21: all Bakong-era artifacts are deleted or
dropped — `bakong-check`, the client poll, `KhqrGenerator` +
`bakong_account.dart` (+ their tests), the `register_qr_payment` RPC,
`payments.qr_md5`, `platform_settings.qr_account_id`, and the admin
simulate shortcut (`20261021000002`; `confirm_qr_payment` is
EXECUTE-locked to service_role — the webhook is the sole settlement path).
Do not revive direct Bakong without a new decision.

## 2. The flow

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

## 3. Current state (verified against the local stack — smoke test PASSED)

- Commits `091f0c4` (gitignore), `9b8e46b` (payway-create),
  `3f80889` (webhook rewrite + app rewiring), `2f851a0` (grants + secrets
  wiring + docs), `c8d5185` (full Bakong-era removal), plus the
  create-hardening commit (global try/catch; tran_id unique per creation —
  PayWay rejects duplicate tran_ids with 403, and QRs regenerate after
  their 60-min lifetime).
- `flutter analyze` clean; 23 tests pass; `deno check` clean on both
  functions; migrations applied locally through `20261021000003`.
- **Verified live 2026-10-22**: `payway-create` against the real sandbox
  returned a 241-char dynamic KHQR (stored on `payments.qr_payload`) —
  merchant id, API key, and the hash implementation are all accepted.
  A signed callback dry-run through `payway-webhook` flipped the row to
  `transaction_verified` (HMAC verified, `return_params` mapping works,
  amount check works). Remaining untested: PayWay's own HTTP callback
  (needs the hosted deploy — the baked callback_url is the local stack's
  address) and a real phone scan.
- `supabase/config.toml` `[edge_runtime.secrets]` maps the four `PAYWAY_*`
  names to host env vars — **`supabase start` does not read
  `supabase/functions/.env` on its own**; start with:
  `set -a; source config/.env; source supabase/functions/.env; set +a; supabase start`
  (BOTH files: `config/.env` also feeds the OAuth providers — starting
  without it silently breaks Google sign-in with a Google-side 400.)
  Do NOT `docker restart` the edge runtime to reload code — it drops the
  injected secrets; restart via the CLI with the env sourced.
- `supabase/functions/.env`: all three values set (sandbox URL,
  merchant `ec463018`, API key). The key's validity was extended by
  PayWay on request (originally "valid until 17 January 2026").
- Smoke-test rows seeded locally (throwaway user
  `payway-smoke2@test.local`): order `8e1406fc-9589-4197-8cdf-b6748e5cb2a3`
  ($1.00, pending, live QR payload attached) and a real app order the
  smoke flow accidentally stamped and then cleaned (`ff8b0ecc-…`,
  `qr_payload` re-cleared). Delete both when done testing.

## 4. Remaining steps (in order)

1. **Hosted deploy** (`REMOTE_SETUP.md` Phase 6):
   `supabase functions deploy payway-create payway-webhook` +
   `supabase secrets set PAYWAY_BASE_URL=… PAYWAY_MERCHANT_ID=… PAYWAY_API_KEY=…`.
   This is what makes PayWay's own HTTP callback reachable (the sandbox
   baked callback_url currently points at the local stack's address).
2. In the ABA PayWay portal: set the callback URL to
   `https://<ref>.supabase.co/functions/v1/payway-webhook` and have PayWay
   whitelist the domain (errors 6/81 mean it isn't whitelisted yet).
3. **Real end-to-end**: place a small order in the app (pointed at the
   hosted project) → scan the KHQR with a banking app → pay → the screen
   must flip to "Payment received" via PayWay's webhook. If the sandbox
   profile lacks the QR API service (error 23), pivot `payway-create` to
   Purchase `abapay_khqr_deeplink` (same file, documented response).
4. Production checklist: production `PAYWAY_BASE_URL` + credentials,
   one real low-value transaction, then normal launch.

## 5. Gotchas

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
- `check-transaction-2` (reconciliation, 600 req/s, 7-day window) is
  documented but intentionally not wired — the webhook is the
  confirmation path.
- KHQR display guidelines: `KhqrCard` already follows the red KHQR/BAKONG
  branding; PayWay also ships Figma templates if the store ever wants
  their `qrImage` (up to 0.5 MB — render `qrString` locally instead).

## 6. Key files

| Purpose | Path |
|---|---|
| QR initiation (signed generate-qr) | `supabase/functions/payway-create/index.ts` |
| Callback verifier (HMAC header, amount check, confirm) | `supabase/functions/payway-webhook/index.ts` |
| Repository method invoking the function | `lib/features/checkout/data/repository/checkout_repository_impl.dart` (`createPaywayQr`) |
| One-shot creation + stream (realtime + 3s refetch) | `lib/features/checkout/presentation/controllers/order_payment_controller.dart` |
| Payment screen (states, creation-failure notice, retry) | `lib/features/checkout/presentation/screens/order_placed_screen.dart` |
| Local secrets wiring | `supabase/config.toml` `[edge_runtime.secrets]` + `supabase/functions/.env` (gitignored) |
| Retired-path record | git history ≤ `c8d5185` (migrations `20261021000002`/`_03` drop the RPCs and columns) |
| PayWay docs (official, public) | https://developer.payway.com.kh — QR API, Purchase, Check transaction, Ecommerce Checkout |
