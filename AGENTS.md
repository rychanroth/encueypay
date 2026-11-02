# AGENTS.md

`encueypay` is a **feature-driven clean architecture** Flutter app backed by Supabase.
The authoritative contract is **`docs/architecture-contract.md`** — read the relevant
layer section and its checklist before touching that layer, then run §12 before claiming
done. This file is the always-loaded index; the contract wins on conflict.

## The one rule above all others

**If a situation is not covered by the contract: ask. Do not invent.** (GLOBAL-01)
Silent invention is how architecture drifts.

## Hard invariants (IDs defined in the full contract)

- **Never** hand-edit generated files: `*.g.dart` and `*.freezed.dart` (GLOBAL-03).
- **Never** add/remove/upgrade dependencies without approval (GLOBAL-04 / DEPS-01).
- **Never** create new `core/` packages, feature layers, or top-level `lib/` dirs
  without approval (GLOBAL-05).
- **Never** refactor code outside the task's scope — report violations instead (GLOBAL-02).
- **Layering:** `presentation → domain ← data` per feature; features never import
  features; `core` never imports features — except `core/router`, the composition root
  (ARCH-03…05).
- **Routing:** names only via `AppRoutes` static consts + `context.goNamed` (ROUTE-01/02);
  one branch file per tab under `core/router/branches/`; branch order = NavigationBar
  order (ROUTE-04/05).
- **Data:** DTOs (`FieldRename.snake`) never leave `data/`; mapping via `<Dto>X.toDomain()`
  extensions; `I<Name>Repository` interface + `Impl` in separate files; exceptions map to
  `Failure` at the repository boundary only — via `mapRepositoryError`
  (backend → `ServerFailure`, sockets → `NetworkFailure`, anything else → logged
  `UnexpectedFailure`; bare `catch (_)` is banned); streams surface `StreamError` events
  (DATA-01…09).
- **Domain:** entities are immutable freezed classes (DTOs stay plain
  json_serializable); use cases = one class, `call()`, interface-injected, own
  manual Provider. Pragmatic split: use cases for real domain logic, controllers
  MAY call the repo for plain one-shot fetches (DOMAIN-01…04).
- **Presentation:** controllers use `@riverpod` codegen (manual providers are for
  wiring only); mutations via `AsyncValue.guard` + `ref.invalidateSelf()` — no optimistic
  UI; state classes immutable via freezed (`==`/`copyWith` generated); screens never
  import repos/DTOs; extract sub-widgets into `presentation/widgets/` (PRES-01…06).
- **Theme:** single `ThemeController` in `core/presentation/theme/`; `shared_preferences`
  stores only the `ThemeMode` — the one sanctioned local persistence (THEME-01/02,
  CORE-05: **no local DB / caching anywhere**).
- **Responsive:** mobile-first; branch on `context.screenSize`
  (`compact < 600 ≤ medium < 840 ≤ expanded`) from
  `core/presentation/responsive/`; no scaling packages (RESP-01…04).
- **Backend:** Supabase only; Google OAuth primary (DEPS-04). `dio` and
  `go_router_builder` are declared but have no contracted role — do not use them (DEPS-01).

## Commands

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # after @riverpod/@JsonSerializable/freezed changes
flutter analyze                                            # must be clean before done
flutter test                                               # no CI — run locally
flutter test test/failure_mapping_test.dart                # focused run
```

Running the app requires compile-time Supabase config; `main()` throws without it:

```bash
flutter run \
  --dart-define=SUPABASE_URL=<url> \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=<publishable-key>
```

Values live in gitignored `config/.env`; local-stack and physical-device OAuth
prerequisites (including the ephemeral `adb reverse`) are in `supabase/README.md`.
Never commit `config/`, `supabase/functions/.env`, or platform secrets.

## Supabase / migrations

Migrations live in `supabase/migrations/` and apply in filename order; app and DB ship
together as vertical slices. Commands:

```bash
supabase db push                                            # remote project
bash supabase/testing/run.sh                               # replay all migrations + RPC smoke
supabase functions deploy payway-create payway-webhook push-dispatch
```

- The local harness expects PostgreSQL on `/tmp:55432` (setup notes in
  `supabase/testing/run_migrations.sh`).
- Function signature change: `DROP FUNCTION` first. `CREATE OR REPLACE` with a changed
  signature **adds an overload**, which breaks PostgREST calls.
- `ALTER TYPE ... ADD VALUE` must be its own migration file.
- Drop dependent RLS policies before `DROP COLUMN`.
- **Never** re-run `supabase/APPLY-UI-OVERHAUL-MIGRATIONS.sql` — it regresses current RPCs.
- PostgREST here has no inline aggregates (DATA-09); use views/RPCs.

## Definition of Done

§12 of the contract. Minimum: `flutter analyze` clean, codegen regenerated, import fences
hold, errors mapped at the repository boundary, no dependency/scope creep. Commit each
slice after DoD.

## Feature state index

Active handoffs live in `docs/HANDOFF-<FEATURE>.md` — read the feature's handoff before
resuming it. If a handoff contradicts this file, this file wins.

- **Checkout:** mid-flight; the referenced `PLAN-CHECKOUT.md` was never written — gauge
  state from `git log` and the contract.
- **Promotions:** `docs/HANDOFF-PROMOTIONS.md` — sales + standalone codes; awaiting
  `supabase db push` and its §6 verification.
- **KHQR:** `docs/HANDOFF-KHQR.md`.
- `FEATURE_VERIFICATION_MATRIX.md` is a 2026-10-07 audit and is stale; trust the contract
  and current code over it.

> Feature done → promote durable lessons into the contract, then delete the handoff.
