import 'package:go_router/go_router.dart';

import '../../../features/admin/presentation/screens/role_applications_review_screen.dart';
import '../app_routes.dart';

/// Admin tab 2 — Role applications review.
final adminApplicationsBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.adminApplications,
      path: '/admin/applications',
      builder: (context, state) => const RoleApplicationsReviewScreen(),
    ),
  ],
);
