import 'package:go_router/go_router.dart';

import '../../../features/delivery/presentation/screens/available_deliveries_screen.dart';
import '../app_routes.dart';

/// Driver tab 1 — Available deliveries.
final driverAvailableBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.driverAvailable,
      path: '/driver/available',
      builder: (context, state) => const AvailableDeliveriesScreen(),
    ),
  ],
);
