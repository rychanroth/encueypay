import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';

/// Injected quick-action wiring for [ProductCard] long-press (Section 6):
/// the card is a catalog widget, so wishlist/cart behavior arrives from the
/// composition root (ARCH-04/ROUTE-08) as plain callbacks + state flags.
///
/// * [onToggleWishlist] adds when [inWishlist] is false, removes otherwise.
/// * [onAddToCart] adds the product's **default variant** (quantity 1) and
///   is only offered when the product is purchasable.
/// * [onRemoveFromCart] removes every cart line of the product.
class ProductCardActions {
  const ProductCardActions({
    required this.inWishlist,
    required this.inCart,
    required this.onToggleWishlist,
    required this.onAddToCart,
    required this.onRemoveFromCart,
  });

  final bool inWishlist;
  final bool inCart;
  final Future<void> Function() onToggleWishlist;
  final Future<void> Function() onAddToCart;
  final Future<void> Function() onRemoveFromCart;

  /// Builds the quick-actions bottom sheet for one product.
  Future<void> showSheet(BuildContext context, Product product) {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                inWishlist ? Icons.favorite : Icons.favorite_border,
                color: inWishlist ? Colors.redAccent : null,
              ),
              title: Text(inWishlist
                  ? 'Remove from wishlist'
                  : 'Add to wishlist'),
              onTap: () async {
                Navigator.of(sheetContext).pop();
                await onToggleWishlist();
              },
            ),
            if (inCart)
              ListTile(
                leading: const Icon(Icons.remove_shopping_cart_outlined),
                title: const Text('Remove from cart'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await onRemoveFromCart();
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.add_shopping_cart_outlined),
                title: const Text('Add to cart (default variant)'),
                subtitle: product.isPurchasable
                    ? null
                    : Text(
                        product.availabilityLabel ?? 'Not purchasable',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                enabled: product.isPurchasable && product.defaultVariantId != null,
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await onAddToCart();
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
