import 'package:flutter/material.dart';

import '../../../../core/domain/money.dart';
import '../../domain/entities/product.dart';
import 'product_card_actions.dart';

/// Reusable product grid card (PRES-06). Price is exact minor-unit money
/// formatted at the display edge (spec §22). Disabled/out-of-stock products
/// render an availability badge (Section 2d) but stay tappable — the detail
/// screen explains the state.
///
/// Tap always navigates to the product detail; long-press (Section 6) opens
/// the quick-actions sheet when [actions] is injected by the composition
/// root (wishlist/cart toggles reflecting current state).
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.actions,
  });

  final Product product;
  final VoidCallback? onTap;
  final ProductCardActions? actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress:
            actions == null ? null : () => actions!.showSheet(context, product),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  product.thumbnailUrl.isEmpty
                      ? ColoredBox(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.image_outlined,
                            size: 40,
                            color: theme.colorScheme.outline,
                          ),
                        )
                      : Image.network(
                          product.thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => ColoredBox(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.image_outlined,
                              size: 40,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ),
                  if (product.availabilityLabel != null)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: _AvailabilityBadge(
                        label: product.availabilityLabel!,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Money(product.fromPriceMinor).format(),
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
      ),
    );
  }
}
