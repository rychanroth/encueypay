import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/products_controller.dart';
import '../widgets/product_grid.dart';

/// Discovery page for one brand or category (Section 2c, assignment §2
/// "navigation for rapid discovery"): a hero header — image + name — above
/// the aggregated product grid. The grid reuses the products controller
/// family with the dimension pre-filtered, so search behavior stays
/// identical everywhere; a parent category aggregates its sub-category
/// products server-side.
///
/// Route shape (home branch): /home/discovery?kind=category|brand&id=...
/// with an optional q carried through to the grid's controller.
class DiscoveryScreen extends ConsumerWidget {
  const DiscoveryScreen({
    super.key,
    required this.kind,
    required this.id,
    required this.name,
    this.imageUrl,
    this.query,
    this.actionsBuilder,
  });

  /// 'category' or 'brand'.
  final String kind;
  final String id;
  final String name;
  final String? imageUrl;
  final String? query;

  /// Long-press quick actions per product (Section 6) — injected by the
  /// composition root; null keeps cards tap-only.
  final ProductCardActionsBuilder? actionsBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categoryId = kind == 'category' ? id : null;
    final brandId = kind == 'brand' ? id : null;
    final controller =
        ref.watch(productsControllerProvider(categoryId, query, brandId));

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (imageUrl != null)
            SizedBox(
              height: 160,
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              name,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: controller.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$error', textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      onPressed: () => ref.invalidate(
                          productsControllerProvider(
                              categoryId, query, brandId)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (listState) => ProductGrid(
                listState: listState,
                onLoadMore: () => ref
                    .read(productsControllerProvider(
                            categoryId, query, brandId)
                        .notifier)
                    .loadMore(),
                actionsBuilder: actionsBuilder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
