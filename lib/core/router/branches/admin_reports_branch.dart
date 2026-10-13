import 'package:go_router/go_router.dart';

import '../../../features/admin/presentation/screens/admin_reports_screen.dart';
import '../app_routes.dart';

/// Admin tab 4 — Reports (DESIGN.md §5.2.4): executive KPI summary with
/// preset date ranges. Previously nested under the dashboard; promoted to a
/// tab by the DESIGN.md shell alignment (§5.2).
final adminReportsBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.adminReports,
      path: '/admin/reports',
      builder: (context, state) => const AdminReportsScreen(),
    ),
  ],
);
