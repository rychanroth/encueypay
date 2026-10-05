import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/admin.dart';
import '../controllers/admin_products_controller.dart';

/// Admin Products tab (Section 2b, spec §8 "manages Products"): every
/// product regardless of status, name search, archive/activate, and the
/// entry points to the product form and brand management (assignment §2/§3).
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

    ref.listen(adminProductsControllerProvider(_query), (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

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
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search products',
                prefixIcon: Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: productsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$error', textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      onPressed: () => ref
                          .invalidate(adminProductsControllerProvider(_query)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (products) {
                if (products.isEmpty) {
                  return const Center(
                    child: Text('No products yet. Seed the store or add one.'),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _AdminProductTile(product: product, query: _query);
                  },
                );
              },
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

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: SizedBox(
          width: 48,
          height: 48,
          child: product.images.isEmpty
              ? ColoredBox(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(Icons.image_outlined,
                      size: 24, color: theme.colorScheme.outline),
                )
              : Image.network(
                  product.images.first.url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
        ),
        title: Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: isArchived
              ? TextStyle(color: theme.colorScheme.outline)
              : null,
        ),
        subtitle: Text(
          '${product.categoryName}'
          '${product.brandName == null ? '' : ' · ${product.brandName}'}'
          ' · ${Money(product.basePriceMinor).format()}'
          ' · ${product.variantCount} variant(s)'
          ' · stock ${product.stock}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: isArchived ? 'Activate' : 'Archive',
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
    );
  }
}
