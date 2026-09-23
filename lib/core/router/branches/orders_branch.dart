import 'package:go_router/go_router.dart';

import '../../../features/orders/presentation/screens/orders_screen.dart';
import '../app_routes.dart';

/// Customer tab 3 — Orders.
final ordersBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.orders,
      path: '/orders',
      builder: (context, state) => const OrdersScreen(),
    ),
  ],
);
