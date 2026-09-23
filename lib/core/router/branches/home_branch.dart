import 'package:go_router/go_router.dart';

import '../../../features/catalog/presentation/screens/home_screen.dart';
import '../app_routes.dart';

/// Customer tab 1 — Home. The branch ORDER is owned by `tabsForRole`
/// (navigation_tabs.dart) and must match the NavigationBar (ROUTE-04/05).
final homeBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.home,
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
