import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/cart/domain/entities/cart_item.dart';
import '../../features/cart/presentation/controllers/cart_controller.dart';
import '../../features/catalog/domain/entities/product.dart';
import '../../features/catalog/presentation/widgets/product_card_actions.dart';
import '../../features/wishlist/presentation/controllers/wishlist_controller.dart';
import '../domain/failures.dart';

/// Builds the ProductCard quick-action wiring for one product (Section 6).
/// Lives in the composition root (core/router, ROUTE-08): it watches the
/// cart and wishlist features so the flags reflect current state, and maps
/// mutations onto the injected callbacks with Failure snackbars. The
/// add-to-cart action uses the product's default variant; remove-from-cart
/// drops every cart line of the product.
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

  Future<void> run(Future<void> Function() action) async {
    try {
      await action();
    } on Failure catch (failure) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(failure.message)));
    } catch (_) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Something went wrong')),
        );
    }
  }

  return ProductCardActions(
    inWishlist: inWishlist,
    inCart: inCart,
    onToggleWishlist: () => run(
      () => inWishlist
          ? ref
              .read(wishlistControllerProvider.notifier)
              .remove(productId: product.id)
          : ref
              .read(wishlistControllerProvider.notifier)
              .add(productId: product.id),
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
