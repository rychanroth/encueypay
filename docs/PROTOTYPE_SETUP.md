# Prototype Setup & Demo Guide — step by step

This guide assumes **nothing** is set up. Every step says exactly where to
click / what to paste. The authoritative feature record is
`docs/app_implementation_specification.md` (living spec); the route/wiring
audit is `FEATURE_VERIFICATION_MATRIX.md`; deep local-networking gotchas live
in `supabase/README.md`.

**The one rule for reading this guide:** sections marked **[REQUIRED]** must
be done in order. Sections marked **[OPTIONAL]** can be skipped entirely —
the app degrades gracefully without them (each one says what you lose).

---

## What's already wired for you vs. what you must do

| Thing | State | Where |
|---|---|---|
| Database schema (4-role baseline + 6 bridge migrations → 2-role) | ✅ committed | `supabase/migrations/` |
| Demo seed: 6 categories, 4 brands, settings row | ✅ committed | `supabase/seed.sql` |
| Server logic: checkout, stock, coupons, QR, lifecycle, reports | ✅ committed | migrations 000001–000006 |
| Google OAuth client credentials (local dev) | ✅ already in root `.env` | `.env` (gitignored) |
| Android deep link for OAuth | ✅ wired | `android/app/src/main/AndroidManifest.xml` |
| Firebase Android config (`google-services.json`) | ✅ already in repo | `android/app/` |
| Gradle google-services plugin | ⚠️ **not applied** — you add 2 lines (Phase 7) | `android/` |
| FCM push bug fix (1 line) | ⚠️ **you apply it** (Phase 7, Step 1) | `supabase/functions/push-dispatch/index.ts` |
| Bakong / PayWay API tokens | ❌ optional secrets | Phase 6 |
| Demo users, store, admin role | ❌ you create them | Phases 3–4 |

---

## Phase 0 — Install the tools [REQUIRED]

You need, with verification commands:

| Tool | Check it works | Notes |
|---|---|---|
| Flutter SDK | `flutter doctor` | You also need the Android toolchain line green |
| Docker | `docker ps` | Must be running before any `supabase` command |
| Supabase CLI ≥ 2.x | `supabase --version` | <https://supabase.com/docs/guides/cli> |
| A device/emulator | `flutter devices` | For push (Phase 7): something **with Google Play services** |

---

## Phase 1 — Start the backend [REQUIRED]

From the repo root:

```bash
supabase start        # first run downloads Docker images (a few minutes)
supabase db reset     # applies ALL migrations in order + seed data
```

`db reset` rebuilds the database from scratch: the frozen 4-role baseline
(`20261007000000_frozen_baseline.sql`) plus the six bridge migrations
(`20261008000001`–`…000006`) that turn it into the 2-role schema, then the
seed. It is safe to run any time — it wipes local demo data on purpose.

Verify the stack and copy two values you'll need in Phase 2:

```bash
supabase status
```

Note from the output:
- **API URL** — `http://127.0.0.1:54321`
- **Publishable (anon) key** — the long `eyJ…` string
- **Studio URL** — `http://127.0.0.1:54323` (the local web dashboard you'll
  use in Phase 3+)

Quick sanity check that the bridge + seed landed (SQL editor in Studio, or
`psql "postgresql://postgres:postgres@127.0.0.1:54322/postgres"`):

```sql
select (select count(*) from public.categories)  as categories,   -- expect 6
       (select count(*) from public.brands)      as brands,       -- expect 4
       (select count(*) from public.platform_settings) as settings; -- expect 1
```

> **Physical device / LAN note:** the repo's root `.env` already pins
> `SUPABASE_URL` to this machine's LAN IP for device testing, and
> `android/app/src/main/res/xml/network_security_config.xml` allowlists that
> IP. If your Wi-Fi/network changes, update the IP in **both** files, then
> restart the stack: `set -a; source .env; set +a; supabase stop && supabase start`.
> Full gotcha list: `supabase/README.md`.

---

## Phase 2 — Run the app [REQUIRED]

Get the two values from Phase 1 (or `grep SUPABASE .env` for the device URL)
and run:

```bash
flutter run \
  --dart-define=SUPABASE_URL=http://127.0.0.1:54321 \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=<paste publishable key>
```

- **Android emulator:** use `http://10.0.2.2:54321` as the URL (already
  allowlisted) — `127.0.0.1` inside the emulator is the emulator itself.
- **Physical device:** use the LAN-IP URL from `.env`, same Wi-Fi as the dev
  machine.

These are the only two environment variables the app reads (`lib/main.dart`).
Sign up with **email + password** — no external account needed yet. Every new
signup automatically gets a `public.users` row with the customer role.

---

## Phase 3 — Create the two demo users [REQUIRED]

Open **Studio** (`http://127.0.0.1:54323`) → **Authentication → Users →
Add user → Create new user**. Fill email + password, tick **Auto Confirm
User**, press Create. Do this twice:

| Email (suggestion) | Purpose |
|---|---|
| `store-owner@demo.local` | Owns the store row (has no portal in the 2-role app) |
| `admin@demo.local` | Will be promoted to admin in Phase 4 |

(Alternatively: sign up both in the app — email confirmation is disabled
locally, so it just works.)

---

## Phase 4 — Create the store + promote the admin [REQUIRED]

In Studio → **SQL Editor → New query**, run each snippet once, replacing the
emails if you chose different ones.

**4.1 — The prototype store** (products must belong to a business row):

```sql
insert into public.businesses (owner_id, name, description, status)
  select u.id, 'Prototype Store', '2-role prototype catalog', 'active'
  from public.users u join auth.users a on a.id = u.id
  where a.email = 'store-owner@demo.local';
```

**4.2 — Promote the admin** (the app has no self-service admin path — by
design; the SQL editor runs with no user identity, which the guard trigger
allows):

```sql
update public.users set active_role = 'admin'
  where id in (select id from auth.users where email = 'admin@demo.local');
```

**4.3 — See it take effect:** sign in as the admin in the app. The role is
read on every auth event — if you were already signed in as that user,
**sign out and sign back in** (or hot-restart) to get the admin tab set.

---

## Phase 5 — Stock the catalog (in-app, as admin) [REQUIRED]

1. **Products tab → `+`**: name, description, base price, **stock**
   (product-wide), the store, a category, a brand, optional image. Create at
   least:
   - one normal product (stock ≥ 10),
   - one that you'll drop to low stock (≤ 5) — the admin dashboard flags it,
   - one you'll **archive** — demos the "Unavailable" badge on the customer
     side.
2. **Promotions tab → `+`**: create a **platform coupon** (e.g. fixed/percent,
   a code like `DEMO10`, optional date window + min order) and a
   **brand-scoped coupon** (pick a brand) — this exercises both coupon scopes.

---

## Phase 6 — QR payments

**6.1 — Turn QR on (required for any QR demo)**: as admin → **Dashboard →
Platform settings → "QR payment account (Bakong ID)"**. Paste your personal
Bakong ID (looks like `name@aclb`). **Empty = the QR option is hidden at
checkout.** For a fake/simulation demo any non-empty value works.

**6.2 — No-credential demo (works with zero external accounts)**: place an
order with QR at checkout → as admin, open the order → **"Simulate QR
payment"** → the customer's payment screen flips to *paid* in real time
(realtime stream on `payments`).

**6.3 — [OPTIONAL] Real Bakong confirmation.** The app polls Bakong's
`check_transaction_by_md5` API through the `bakong-check` edge function:

1. Register at the Bakong developer portal and obtain an API token.
2. Local stack — put the token where local functions read secrets:
   create `supabase/functions/.env` (gitignored — add it, see Step 3) with:
   ```
   BAKONG_TOKEN=<your-token>
   ```
3. Restart so the runtime picks it up: `supabase stop && supabase start`.
4. Scan the checkout QR with a real banking app once **before** demoing.
   Until paid, `bakong-check` returns `configured: true, paid: false` and the
   UI keeps polling every ~5 s.

**6.4 — [OPTIONAL] Real PayWay webhook (ABA merchant account).**
`payway-webhook` is a fail-closed HMAC-verified server-to-server callback:

1. Get an ABA merchant account + `PAYWAY_API_KEY`.
2. Local: add `PAYWAY_API_KEY=<key>` to `supabase/functions/.env` and restart.
3. In the ABA merchant portal, set the payment callback URL to
   `https://<project>.supabase.co/functions/v1/payway-webhook` — this
   realistically requires the **hosted** project (Phase 7 note explains
   hosting), since ABA must reach your backend over the public internet.

---

## Phase 7 — FCM push [OPTIONAL, 2 one-time fixes + config]

State of the repo: `android/app/google-services.json` **already exists**
(Firebase project `encueypay`, Android package `com.example.encueypay`), the
FCM packages are in `pubspec.yaml`, and the app registers device tokens on
startup. What's missing is (1) a one-line function fix, (2) the Gradle plugin
line, (3) the service-account secret, (4) the database webhook. Without all
four, push stays inert (the app still runs; the in-app realtime inbox is
unaffected).

**Step 1 — the push-dispatch fix (mandatory, previously flagged).** Open
`supabase/functions/push-dispatch/index.ts` and change line 91:

```ts
// before
const recipient: string | undefined = notification?.recipient;
// after
const recipient: string | undefined = notification?.recipient_id;
```

The webhook payload carries the `notifications` row, and that column is
`recipient_id` — as written, the function looks up device tokens for
`undefined` and silently sends nothing.

**Step 2 — apply the google-services Gradle plugin.** In
`android/settings.gradle.kts`, inside the top-level `plugins { … }` block add:

```kotlin
id("com.google.gms.google-services") version "4.4.2" apply false
```

In `android/app/build.gradle.kts`, inside its `plugins { … }` block add:

```kotlin
id("com.google.gms.google-services")
```

(The JSON is already in place, so this is the whole story. If the build then
complains about `minSdk`, set `minSdk = 23` in
`android/app/build.gradle.kts` `defaultConfig`.)

**Step 3 — service-account secret.** Firebase Console → ⚙️ Project settings →
**Service accounts → Generate new private key** → download the JSON. Put its
entire contents on **one line** in `supabase/functions/.env`:

```
FCM_SERVICE_ACCOUNT='{"type":"service_account","project_id":"encueypay", … }'
```

`supabase/functions/.env` is local-secret storage for edge functions and is
loaded on `supabase start` — keep it out of git
(`supabase/.gitignore` already ignores `.env.local`; add a line
`functions/.env` there if you create it).

**Step 4 — restart the stack** so the function runtime gets the secret:
`supabase stop && supabase start`.

**Step 5 — create the database webhook** (this is what invokes the function
on every new notification): Studio → **Database → Webhooks → Create a new
hook** → name `push-dispatch`, table `notifications`, event **INSERT**,
delivery: POST to

```
http://kong:8000/functions/v1/push-dispatch
```

> **Why `kong:8000` and not `127.0.0.1:54321`?** The webhook is executed by
> the database *container*, where `127.0.0.1` is the database itself. `kong`
> is the API-gateway container on the same Docker network (externally mapped
> to 54321). If pushes never fire, this URL is the first thing to check.

**Step 6 — test:** run the app on a device **with Google Play services**,
sign in (a device token is registered at startup), then trigger a
notification as the admin (e.g. transition an order). Push arrives in the
system tray when the app is **backgrounded or terminated** — an in-app
foreground display is intentionally not built (matrix row 101).

---

## Phase 8 — Google OAuth [OPTIONAL — already configured on this machine]

Google is the app's primary sign-in method (DEPS-04). The repo already has:
provider enabled in `supabase/config.toml` (`[auth.external.google]`), the
credentials in the root `.env` (`GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`,
`SUPABASE_REDIRECT_URI`), and the Android deep link
(`io.supabase.encueypay://login-callback/`). The login screen's **Continue
with Google** button should just work.

To reproduce on a fresh machine:

1. Google Cloud Console → create/select a project → **OAuth consent screen**
   (External; add your Gmail under test users).
2. **Credentials → Create credentials → OAuth client ID → Web application**;
   authorized redirect URI exactly:
   `http://127.0.0.1:54321/auth/v1/callback`
   (loopback only — Google rejects plain-HTTP on any other host; this is why
   the device flow bridges through `adb reverse`).
3. Copy client ID + secret into the root `.env` and restart the stack **with
   the vars in the shell** (containers freeze `env(...)` at creation):
   ```bash
   set -a; source .env; set +a
   supabase stop && supabase start
   ```
4. Verify what the auth server actually advertises:
   `docker inspect supabase_auth_encueypay | grep GOOGLE_REDIRECT_URI`.
5. Device testing: `adb reverse tcp:54321 tcp:54321` **before every OAuth
   test** — the bridge is ephemeral and dies on reconnect. Symptom of a
   missing bridge: the device browser can't open the callback URL.

---

## Phase 9 — Demo script

1. **Customer**: Home (banner strip, category cards, brand rail) → product
   detail (variants, stock) → cart (stock-capped stepper) → 7-step checkout
   → QR → admin "Simulate payment" → screen flips to paid in real time.
2. **Admin**: Dashboard (KPIs, stock alerts, trend) → Orders:
   Confirmed → Processing → Packed → Ship → Out for delivery → Complete →
   **Mark refunded** (on a cancelled/returned paid order) → **Complete
   return**.
3. **Edge cases**: archive a product ("Unavailable"), stock to 0 ("Out of
   stock"), low-stock alerts, Reports date range, Audit logs (every admin
   mutation lands there).
4. **Profile tab**: spending hero (cancel an order — watch it drop out),
   orders panel, wishlist rail, cart summary.

---

## Troubleshooting

| Symptom | Cause → fix |
|---|---|
| Tab set doesn't switch after promoting the admin | Profile is read per auth event → **sign out and back in** (or hot-restart) |
| QR option missing at checkout | `qr_account_id` empty → Admin → Platform settings (Phase 6.1) |
| "Some items in your cart are no longer available" | A cart line's variant/product/business is no longer active (server-side gate) — remove the line |
| `bakong-check` says `configured: false` | `BAKONG_TOKEN` not in `supabase/functions/.env`, or stack not restarted after adding it |
| Push never arrives | In order: recipient_id fix applied (Step 1)? Gradle plugin applied (Step 2)? `FCM_SERVICE_ACCOUNT` set + stack restarted (Steps 3–4)? Webhook created with the `kong:8000` URL (Step 5)? Device has Play services? App backgrounded? |
| OAuth: `redirect_uri_mismatch` | The Google client must allow exactly `http://127.0.0.1:54321/auth/v1/callback`, and `.env`'s `SUPABASE_REDIRECT_URI` must match; then the restart ritual |
| OAuth on device: browser can't open callback | `adb reverse tcp:54321 tcp:54321` (ephemeral — re-run) |
| Device can't reach the backend at all | LAN IP changed → update `.env` `SUPABASE_URL` **and** `network_security_config.xml`, then the restart ritual |
| `supabase: command not found` / docker errors | Install CLI / start Docker (Phase 0) |
| Something's weird in the DB | `supabase db reset` rebuilds everything from migrations + seed |

## External prerequisites summary

| Prerequisite | Unlocks | Phase |
|---|---|---|
| Two auth users + store INSERT + admin promotion | The demo itself | 3–4 |
| `qr_account_id` in Platform settings | KHQR visible at checkout | 6.1 |
| Bakong developer token (`BAKONG_TOKEN`) | Real payment confirmation polling | 6.3 |
| ABA merchant account + `PAYWAY_API_KEY` + callback URL | Real webhook confirmation | 6.4 |
| push-dispatch 1-line fix + Gradle plugin + `FCM_SERVICE_ACCOUNT` + notifications webhook | Real push notifications | 7 |
| Google OAuth client (already in `.env` here) | Google sign-in; email/password is the fallback | 8 |
