import 'package:go_router/go_router.dart';

import '../../../features/business/presentation/screens/business_dashboard_screen.dart';
import '../../../features/returns/presentation/screens/business_returns_screen.dart';
import '../app_routes.dart';

/// Business tab 1 — Dashboard + returns processing nested route (ROUTE-04).
final businessDashboardBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.businessDashboard,
      path: '/business/dashboard',
      builder: (context, state) => const BusinessDashboardScreen(),
      routes: [
        GoRoute(
          name: AppRoutes.businessReturns,
          path: 'returns',
          builder: (context, state) => const BusinessReturnsScreen(),
        ),
      ],
    ),
  ],
);
