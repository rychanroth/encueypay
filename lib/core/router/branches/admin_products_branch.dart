import 'package:go_router/go_router.dart';

import '../../../features/admin/domain/entities/admin.dart';
import '../../../features/admin/presentation/screens/admin_product_form_screen.dart';
import '../../../features/admin/presentation/screens/admin_products_screen.dart';
import '../../../features/admin/presentation/screens/brands_admin_screen.dart';
import '../app_routes.dart';

/// Admin Products tab (Section 2b — spec §8 "manages Products"). Nested
/// routes of this tab are declared here (ROUTE-04). Branch ORDER is owned by
/// `tabsForRole` (navigation_tabs.dart) per ROUTE-05.
final adminProductsBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.adminProducts,
      path: '/admin/products',
      builder: (context, state) => const AdminProductsScreen(),
      routes: [
        GoRoute(
          name: AppRoutes.adminProductForm,
          path: 'form',
          builder: (context, state) => AdminProductFormScreen(
            product: state.extra as AdminProductSummary?,
          ),
        ),
        GoRoute(
          name: AppRoutes.adminBrands,
          path: 'brands',
          builder: (context, state) => const BrandsAdminScreen(),
        ),
      ],
    ),
  ],
);
