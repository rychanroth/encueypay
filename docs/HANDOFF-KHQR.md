# Handoff — Bakong/KHQR Payment Integration (session notes)

Read this before touching the QR payment flow. It covers what was done,
why, the current state, and what remains. Chronology follows the commits
on `impl/mvp` (Oct 2026).

## 1. How the QR payment flow works (final design)

```
Checkout (method=qr)
  └─ RPC create_order_from_cart → orders + payments row (status: pending)
       └─ OrderPlacedScreen (one-shot registration, never from build())
            ├─ fetchQrAccountId() → platform_settings.qr_account_id
            │    stored VERBATIM: a bare `alias@bank` OR the full bank-QR
            │    payload (whatever the admin pasted — both accepted)
            ├─ extractBakongAccountParts(raw)  [core TLV walker]
            │    → { accountId, accountInformation, acquiringBank }
            ├─ KhqrGenerator.build(...)  → dynamic KHQR (USD, 24h validity)
            │    tag-29 sub-tags: 00 = account field, 01 = account number,
            │    02 = acquiring bank (official SDK IndividualInfo shape;
            │    empty optionals omitted SDK-style)
            ├─ RPC register_qr_payment (idempotent; server computes the
            │    payload's MD5 = the Bakong transaction key)
            └─ polling every 5s (bakong-check edge function)
                 + Supabase Realtime on `payments`
                 + a 3s deduplicated REST ground-truth refetch
                 → all three paths converge the same stream

Confirmation flips `payments.status` pending → transaction_verified
SERVER-SIDE only, via: (a) bakong-check polling the real Bakong API
(needs BAKONG_TOKEN), (b) payway-webhook (receiver-only stub, unused),
(c) admin "Simulate QR payment". The screen celebrates ONLY on
transaction_verified; pending shows "Order placed — payment pending".
```

## 2. What was broken and what fixed it

1. **Invalid QR payload** (`65c14f0`) — the original hand-rolled builder
   put a fake 'KHQR' string in sub-tag 00 (sub-tag 00 IS the account
   field), the account in sub-tag 01, the bill number in sub-tag 05
   (spec: 01), and omitted tag 99 (dynamic KHQRs REQUIRE
   creation/expiration timestamps). The builder now mirrors the official
   `bakong-khqr` npm SDK (v1.0.20) exactly and is pinned by
   `test/khqr_generator_test.dart` using the SDK's own test vectors.
   USD amounts print bare (`1`) or 2-decimal (`10.50`); KHR is never
   emitted (the app's money model is USD; KHR display is conversion only).

2. **~2s rebuild loop** (`65c14f0` + migration `20261016000002`) —
   registration ran inside `build()`; when Realtime was down the client
   never saw its own `qr_payload` and re-fired the RPC every rebuild,
   each UPDATE re-triggering the stream. Registration is now one-shot
   from the screen lifecycle, and `register_qr_payment` is idempotent
   (pending payment already carrying a payload = quiet no-op).

3. **Realtime HTTP 401 → QR never rendered** (`163f474`) — the app was
   launched with a new-format `sb_publishable_...` key: local PostgREST
   accepts it but local Realtime rejects it at the websocket upgrade
   (reproduced; a classic anon JWT upgrades with 101). `config/.env`
   now carries a classic anon JWT minted from the stack's JWT secret
   (10-year expiry). Defense-in-depth: `OrderPaymentController.build`
   merges a 3-second deduplicated REST refetch into the realtime stream
   so the screen converges even with Realtime dead.

4. **ACLEDA's generic ID → ambiguous QR** (`e317080` + `c444f74`) —
   ACLEDA embeds `khqr@aclb` (generic, bank-wide) in consumer QRs and
   routes via the embedded account number. A QR built from the bare ID
   is ambiguous; my earlier claim that `khqr@aclb` alone was "the real
   ID" was wrong. Fix per the official SDK's `IndividualInfo`: the
   generated QR reproduces the receiver's own bank QR faithfully —
   account field (00) + account number (01) + acquiring bank (02).
   Storage is one verbatim field decoded at use time (TLV walker in
   `core/domain/bakong_account.dart`); a redundant entity and two extra
   columns were added and then removed after review.

5. **Personal data scrub** (`c444f74`) — the admin's real QR payload and
   decoded pieces had leaked into committed test fixtures; replaced with
   synthetic structural twins (`janedoe@aclb` / `0999888777` / `MYBANK`).
   No personal data remains in the working tree, but EARLIER COMMITS IN
   GIT HISTORY still contain it — if this repo will be pushed somewhere
   public, consider history rewrite (user's call).

## 3. Current state (verified against the local stack)

- **Database**: migrations applied through `20261016000004`
  (`drop_qr_disambiguator_columns`) — `platform_settings` has ONLY
  `qr_account_id` for QR config, currently holding the admin's full
  146-char ACLEDA QR payload (decodes to `khqr@aclb` + account
  `85523911897` + bank `ACLEDA`).
- **`config/.env`** (local, gitignored): `SUPABASE_URL` = local,
  `SUPABASE_PUBLISHABLE_KEY` = classic anon JWT (10y),
  `SUPABASE_REDIRECT_URI`, Google OAuth ids, `BAKONG_TOKEN` — see open
  item 2.
- **`analyze` clean; 35 tests passing** — relevant suites:
  `test/khqr_generator_test.dart` (SDK vectors + faithful-template
  byte-equality + structure), `test/bakong_account_test.dart` (TLV
  extraction, synthetic fixtures), `test/failure_mapping_test.dart`,
  `test/order_lifecycle_parsing_test.dart`.
- The KHQR work rode along with broader hardening the next session
  should know about: DATA-05 was reworked — every repository catch goes
  through `mapRepositoryError` (`core/network/failure_mapping.dart`);
  unexpected client bugs surface as `UnexpectedFailure` with the real
  cause and are logged in debug builds; bare `catch (_)` is banned by
  the amended contract. Also fixed in the same window: enum wire parsers
  (snake_case `out_for_delivery`/`bank_transfer`/`transaction_verified`
  used to collapse to fallbacks), admin orders/reports parse bugs,
  wishlist duplicate-add idempotency, ProductCard flex layout + coupon
  chips, order-details OrderItemCards, banner CTAs into Discovery.

## 4. Open items (in order)

1. **Move `BAKONG_TOKEN` to where the edge function reads it.** It
   currently sits in `config/.env` (app dart-defines — useless to the
   server). Create `supabase/functions/.env` (gitignored) with
   `BAKONG_TOKEN=<the token>`, then `supabase stop && supabase start`.
   Without it, `bakong-check` reports `configured:false` and demos use
   the admin Simulate button instead.
2. **End-to-end verification** (needs a full `flutter run` restart after
   any dart-define change): place a small QR order → scan the generated
   QR with the ACLEDA app → it must offer to pay RY CHANROTH the exact
   amount → pay → the screen flips to "Payment received" within ~5s
   (token path) or instantly after admin Simulate (no-token path).
3. **Open question — personal alias**: ACLEDA Mobile may show the user a
   PERSONAL Bakong alias (`name@aclb`) in its KHQR/Bakong settings. If
   found, it can replace the pasted payload in Platform settings (bare
   IDs are fully supported). Not required — the faithful-payload route
   works regardless.
4. **PayWay** (`supabase/functions/payway-webhook/index.ts`) is a
   receiver-only stub with real HMAC validation; payment *initiation*
   was never built (deliberate — KHQR was chosen as the path of least
   resistance). Do not mistake the webhook for a working PayWay
   integration.

## 5. Gotchas

- The Bakong ID field and the API token are DIFFERENT things: the ID
  says where money goes (Platform settings field), the token is how the
  server asks "paid?" (edge-function secret). Never swap them.
- A generic QR scanner shows the WHOLE envelope; the Bakong account
  field is sub-tag 00 inside tag 29/30. Never paste the envelope as
  "just an ID" into code that expects an ID — the pipeline decodes it
  instead.
- `platform_settings.qr_account_id` is verbatim-by-design. Don't
  normalize/flatten it on save.
- If the 401 returns, check `config/.env` first: the key must be a
  classic `eyJ...` JWT, not `sb_publishable_...`.
- KHQR spec references: official SDK `bakong-khqr` (npm, v1.0.20 —
  source was read to pin the builder), NBC portal
  bakong.nbc.gov.kh (individual registration = national ID + phone via
  a member bank; the phone number can serve as an account identifier).

## 6. Key files

| Purpose | Path |
|---|---|
| KHQR payload builder (SDK-mirroring, tested) | `lib/features/checkout/data/khqr_generator.dart` |
| TLV walker + account-parts extraction | `lib/core/domain/bakong_account.dart` |
| Payment screen (one-shot registration, states, poll) | `lib/features/checkout/presentation/screens/order_placed_screen.dart` |
| Payment stream (realtime + 3s refetch merge) | `lib/features/checkout/presentation/controllers/order_payment_controller.dart` |
| Verbatim fetch, ground-truth fetch, Bakong probe | `lib/features/checkout/data/repository/checkout_repository_impl.dart` |
| Bakong confirmation poller (edge function) | `supabase/functions/bakong-check/index.ts` |
| SQL: idempotent registration | `supabase/migrations/20261016000002_register_qr_payment_idempotent.sql` |
| SQL: disambiguator columns added→dropped | `supabase/migrations/20261016000003_*` / `20261016000004_*` |
| Local app config (key/token; gitignored) | `config/.env` |
| Failure taxonomy + mapper (DATA-05) | `lib/core/domain/failures.dart`, `lib/core/network/failure_mapping.dart` |
