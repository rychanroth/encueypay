import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/router/app_routes.dart';
import '../controllers/product_detail_controller.dart';
import '../widgets/product_card.dart';

/// Product detail (spec §32): images, variant selection, business link,
/// related products. The add-to-cart action is injected by the composition
/// root (home branch, ROUTE-08) so catalog never imports cart (ARCH-04).
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.onAddToCart,
  });

  final String productId;

  /// (variantId, quantity) — the screen always resolves a concrete variant;
  /// server-side RPC re-validates availability (spec §53).
  final Future<void> Function(String variantId, int quantity) onAddToCart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(productDetailControllerProvider(productId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Product')),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$error', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => ref
                    .invalidate(productDetailControllerProvider(productId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (state) {
          final detail = state.detail;
          final product = detail.product;
          final selected = state.selectedVariant;
          final priceMinor =
              selected?.effectivePriceMinor(product) ?? detail.fromPriceMinor;
          // A variant must be chosen for varianted products. Products
          // without variants cannot be added to the cart (spec §8: cart
          // items reference ProductVariants).
          final canAdd = !detail.hasVariants || selected != null;

          Future<void> addToCart() async {
            if (detail.hasVariants && selected == null) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Select an option first')),
                );
              return;
            }
            try {
              await onAddToCart(selected!.id, 1);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(content: Text('Added to cart')));
            } on Failure catch (failure) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(failure.message)));
            } catch (_) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Something went wrong')),
                );
            }
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    _ImagePager(imageUrls: product.imageUrls),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            Money(priceMinor).format(),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'In stock: ${product.stock}',
                            style: theme.textTheme.bodySmall,
                          ),
                          if (detail.businessName.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.storefront),
                                title: Text(detail.businessName),
                                trailing: const Icon(Icons.chevron_right),
                                dense: true,
                                onTap: () => context.pushNamed(
                                  AppRoutes.businessDetail,
                                  pathParameters: {'id': product.businessId},
                                ),
                              ),
                            ),
                          ],
                          if (detail.hasVariants) ...[
                            const SizedBox(height: 16),
                            Text(
                              'Options',
                              style: theme.textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final variant in detail.variants)
                                  ChoiceChip(
                                    label: Text(variant.name),
                                    selected:
                                        state.selectedVariantId == variant.id,
                                    onSelected: (isSelected) => ref
                                        .read(productDetailControllerProvider(
                                                productId)
                                            .notifier)
                                        .selectVariant(
                                            isSelected ? variant.id : null),
                                  ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 16),
                          Text(
                            'Description',
                            style: theme.textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.description.isEmpty
                                ? 'No description available.'
                                : product.description,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    if (state.relatedProducts.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Related products',
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 180,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.relatedProducts.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final related = state.relatedProducts[index];
                            return SizedBox(
                              width: 130,
                              child: ProductCard(
                                product: related,
                                onTap: () => context.pushNamed(
                                  AppRoutes.productDetail,
                                  pathParameters: {'id': related.id},
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: canAdd ? addToCart : null,
                      child: const Text('Add to cart'),
                    ),
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

class _ImagePager extends StatelessWidget {
  const _ImagePager({required this.imageUrls});

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (imageUrls.isEmpty) {
      return Container(
        height: 260,
        color: theme.colorScheme.surfaceContainerHighest,
        child: Icon(Icons.image_outlined,
            size: 56, color: theme.colorScheme.outline),
      );
    }
    return SizedBox(
      height: 260,
      child: PageView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) => Image.network(
          imageUrls[index],
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => ColoredBox(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Icon(Icons.image_outlined,
                size: 56, color: theme.colorScheme.outline),
          ),
        ),
      ),
    );
  }
}
