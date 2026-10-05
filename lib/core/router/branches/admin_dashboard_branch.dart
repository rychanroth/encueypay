import 'package:go_router/go_router.dart';

import '../../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../../features/admin/presentation/screens/admin_reports_screen.dart';
import '../../../features/admin/presentation/screens/audit_logs_screen.dart';
import '../../../features/admin/presentation/screens/platform_settings_screen.dart';
import '../app_routes.dart';

/// Admin tab 1 — Dashboard + audit/settings nested routes (ROUTE-04).
final adminDashboardBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.adminDashboard,
      path: '/admin/dashboard',
      builder: (context, state) => const AdminDashboardScreen(),
      routes: [
        GoRoute(
          name: AppRoutes.adminReports,
          path: 'reports',
          builder: (context, state) => const AdminReportsScreen(),
        ),
        GoRoute(
          name: AppRoutes.adminAudit,
          path: 'audit',
          builder: (context, state) => const AuditLogsScreen(),
        ),
        GoRoute(
          name: AppRoutes.adminSettings,
          path: 'settings',
          builder: (context, state) => const PlatformSettingsScreen(),
        ),
      ],
    ),
  ],
);
