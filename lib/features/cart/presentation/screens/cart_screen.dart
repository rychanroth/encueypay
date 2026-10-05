import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/cart_item.dart';
import '../controllers/cart_controller.dart';

/// Customer tab 2 — Cart. Totals are display previews; the server
/// recalculates authoritatively at checkout (spec §25/§53).
///
/// 2-Role Academic Prototype: the per-business grouping (multi-vendor model,
/// old spec §9) is flattened to a single list (living spec Part C L-06) —
/// vendor identity is bypassed in the customer UI; items still carry their
/// business through the data model and the server keeps pricing per business
/// at checkout.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartControllerProvider);
    final theme = Theme.of(context);

    ref.listen(cartControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          cartAsync.maybeWhen(
            data: (items) => items.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.delete_sweep_outlined),
                    tooltip: 'Clear cart',
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Clear cart?'),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(false),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(true),
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        await ref.read(cartControllerProvider.notifier).clear();
                      }
                    },
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: cartAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$error', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(cartControllerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text('Your cart is empty.'),
            );
          }
          final totalMinor = items.fold<int>(0, (sum, i) => sum + i.lineTotalMinor);

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Flat list (L-06): the previous layout grouped lines per
                    // business with per-group subtotals.
                    for (final item in items) _CartItemTile(item: item),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total',
                              style: theme.textTheme.titleMedium),
                          Text(
                            Money(totalMinor).format(),
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () =>
                              context.pushNamed(AppRoutes.checkout),
                          child: const Text('Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

}
class _CartItemTile extends ConsumerWidget {
  const _CartItemTile({required this.item});

  static const _maxQuantity = 99;

  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = ref.read(cartControllerProvider.notifier);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      // Tapping the line opens its product page (same cross-tab push as the
      // wishlist); the quantity/delete buttons keep their own handlers.
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: item.productId.isEmpty
            ? null
            : () => context.pushNamed(
                  AppRoutes.productDetail,
                  pathParameters: {'id': item.productId},
                ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 64,
                height: 64,
                child: item.imageUrl != null
                    ? Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const _Placeholder(),
                      )
                    : const _Placeholder(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (item.variantName != null)
                    Text(item.variantName!,
                        style: theme.textTheme.bodySmall),
                  Text(
                    '${Money(item.unitPriceMinor).format()} × ${item.quantity}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: item.quantity <= 1
                          ? null
                          : () => controller.updateQuantity(
                                itemId: item.id,
                                quantity: item.quantity - 1,
                              ),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('${item.quantity}'),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      // Stock is out of scope — the stepper is capped at a
                      // fixed sanity maximum instead.
                      onPressed: item.quantity >= _maxQuantity
                          ? null
                          : () => controller.updateQuantity(
                                itemId: item.id,
                                quantity: item.quantity + 1,
                              ),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => controller.remove(itemId: item.id),
                  icon: Icon(Icons.delete_outline,
                      color: theme.colorScheme.error),
                ),
              ],
            ),
          ],
          ),
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(Icons.image_outlined,
          size: 24, color: Theme.of(context).colorScheme.outline),
    );
  }
}
