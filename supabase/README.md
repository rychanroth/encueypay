# EncueYPay — Supabase backend

Migrations live in `migrations/` and are applied **per feature phase**
(backend + Flutter land together as vertical slices; the server is
authoritative per spec §53).

## Applying migrations

The Supabase CLI is not installed in this workspace; the folder is prepared
so the CLI can adopt it directly:

```bash
# 1. Install the CLI (https://supabase.com/docs/guides/cli)
# 2. From the repo root:
supabase init                      # creates config.toml; keeps migrations/
supabase link --project-ref <your-project-ref>
supabase db push                   # applies pending migrations in order
```

## Configuration

The Flutter app reads the project URL + anon key via `--dart-define`:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://<ref>.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=<publishable-key>
```

## Auth setup (dashboard)

- **Google OAuth** is the primary sign-in method (DEPS-04): enable the
  Google provider in Authentication → Providers with your OAuth client
  credentials.
- **Email/password** is enabled as a secondary method for testing the four
  roles quickly.
- Mobile OAuth sign-in additionally needs a redirect deep-link configured
  per platform (web/desktop work out of the box).
