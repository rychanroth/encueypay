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
  `drift_dev` is still in `dev_dependencies` with no drift code; DEPS-02 schedules its
  removal — do not start using drift (CORE-05 bans local persistence).

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
flutter run --dart-define-from-file=config/.env     # local stack
flutter run --dart-define-from-file=config/.remote  # hosted project
# or explicitly:
flutter run \
  --dart-define=SUPABASE_URL=<url> \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=<publishable-key>
```

Values live in gitignored `config/.env` / `config/.remote`; local-stack and
physical-device OAuth prerequisites (including the ephemeral `adb reverse`) are in
`supabase/README.md`. Never commit `config/`, `supabase/functions/.env`, or platform
secrets.

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
- Local edge functions need secrets in the CLI process environment; `supabase start` does
  NOT read `supabase/functions/.env` on its own. Source **both** `config/.env` and
  `supabase/functions/.env` before `supabase start`, and never `docker restart` the edge
  runtime (it drops injected secrets). Details in `docs/HANDOFF-KHQR.md` §3.
- Function signature change: `DROP FUNCTION` first. `CREATE OR REPLACE` with a changed
  signature **adds an overload**, which breaks PostgREST calls.
- `ALTER TYPE ... ADD VALUE` must be its own migration file.
- Drop dependent RLS policies before `DROP COLUMN`.
- **Never** re-run `supabase/APPLY-UI-OVERHAUL-MIGRATIONS.sql` — it regresses current RPCs.
- PostgREST here has no inline aggregates (DATA-09); use views/RPCs.

## Definition of Done

§12 of the contract. Minimum: `flutter analyze` clean, codegen regenerated, import fences
hold, errors mapped at the repository boundary, no dependency/scope creep. After each DoD, `git add` the related files, and `git commit -m [message]`.

**Commit authorization:** the user pre-authorizes that commit after each slice/DoD.
Do not wait for a separate “please commit” message. If a session-level rule
conflicts, surface the conflict and treat this repo instruction as the user’s
explicit authorization to commit the completed slice.

## Feature state index

Active handoffs live in `docs/HANDOFF-<FEATURE>.md` — read the feature's handoff before
resuming it. If a handoff contradicts this file, this file wins.

- **Checkout:** no active handoff. The flat one-page checkout, server-priced cart lines,
  and QR order lifecycle landed in `e649771`. Checkout is selection-aware: only the
  cart lines ticked on the cart page are priced and placed (`create_order_from_cart`
  takes `p_item_ids`); `docs/DESIGN.md` still describes the retired multi-step wizard —
  the contract and current code win.
- **Cart:** no active handoff. Taobao-style selectable cart landed 2026-11-16
  (`5ea0193`, `fee03a2`): tick lines + select-all, client-side search/filter/sort,
  delivery-address and store bands, shared trust card, swipe-to-delete. Migration
  `20261116000001` is applied locally and hosted.
- **Admin reporting:** no active handoff. Revenue/AOV definition is `realized_orders`
  (delivered or `payments.status = 'transaction_verified'`; never cancelled/returned/
  refunded). Both `get_sales_report` and `get_admin_kpis` read it; `20261116000002`
  applied locally and hosted. `docs/DESIGN.md` §5.2/§7.1 carries the definition.
- **Promotions:** `docs/HANDOFF-PROMOTIONS.md` — the 2026-11-03 reset wiped
  sales/coupons/banners; re-author them in the admin UI, then run the §6 verification.
- **Variants:** `docs/HANDOFF-VARIANTS.md` — explicit variants only (no implicit
  Default); migration `20261103000001` applied locally and hosted. `base_price_minor`
  is a derived cache, never a pricing fallback.
- **UX/visual:** `docs/HANDOFF-UX-VISUAL.md` — implementation and motion pass complete;
  only device visual QA remains (compact/expanded, light/dark, large text).
- **Push/FCM:** `docs/HANDOFF-FCM.md` — hosted pipeline verified 2026-11-07
  (background tray + tap open); foreground now shows a native local notification.
  The service-role `device_tokens` grant fix is in `20261107000001`. Remaining:
  iOS platform config, admin/new-order and promo notifications.
- **KHQR:** `docs/HANDOFF-KHQR.md` — working end-to-end (hosted functions + PayWay
  callback live, 2026-11-03); hosted sandbox re-verified 2026-11-16 (real QR returned,
  terminal orders now refused, `service_role` orders grant in `20261116000003`).
  Production credentials remain a launch checklist item.
- **Figma mirror:** **frozen snapshot** — record in `docs/figma/PLAN.md`, pinned ids
  and commits in `docs/figma/manifest.json`. 18 component sets, 30 screens, 9 FigJam
  diagrams, page 03, two unmetered local dev plugins (`docs/figma/plugin/`,
  `docs/figma/plugin-figjam/`). Nothing to rebuild or resume; do not restart a standing
  mirror, and for demo visuals capture the running app instead.
- `FEATURE_VERIFICATION_MATRIX.md` is a 2026-10-07 audit and is stale; trust the contract
  and current code over it.

> Feature done → promote durable lessons into the contract, then delete the handoff.
