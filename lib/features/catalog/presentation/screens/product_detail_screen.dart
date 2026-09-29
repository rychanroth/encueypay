import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/router/app_routes.dart';
import '../controllers/product_detail_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/product_image_gallery.dart';
import '../widgets/variant_picker_sheet.dart';

/// Product detail (spec §32): images, business link, related products. The
/// add-to-cart flow opens the variant picker sheet; the cart action itself is
/// injected by the composition root (home branch, ROUTE-08) so catalog never
/// imports cart (ARCH-04).
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.onAddToCart,
  });

  final String productId;

  /// (variantId, quantity) — the sheet always resolves a concrete variant;
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
                            Money(detail.fromPriceMinor).format(),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
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
                    if (detail.reviews.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Reviews (${detail.reviews.length})'
                        '${detail.averageRating == null ? '' : ' · ${detail.averageRating!.toStringAsFixed(1)}★'}',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      for (final review in detail.reviews)
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.star,
                              color: Colors.amber, size: 20),
                          title: Text(review.authorName),
                          subtitle: Text(
                            review.text.isEmpty ? '—' : review.text,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text('${review.rating}/5',
                              style: theme.textTheme.bodySmall),
                        ),
                    ],
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
                      onPressed: () => showVariantPickerSheet(
                        context,
                        product: product,
                        variants: detail.variants,
                        onAddToCart: onAddToCart,
                      ),
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

class _ImagePager extends StatefulWidget {
  const _ImagePager({required this.imageUrls});

  final List<String> imageUrls;

  @override
  State<_ImagePager> createState() => _ImagePagerState();
}

class _ImagePagerState extends State<_ImagePager> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrls = widget.imageUrls;
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
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            itemCount: imageUrls.length,
            onPageChanged: (index) => setState(() => _page = index),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => showProductImageGallery(
                context,
                imageUrls: imageUrls,
                initialIndex: index,
              ),
              child: Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => ColoredBox(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(Icons.image_outlined,
                      size: 56, color: theme.colorScheme.outline),
                ),
              ),
            ),
          ),
          if (imageUrls.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < imageUrls.length; i++)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == _page
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
