import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/cart/presentation/controllers/cart_controller.dart';
import '../../../features/catalog/presentation/screens/home_screen.dart';
import '../../../features/catalog/presentation/screens/product_detail_screen.dart';
import '../../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../../features/wishlist/presentation/controllers/wishlist_controller.dart';
import '../app_routes.dart';
import '../product_card_actions.dart';


/// Customer tab 1 — Home + catalog nested routes (ROUTE-04: nested routes
/// of a tab are declared in the same file). Branch ORDER is owned by
/// `tabsForRole` (navigation_tabs.dart) per ROUTE-05.
///
/// The composition root wires the cart feature into product detail via
/// callback so catalog never imports cart (ARCH-04, ROUTE-08).
///
/// Search/browse lives in the Discover tab (DESIGN.md §5.1.2) — the old
/// `/home/products` and `/home/discovery` routes were absorbed there
/// (discovery_branch.dart); Home deep-links into the tab via `goNamed`.
final homeBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.home,
      path: '/home',
      builder: (context, state) => Consumer(
        builder: (context, ref, _) => HomeScreen(
          // Long-press quick actions (Section 6) — cart/wishlist wiring
          // lives in the composition root (ARCH-04, ROUTE-08).
          actionsBuilder: (product) => productCardActions(context, ref, product),
        ),
      ),
      routes: [
        GoRoute(
          name: AppRoutes.productDetail,
          path: 'product/:id',
          builder: (context, state) => Consumer(
            builder: (context, ref, _) {
              final productId = state.pathParameters['id']!;
              // Wishlist state rides along with the cart callback — both
              // wired here in the composition root (ARCH-04, ROUTE-08).
              final inWishlist = ref.watch(
                wishlistControllerProvider.select(
                  (wishlist) =>
                      wishlist.value?.any((item) => item.productId == productId) ??
                      false,
                ),
              );
              return ProductDetailScreen(
                productId: productId,
                inWishlist: inWishlist,
                onToggleWishlist: () async {
                  final wishlist = ref.read(wishlistControllerProvider.notifier);
                  if (inWishlist) {
                    await wishlist.remove(productId: productId);
                  } else {
                    await wishlist.add(productId: productId);
                  }
                },
                onAddToCart: (variantId, quantity) async {
                  await ref.read(cartControllerProvider.notifier).add(
                        variantId: variantId,
                        quantity: quantity,
                      );
                },
              );
            },
          ),
        ),
        GoRoute(
          name: AppRoutes.notifications,
          path: 'notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
      ],
    ),
  ],
);
