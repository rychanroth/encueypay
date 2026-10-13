import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/theme/app_typography.dart';
import '../../../../core/presentation/widgets/async_value_widget.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/admin.dart';
import '../controllers/admin_products_controller.dart';

/// Admin Products tab (DESIGN.md §5.2.2): inventory manager with product-
/// wide stock counters, filter chips (All / Low Stock ≤5 / Out of Stock),
/// quick inline [- Stock +] adjustment, "Unavailable" badge + archive/
/// restore, search, and the entry points to the product form and brand
/// management (assignment §2/§3).
class AdminProductsScreen extends ConsumerStatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  ConsumerState<AdminProductsScreen> createState() =>
      _AdminProductsScreenState();
}

class _AdminProductsScreenState extends ConsumerState<AdminProductsScreen> {
  String? _query;

  @override
  Widget build(BuildContext context) {
    final productsAsync =
        ref.watch(adminProductsControllerProvider(_query));
    final filterState = ref.watch(adminProductsFilterControllerProvider);

    ref.listen(adminProductsControllerProvider(_query), (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    final filtered = productsAsync.value?.where((product) {
          switch (filterState.filter) {
            case AdminProductsFilter.lowStock:
              return product.stock > 0 && product.stock <= 5;
            case AdminProductsFilter.outOfStock:
              return product.stock == 0;
            case AdminProductsFilter.all:
              return true;
          }
        }).toList() ??
        const <AdminProductSummary>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            tooltip: 'Brands',
            icon: const Icon(Icons.sell_outlined),
            onPressed: () => context.pushNamed(AppRoutes.adminBrands),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(AppRoutes.adminProductForm),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm + 4,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search products',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) => setState(() => _query = value),
            ),
          ),
          // Filter chips (§5.2.2).
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                for (final filter in AdminProductsFilter.values)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: ChoiceChip(
                      label: Text(switch (filter) {
                        AdminProductsFilter.all => 'All Products',
                        AdminProductsFilter.lowStock => 'Low Stock (≤5)',
                        AdminProductsFilter.outOfStock => 'Out of Stock',
                      }),
                      selected: filterState.filter == filter,
                      onSelected: (_) => ref
                          .read(adminProductsFilterControllerProvider.notifier)
                          .setFilter(filter),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: AsyncValueWidget(
              value: productsAsync,
              retry: () =>
                  ref.invalidate(adminProductsControllerProvider(_query)),
              loading: const SkeletonListView(crossAxisCount: 1),
              data: (_) => filtered.isEmpty
                  ? const EmptyStateView(
                      icon: Icons.inventory_2_outlined,
                      title: 'No products match',
                      description: 'Adjust the filter or add a product.',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final product = filtered[index];
                        return _AdminProductTile(
                          product: product,
                          query: _query,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminProductTile extends ConsumerWidget {
  const _AdminProductTile({required this.product, required this.query});

  final AdminProductSummary product;

  /// The owning screen's controller-family key — mutations must invalidate
  /// the exact instance the screen is watching.
  final String? query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isArchived = product.status == AdminCatalogStatus.archived;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm + 2),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: ClipRRect(
                  borderRadius: AppRadii.br12,
                  child: MonogramImage(
                    imageUrl:
                        product.images.isEmpty ? null : product.images.first.url,
                    name: product.name,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm + 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color:
                                  isArchived ? theme.colorScheme.outline : null,
                            ),
                          ),
                        ),
                        // §5.2.2 / §2d: archived products surface the
                        // "Unavailable" badge with a Restore action.
                        if (isArchived)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.errorContainer,
                              borderRadius: AppRadii.br8,
                            ),
                            child: Text(
                              'Unavailable',
                              style: AppTypography.labelSmall.copyWith(
                                color: theme.colorScheme.onErrorContainer,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${product.categoryName}'
                      '${product.brandName == null ? '' : ' · ${product.brandName}'}'
                      ' · ${Money(product.basePriceMinor).formatUsd()}'
                      ' · ${product.variantCount} variant(s)',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Quick inline [- Stock +] (§5.2.2), stock counter semantics
              // preserved: low-stock tint when ≤5.
              Container(
                decoration: BoxDecoration(
                  color: product.stock == 0
                      ? theme.colorScheme.errorContainer
                      : product.stock <= 5
                          ? theme.colorScheme.tertiaryContainer
                          : theme.colorScheme.surfaceContainer,
                  borderRadius: AppRadii.brFull,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Decrease stock',
                      visualDensity: VisualDensity.compact,
                      onPressed: product.stock <= 0
                          ? null
                          : () => ref
                              .read(adminProductsControllerProvider(query)
                                  .notifier)
                              .adjustStock(
                                productId: product.id,
                                newStock: product.stock - 1,
                              ),
                      icon: const Icon(Icons.remove, size: 16),
                    ),
                    Text(
                      '${product.stock}',
                      style: AppTypography.labelMedium.copyWith(
                        color: product.stock == 0
                            ? theme.colorScheme.onErrorContainer
                            : product.stock <= 5
                                ? theme.colorScheme.onTertiaryContainer
                                : null,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Increase stock',
                      visualDensity: VisualDensity.compact,
                      onPressed: () => ref
                          .read(adminProductsControllerProvider(query).notifier)
                          .adjustStock(
                            productId: product.id,
                            newStock: product.stock + 1,
                          ),
                      icon: const Icon(Icons.add, size: 16),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: isArchived ? 'Restore' : 'Archive',
                icon: Icon(isArchived
                    ? Icons.unarchive_outlined
                    : Icons.archive_outlined),
                onPressed: () => ref
                    .read(adminProductsControllerProvider(query).notifier)
                    .setArchived(productId: product.id, archived: !isArchived),
              ),
              IconButton(
                tooltip: 'Edit',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.pushNamed(
                  AppRoutes.adminProductForm,
                  extra: product,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
