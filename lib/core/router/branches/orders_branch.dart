import 'package:go_router/go_router.dart';

import '../../../features/orders/presentation/screens/order_detail_screen.dart';
import '../../../features/orders/presentation/screens/orders_screen.dart';
import '../app_routes.dart';

/// Customer tab 3 — Orders + detail nested route (ROUTE-04).
final ordersBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.orders,
      path: '/orders',
      builder: (context, state) => const OrdersScreen(),
      routes: [
        GoRoute(
          name: AppRoutes.orderDetail,
          path: ':id',
          builder: (context, state) => OrderDetailScreen(
            orderId: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
  ],
);
