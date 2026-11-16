import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/widgets/app_snack_bar.dart';

import '../../features/cart/domain/entities/cart_item.dart';
import '../../features/cart/presentation/controllers/cart_controller.dart';
import '../../features/catalog/domain/entities/product.dart';
import '../../features/catalog/presentation/widgets/product_card_actions.dart';
import '../../features/wishlist/domain/entities/wishlist_item.dart';
import '../../features/wishlist/presentation/controllers/wishlist_controller.dart';
import 'app_routes.dart';
import '../domain/failures.dart';
import '../network/failure_mapping.dart';
import '../network/supabase_client_provider.dart';

/// Builds the ProductCard quick-action wiring for one product (Section 6).
/// Lives in the composition root (core/router, ROUTE-08): it watches the
/// cart and wishlist features so the flags reflect current state, and maps
/// mutations onto the injected callbacks with Failure snackbars. The
/// add-to-cart action uses the product's default variant; remove-from-cart
/// drops every cart line of the product.
///
/// Product → the optimistic wishlist row shown while the add write is in
/// flight. The wishlist controller replaces it with the server row on success.
WishlistItem wishlistItemFromProduct(Product product) => WishlistItem(
      id: 'optimistic-${product.id}',
      productId: product.id,
      productName: product.name,
      priceMinor: product.basePriceMinor,
      fromPriceMinor: product.fromPriceMinor,
      stock: product.stock,
      status: product.status.name,
      defaultVariantId: product.defaultVariantId,
      imageUrl: product.thumbnailUrl.isEmpty ? null : product.thumbnailUrl,
      brandId: product.brandId,
      categoryId: product.categoryId,
      brandName: product.brandName,
      ratingAvg: product.ratingAvg,
      reviewCount: product.reviewCount,
    );

ProductCardActions productCardActions(
  BuildContext context,
  WidgetRef ref,
  Product product,
) {
  final cartItems =
      ref.watch(cartControllerProvider).value ?? const <CartItem>[];
  final wishlistItems = ref.watch(wishlistControllerProvider).value ?? const [];
  final inCart = cartItems.any((item) => item.productId == product.id);
  final inWishlist = wishlistItems.any((item) => item.productId == product.id);
  final messenger = ScaffoldMessenger.of(context);

  void showFailure(Failure failure) {
    // A dead/exported session surfaces as 'Not authenticated' — offer the
    // way back instead of a dead-end message.
    final needsSignIn =
        ref.read(supabaseClientProvider).auth.currentUser == null;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(AppSnackBar(
        content: Text(failure.message),
        // The "Sign in" action needs a tap window.
        duration: appSnackBarActionDuration,
        action: needsSignIn
            ? SnackBarAction(
                label: 'Sign in',
                onPressed: () => context.goNamed(AppRoutes.login),
              )
            : null,
      ));
  }

  Future<void> run(Future<void> Function() action) async {
    try {
      await action();
    } on Failure catch (failure) {
      showFailure(failure);
    } catch (error, stackTrace) {
      // DATA-05: presentation never sees raw exceptions — classify first.
      showFailure(mapRepositoryError(error, stackTrace));
    }
  }

  /// Wishlist actions route through here. Optimistic mutations roll back and
  /// rethrow on failure (PRES-03 ratified exception), so [run] surfaces the
  /// rejection — without this, a failing write looks like a no-op on every
  /// heart surface.
  Future<void> runWishlist(Future<void> Function() action) async {
    await run(action);
  }

  return ProductCardActions(
    inWishlist: inWishlist,
    inCart: inCart,
    onToggleWishlist: () => runWishlist(
      () => inWishlist
          ? ref
              .read(wishlistControllerProvider.notifier)
              .remove(productId: product.id)
          : ref.read(wishlistControllerProvider.notifier).add(
                productId: product.id,
                optimistic: wishlistItemFromProduct(product),
              ),
    ),
    onAddToCart: () {
      final variantId = product.defaultVariantId;
      if (variantId == null) return Future.value();
      return run(
        () => ref.read(cartControllerProvider.notifier).add(
              variantId: variantId,
            ),
      );
    },
    onRemoveFromCart: () => run(() async {
      for (final item in cartItems.where((i) => i.productId == product.id)) {
        await ref.read(cartControllerProvider.notifier).remove(itemId: item.id);
      }
    }),
  );
}
