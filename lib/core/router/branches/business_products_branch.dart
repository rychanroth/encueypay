import 'package:go_router/go_router.dart';

import '../../../features/business/domain/entities/business_profile.dart';
import '../../../features/business/presentation/screens/business_product_form_screen.dart';
import '../../../features/business/presentation/screens/business_products_screen.dart';
import '../app_routes.dart';

/// Business tab 2 — Products + form nested route (ROUTE-04).
final businessProductsBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.businessProducts,
      path: '/business/products',
      builder: (context, state) => const BusinessProductsScreen(),
      routes: [
        GoRoute(
          name: AppRoutes.businessProductForm,
          path: 'form',
          builder: (context, state) => BusinessProductFormScreen(
            product: state.extra as BusinessProduct?,
          ),
        ),
      ],
    ),
  ],
);
