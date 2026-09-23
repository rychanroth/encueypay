import 'package:go_router/go_router.dart';

import '../../../features/catalog/presentation/screens/business_detail_screen.dart';
import '../../../features/catalog/presentation/screens/home_screen.dart';
import '../../../features/catalog/presentation/screens/product_detail_screen.dart';
import '../../../features/catalog/presentation/screens/products_screen.dart';
import '../app_routes.dart';

/// Customer tab 1 — Home + catalog nested routes (ROUTE-04: nested routes
/// of a tab are declared in the same file). Branch ORDER is owned by
/// `tabsForRole` (navigation_tabs.dart) per ROUTE-05.
final homeBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.home,
      path: '/home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          name: AppRoutes.products,
          path: 'products',
          builder: (context, state) => ProductsScreen(
            categoryId: state.uri.queryParameters['category'],
            query: state.uri.queryParameters['q'],
          ),
        ),
        GoRoute(
          name: AppRoutes.productDetail,
          path: 'product/:id',
          builder: (context, state) => ProductDetailScreen(
            productId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          name: AppRoutes.businessDetail,
          path: 'business/:id',
          builder: (context, state) => BusinessDetailScreen(
            businessId: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
  ],
);
