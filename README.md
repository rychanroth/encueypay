# encueypay

Feature-driven clean-architecture Flutter storefront backed by Supabase: catalog,
cart + checkout, orders, KHQR (ABA PayWay) payments, wishlist, notifications, and an
admin console (dashboard, products, orders, reports).

The authoritative engineering contract is [`docs/architecture-contract.md`](docs/architecture-contract.md);
the always-loaded working notes and feature state index are in [`AGENTS.md`](AGENTS.md).
Product/UX specifications live in [`docs/DESIGN.md`](docs/DESIGN.md).

## Layout

`lib/features/<feature>/{data,domain,presentation}` with shared code under `lib/core/`.
Features never import other features; `core/router` is the composition root.
Supabase migrations and Edge Functions live in `supabase/`.

## Run

Requires compile-time Supabase config (gitignored `config/.env` for the local stack,
`config/.remote` for the hosted project):

```bash
flutter pub get
flutter run --dart-define-from-file=config/.env
flutter run --dart-define-from-file=config/.remote
```

OAuth/setup prerequisites are in [`supabase/README.md`](supabase/README.md).

## Verify

```bash
dart run build_runner build --delete-conflicting-outputs   # after annotations change
flutter analyze
flutter test
bash supabase/testing/run.sh                               # migrations + RPC smoke
```

Deploy backend changes with `supabase db push` and
`supabase functions deploy payway-create payway-webhook push-dispatch`.

## Docs

- [`docs/DESIGN.md`](docs/DESIGN.md) — screens, tokens, flows.
- [`docs/DEVELOPER-HANDOFF.md`](docs/DEVELOPER-HANDOFF.md) — routes, RPCs, state.
- `docs/HANDOFF-*.md` — per-feature state; `docs/figma/` — frozen design mirror.
