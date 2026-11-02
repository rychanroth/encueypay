import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/cart/presentation/controllers/cart_controller.dart';
import '../../../features/cart/presentation/screens/cart_screen.dart';
import '../../../features/checkout/presentation/screens/checkout_screen.dart';
import '../../../features/checkout/presentation/screens/order_placed_screen.dart';
import '../app_routes.dart';

/// Customer tab 2 — Cart + checkout nested routes (ROUTE-04).
final cartBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.cart,
      path: '/cart',
      builder: (context, state) => const CartScreen(),
      routes: [
        GoRoute(
          name: AppRoutes.checkout,
          path: 'checkout',
          builder: (context, state) => const CheckoutScreen(),
          routes: [
            GoRoute(
              name: AppRoutes.orderPlaced,
              path: 'placed/:id',
              // Leaving the order-placed screen: the order consumed the cart
              // server-side, and the cart tab stays mounted in the shell —
              // drop its cached contents so the tab refetches ground truth.
              onExit: (context, state) {
                ProviderScope.containerOf(
                  context,
                  listen: false,
                ).invalidate(cartControllerProvider);
                return true;
              },
              builder: (context, state) =>
                  OrderPlacedScreen(orderId: state.pathParameters['id']!),
            ),
          ],
        ),
      ],
    ),
  ],
);
