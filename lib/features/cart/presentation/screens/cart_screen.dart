import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/presentation/illustrations.dart';
import '../../../../core/presentation/motion.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/theme/app_typography.dart';
import '../../../../core/presentation/widgets/async_value_widget.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/cart_item.dart';
import '../controllers/cart_controller.dart';

/// Customer tab 3 — Cart (DESIGN.md §5.1.3): line items with product-wide
/// stock-capped steppers and the **Floating Action Dock** (§6.5) — backdrop
/// blur, elevation shadow, total payable and the one-tap checkout entry
/// floating above the navigation bar.
///
/// Sale prices arrive precomputed from the composition root (an item-id →
/// unit-price map — features/cart never imports features/catalog,
/// ARCH-04): a sale is what the product costs, so lines show it directly.
/// Coupon codes live in checkout (step 5) — the cart carries no voucher
/// entry: checkout re-validates authoritatively at placement, so a
/// cart-side entry was a redundant second gate.
///
/// Totals are display previews; the server recalculates authoritatively at
/// checkout (spec §25/§53).
///
/// Single-vendor model: one flat list — every item belongs to the store.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartControllerProvider);

    ref.listen(cartControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(userMessageFor(error))));
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
              Text(userMessageFor(error), textAlign: TextAlign.center),
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
            return const EmptyStateView(
              illustration: AppIllustrations.emptyCart,
              title: 'Your cart is empty',
              description: 'Discover products and add them to your bag.',
            );
          }
          final totalMinor = items.fold<int>(
              0, (sum, i) => sum + i.lineTotalMinor);

          return Stack(
            children: [
              // AnimatedList removes rows only after the server-confirmed
              // refetch drops them, so the exit motion never fakes state
              // (PRES-03). The dock stays outside the list.
              _AnimatedCartList(items: items),
              // Floating Action Dock (§6.5): blurred glass, E2 shadow, docked
              // above the navigation bar with safe-area respect.
              Positioned(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.md,
                child: _FloatingCheckoutDock(payableMinor: totalMinor),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Floating Action Dock (DESIGN.md §6.5): anchored above the 5-tab shell,
/// backdrop blur + elevation shadow, cart total (dual currency) and the
/// one-tap checkout entry. Sale prices are already inside the line totals;
/// coupon discounts apply at checkout (step 5) and are not previewed here.
class _FloatingCheckoutDock extends StatelessWidget {
  const _FloatingCheckoutDock({required this.payableMinor});

  final int payableMinor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final money = Money(payableMinor);
    return ClipRRect(
      borderRadius: AppRadii.br24,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.82),
            borderRadius: AppRadii.br24,
            border: Border.all(color: theme.colorScheme.outlineVariant),
            boxShadow: AppElevation.dock,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Total payable', style: theme.textTheme.labelSmall),
                    AnimatedSwitcher(
                      duration: AppMotion.duration(context, AppMotion.press),
                      switchInCurve: AppMotion.enterCurve,
                      switchOutCurve: AppMotion.exitCurve,
                      child: Text(
                        money.formatUsd(),
                        key: ValueKey(payableMinor),
                        style: AppTypography.priceHighlight.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Text(
                      '≈ ${money.formatKhr()}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () => context.pushNamed(AppRoutes.checkout),
                icon: const Icon(Icons.arrow_forward, size: 18),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: 14,
                  ),
                ),
                label: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Checkout'),
                    Text('Review order', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartItemTile extends ConsumerWidget {
  const _CartItemTile({required this.item});

  final CartItem item;

  /// Product-wide stock cap (Section 6): every variant shares the product's
  /// stock; the stepper cannot exceed it. The server re-validates at
  /// checkout (§53). A zero cap means the product sold out after the line
  /// was added — decrease or remove are still available.
  int get _stockCap => item.stock < 0 ? 0 : item.stock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = ref.read(cartControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: AppRadii.br16,
        child: InkWell(
          borderRadius: AppRadii.br16,
          // Tapping the line opens its product page (same cross-tab push as
          // the wishlist); the quantity/delete buttons keep their handlers.
          onTap: item.productId.isEmpty
              ? null
              : () => context.pushNamed(
                    AppRoutes.productDetail,
                    pathParameters: {'id': item.productId},
                  ),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm + 2),
            decoration: BoxDecoration(
              borderRadius: AppRadii.br16,
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: ClipRRect(
                    borderRadius: AppRadii.br12,
                    child: MonogramImage(
                      imageUrl: item.imageUrl,
                      name: item.productName,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm + 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall,
                      ),
                      if (item.variantName != null)
                        Text(item.variantName!, style: theme.textTheme.bodySmall),
                      const SizedBox(height: 2),
                      // Variant-aware unit price × quantity, with the line
                      // subtotal beneath (§1: unit price falls back
                      // variant → base server-side; the server re-prices
                      // at checkout). Sale-priced lines strike the original
                      // through.
                      if (item.hasSale) ...[
                        Text(
                          '${Money(item.saleUnitPriceMinor).formatUsd()} × ${item.quantity}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          Money(item.unitPriceMinor).formatUsd(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ] else
                        Text(
                          '${Money(item.unitPriceMinor).formatUsd()} × ${item.quantity}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      Text(
                        Money(item.lineTotalMinor).formatUsd(),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Quantity stepper — pill with circular buttons (§4.2 full).
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: AppRadii.brFull,
                        color: theme.colorScheme.surfaceContainer,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _StepButton(
                            icon: Icons.remove,
                            tooltip: 'Decrease quantity',
                            onPressed: item.quantity <= 1
                                ? null
                                : () => controller.updateQuantity(
                                      itemId: item.id,
                                      quantity: item.quantity - 1,
                                    ),
                          ),
                          SizedBox(
                            width: 28,
                            child: AnimatedSwitcher(
                              duration:
                                  AppMotion.duration(context, AppMotion.press),
                              switchInCurve: AppMotion.enterCurve,
                              switchOutCurve: AppMotion.exitCurve,
                              transitionBuilder: (child, animation) =>
                                  FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: Tween(begin: 0.9, end: 1.0)
                                      .animate(animation),
                                  child: child,
                                ),
                              ),
                              child: Text(
                                '${item.quantity}',
                                key: ValueKey(item.quantity),
                                textAlign: TextAlign.center,
                                style: AppTypography.labelMedium,
                              ),
                            ),
                          ),
                          _StepButton(
                            icon: Icons.add,
                            tooltip: 'Increase quantity',
                            // Stock is product-wide (Section 6) — the stepper
                            // is capped at the product's stock.
                            onPressed: item.quantity >= _stockCap
                                ? null
                                : () => controller.updateQuantity(
                                      itemId: item.id,
                                      quantity: item.quantity + 1,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      constraints:
                          const BoxConstraints(minWidth: 48, minHeight: 48),
                      tooltip: 'Remove item',
                      onPressed: () => controller.remove(itemId: item.id),
                      icon: Icon(Icons.delete_outline,
                          size: 20, color: theme.colorScheme.error),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Server-confirmed cart list. The controller refetches after a mutation;
/// this widget diffs the new list and lets AnimatedList collapse/fade a
/// removed row instead of yanking the list upward.
class _AnimatedCartList extends StatefulWidget {
  const _AnimatedCartList({required this.items});

  final List<CartItem> items;

  @override
  State<_AnimatedCartList> createState() => _AnimatedCartListState();
}

class _AnimatedCartListState extends State<_AnimatedCartList> {
  final _listKey = GlobalKey<AnimatedListState>();
  late final List<CartItem> _items = List.of(widget.items);
  bool _reduceMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = AppMotion.reduced(context);
  }

  @override
  void didUpdateWidget(covariant _AnimatedCartList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.items;
    final nextIds = {for (final item in next) item.id};
    final duration = _reduceMotion ? Duration.zero : AppMotion.enter;

    // Removals: walk backwards so the index stays valid while collapsing.
    for (var i = _items.length - 1; i >= 0; i--) {
      final item = _items[i];
      if (nextIds.contains(item.id)) continue;
      _items.removeAt(i);
      _listKey.currentState?.removeItem(
        i,
        (context, animation) => _RemovedCartTile(
          item: item,
          animation: animation,
        ),
        duration: duration,
      );
    }

    // Additions + in-place updates (quantity/price refetch).
    for (var i = 0; i < next.length; i++) {
      final item = next[i];
      final existing = _items.indexWhere((entry) => entry.id == item.id);
      if (existing == -1) {
        _items.insert(i, item);
        _listKey.currentState?.insertItem(i, duration: duration);
      } else {
        _items[existing] = item;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: _items.length,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        148, // clearance above the floating dock (§1.5/§6.5)
      ),
      itemBuilder: (context, index, animation) {
        return SizeTransition(
          sizeFactor: animation,
          alignment: Alignment.topCenter,
          child: FadeTransition(
            opacity: animation,
            child: _CartItemTile(item: _items[index]),
          ),
        );
      },
    );
  }
}

/// The row being removed — sized/faded by the AnimatedList animation. It is
/// non-interactive while it collapses.
class _RemovedCartTile extends StatelessWidget {
  const _RemovedCartTile({required this.item, required this.animation});

  final CartItem item;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      alignment: Alignment.topCenter,
      child: FadeTransition(
        opacity: animation,
        child: IgnorePointer(child: _CartItemTile(item: item)),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
    );
  }
}
