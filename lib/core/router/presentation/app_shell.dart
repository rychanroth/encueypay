import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/domain/entities/user_role.dart';
import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../features/auth/presentation/widgets/auth_error_snackbar.dart';
import '../../../features/cart/presentation/controllers/cart_controller.dart';
import '../navigation_tabs.dart';

/// Shell scaffold (ROUTE-06). Destinations derive from the same
/// [tabsForRole] source as the router's branch list (ROUTE-05).
///
/// The Cart destination carries an active-bag-count badge (DESIGN.md
/// §5.1.3) fed by the cart controller — `core/router` is the composition
/// root, the one place allowed to watch feature providers (ARCH-05
/// exception). `select` narrows rebuilds to count changes only (PRES-05).
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
    final cartCount = role == UserRole.customer
        ? ref.watch(
            cartControllerProvider.select((cart) => cart.value?.length ?? 0),
          )
        : 0;

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
            NavigationDestination(
              icon: tab.id == 'cart' && cartCount > 0
                  ? Badge(
                      label: Text('$cartCount'),
                      child: Icon(tab.icon),
                    )
                  : Icon(tab.icon),
              selectedIcon: Icon(tab.selectedIcon),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}
