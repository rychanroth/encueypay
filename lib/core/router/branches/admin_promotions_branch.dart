import 'package:go_router/go_router.dart';

import '../../../features/promotions/presentation/screens/admin_promotions_screen.dart';
import '../app_routes.dart';

/// Admin tab 4 — Promotions (banners moderation + platform promotions).
final adminPromotionsBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.adminPromotions,
      path: '/admin/promotions',
      builder: (context, state) => const AdminPromotionsScreen(),
    ),
  ],
);
