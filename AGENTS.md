# AGENTS.md

You are modifying a **feature-driven clean architecture** Flutter app. The full,
authoritative contract is **`docs/architecture-contract.md`** — read the relevant
section before touching a layer, and run its checklist before claiming done. This file
is the always-loaded index.

## The one rule above all others

**If a situation is not covered by the contract: ask. Do not invent.** (GLOBAL-01)
Silent invention is how architecture drifts.

## Hard invariants (IDs defined in the full contract)

- **Never** hand-edit `*.g.dart`; regenerate instead (GLOBAL-03).
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
  `Failure` at the repository boundary only; streams surface `StreamError` events
  (DATA-01…08).
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
  `go_router_builder` have no contracted role — do not use them (DEPS-01).

## Commands

```bash
dart run build_runner build --delete-conflicting-outputs   # codegen (rivers, DTOs)
flutter analyze                                            # must be clean before done
```

## Definition of Done

Full checklist in §12 of the contract. Minimum: analyze clean, codegen regenerated,
import fences hold, errors mapped at repo boundary, no dependency/scope creep.
