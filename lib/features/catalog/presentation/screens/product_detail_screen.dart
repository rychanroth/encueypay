import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/theme/app_typography.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/entities/product_variant.dart';
import '../controllers/product_detail_controller.dart';
import '../controllers/promo_chip_providers.dart';
import '../widgets/product_card.dart';
import '../widgets/product_image_gallery.dart';
import '../widgets/rating_stars.dart';
import '../widgets/review_card.dart';
import '../widgets/variant_picker_sheet.dart';

/// Product detail (spec §32), restructured to the Shopee-style reference
/// (Section 9): image carousel with variant-synced selection, variant
/// thumbnail rail, tappable brand tag (→ Discovery), rating row, mocked
/// merchandising blocks (warranty, logistics facts, KHQR/COD, returns,
/// specs), reviews with an empty state, related products, and a bottom
/// action bar pairing wishlist with the cart CTA (dual-currency price).
///
/// The add-to-cart flow opens the variant picker sheet — it owns variant +
/// quantity (the page deliberately has no quantity row, mirroring the
/// removed Select-Color section). Cart and wishlist actions are injected by
/// the composition root (home branch, ROUTE-08) so catalog never imports
/// cart/wishlist (ARCH-04).
class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.onAddToCart,
    this.inWishlist = false,
    this.onToggleWishlist,
  });

  final String productId;

  /// (variantId, quantity) — the sheet always resolves a concrete variant;
  /// server-side RPC re-validates availability (spec §53).
  final Future<void> Function(String variantId, int quantity) onAddToCart;

  /// Wishlist state + toggle, injected by the composition root (ARCH-04).
  final bool inWishlist;
  final Future<void> Function()? onToggleWishlist;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  String? _selectedVariantId;
  final PageController _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Carousel pages: the selected variant's image leads (when it has one),
  /// followed by the product's own gallery — selecting a variant moves the
  /// carousel to it dynamically.
  List<String> _carouselImages(Product product, ProductVariant? selected) {
    final urls = [...product.imageUrls];
    final variantUrl = selected?.imageUrl;
    if (variantUrl != null && variantUrl.isNotEmpty) {
      urls
        ..remove(variantUrl)
        ..insert(0, variantUrl);
    }
    return urls;
  }

  void _selectVariant(ProductVariant variant) {
    setState(() => _selectedVariantId = variant.id);
    if (variant.imageUrl != null && variant.imageUrl!.isNotEmpty) {
      // The variant image leads the carousel after the rebuild.
      _pageController.jumpToPage(0);
    }
  }

  void _openVariantSheet(Product product, List<ProductVariant> variants) {
    showVariantPickerSheet(
      context,
      product: product,
      variants: variants,
      initialVariantId: _selectedVariantId,
      onAddToCart: widget.onAddToCart,
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(productDetailControllerProvider(widget.productId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
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
                    .invalidate(productDetailControllerProvider(widget.productId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (state) {
          final detail = state.detail;
          final product = detail.product;
          final selected = detail.variants
              .where((variant) => variant.id == _selectedVariantId)
              .firstOrNull;
          final carouselImages = _carouselImages(product, selected);
          // Coupon chip (Section 9): coupon-backed promotion for this
          // product — brand scope beats platform.
          final promos = ref.watch(activePromotionsProvider).value;
          final promo =
              promos == null ? null : promoForProduct(promos, product);

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    _ImagePager(
                      imageUrls: carouselImages,
                      pageController: _pageController,
                      currentPage: _page,
                      onPageChanged: (index) => setState(() => _page = index),
                    ),
                    // Variant thumbnails (Section 9): image + name below the
                    // carousel; selecting one re-leads the carousel.
                    if (detail.variants.length > 1) ...[
                      const SizedBox(height: 8),
                      _VariantThumbnailRow(
                        variants: detail.variants,
                        selectedId: _selectedVariantId,
                        onSelect: _selectVariant,
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Brand tag card (Section 9): taps through to the
                          // brand's Discovery feed — same deep-link contract
                          // as the home brand cards.
                          if (detail.brandName.isNotEmpty &&
                              product.brandId != null)
                            _BrandTag(
                              brandName: detail.brandName,
                              onTap: () => context.goNamed(
                                AppRoutes.discovery,
                                queryParameters: {
                                  'kind': 'brand',
                                  'id': product.brandId!,
                                  'name': detail.brandName,
                                },
                              ),
                            ),
                          Text(product.name,
                              style: theme.textTheme.headlineSmall),
                          const SizedBox(height: 8),
                          // Rating row (Section 9): stars + value + count —
                          // real data from the embedded reviews.
                          _RatingSummaryRow(detail: detail),
                          const SizedBox(height: 4),
                          // Stock line (Section 9): real product-wide stock
                          // against a hardcoded hub label (prototype mock).
                          _StockLine(product: product),
                          // TODO(prototype): hardcoded social-proof line
                          // from the UI reference — no sales aggregation
                          // exists yet.
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              '450+ sold in Cambodia',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
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
                          // Coupon chip + VAT caption (Section 9): the chip
                          // is real promotion data; the caption is mocked.
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                if (promo != null) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.promotionCoral,
                                      borderRadius: AppRadii.br8,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.local_offer_outlined,
                                            size: 11, color: Colors.white),
                                        const SizedBox(width: 4),
                                        Text(
                                          promo.chipLabel,
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                // TODO(prototype): hardcoded per the
                                // reference.
                                Text(
                                  'VAT included',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
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
                          // Reviews (Section 9): always rendered — the empty
                          // state was previously unreachable because the
                          // whole section was gated on a non-empty list.
                          const SizedBox(height: 16),
                          Text(
                            'Reviews (${detail.reviews.length})'
                            '${detail.averageRating == null ? '' : ' · ${detail.averageRating!.toStringAsFixed(1)}★'}',
                            style: theme.textTheme.titleMedium,
                          ),
                          if (detail.reviews.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'No review available.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            )
                          else
                            for (final review in detail.reviews)
                              ReviewCard(review: review),
                          // Mocked merchandising blocks (Section 9).
                          _PurchaseFacts(),
                          _SpecificationsHighlights(),
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
                      // Tall enough for a full ProductCard (metadata ~110dp,
                      // image flexes into the remainder) — the old 180dp
                      // rail overflowed by ~70px.
                      SizedBox(
                        height: 220,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.relatedProducts.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final related = state.relatedProducts[index];
                            return SizedBox(
                              width: 140,
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
              // Bottom action bar (Section 9): wishlist toggle + the cart
              // CTA carrying the dual-currency price.
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      IconButton.outlined(
                        tooltip: widget.inWishlist
                            ? 'Remove from wishlist'
                            : 'Add to wishlist',
                        onPressed: widget.onToggleWishlist == null
                            ? null
                            : () => widget.onToggleWishlist!(),
                        icon: Icon(
                          widget.inWishlist
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.inWishlist
                              ? AppColors.accentRose
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          // Disabled products and out-of-stock products cannot
                          // be purchased (Section 2d); checkout re-validates
                          // both server-side (§53).
                          onPressed: product.isPurchasable
                              ? () => _openVariantSheet(
                                  product, detail.variants)
                              : null,
                          icon: const Icon(Icons.shopping_cart_outlined),
                          label: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Add to Cart'),
                              Text(
                                '${Money(detail.fromPriceMinor).formatUsd()}'
                                ' · ≈ ${Money(detail.fromPriceMinor).formatKhr()}',
                                style: theme.textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

/// Tappable brand tag (Section 9) — routes to the brand's Discovery feed.
class _BrandTag extends StatelessWidget {
  const _BrandTag({required this.brandName, required this.onTap});

  final String brandName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.br8,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
            borderRadius: AppRadii.br8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.storefront_outlined,
                  size: 14, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  brandName.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios,
                  size: 10, color: theme.colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}

/// Stars + average + review count (Section 9). Zero reviews render the
/// "No reviews yet" hint instead of an empty star row.
class _RatingSummaryRow extends StatelessWidget {
  const _RatingSummaryRow({required this.detail});

  final ProductDetail detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        if (detail.averageRating != null) ...[
          RatingStars(rating: detail.averageRating!, starSize: 14),
          const SizedBox(width: 4),
          Text(
            detail.averageRating!.toStringAsFixed(1),
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
        ],
        Text(
          detail.reviews.isEmpty
              ? 'No reviews yet'
              : '${detail.reviews.length} Reviews',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// In-stock row with real product-wide stock against the hardcoded hub
/// label; archived/out-of-stock render the error-toned availability text.
class _StockLine extends StatelessWidget {
  const _StockLine({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!product.isPurchasable) {
      final label = product.status == ProductStatus.archived
          ? 'This product is currently unavailable.'
          : 'Out of stock';
      return Text(
        label,
        style: theme.textTheme.bodyMedium
            ?.copyWith(color: theme.colorScheme.error),
      );
    }
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accentEmerald,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'In Stock',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.accentEmerald,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            '(${product.stock} units left at Phnom Penh hub)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

/// Variant thumbnail rail (Section 9): each variant's image (monogram
/// fallback) over its name; the selected one is highlighted.
class _VariantThumbnailRow extends StatelessWidget {
  const _VariantThumbnailRow({
    required this.variants,
    required this.selectedId,
    required this.onSelect,
  });

  final List<ProductVariant> variants;
  final String? selectedId;
  final ValueChanged<ProductVariant> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: variants.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final variant = variants[index];
          final isSelected = variant.id == selectedId;
          return InkWell(
            onTap: () => onSelect(variant),
            borderRadius: AppRadii.br12,
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: AppRadii.br12,
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: MonogramImage(
                    imageUrl: variant.imageUrl,
                    name: variant.name,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 64,
                  child: Text(
                    variant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Mocked purchase-facts card (Section 9): warranty banner + the three
/// logistics/payment/returns rows. Content is hardcoded per the UI
/// reference — none of it is backed by data yet.
// TODO(prototype): hardcoded merchandising content from the reference
// mock; wire to real data (warranty/promises) when it exists.
class _PurchaseFacts extends StatelessWidget {
  const _PurchaseFacts();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: AppRadii.br16,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.verified_user_outlined,
                  size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('12-Month Official Warranty',
                        style: theme.textTheme.titleSmall),
                    Text(
                      'Cambodia authorized replacement support.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accentEmeraldLight,
                  borderRadius: AppRadii.br8,
                ),
                child: Text(
                  'Included',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.accentEmerald,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          const _FactRow(
            icon: Icons.local_shipping_outlined,
            title: 'Delivery managed by EncueYPay Logistics',
            subtitle:
                'Express 2–3 business days across Phnom Penh & Kandal. '
                'Same-day pickup available at central hubs.',
          ),
          const _FactRow(
            icon: Icons.qr_code_2,
            title: 'KHQR & Cash on Delivery Accepted',
            subtitle:
                'Pay instantly with any Cambodian mobile banking app or '
                'upon package handover.',
            trailingPill: 'BAKONG',
          ),
          const _FactRow(
            icon: Icons.assignment_return_outlined,
            title: '7-Day Hassle-Free Returns',
            subtitle:
                'Instant refund or direct swap guaranteed for factory '
                'imperfections.',
          ),
        ],
      ),
    );
  }
}

/// One mocked fact row (Section 9) — icon, two-line copy, optional pill.
class _FactRow extends StatelessWidget {
  const _FactRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailingPill,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailingPill;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (trailingPill != null) ...[
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: AppRadii.br8,
              ),
              child: Text(
                trailingPill!,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Mocked Specifications & Highlights block (Section 9): generic hardcoded
/// chips and expandable panels — every product renders the same content.
// TODO(prototype): hardcoded per the reference; real product spec data
// would need a schema addition — out of scope for the mock.
class _SpecificationsHighlights extends StatelessWidget {
  const _SpecificationsHighlights();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text('Specifications & Highlights',
            style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final (index, spec) in const [
              (Icons.verified_outlined, 'Official Product', '100% genuine'),
              (
                Icons.battery_charging_full_outlined,
                '1-Year Warranty',
                'local support'
              ),
              (Icons.local_shipping_outlined, 'Nationwide', 'delivery'),
            ].indexed) ...[
              if (index > 0) const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLowest,
                    borderRadius: AppRadii.br12,
                  ),
                  child: Column(
                    children: [
                      Icon(spec.$1, size: 22, color: theme.colorScheme.primary),
                      const SizedBox(height: 4),
                      Text(
                        spec.$2,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        spec.$3,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        const _HighlightTile(
          title: 'Quality Guaranteed',
          body:
              'Every item is inspected before dispatch. If anything falls '
              'short of the listing, the 7-day return window covers an '
              'instant refund or a direct swap.',
        ),
        const _HighlightTile(
          title: 'Secure Packaging',
          body:
              'Shock-absorbing wrap and sealed cartons on every order — '
              'validated at the central hub before handover to the courier.',
        ),
        const _HighlightTile(
          title: 'Supported Payments',
          body:
              'KHQR through any Bakong-member banking app, cash on '
              'delivery, and platform coupons stack at checkout.',
          initiallyExpanded: true,
        ),
      ],
    );
  }
}

/// Expandable mock highlight panel (Section 9).
class _HighlightTile extends StatelessWidget {
  const _HighlightTile({
    required this.title,
    required this.body,
    this.initiallyExpanded = false,
  });

  final String title;
  final String body;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: AppRadii.br12,
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          childrenPadding:
              const EdgeInsets.fromLTRB(12, 0, 12, 12),
          initiallyExpanded: initiallyExpanded,
          title: Text(title, style: theme.textTheme.titleSmall),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                body,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Image carousel (Section 9): paged cover images, dot indicators, a
/// hardcoded "KHQR Ready" badge (the app genuinely settles KHQR), and
/// tap-to-full-screen with the current page preselected.
class _ImagePager extends StatelessWidget {
  const _ImagePager({
    required this.imageUrls,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  });

  final List<String> imageUrls;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

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
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: imageUrls.length,
            onPageChanged: onPageChanged,
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
          // TODO(prototype): hardcoded trust badge from the reference —
          // the app does settle KHQR, but the badge itself is static.
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: AppRadii.br8,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.qr_code_2, size: 12, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'KHQR Ready',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
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
                        color: i == currentPage
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
