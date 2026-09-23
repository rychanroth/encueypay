import 'package:go_router/go_router.dart';

import '../../../features/admin/presentation/screens/categories_admin_screen.dart';
import '../app_routes.dart';

/// Admin tab 3 — Categories.
final adminCategoriesBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.adminCategories,
      path: '/admin/categories',
      builder: (context, state) => const CategoriesAdminScreen(),
    ),
  ],
);
