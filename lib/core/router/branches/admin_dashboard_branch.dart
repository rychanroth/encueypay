import 'package:go_router/go_router.dart';

import '../../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../app_routes.dart';

/// Admin tab 1 — Dashboard.
final adminDashboardBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.adminDashboard,
      path: '/admin/dashboard',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
  ],
);
