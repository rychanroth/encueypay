import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/responsive/screen_size.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/product.dart';
import '../states/product_list_state.dart';
import 'product_card.dart';
import 'product_card_actions.dart';

/// Builds the quick-action wiring for one product (injected by the
/// composition root — ARCH-04/ROUTE-08).
typedef ProductCardActionsBuilder = ProductCardActions? Function(
  Product product,
);

/// Paginated product grid shared by the products screen and the discovery
/// screen (PRES-06). Presentational only: pagination and refresh are driven
/// through the callbacks; navigation goes to the product detail route.
/// [actionsBuilder] (Section 6) wires the long-press quick actions per
/// product; null keeps the cards tap-only.
class ProductGrid extends ConsumerWidget {
  const ProductGrid({
    super.key,
    required this.listState,
    required this.onLoadMore,
    this.actionsBuilder,
  });

  final ProductListState listState;
  final VoidCallback onLoadMore;
  final ProductCardActionsBuilder? actionsBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final columns = switch (context.screenSize) {
      ScreenSize.expanded => 4,
      ScreenSize.medium => 3,
      ScreenSize.compact => 2,
    };
    if (listState.items.isEmpty) {
      return const Center(child: Text('No products found.'));
    }
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < 400) {
          onLoadMore();
        }
        return false;
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.62,
        ),
        itemCount:
            listState.items.length + (listState.hasMore ? columns : 0),
        itemBuilder: (context, index) {
          if (index >= listState.items.length) {
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          }
          final product = listState.items[index];
          return ProductCard(
            product: product,
            onTap: () => context.pushNamed(
              AppRoutes.productDetail,
              pathParameters: {'id': product.id},
            ),
            actions: actionsBuilder?.call(product),
          );
        },
      ),
    );
  }
}
