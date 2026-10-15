# Architecture Contract

**Version:** 2.2.0 · **Status:** Ratified (2026-09-27) · **Owner:** Project maintainer
**2.2.0 (2026-10-15):** DATA-09 added (PostgREST aggregate constraint); THEME-03 updated to the as-built token system; §3 CORE widget inventory; ACTION-02 recorded (single-seller schema retirement, migrations 0008–0010).
**Audience:** Every AI agent and human contributor modifying this codebase.

This document is the single source of truth for how code is structured in this project.
It exists specifically to prevent architectural drift by AI agents. It is written as an
executable spec, not as prose.

---

## 0. How to read and use this contract

**Normative language** (RFC-2119 style):

| Keyword | Meaning |
|---|---|
| MUST / MUST NOT | Non-negotiable. A change that violates it is wrong, full stop. |
| SHOULD / SHOULD NOT | The default. Deviating requires a documented exception or user approval. |
| MAY | Explicitly permitted option. |

**Rule IDs** are stable (`ARCH-01`, `DATA-05`, …). Never renumber rules; only add or
deprecate. Cite rule IDs in code review, prompts, and commit messages.

**Agent workflow:**

1. `AGENTS.md` (repo root) is always loaded; it is the lean index of this document.
2. Before touching a layer, read that layer's section **and its checklist** here.
3. Before finishing, run the **Definition of Done** (§12).
4. If a situation is not covered by this contract → **ask the user. Do not invent.**

**Precedence order** when instructions conflict:

1. An explicit instruction from the user in the current task.
2. This contract.
3. The agent's own judgment — and if judgment would override (2), stop and ask.

---

## 1. GLOBAL — Meta rules

- **GLOBAL-01 (Ask, don't invent).** If a situation is not covered by this contract, the
  agent MUST ask the user instead of inventing a convention. Silent invention is the
  primary drift vector and is forbidden.
- **GLOBAL-02 (Scope discipline).** The agent MUST NOT refactor, "improve," or reorganize
  code outside the explicit scope of the current task — even code that appears to violate
  this contract. Instead, report the violation in the final summary. Fixes happen via
  §10 (Actions) or explicit user request.
- **GLOBAL-03 (Generated files).** Files matching `*.g.dart` are generated. The agent
  MUST NOT hand-edit them. Regenerate with:

  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```

- **GLOBAL-04 (Dependencies).** The agent MUST NOT add, remove, upgrade, or downgrade any
  package without explicit user approval. See §9.
- **GLOBAL-05 (Core creation is ask-first).** The agent MUST NOT create new subpackages or
  layers under `core/`, new layers within a feature, or new top-level directories under
  `lib/` on its own initiative. Only the specification (this contract or the task) may
  call a new package into existence — otherwise, prompt the user first.
- **GLOBAL-06 (Verification).** Before claiming a task complete, `flutter analyze` MUST
  report no new issues, and codegen MUST be regenerated if any `@riverpod` /
  `@JsonSerializable` annotation was added or changed.

---

## 2. ARCH — Layering & import fences

- **ARCH-01.** The app is **feature-driven clean architecture**. Product code lives in
  `lib/features/<feature>/`. Code shared across features lives in `lib/core/`.
- **ARCH-02.** Every feature MUST contain exactly three layers: `data/`, `domain/`,
  `presentation/`. Subfolders are created when the first file for them arrives.

  ```
  features/<name>/
  ├── data/
  │   ├── dtos/         # json_serializable DTOs (+ generated .g.dart)
  │   ├── mappers/      # DTO → entity extensions
  │   └── repository/   # interface + impl + repo provider
  ├── domain/
  │   ├── entities/     # plain immutable classes
  │   └── usecases/     # one class per use case (+ provider)
  └── presentation/
      ├── controllers/  # Riverpod codegen controllers
      ├── screens/      # route-level widgets
      ├── states/       # immutable state classes
      └── widgets/      # extracted reusable sub-widgets (PRES-06)
  ```

  The `catalog` feature is the reference implementation.

- **ARCH-03 (Dependency direction).** Inside a feature: `presentation → domain ← data`.
  `domain/` MUST NOT import from `data/` or `presentation/`.
- **ARCH-04 (Feature isolation).** Features MUST NOT import other features. Shared code
  goes through `core/`; if none exists, ask (GLOBAL-01).
- **ARCH-05 (Core purity).** `core/` MUST NOT import from `features/` — with one
  exception: `core/router` is the composition root and MAY import feature screens
  (ROUTE-08).
- **ARCH-06 (Core justification).** A module in `core/` must serve 2+ features or be
  app-shell infrastructure (router, network, theme, responsive).

**Procedure — adding a new feature:**
1. Create `features/<name>/{data,domain,presentation}`.
2. Work inside-out: entity → DTO/mapper → repository → use case → controller → screen.
3. Register routes (ROUTE-03 / ROUTE-04) and route names (ROUTE-01).
4. Run build_runner + `flutter analyze`.

**Anti-patterns:** a `domain/` file importing Flutter or Supabase; a feature importing
another feature; shared code duplicated into two features instead of promoted to `core/`
(promotion is ask-first, GLOBAL-05).

---

## 3. CORE — The `core/` map

| Package | Contents | Rules |
|---|---|---|
| `core/domain` | Shared domain primitives: `Failure` taxonomy (`failures.dart`), `StreamResult<T>` (`stream_result.dart`) | CORE-02 |
| `core/network` | External service clients: `supabaseClientProvider` | CORE-03 |
| `core/presentation` | Shared UI: `NotFoundScreen`, `theme/` (§8), `responsive/` (§9), `widgets/` (EncueButton, EncueCard, StatusBadge, AsyncValueWidget, KhqrCard, PriceText, MonogramImage) | CORE-04 |
| `core/router` | `AppRoutes`, `appRouterProvider`, `branches/`, shell scaffold in `presentation/` | ROUTE-* |
| `core/data` | **Forbidden.** No local persistence exists in this app (§10, ACTION-01) | CORE-05 |

- **CORE-01.** New `core/` subpackages are ask-first (GLOBAL-05).
- **CORE-02.** Shared domain primitives (`Failure`, `StreamResult`) live in `core/domain`.
  Features MUST NOT redefine them locally. Feature-specific entities stay in
  `features/<f>/domain/entities/`.
- **CORE-03.** `supabaseClientProvider` is the only supplier of `SupabaseClient`. It is
  consumed exclusively by repository implementations (DATA-04).
- **CORE-04.** `core/presentation` holds only UI shared across features. Feature-specific
  widgets stay in the feature.
- **CORE-05.** No local persistence: no database, no caching layer, no local datasource
  anywhere. The single sanctioned exception is THEME-02 (theme mode in
  `shared_preferences`).

---

## 4. ROUTE — Routing (go_router)

- **ROUTE-01 (Single source of route names).** All route names MUST be declared as
  `static const` fields of the abstract `AppRoutes` class in
  `core/router/app_routes.dart`. Magic strings in navigation calls are forbidden.

- **ROUTE-02 (Navigate by name).** Use `context.goNamed(AppRoutes.x)` with parameters —
  never raw path strings. Raw paths appear only inside route *definitions*.

- **ROUTE-03 (Shell layout).** Full-screen overlays (e.g. login) are declared **outside**
  the shell. Tab destinations live **inside** `StatefulShellRoute.indexedStack`.

- **ROUTE-04 (One branch file per tab).** Each tab is a `StatefulShellBranch` in its own
  file under `core/router/branches/`. Nested routes of that tab are declared in the same
  file.

- **ROUTE-05 (Order is sacred).** The order of `branches:` MUST strictly match the order
  of `NavigationDestination`s in the shell scaffold (`core/router/presentation/`).

- **ROUTE-06 (Shell scaffold location).** The shell scaffold lives in
  `core/router/presentation/`.

- **ROUTE-07 (Riverpod ↔ GoRouter bridge).** The router is built in `appRouterProvider`
  (a manual `Provider`). Auth-driven refresh uses a `ValueNotifier` fed by `ref.listen`
  — because a provider body does not re-run like a widget build, the listener is what
  pushes state changes into GoRouter's `refreshListenable`. The provider body MUST NOT
  watch the full auth state — initialize the notifier with `ref.read`. Watching it
  would rebuild the provider, recreating the GoRouter on every session transition and
  stranding navigation mid-flow (observed: the OAuth deep-link return landed on a
  stale login route). The GoRouter is recreated **only** when the active role changes,
  via a `select` on the role.

- **ROUTE-08 (Composition root).** `core/router` MAY import feature screens — the single
  exception to ARCH-05.

- **ROUTE-09 (Unknown routes).** `errorBuilder` renders `NotFoundScreen` from
  `core/presentation`.

- **ROUTE-10 (Auth redirect pattern).** Redirect logic follows the canonical shape:
  while the initial auth state is loading, return `null` **only for locations that
  match a route** — unmatched locations redirect to login (the bare root `/` and the
  OAuth deep-link landing both normalize to matchedLocation `/` in go_router: a
  custom-scheme URI's host is not part of the path, so `io.supabase.<app>://login-callback/`
  parses to `/`); unauthenticated user on any non-login route → login; authenticated
  user on login **or on the deep-link landing (`/`)** → default tab.

**Canonical — Riverpod → GoRouter bridge:**

```dart
final appRouterProvider = Provider<GoRouter>((ref) {
  // ref.read, never ref.watch: a watch on the full auth state would rebuild
  // this provider — recreating the GoRouter — on every session transition.
  final refreshListenable =
      ValueNotifier<AsyncValue<AuthState>>(ref.read(authControllerProvider));

  // Bridge Riverpod state to GoRouter's Listenable API
  // (no re-run happens here like in a Widget class).
  ref.listen<AsyncValue<AuthState>>(authControllerProvider, (prev, next) {
    refreshListenable.value = next;
  });

  return GoRouter(
    // ...
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final authAsync = ref.read(authControllerProvider);
      if (authAsync.isLoading) {
        // While loading, hold only unmatched locations (the bare root and the
        // OAuth deep-link landing — both normalize to `/`) on login; deep
        // links into real routes pass through.
        return state.matchedLocation == '/'
            ? state.namedLocation(AppRoutes.login)
            : null;
      }

      final isAuthenticated = authAsync.value?.session != null;
      final isLoggingIn = state.matchedLocation == '/login';
      if (!isAuthenticated && !isLoggingIn) {
        return state.namedLocation(AppRoutes.login);
      }
      if (isAuthenticated && (isLoggingIn || state.matchedLocation == '/')) {
        return state.namedLocation(AppRoutes.catalog);
      }
      return null;
    },
  );
});
```

**Anti-patterns:** navigating with `context.go('/catalog')`; declaring a route name
inline; putting a branch in `app_router.dart` instead of its own file; reordering
branches without reordering `NavigationDestination`s; watching the full auth state
inside `appRouterProvider` (recreates the GoRouter on every session change —
session updates flow through `ref.listen` only).

---

## 5. DATA — Data layer

- **DATA-01 (DTOs).** One DTO per entity per backend table, in `data/dtos/`, annotated
  `@JsonSerializable(fieldRename: FieldRename.snake)`, with generated
  `fromJson`/`toJson`. DTOs MUST NOT leave the data layer.

- **DATA-02 (Mappers).** Mapping is an extension `<EntityDto>X` on the DTO in
  `data/mappers/`, exposing a single `toDomain()` method. Null-coalescing defaults live
  here — never in the UI.

- **DATA-03 (Repository contract).** The interface `I<Name>Repository` lives in
  `<name>_repository.dart`; the implementation `<Name>RepositoryImpl` lives in
  `<name>_repository_impl.dart` — same `data/repository/` folder, separate files.

- **DATA-04 (Client injection).** The impl receives `SupabaseClient` via constructor
  injection, sourced from `supabaseClientProvider`.

- **DATA-05 (Error mapping at the boundary).** The repository is the ONLY layer that may
  catch raw exceptions. Mapping is fixed:
  `PostgrestException` → `ServerFailure(e.message)`; anything else → `NetworkFailure()`.
  No raw exception may cross into `domain/` or `presentation/`.

- **DATA-06 (Streaming).** Repository streams surface failures as `StreamError(failure)`
  data events via `handleError` — so stream consumers switch on `StreamResult`, and
  errors never terminate the stream.

- **DATA-07 (Repository provider).** A manual `Provider<I<Name>Repository>` in the impl
  file, exposing the **interface** type — never the impl class.

- **DATA-08 (Supabase only).** Table access happens exclusively inside repository impls
  via `_client.from('<table>')`. No SQL, table names, or client access anywhere else.

**Procedure — adding a data flow:**
1. DTO (if the wire shape differs from the entity) → run build_runner.
2. Mapper extension with null-defaults.
3. Method on `I<Name>Repository`.
4. Impl with error mapping (DATA-05 / DATA-06).
5. Consume via use case (DOMAIN-03) or controller.

**Canonical — DTO + mapper:**

```dart
@JsonSerializable(fieldRename: FieldRename.snake)
class CelestialBodyDto {
  final String id;
  final String name;
  final String type;
  final String? description;
  final double? distanceLy;
  // ...
  factory CelestialBodyDto.fromJson(Map<String, dynamic> json) =>
      _$CelestialBodyDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CelestialBodyDtoToJson(this);
}

extension CelestialBodyDtoX on CelestialBodyDto {
  CelestialBody toDomain() => CelestialBody(
        id: id,
        name: name,
        type: type,
        description: description ?? "No description available.",
        distance: distanceLy ?? -1.0,
      );
}
```

**Canonical — error mapping (future):**

```dart
try {
  // Supabase call
} on PostgrestException catch (e) {
  throw ServerFailure(e.message);
} catch (_) {
  throw const NetworkFailure();
}
```

**Canonical — error mapping (stream):**

```dart
_client
    .from('celestial_bodies')
    .stream(primaryKey: ['id']) // Required by Supabase
    .map((rows) =>
        rows.map((j) => CelestialBodyDto.fromJson(j).toDomain()).toList())
    .handleError((error) {
      final failure = (error is PostgrestException)
          ? ServerFailure(error.message)
          : const NetworkFailure();
      return StreamError(failure);
    });
```

**Canonical — provider:**

```dart
final celestialRepoProvider = Provider<ICelestialRepository>((ref) {
  return CelestialRepositoryImpl(ref.watch(supabaseClientProvider));
});
```

**Anti-patterns:** `@JsonSerializable` on an entity; a mapper used from UI code; a repo
method returning a DTO; catching `PostgrestException` in a controller; `_client.from(...)`
outside `data/repository/`.

- **DATA-09 (Backend PostgREST constraints).** This deployment's PostgREST does
  not support inline aggregate functions in select parameters (≥ v12,
  `db-aggregates` opt-in). Computed values come from plain SQL views exposed
  through FK-detectable embeds (`product_ratings` is the precedent) or from
  RPCs (`get_sales_report`). Every select must reference only columns that
  exist in the current schema — when the schema retires a column, sweep the
  SQL *strings* in repositories (not just Dart field names; both
  snake_case column forms and Dart camelCase forms).

**Checklist:**
- [ ] DTO annotated with `FieldRename.snake`, `.g.dart` regenerated, not hand-edited.
- [ ] Null-defaults applied in the mapper, not in widgets.
- [ ] Interface and impl in separate files; provider exposes the interface.
- [ ] Every method maps exceptions to `Failure` (futures throw, streams emit `StreamError`).
- [ ] Selects reference only existing columns; aggregates via views/RPCs (DATA-09).

---

## 6. DOMAIN — Domain layer

- **DOMAIN-01 (Entities).** Immutable classes generated with **freezed**
  (`@freezed abstract class X with _$X` + `part 'x.freezed.dart'`; user
  decision, 2026-09-24). No Flutter / json / Supabase imports. Computed
  getters/methods live in the class body (declare `const X._();` so the
  generated class inherits them); DTOs remain plain `json_serializable`
  classes. They model the business object after mapper defaults are applied
  (e.g. nullable wire fields become non-nullable on the entity).

- **DOMAIN-02 (Use case shape).** A use case is one class with one purpose, a `call()`
  method, the repository **interface** constructor-injected, and its own manual
  `Provider` in the same file.

- **DOMAIN-03 (Pragmatic split — ratified decision).** Use cases exist for real domain
  logic (sorting, filtering, combining, business rules). Controllers MAY call the
  repository interface directly for plain one-shot fetches (e.g.
  `fetchCelestialBodyById`, `checkIsBookmarked`). If logic is needed by two or more
  controllers, it MUST be promoted into a use case.

- **DOMAIN-04 (Shared primitives).** `Failure` and `StreamResult` come from
  `core/domain` (CORE-02). Never redefine them.

**Canonical — use case:**

```dart
class StreamCelestialBodiesUseCase {
  final ICelestialRepository _repository;
  StreamCelestialBodiesUseCase(this._repository);

  Stream<List<CelestialBody>> call() {
    // Domain rule: sort alphabetically
    return _repository
        .streamCelestialBodies()
        .map((bodies) => bodies..sort((a, b) => a.name.compareTo(b.name)));
  }
}

final streamCelestialBodiesUseCaseProvider =
    Provider<StreamCelestialBodiesUseCase>(
        (ref) => StreamCelestialBodiesUseCase(ref.watch(celestialRepoProvider)));
```

**Anti-patterns:** an entity importing anything from `data/`; a use case with injected
`SupabaseClient`; business logic (sorting, defaults) living in a screen; a one-shot fetch
wrapped in a use case "for symmetry."

---

## 7. PRES — Presentation layer

- **PRES-01 (Codegen split — ratified convention).** Controllers (UI-facing state) MUST
  use Riverpod codegen: `@riverpod`, `part '<file>.g.dart'`, regenerate with
  build_runner. Manual providers are reserved for wiring: clients, repositories, use
  cases (DATA-07, DOMAIN-02).

- **PRES-02 (State shape).** Controller states are immutable classes in `states/`,
  named `<Thing>State`, generated with freezed (`==`/`hashCode`/`copyWith` come
  from the generator — do not hand-write them). UI-only flags (e.g.
  `isDescriptionExpanded`) live in the state class — not in loose fields on the
  controller.

- **PRES-03 (Mutations).** Wrap mutations in `AsyncValue.guard`, then
  `ref.invalidateSelf()` to re-run `build()` and refetch ground truth. **No optimistic
  UI** — state reflects backend truth after the mutation completes.

- **PRES-04 (Screens are dumb-ish).** Screens watch controllers. Screens MUST NOT import
  repositories, `supabaseClientProvider`, DTOs, or mappers.

- **PRES-05 (Rebuild scoping).** Use `ref.watch(...select(...))` where it meaningfully
  narrows rebuilds (e.g. pulling one field out of a state).

- **PRES-06 (Widget extraction — ratified rule).** When possible, split smaller widgets
  into their own file: reusable or growing sub-widgets go to the feature's
  `presentation/widgets/`. A screen file contains screen-level layout, not deep nests of
  inline widgets.

**Canonical — controller with mutation:**

```dart
@riverpod
class CelestialDetailController extends _$CelestialDetailController {
  @override
  Future<CelestialDetailState> build(String id) async {
    final repo = ref.watch(celestialRepoProvider);
    final body = await repo.fetchCelestialBodyById(id);
    // Retrieved from the DB for realtime state accuracy
    final isBookmarked = await repo.checkIsBookmarked(id);
    return CelestialDetailState(body: body, isBookmarked: isBookmarked);
  }

  Future<void> toggleBookmark() async {
    final value = state.value;
    if (value == null) return;

    state = await AsyncValue.guard(() async {
      final repo = ref.read(celestialRepoProvider);
      // 1. Backend mutation through the repository
      await repo.toggleBookmark(value.body.id, !value.isBookmarked);
      // 2. Invalidate self: re-runs build() for fresh ground truth
      ref.invalidateSelf();
      return value;
    });
  }
}
```

**Anti-patterns:** a manual `StateProvider`/`NotifierProvider` for UI state; optimistic
`state = state.copyWith(...)` after a mutation instead of invalidate-refetch; a screen
importing `celestial_repository_impl.dart`; a 300-line `build()` with inline sub-widgets.

**Checklist:**
- [ ] Controller uses `@riverpod` codegen; `.g.dart` regenerated.
- [ ] State class is immutable with `copyWith`.
- [ ] Mutations go through `AsyncValue.guard` + `ref.invalidateSelf()`.
- [ ] Screen imports only controllers, entities, and route/theme/responsive helpers.
- [ ] Sub-widgets extracted per PRES-06.

---

## 8. THEME — Unified theming

Single source of truth for theme state. Lives in `core/presentation/theme/`.

- **THEME-01 (One controller).** `ThemeController` in
  `core/presentation/theme/theme_controller.dart` — a `@riverpod` codegen
  `Notifier<ThemeMode>`. `MaterialApp` reads `themeMode` from it. No other component
  stores or derives theme state.

- **THEME-02 (The persistence exception).** Theme mode is the **only** sanctioned local
  persistence in the app (exception to CORE-05): `shared_preferences` stores exactly the
  `ThemeMode.name` string under exactly one key. No other preference may be persisted
  without user approval.

- **THEME-03 (ThemeData & tokens).** Custom `ThemeData` lives in
  `core/presentation/theme/app_theme.dart` as `AppTheme.light` / `AppTheme.dark`
  — explicit `ColorScheme`s per brightness (no seed derivation) with global
  component themes (48dp/r8 buttons, r12 inputs, r16 cards, r24 sheets).
  It composes the DESIGN.md token files: `app_colors.dart` (palette + the
  §2.2 wire-name-keyed status-badge table), `app_typography.dart`
  (Plus Jakarta Sans, bundled in `pubspec.yaml` — 400–800 static TTFs), and
  `app_dimensions.dart` (8dp spacing rhythm, radii, elevation shadows).
  `MaterialApp` wires `theme:`/`darkTheme:` from there. Screens read colors
  through the `ColorScheme`/`TextTheme`; direct token reads are reserved for
  the theme builder and the badge/KHQR chrome.

- **THEME-04 (Hydration before first frame).** Theme is hydrated in `main()` before
  `runApp` — no theme flash and no side effects inside `build()`.

**Canonical — theme controller:**

```dart
// core/presentation/theme/theme_controller.dart
part 'theme_controller.g.dart';

@riverpod
class ThemeController extends _$ThemeController {
  static const _prefsKey = 'app.themeMode';

  @override
  ThemeMode build() => ThemeMode.system;

  /// Called once at startup, before runApp.
  Future<void> hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = ThemeMode.values.asNameMap()[prefs.getString(_prefsKey)];
    if (mode != null) state = mode;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, mode.name);
  }
}
```

**Canonical — startup wiring:**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(/* ... */);

  final container = ProviderContainer();
  await container.read(themeControllerProvider.notifier).hydrate();

  runApp(
    UncontrolledProviderScope(container: container, child: const MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeControllerProvider),
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
```

**Anti-patterns:** theme mode stored per-feature or per-screen; reading
`SharedPreferences` inside a widget build; a second settings cache duplicating
`ThemeController`; persisting anything else locally.

---

## 9. RESP — Responsiveness (mobile-first)

- **RESP-01 (Mobile-first).** Design for compact widths first. Wider layouts are
  progressive enhancement. The app is **not** optimized for desktop, even though it
  builds on Linux.

- **RESP-02 (Window size classes).** Breakpoints follow the Material 3 window size
  classes, exposed as a `ScreenSize` enum from
  `core/presentation/responsive/screen_size.dart`:

  | Class | Width |
    |---|---|
  | `compact` | < 600 |
  | `medium` | 600 – 839 |
  | `expanded` | ≥ 840 |

- **RESP-03 (Centralized MediaQuery logic).** UI code branches on
  `context.screenSize`, not on scattered raw `MediaQuery.of(context).size.width`
  comparisons. Width math lives in exactly one file.

- **RESP-04 (No scaling packages).** Third-party responsive/scaling packages
  (`flutter_screenutil`, `responsive_framework`, etc.) are forbidden unless the user
  explicitly approves one (GLOBAL-04). The custom enum is the whole mechanism — it is
  deliberately minimal.

**Canonical:**

```dart
// core/presentation/responsive/screen_size.dart
import 'package:flutter/material.dart';

enum ScreenSize { compact, medium, expanded }

extension ScreenSizeX on BuildContext {
  /// Material 3 window size classes.
  ScreenSize get screenSize {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= 840) return ScreenSize.expanded;
    if (width >= 600) return ScreenSize.medium;
    return ScreenSize.compact;
  }
}
```

**Usage:**

```dart
final size = context.screenSize;
if (size == ScreenSize.compact) { /* bottom sheet */ }
else { /* split view / dialog */ }
```

**Anti-patterns:** hardcoded pixel-width checks in widgets; `flutter_screenutil`;
designing the expanded layout first and "shrinking down"; duplicating breakpoint
constants per feature.

---

## 10. DEPS — Dependencies & services

- **DEPS-01 (Target allow-list).** The dependency set below is the contracted target
  state. Anything not on this list must not be introduced without approval (GLOBAL-04).

  | Package | Role |
    |---|---|
  | `flutter_riverpod` ^3.4.3 | State management |
  | `go_router` ^18.0.1 | Navigation |
  | `supabase_flutter` ^2.17.2 | Backend (database, realtime, auth) |
  | `shared_preferences` | **Only** theme-mode persistence (THEME-02) |
  | `cupertino_icons` | Icons |
  | `file_picker` ^13 | Proof/image picking (user-approved 2026-09-24) |
  | `freezed` + `freezed_annotation` | Immutable entities & states (user-approved 2026-09-24 — DOMAIN-01/PRES-02) |
  | `dio` ^5.11.1 | *Role undefined in this contract — MUST NOT be used until the user defines it* |
  | `go_router_builder` ^4.5.0 | *Role undefined in this contract — MUST NOT be used; navigation is name-based (ROUTE-02)* |
  | dev: `flutter_lints`, `build_runner`, `json_serializable`, `riverpod_annotation`, `riverpod_generator`, `freezed` | Toolchain |

- **DEPS-02 (Scheduled removals).** `drift`, `sqlite3_flutter_libs`, `path_provider`
  (and `drift_dev`) are removed per the no-local-persistence decision (ACTION-01).

- **DEPS-03 (Zero-dependency bias).** Prefer a small in-repo solution over a new package
  (RESP-04 is the model). New packages are essential-complexity-only, user-approved.

- **DEPS-04 (Backend contract).** Supabase is the only backend. Auth is Supabase Auth,
  with Google OAuth as the primary sign-in method. No second auth provider or REST layer
  without approval.

---

## 11. Actions & known deviations

**Actions** — mandated changes, executed only when explicitly tasked (GLOBAL-02):

- **ACTION-01 (Remove local persistence).** Delete `core/data/local/` (`app_database`,
  `connection`, `tables/`) and the `drift` / `sqlite3_flutter_libs` / `path_provider`
  / `drift_dev` dependencies. Repositories talk to Supabase only.
- **ACTION-02 (Single-seller schema retirement — EXECUTED 2026-10-13, user decision).**
  The prototype pivoted from a vendor-capable data model to an admin-centric
  single-seller application. Executed via migrations 0008 (drop
  `products.business_id`, `promotions.business_id`, `order_coupons.business_id`,
  `order_items.business_name`, the `businesses` table; rework the vendor-era
  RLS read policies to product-level visibility; checkout/coupon RPCs lose
  the business dimension) and 0010 (drop stale RPC overloads — Postgres
  overloads instead of replacing when a signature changes). Product images
  upload under `{product_id}/…`; promotions are platform|brand scoped only
  (the dormant `'business'` enum value remains — Postgres cannot drop enum
  values).

**Known deviations** — acknowledged debt. Do **not** fix unprompted (GLOBAL-02); fix on
the next touch of the file or on request:

- **DEV-01.** `CelestialRepositoryImpl.fetchCelestialBodyById` and
  `checkIsBookmarked` do not map exceptions to `Failure` (violates DATA-05), unlike
  `toggleBookmark` which does it correctly.

---

## 12. Definition of Done (run before claiming any task complete)

- [ ] `flutter analyze` — no new issues.
- [ ] `dart run build_runner build --delete-conflicting-outputs` — run if any annotation
  changed; no hand-edited `*.g.dart` (GLOBAL-03).
- [ ] No dependency changes beyond the task's explicit mandate (GLOBAL-04).
- [ ] No new `core/` packages, feature layers, or top-level dirs without approval
  (GLOBAL-05).
- [ ] Import fences hold: no feature→feature, no core→feature outside `core/router`
  (ARCH-04/05).
- [ ] Errors mapped at the repository boundary; no raw exceptions in domain/presentation
  (DATA-05).
- [ ] The section checklists for every layer touched in this task pass.

---

## 13. Change protocol

- This contract changes only by explicit user decision. Proposals state the rule ID
  affected and the motivation.
- Rules are never renumbered. Deprecated rules are struck through with a pointer to
  their replacement.
- Version bumps: `MAJOR` for removed/changed rules, `MINOR` for added rules,
  `PATCH` for wording clarifications.
