# Remote Supabase Setup — step by step

Switching the app from the local stack (`supabase start`) to a **hosted**
Supabase project. Companion to `PROTOTYPE_SETUP.md` (local phases) and
`supabase/README.md` (migration workflow). As there: **[REQUIRED]** sections
are in order; **[OPTIONAL]** ones can be skipped (each says what you lose).

---

## What moves where

The app itself reads exactly **two** variables (`lib/main.dart`):
`SUPABASE_URL` + `SUPABASE_PUBLISHABLE_KEY`. Everything else in
`config/.env` belongs to the *local stack*, not the app — each row below
says where it lives remotely.

| Piece | Local (today) | Remote | Where it goes |
|---|---|---|---|
| `SUPABASE_URL` | `http://127.0.0.1:54321` | `https://<ref>.supabase.co` | `config/.remote` (dart-define) |
| Publishable key | from `supabase status` | Dashboard → **Settings → API Keys** | `config/.remote` |
| Migrations | `supabase db reset` | `supabase db push` | CLI (linked project) |
| Demo seed | automatic on `db reset` | manual (SQL editor / psql) | Phase 3 [OPTIONAL] |
| `GOOGLE_CLIENT_ID` / `GOOGLE_CLIENT_SECRET` | `config.toml env(...)` | Dashboard → **Auth → Providers → Google** | same Google OAuth client |
| `SUPABASE_REDIRECT_URI` | loopback callback for local auth | not needed — hosted callback is fixed | Google Cloud Console (Phase 5) |
| OAuth deep link | already in manifests | also register in dashboard | Phase 5 |
| `PAYWAY_BASE_URL` / `PAYWAY_MERCHANT_ID` / `PAYWAY_API_KEY` | `supabase/functions/.env` (via `[edge_runtime.secrets]`) | `supabase secrets set` | Phase 6 |
| push-dispatch DB webhook | `http://kong:8000/...` | `https://<ref>.supabase.co/functions/v1/push-dispatch` | Phase 7 [OPTIONAL] |
| `network_security_config.xml`, `adb reverse` | needed for LAN http / device loopback | **not needed** — https over the internet | nothing to do |
| `supabase/config.toml` | local-only config | **does not apply remotely** — the dashboard is the config | — |

## Phase 0 — Prerequisites [REQUIRED]

- A project on [supabase.com](https://supabase.com). The **project ref**
  (the `abcdefg` in `abcdefg.supabase.co`) appears in the dashboard URL —
  one is already commented in `config/.env` line 1. Keep the **database
  password** handy (Dashboard → Settings → Database; resettable there).
- CLI logged in:

  ```bash
  supabase login        # browser flow, or SUPABASE_ACCESS_TOKEN env
  ```

## Phase 1 — Link the CLI to the project [REQUIRED]

From the repo root:

```bash
supabase link --project-ref <ref>
# forgot the ref? `supabase projects list`
```

Prompts for the DB password once. This stores the link in
`supabase/.temp/` (gitignored). `config.toml` stays untouched — it remains
the **local** stack's config.

## Phase 2 — Apply the schema [REQUIRED]

```bash
supabase db push
```

Applies the frozen baseline, the bridge migrations and the ten overhaul
migrations in order; records each in the remote's
`supabase_migrations.schema_migrations` (safe to re-run). Storage buckets
and their policies are inside the migrations, so uploads work after this —
no dashboard bucket setup needed.

> **Connection fails on an IPv6-only network?** Hosted projects route
> direct connections over IPv6. Use the pooler instead: Dashboard →
> **Connect** → copy the *Connection pooling* string, then
> `supabase db push --db-url "<that string>"`.

## Phase 3 — Seed the demo catalog [OPTIONAL]

`db push` does **not** run `seed.sql` (that's a `db reset` local-only
behavior). Without it the catalog is empty and you author everything
in-app. To ship the demo data:

```bash
psql "<Connection pooling string>" -f supabase/seed.sql
```

or paste `supabase/seed.sql` into Dashboard → **SQL Editor**. The file is
idempotent. Auth users cannot be seeded — create them in the dashboard
(Phase 8).

## Phase 4 — Point the app at the remote [REQUIRED]

Fill in `config/.remote` (already created, gitignored like all of
`config/`):

```
SUPABASE_URL=https://<ref>.supabase.co
SUPABASE_PUBLISHABLE_KEY=sb_publishable_...
```

The key is under Dashboard → **Settings → API Keys**. Keep this file
minimal — dart-defines are **baked into the binary at compile time**. The
app never reads `GOOGLE_CLIENT_SECRET` or the PayWay API key; those must
not live here (they belong to Google Cloud Console and `supabase secrets`).

> ⚠️ The commented URL in `config/.env` ends with a **trailing comma** —
> don't copy it verbatim.

Run:

```bash
flutter run --dart-define-from-file=config/.remote
```

(or the two explicit `--dart-define`s from `PROTOTYPE_SETUP.md` Phase 2 —
same result). Notes:

- Switching environments = **new build**. Hot reload/restart does not
  re-read dart-defines; stop and start `flutter run`.
- https needs no `network_security_config.xml` entry, and **no
  `adb reverse`** — a physical device reaches the hosted project over the
  internet directly.
- Keep `config/.env` for local work: `--dart-define-from-file=config/.env`
  + `supabase start` behaves exactly as before.

## Phase 5 — Auth on the dashboard [REQUIRED]

1. **Email + password** is enabled by default. Locally, email confirmation
   was off (`config.toml: enable_confirmations = false`). For demo parity
   turn it off: **Auth → Sign In / Providers → Email → Confirm email**.
   For anything user-facing, leave it on.
2. **Google provider** (DEPS-04, primary sign-in): **Auth → Providers →
   Google**, enable, paste the same client ID + secret from
   `config/.env` (`GOOGLE_CLIENT_ID` / `GOOGLE_CLIENT_SECRET`).
3. **Google Cloud Console** → Credentials → your OAuth client → add a
   second *Authorized redirect URI*:

   ```
   https://<ref>.supabase.co/auth/v1/callback
   ```

   Keep the loopback one too — it still serves local development.
4. **Auth → URL Configuration → Redirect URLs**: add

   ```
   io.supabase.encueypay://login-callback/
   ```

   (the app sends exactly this as `redirectTo` on mobile OAuth —
   `auth_repository_impl.dart` `_oauthRedirect`).

No app code change: the Android intent-filter / iOS URL scheme are already
wired, and the hosted auth server bridges Google's callback to the deep
link itself.

## Phase 6 — Edge functions + secrets [REQUIRED for QR payments]

```bash
supabase functions deploy payway-create payway-webhook
supabase secrets set PAYWAY_BASE_URL=https://checkout.payway.com.kh \
  PAYWAY_MERCHANT_ID=<production merchant id> \
  PAYWAY_API_KEY=<production API key>
```

(HOSTED secrets are plain `supabase secrets set` — the local
`[edge_runtime.secrets]`/env-export mechanism in `PROTOTYPE_SETUP.md` 6.1
does not apply remotely. `PAYWAY_CALLBACK_URL` is unnecessary hosted: the
functions default to `$SUPABASE_URL/functions/v1/payway-webhook`.)

Optional, per `PROTOTYPE_SETUP.md` Phase 7:

```bash
supabase functions deploy push-dispatch
supabase secrets set FCM_SERVICE_ACCOUNT='{"type":"service_account", …}'
```

(The `push-dispatch` `recipient_id` fix is already applied. In the ABA
merchant portal, set the payment callback URL to
`https://<ref>.supabase.co/functions/v1/payway-webhook`.)

## Phase 7 — DB webhook for push [OPTIONAL]

Same as local Phase 7 Step 5, but with the public URL: Dashboard →
**Database → Webhooks → Create** → table `notifications`, event INSERT,
type **Supabase Edge Function**, **Add secret key** (otherwise
`verify_jwt` rejects the call with 401), method POST →

```
https://<ref>.supabase.co/functions/v1/push-dispatch
```

## Phase 8 — Bootstrap app state [REQUIRED]

1. Create the admin account: **Auth → Users → Add user**, email +
   password, **Auto Confirm User**.
2. Promote it — Dashboard → **SQL Editor**:

   ```sql
   update public.users set active_role = 'admin'
     where id in (select id from auth.users where email = 'admin@demo.local');
   ```

3. Sign in in the app and set **Dashboard → Platform settings** (delivery
   fee, payment account). Coupons and banners are authored in-app on this
   database (they record `created_by`).

## Phase 9 — Verify (smoke pass)

- App launches; email sign-up creates the `users` row (customer) via
  trigger; sign out/in lands the admin tab set after Phase 8.
- Catalog renders (seed imagery loads from the public URLs).
- **Continue with Google** opens the browser and returns into the app via
  the deep link.
- QR checkout: the payment screen renders the PayWay KHQR (needs the
  Phase 6 secrets + callback URL) → a real sandbox payment — or the
  signed webhook dry-run (HANDOFF-KHQR.md step 3) — flips the customer
  screen to *paid* in realtime.
- Push (if set up): trigger a notification as admin with the app
  backgrounded.

## Troubleshooting

| Symptom | Cause → fix |
|---|---|
| `StateError` about missing Supabase config on startup | `--dart-define-from-file=config/.remote` not passed, or file empty / not `KEY=VALUE` lines |
| Edited `.remote`, app still hits `127.0.0.1` | dart-defines are compile-time — full stop + `flutter run` again |
| `db push` can't connect | IPv6 → `--db-url "<Connection pooling string>"` (Phase 2 note) |
| Google: `redirect_uri_mismatch` | hosted callback URI missing in Google Cloud Console (Phase 5.3) |
| Google: browser opens, app never comes back | deep link missing from dashboard Redirect URLs (Phase 5.4) |
| QR screen: "Could not start the QR payment" | `payway-create` not deployed / `PAYWAY_*` secrets not set / PayWay rejected (reason shown; Phase 6) |
| Webhook never confirms | callback URL not set in the ABA portal, or callback domain not whitelisted with PayWay (Phase 6) |
| Push never arrives | webhook URL, `FCM_SERVICE_ACCOUNT`, function deploy — Phases 6–7 in order |
| Ran `supabase db reset` expecting remote changes | it is local-only by design; remote resets happen in the dashboard (or a fresh project) |
| Confused which env file is which | `config/.env` = local stack; `config/.remote` = the app's remote dart-defines; both gitignored |

## Switching environments day to day

| Target | Backend | App |
|---|---|---|
| Local | `supabase start` (+ `db reset`) | `flutter run --dart-define-from-file=config/.env` |
| Remote | `supabase db push` (schema changes only) | `flutter run --dart-define-from-file=config/.remote` |

The publishable key is public by design — embedding it in the binary is
safe. Never put service-role keys, `GOOGLE_CLIENT_SECRET` or the PayWay API
key into a dart-define file; those live in Google Cloud Console /
`supabase secrets` / the edge-function env only.
