import 'package:go_router/go_router.dart';

import '../../../features/business/presentation/screens/business_dashboard_screen.dart';
import '../app_routes.dart';

/// Business tab 1 — Dashboard.
final businessDashboardBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.businessDashboard,
      path: '/business/dashboard',
      builder: (context, state) => const BusinessDashboardScreen(),
    ),
  ],
);
