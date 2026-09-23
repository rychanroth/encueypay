import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/router/app_routes.dart';
import '../controllers/business_products_controller.dart';

/// Business tab 2 — Products (spec §2.2: manage products/variants, archive,
/// maintain stock).
class BusinessProductsScreen extends ConsumerWidget {
  const BusinessProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(businessProductsControllerProvider);

    ref.listen(businessProductsControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('My products')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(AppRoutes.businessProductForm),
        icon: const Icon(Icons.add),
        label: const Text('Add product'),
      ),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$error', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () =>
                    ref.invalidate(businessProductsControllerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No products yet.'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(businessProductsControllerProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      product.name,
                      style: TextStyle(
                        decoration: product.archived
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Text(
                      '${Money(product.basePriceMinor).format()} · '
                      'stock ${product.stock} · '
                      '${product.variants.length} variant(s)',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: product.archived ? 'Restore' : 'Archive',
                          icon: Icon(product.archived
                              ? Icons.unarchive_outlined
                              : Icons.archive_outlined),
                          onPressed: () => ref
                              .read(businessProductsControllerProvider.notifier)
                              .setArchived(
                                productId: product.id,
                                archived: !product.archived,
                              ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () => context.pushNamed(
                      AppRoutes.businessProductForm,
                      extra: product,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
