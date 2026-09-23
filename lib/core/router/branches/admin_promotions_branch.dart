import 'package:go_router/go_router.dart';

import '../../../features/admin/presentation/screens/promotions_admin_screen.dart';
import '../app_routes.dart';

/// Admin tab 4 — Promotions.
final adminPromotionsBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.adminPromotions,
      path: '/admin/promotions',
      builder: (context, state) => const PromotionsAdminScreen(),
    ),
  ],
);
