import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/cart/presentation/controllers/cart_controller.dart';
import '../../../features/cart/presentation/screens/cart_screen.dart';
import '../../../features/checkout/presentation/screens/checkout_screen.dart';
import '../../../features/checkout/presentation/screens/order_placed_screen.dart';
import '../../../features/profile/domain/entities/address.dart';
import '../../../features/profile/presentation/screens/address_edit_screen.dart';
import '../../../features/profile/presentation/screens/addresses_screen.dart';
import '../app_routes.dart';

/// Customer tab 2 — Cart + checkout nested routes (ROUTE-04).
final cartBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.cart,
      path: '/cart',
      builder: (context, state) => const CartScreen(),
      routes: [
        // Cart-scoped address management: the same screens as the profile
        // tab, nested here so the back stack stays on the cart.
        GoRoute(
          name: AppRoutes.cartAddresses,
          path: 'addresses',
          builder: (context, state) =>
              const AddressesScreen(editRouteName: AppRoutes.cartAddressEdit),
          routes: [
            GoRoute(
              name: AppRoutes.cartAddressEdit,
              path: 'edit',
              builder: (context, state) =>
                  AddressEditScreen(address: state.extra as Address?),
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.checkout,
          path: 'checkout',
          builder: (context, state) => CheckoutScreen(
            // Selected cart-item ids from the cart's tick rail; empty means
            // the whole cart (the RPC default).
            selectedItemIds: (state.extra as List<String>?) ?? const <String>[],
          ),
          routes: [
            GoRoute(
              name: AppRoutes.checkoutAddressEdit,
              path: 'address/edit',
              builder: (context, state) => const AddressEditScreen(),
            ),
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
