import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/domain/entities/user_role.dart';
import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../features/auth/presentation/widgets/auth_error_snackbar.dart';
import '../navigation_tabs.dart';

/// Shell scaffold (ROUTE-06). Destinations derive from the same
/// [tabsForRole] source as the router's branch list (ROUTE-05).
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(
      authControllerProvider.select(
        (auth) => auth.value?.activeRole ?? UserRole.customer,
      ),
    );
    final tabs = tabsForRole(role);

    // Signed-in-phase session failures (e.g. profile fetch on token refresh).
    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError) showAuthStreamError(context, next.error);
    });

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          for (final tab in tabs)
            NavigationDestination(icon: Icon(tab.icon), label: tab.label),
        ],
      ),
    );
  }
}
