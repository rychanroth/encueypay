import 'package:go_router/go_router.dart';

import '../../../features/admin/presentation/screens/admin_order_detail_screen.dart';
import '../../../features/admin/presentation/screens/admin_orders_screen.dart';
import '../app_routes.dart';

/// Admin Orders tab (Section 3 — spec §8 "manages Orders"). Nested routes of
/// this tab are declared here (ROUTE-04). Branch ORDER is owned by
/// `tabsForRole` (navigation_tabs.dart) per ROUTE-05.
final adminOrdersBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.adminOrders,
      path: '/admin/orders',
      builder: (context, state) => const AdminOrdersScreen(),
      routes: [
        GoRoute(
          name: AppRoutes.adminOrderDetail,
          path: ':id',
          builder: (context, state) => AdminOrderDetailScreen(
            orderId: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
  ],
);
