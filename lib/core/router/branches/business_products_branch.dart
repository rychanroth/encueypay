import 'package:go_router/go_router.dart';

import '../../../features/business/presentation/screens/business_products_screen.dart';
import '../app_routes.dart';

/// Business tab 2 — Products.
final businessProductsBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.businessProducts,
      path: '/business/products',
      builder: (context, state) => const BusinessProductsScreen(),
    ),
  ],
);
