import 'package:go_router/go_router.dart';

import '../../../features/business/presentation/screens/business_orders_screen.dart';
import '../../../features/business/presentation/screens/managed_order_detail_screen.dart';
import '../app_routes.dart';

/// Business tab 3 — Orders + detail nested route (ROUTE-04).
final businessOrdersBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.businessOrders,
      path: '/business/orders',
      builder: (context, state) => const BusinessOrdersScreen(),
      routes: [
        GoRoute(
          name: AppRoutes.businessOrderDetail,
          path: ':id',
          builder: (context, state) => ManagedOrderDetailScreen(
            orderId: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
  ],
);
