# Prototype Setup & Demo Guide

Everything here is operational setup on your side — the code is complete and
committed. The authoritative feature record is
`docs/app_implementation_specification.md` (living spec).

## Phase 0 — Fresh database state

```bash
supabase db reset   # applies all migrations + re-runs seed.sql
```

The frozen 4-role baseline (`20261007000000_frozen_baseline.sql`) is bridged to
the 2-role schema by migrations `20261008000001`–`…000006` (see the "Applied
server-side (DB bridge)" ledger in the living spec, Part C). Old demo data is
intentionally lost on reset. Seed provides 6 categories, 4 demo brands (Acme,
Nordwind, Lumina, Verde) and the `platform_settings` singleton. The full server
lifecycle is verified by `supabase/testing/smoke_test_2role.sql` (optional:
`psql … -f supabase/testing/smoke_test_2role.sql` against the local DB).
Note: `supabase/testing/smoke_test.sql` is the old 4-role harness and is
obsolete.

## Phase 1 — Users, store, admin

1. Create two auth users (Dashboard → Authentication → Users, auto-confirm
   ON, or sign up in-app):
   - `store-owner@…` — owns the store row only (its portal was removed)
   - `admin@…` — will be promoted
2. Create the Prototype Store (SQL editor — businesses need an auth-user
   owner):
   ```sql
   insert into public.businesses (owner_id, name, description, status)
     select u.id, 'Prototype Store', '2-role prototype catalog', 'active'
     from public.users u join auth.users a on a.id = u.id
     where a.email = 'store-owner@…';
   ```
3. Promote the admin:
   ```sql
   update public.users set active_role = 'admin'
     where id in (select id from auth.users where email = 'admin@…');
   ```
4. Sign in as admin in the app (re-login if the tab set hasn't switched).

## Phase 2 — Stock the catalog (in-app, as admin)

Products tab → `+`: name, description, base price, **stock** (product-wide),
store, category, brand, images. Create at least: one normal product, one to
drop to low stock (≤5), one to archive (demoes the "Unavailable" badge).
Promotions tab → `+`: a platform coupon and a brand-scoped coupon (date
windows, min order).

## Phase 3 — QR payments

1. Admin → Platform settings → "QR payment account (Bakong ID)": your
   personal Bakong ID. Empty = QR hidden at checkout.
2. **No-credential demo**: admin order view → "Simulate QR payment".
3. Real Bakong confirmation (optional): Bakong developer portal token →
   `supabase secrets set BAKONG_TOKEN=…` → `supabase functions deploy
   bakong-check`.
4. Real PayWay webhook (optional, merchant account): `supabase secrets set
   PAYWAY_API_KEY=…` → `supabase functions deploy payway-webhook` → set the
   callback URL to `https://<project>.supabase.co/functions/v1/payway-webhook`.
5. Scan-test the generated KHQR with a real banking app once before demoing.

## Phase 4 — FCM push (optional; inert until configured)

1. Firebase project → Android app → `google-services.json` → `android/app/`.
2. **Together with the JSON** (build fails otherwise): Gradle
   `com.google.gms:google-services:4.4.2` classpath + plugin apply.
3. Service-account JSON (Project settings → Service accounts):
   `supabase secrets set FCM_SERVICE_ACCOUNT='{…}'`
4. `supabase functions deploy push-dispatch`.
5. Supabase Dashboard → Database → Webhooks: on `public.notifications`
   INSERT → `https://<project>.supabase.co/functions/v1/push-dispatch`.

Without this, the app runs fine — the in-app realtime inbox is unaffected.

⚠ **Known defect (flagged, unfixed):** `push-dispatch/index.ts` reads
`notification.recipient`, but the column is `recipient_id` — real pushes will
silently skip every device until that one line is corrected.

## Phase 5 — Run + demo script

```bash
flutter run --dart-define=SUPABASE_URL=<url> \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=<key>
```

1. **Customer**: Home (category cards → Discovery, brand rail) → detail
   (stars, stock, variants) → cart (stock cap, long-press quick actions) →
   7-step checkout → QR → admin "Simulate payment" → auto-flip to paid.
2. **Admin**: Dashboard (sales hero + momentum, stock alerts, trend) →
   Orders: Confirmed → Processing → Packed → Ship → Out for delivery →
   Complete → Mark refunded (cancelled paid order) → Complete return.
3. **Edge cases**: archive a product ("Unavailable"), stock to 0 ("Out of
   stock"), low-stock alerts, Reports date range, Audit logs.
4. **Profile tab**: spending hero (cancel an order — watch it drop out),
   orders panel, wishlist rail, cart summary.

## External prerequisites summary (living spec Part A.5/A.6)

| Prerequisite | Unlocks |
|---|---|
| Google Cloud Console OAuth client (Android + Web) → Supabase auth provider config (`SUPABASE_AUTH_EXTERNAL_GOOGLE_*` locally; Dashboard → Auth → Providers when hosted) | Google sign-in (the primary method per DEPS-04); the deep-link redirect `io.supabase.encueypay://login-callback/` is already pre-wired in `config.toml`. Until configured, email/password sign-in is the working fallback. |
| Personal Bakong ID in Platform settings | Scannable KHQR at checkout |
| `BAKONG_TOKEN` secret + deployed `bakong-check` | Real QR payment confirmation polling |
| ABA merchant account + `PAYWAY_API_KEY` + callback URL | Real webhook confirmation |
| Firebase project + config files + Gradle plugin + `FCM_SERVICE_ACCOUNT` + notifications webhook + deployed `push-dispatch` | Real push notifications |
