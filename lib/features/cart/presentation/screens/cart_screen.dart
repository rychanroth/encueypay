import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/presentation/illustrations.dart';
import '../../../../core/presentation/motion.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/async_value_widget.dart';
import '../../../../core/presentation/widgets/store_promises_card.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/filter_cart_items.dart';
import '../controllers/cart_controller.dart';
import '../controllers/cart_filter_controller.dart';
import '../controllers/cart_header_provider.dart';
import '../controllers/cart_selection_controller.dart';
import '../states/cart_selection_state.dart';
import '../widgets/cart_checkout_dock.dart';
import '../widgets/cart_delivery_header.dart';
import '../widgets/cart_filter_bar.dart';
import '../widgets/cart_line_tile.dart';
import '../widgets/cart_store_header.dart';

/// Customer tab 3 — Cart (DESIGN.md §5.1.3, restyled after the reference):
/// Taobao-style line ticks with a select-all rail, client-side search/filter/
/// sort, the delivery-address header, the single-seller store header, honest
/// trust rows and the Floating Action Dock (§6.5) with the selected total.
///
/// Selection is presentation state: checkout prices and places only the
/// ticked lines (the server narrows `create_order_from_cart` by cart-item
/// ids). Unticked lines stay in the cart after an order.
///
/// Sale prices arrive precomputed from the composition root (an item-id →
/// unit-price map — features/cart never imports features/catalog, ARCH-04):
/// a sale is what the product costs, so lines show it directly.
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
        title: Text(
          cartAsync.value == null || cartAsync.value!.isEmpty
              ? 'Cart'
              : 'Cart (${cartAsync.value!.length})',
        ),
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
          return _CartBody(items: items);
        },
      ),
    );
  }
}

class _CartBody extends ConsumerWidget {
  const _CartBody({required this.items});

  final List<CartItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final filterState = ref.watch(cartFilterControllerProvider);
    final filterController = ref.read(cartFilterControllerProvider.notifier);
    final selection = ref.watch(cartSelectionControllerProvider);
    final headerAsync = ref.watch(cartHeaderProvider);
    final header = headerAsync.value;

    final visibleItems = ref.watch(filterCartItemsUseCaseProvider)(
      items: items,
      filter: filterState.filter,
      sort: filterState.sort,
      query: filterState.query,
    );

    // Sold-out lines cannot be ordered; they never count towards the total or
    // the checkout payload.
    final buyableItems = items.where((item) => item.stock > 0).toList();
    final selectedItems = buyableItems
        .where((item) => selection.contains(item.id))
        .toList();
    final allSelected =
        buyableItems.isNotEmpty && selectedItems.length == buyableItems.length;
    final payableMinor = selectedItems.fold<int>(
      0,
      (sum, item) => sum + item.lineTotalMinor,
    );

    void openAddresses() {
      context.pushNamed(AppRoutes.cartAddresses).then((_) {
        if (context.mounted) ref.invalidate(cartHeaderProvider);
      });
    }

    void checkout() {
      if (selectedItems.isEmpty) return;
      // An empty selection key means "the whole cart" to the RPC. Only send
      // explicit ids when the order is a subset.
      final wholeCart = selectedItems.length == items.length;
      context.pushNamed(
        AppRoutes.checkout,
        extra: wholeCart
            ? const <String>[]
            : [for (final item in selectedItems) item.id],
      );
    }

    return ColoredBox(
      // Grouped cart surface: white section bands on a stronger gray page —
      // the reference's section separation without inventing markup. Dark
      // mode uses the base surface so the cards (surfaceContainerLowest)
      // still read as raised.
      color: theme.brightness == Brightness.dark
          ? theme.colorScheme.surface
          : theme.colorScheme.surfaceContainer,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                color: theme.colorScheme.surfaceContainerLowest,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.xs,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CartDeliveryHeader(
                        address: header?.address,
                        loading: headerAsync.isLoading,
                        onTap: openAddresses,
                      ),
                      CartStoreHeader(),
                      CartFilterBar(
                        state: filterState,
                        onQueryChanged: filterController.setQuery,
                        onFilterChanged: filterController.setFilter,
                        onSortChanged: filterController.setSort,
                        onClear: filterController.clear,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: visibleItems.isEmpty
                    ? EmptyStateView(
                        illustration: AppIllustrations.noSearch,
                        title: 'No items match',
                        description: 'Try another keyword or filter.',
                        actionLabel: 'Clear filters',
                        onAction: filterController.clear,
                      )
                    : _AnimatedCartList(
                        items: visibleItems,
                        selection: selection,
                        deliveryFeeMinor: header?.deliveryFeeMinor,
                        onToggle: (itemId) => ref
                            .read(cartSelectionControllerProvider.notifier)
                            .toggle(itemId),
                        onRemove: (itemId) async {
                          try {
                            await ref
                                .read(cartControllerProvider.notifier)
                                .remove(itemId: itemId);
                            return true;
                          } on Failure catch (failure) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(content: Text(failure.message)),
                                );
                            }
                            return false;
                          }
                        },
                        onQuantityChanged: (itemId, quantity) => ref
                            .read(cartControllerProvider.notifier)
                            .updateQuantity(itemId: itemId, quantity: quantity),
                        onSupportTap: () =>
                            context.pushNamed(AppRoutes.helpSupport),
                      ),
              ),
            ],
          ),
          // Floating Action Dock (§6.5), docked above the navigation bar.
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md,
            child: CartCheckoutDock(
              payableMinor: payableMinor,
              selectedCount: selectedItems.length,
              allSelected: allSelected,
              onToggleAll: () => ref
                  .read(cartSelectionControllerProvider.notifier)
                  .setAll(selected: !allSelected),
              onCheckout: checkout,
            ),
          ),
          if (selectedItems.isEmpty)
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md + 84,
              child: IgnorePointer(
                child: Text(
                  'Tick at least one line to checkout',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Server-confirmed cart list. The controller refetches after a mutation;
/// this widget diffs the new list and lets AnimatedList collapse/fade a
/// removed row instead of yanking the list upward. The trust block rides as
/// the list's trailing row so it scrolls with the lines.
class _AnimatedCartList extends StatefulWidget {
  const _AnimatedCartList({
    required this.items,
    required this.selection,
    required this.deliveryFeeMinor,
    required this.onToggle,
    required this.onRemove,
    required this.onQuantityChanged,
    required this.onSupportTap,
  });

  final List<CartItem> items;
  final CartSelectionState selection;
  final int? deliveryFeeMinor;
  final ValueChanged<String> onToggle;
  final Future<bool> Function(String itemId) onRemove;
  final void Function(String itemId, int quantity) onQuantityChanged;
  final VoidCallback onSupportTap;

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
        (context, animation) =>
            _RemovedCartLine(item: item, animation: animation),
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
    final theme = Theme.of(context);
    return AnimatedList(
      key: _listKey,
      // +1 for the trailing trust section.
      initialItemCount: _items.length + 1,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        156, // clearance above the floating dock (§1.5/§6.5)
      ),
      itemBuilder: (context, index, animation) {
        if (index >= _items.length) {
          return SizeTransition(
            sizeFactor: animation,
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.xs,
                      bottom: AppSpacing.sm,
                    ),
                    child: Text(
                      'Why shop with R67',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  StorePromisesCard(
                    deliveryFeeMinor: widget.deliveryFeeMinor,
                    onSupportTap: widget.onSupportTap,
                  ),
                ],
              ),
            ),
          );
        }
        final item = _items[index];
        return SizeTransition(
          sizeFactor: animation,
          alignment: Alignment.topCenter,
          child: FadeTransition(
            opacity: animation,
            child: CartLineTile(
              item: item,
              selected: widget.selection.contains(item.id),
              onToggle: () => widget.onToggle(item.id),
              onRemove: () => widget.onRemove(item.id),
              onTap: item.productId.isEmpty
                  ? () {}
                  : () => context.pushNamed(
                      AppRoutes.productDetail,
                      pathParameters: {'id': item.productId},
                    ),
              onQuantityChanged: (quantity) =>
                  widget.onQuantityChanged(item.id, quantity),
            ),
          ),
        );
      },
    );
  }
}

/// The row being removed — sized/faded by the AnimatedList animation. It is
/// non-interactive while it collapses.
class _RemovedCartLine extends StatelessWidget {
  const _RemovedCartLine({required this.item, required this.animation});

  final CartItem item;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      alignment: Alignment.topCenter,
      child: FadeTransition(
        opacity: animation,
        child: IgnorePointer(
          child: CartLineTile(
            item: item,
            selected: false,
            onToggle: () {},
            onRemove: () async => true,
            onTap: () {},
            onQuantityChanged: (_) {},
          ),
        ),
      ),
    );
  }
}
