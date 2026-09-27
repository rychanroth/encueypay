import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/app_user.dart';
import '../../features/auth/domain/entities/user_role.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../presentation/not_found_screen.dart';
import 'app_routes.dart';
import 'navigation_tabs.dart';
import 'presentation/app_shell.dart';

/// Riverpod ↔ GoRouter bridge (ROUTE-07).
///
/// The router rebuilds *structurally* only when the active role changes
/// (the `select` below); session-level auth changes flow through
/// [refreshListenable] instead — a provider body does not re-run like a
/// widget build, so the `ref.listen` is what pushes auth state into
/// GoRouter's redirect (ROUTE-10).
///
/// `core/router` is the composition root — the one place allowed to import
/// feature code (ROUTE-08, exception to ARCH-05).
final appRouterProvider = Provider<GoRouter>((ref) {
  // Read (not watch) the initial value: watching the full auth state here
  // would rebuild this provider — and recreate the GoRouter — on every
  // session transition, stranding navigation mid-OAuth. Session-level
  // changes flow through the listen below (ROUTE-10).
  final refreshListenable =
      ValueNotifier<AsyncValue<AppUser?>>(ref.read(authControllerProvider));

  ref.listen<AsyncValue<AppUser?>>(authControllerProvider, (prev, next) {
    refreshListenable.value = next;
  });

  final role = ref.watch(
    authControllerProvider.select(
      (auth) => auth.value?.activeRole ?? UserRole.customer,
    ),
  );
  final tabs = tabsForRole(role);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final authAsync = ref.read(authControllerProvider);
      if (authAsync.isLoading) {
        // While the session resolves, hold unmatched locations (the bare root
        // and the OAuth deep-link landing — both normalize to `/`) on the
        // login route instead of letting go_router render NotFoundScreen.
        // The redirect re-runs once auth resolves (ROUTE-10).
        return state.matchedLocation == '/'
            ? state.namedLocation(AppRoutes.login)
            : null;
      }

      final isAuthenticated = authAsync.value != null;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoggingIn) {
        return state.namedLocation(AppRoutes.login);
      }
      if (isAuthenticated &&
          (isLoggingIn || state.matchedLocation == '/')) {
        return state.namedLocation(defaultRouteForRole(role));
      }
      return null;
    },
    errorBuilder: (context, state) => NotFoundScreen(path: state.uri.path), // ROUTE-09
    routes: [
      GoRoute(
        name: AppRoutes.login,
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [for (final tab in tabs) tab.branch],
      ),
    ],
  );
});
