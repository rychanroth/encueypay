import 'package:go_router/go_router.dart';

import '../../../features/cart/presentation/screens/cart_screen.dart';
import '../app_routes.dart';

/// Customer tab 2 — Cart.
final cartBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.cart,
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
  ],
);
