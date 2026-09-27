# EncueYPay — Supabase backend

Migrations live in `migrations/` and are applied **per feature phase**
(backend + Flutter land together as vertical slices; the server is
authoritative per spec §53).

## What this folder is (and isn't)

This folder contains **source-controlled SQL** — it is not a database and
not a local Supabase instance. The actual database is your **remote**
Supabase project (created in the web dashboard). The Supabase CLI connects
the two:

```
supabase/migrations/*.sql   ← versioned schema changes (applied in order)
supabase/seed.sql           ← demo data (run manually / via db reset)
supabase/testing/           ← local harness: replays migrations + RPC smoke
                              suite against a scratch Postgres (no Supabase
                              needed — see testing/ scripts' headers)
```

## Connecting to your remote project

```bash
# 1. Install the CLI (https://supabase.com/docs/guides/cli)
# 2. From the repo root:
supabase init                      # creates config.toml; keeps migrations/
supabase link --project-ref <your-project-ref>
                                   # (ref = the abcdefg in abcdefg.supabase.co)
supabase db push                   # applies only migrations the remote
                                   # hasn't recorded yet
```

`db push` records each applied file in the remote's
`supabase_migrations.schema_migrations` table — it is safe to re-run, and
editing a migration file that has **never applied remotely** is safe too.

## Configuration

The Flutter app reads the project URL + publishable key via `--dart-define`:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://<ref>.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=<publishable-key>
```

## Local stack & physical device OAuth

For local development against `supabase start`, the root `.env` splits the
project URL into two roles:

```
SUPABASE_URL=http://<dev-machine-LAN-IP>:54321        # app API calls + /authorize hop
SUPABASE_REDIRECT_URI=http://127.0.0.1:54321/auth/v1/callback   # Google-facing callback
```

The callback **must stay `127.0.0.1`**: Google only accepts plain-HTTP
redirect URIs for loopback hosts, so the LAN IP can never be registered in
Google Cloud Console (`redirect_uri_mismatch`). Register
`http://127.0.0.1:54321/auth/v1/callback` there instead, and bridge the
device's loopback to the dev machine:

```bash
adb reverse tcp:54321 tcp:54321
```

Gotchas (each of these has cost us a debugging session):

- **`adb reverse` is ephemeral** — it dies whenever the device disconnects,
  `flutter run` detaches, or USB/Wi-Fi debugging reconnects. Re-run it
  before every device OAuth test; the symptom of a missing bridge is the
  device browser failing to open `127.0.0.1:54321/auth/v1/callback`.
- **Containers freeze `env(...)` at creation.** Changing `.env` or
  `supabase/config.toml` does nothing until the stack is recreated with the
  vars in the CLI's process environment:

  ```bash
  set -a; source .env; set +a
  supabase stop && supabase start
  ```

  Verify what the running auth server actually advertises:
  `docker inspect supabase_auth_encueypay | grep GOOGLE_REDIRECT_URI`.
- **`[api] external_url` is not a real config field** (CLI 2.114) — the
  Google-facing callback is overridden via
  `[auth.external.google].redirect_uri` only.
- If the dev machine's LAN IP changes (new network/DHCP), update
  `.env`'s `SUPABASE_URL` **and** `android/app/src/main/res/xml/
  network_security_config.xml`, then run the restart ritual above.

## Auth setup (dashboard)

- **Google OAuth** is the primary sign-in method (DEPS-04): enable the
  Google provider in Authentication → Providers with your OAuth client
  credentials.
- **Email/password** is enabled as a secondary method for testing the four
  roles quickly.
- **Mobile deep link**: add `io.supabase.encueypay://login-callback/` to
  Authentication → URL Configuration → Redirect URLs (the app sends this
  as `redirectTo` on mobile OAuth).
- Mobile OAuth sign-in additionally needs the platform deep-link config —
  already wired in this repo (Android intent-filter + iOS URL scheme).

## Testing with multiple roles

1. **Create users** — either sign up in the app (email/password or Google;
   each new auth user gets an application `users` row with
   `active_role = customer` via a trigger), or create them in the dashboard
   (Authentication → Users → Add user).
2. **Switch a user's role for testing** — run in the dashboard SQL editor
   (runs as the service role, so the role-guard trigger allows it):

   ```sql
   update public.users
   set active_role = 'business'   -- or 'driver' / 'admin' / 'customer'
   where id = (select id from auth.users where email = 'biz1@test.dev');
   ```

   The app caches the profile until the next auth event — **sign out and
   sign back in** (or hot-restart) to land on the new role's tab set.
   Note: `public.users` has no email column; join through `auth.users`.

3. **Quickstart happy path** — customer signs up → adds address → browses →
   cart → checkout (COD or bank transfer) → business accepts/prepares/ready
   (second account) → driver accepts delivery & completes pickup stops →
   delivered. Then try cancel, reject, returns, reviews, coupons.

4. **Local backend verification** (optional, no Supabase account needed):

   ```bash
   bash supabase/testing/run.sh    # replays all migrations + RPC smoke suite
   ```
