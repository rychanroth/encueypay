import 'package:go_router/go_router.dart';

import '../../../features/business/presentation/screens/business_orders_screen.dart';
import '../app_routes.dart';

/// Business tab 3 — Orders.
final businessOrdersBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.businessOrders,
      path: '/business/orders',
      builder: (context, state) => const BusinessOrdersScreen(),
    ),
  ],
);
