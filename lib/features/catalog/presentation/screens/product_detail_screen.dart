import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/presentation/theme/app_typography.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/product.dart';
import '../controllers/product_detail_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/rating_stars.dart';
import '../widgets/review_card.dart';
import '../widgets/product_image_gallery.dart';
import '../widgets/variant_picker_sheet.dart';

/// Product detail (spec §32): images, description, reviews, related
/// products. The add-to-cart flow opens the variant picker sheet; the cart
/// action itself is injected by the composition root (home branch, ROUTE-08)
/// so catalog never imports cart (ARCH-04).
///
/// 2-Role Academic Prototype: the owning-business card was removed (living
/// spec Part C L-04) — vendor identity is bypassed in the customer UI; the
/// The single-seller retirement removed the vendor fields entirely.
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

  static String _availabilityText(Product product) {
    if (product.status == ProductStatus.archived) {
      return 'This product is currently unavailable.';
    }
    if (product.stock <= 0) return 'Out of stock';
    return 'In stock: ${product.stock}';
  }

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
                          Text(product.name,
                              style: theme.textTheme.headlineSmall),
                          const SizedBox(height: 8),
                          // Dual-currency price (DESIGN.md §1.4): USD
                          // primary, KHR approximation secondary.
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                Money(detail.fromPriceMinor).formatUsd(),
                                style: AppTypography.priceHighlight
                                    .copyWith(fontSize: 24),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '≈ ${Money(detail.fromPriceMinor).formatKhr()}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          // Brand line (assignment §3) — Section 2b. Hidden
                          // entirely when the product carries no brand.
                          if (detail.brandName.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                detail.brandName,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            ),
                          // Availability (Section 2d, assignment §3): stock
                          // is product-wide; archived = disabled.
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              _availabilityText(product),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: product.isPurchasable
                                    ? theme.colorScheme.outline
                                    : theme.colorScheme.error,
                              ),
                            ),
                          ),
                          // Rating UI (assignment §3/§7): visual stars over
                          // the aggregate; the written list follows below.
                          if (detail.averageRating != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: RatingStars(
                                rating: detail.averageRating!,
                              ),
                            ),
                          const SizedBox(height: 16),
                    Text('Description', style: theme.textTheme.titleMedium),
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
                        style: theme.textTheme.titleMedium,
                      ),
                      for (final review in detail.reviews)
                        ReviewCard(review: review),
                    ],
                        ],
                      ),
                    ),
                    if (state.relatedProducts.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Related products',
                            style: theme.textTheme.titleMedium),
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
                      // Disabled products and out-of-stock products cannot be
                      // purchased (Section 2d); checkout re-validates both
                      // server-side (§53).
                      onPressed: product.isPurchasable
                          ? () => showVariantPickerSheet(
                                context,
                                product: product,
                                variants: detail.variants,
                                onAddToCart: onAddToCart,
                              )
                          : null,
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
