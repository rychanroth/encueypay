import 'package:go_router/go_router.dart';

import '../../../features/delivery/presentation/screens/my_deliveries_screen.dart';
import '../app_routes.dart';

/// Driver tab 2 — My deliveries.
final driverDeliveriesBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.driverDeliveries,
      path: '/driver/deliveries',
      builder: (context, state) => const MyDeliveriesScreen(),
    ),
  ],
);
