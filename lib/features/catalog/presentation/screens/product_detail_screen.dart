import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/domain/failures.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/presentation/motion.dart';
import '../../../../core/presentation/responsive/screen_size.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/theme/app_typography.dart';
import '../../../../core/presentation/widgets/content_width.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/active_sale.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/entities/product_variant.dart';
import '../controllers/delivery_fee_provider.dart';
import '../controllers/product_detail_controller.dart';
import '../controllers/sale_providers.dart';
import '../widgets/product_card.dart';
import '../widgets/product_image_gallery.dart';
import '../widgets/sale_detail_sheet.dart';
import '../widgets/rating_stars.dart';
import '../widgets/review_card.dart';
import '../widgets/variant_picker_sheet.dart';

/// Product detail (spec §32), restructured to the Shopee-style reference
/// (Section 9): image carousel with variant-synced selection, variant
/// thumbnail rail, tappable brand tag (→ Discovery), rating row, reviews
/// with an empty state, related products, and a bottom action bar pairing
/// wishlist with the cart CTA (dual-currency price). Only verified product
/// data is rendered; the trust block states the real platform fee, supported
/// payment methods and the single-seller identity.
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
  /// The product rides along so the toggle can seed an optimistic wishlist
  /// row before the write completes (PRES-03 exception).
  final bool inWishlist;
  final Future<void> Function(Product product)? onToggleWishlist;

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

  void _openVariantSheet(
    Product product,
    List<ProductVariant> variants,
    ActiveSale? sale,
  ) {
    showVariantPickerSheet(
      context,
      product: product,
      variants: variants,
      initialVariantId: _selectedVariantId,
      onAddToCart: widget.onAddToCart,
      sale: sale,
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
              Text(userMessageFor(error), textAlign: TextAlign.center),
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
          // Selection falls back to the product's default variant — the
          // page (price, CTA, carousel) always reflects a concrete variant
          // (user feedback 2026-10-28).
          final selected = detail.variants
              .where((variant) =>
                  variant.id ==
                  (_selectedVariantId ?? detail.product.defaultVariantId))
              .firstOrNull;
          // The page price follows the selected variant's explicit price.
          final pagePriceMinor = selected?.priceMinor ?? detail.fromPriceMinor;
          final carouselImages = _carouselImages(product, selected);
          // Sale chip (Section 9): the live sale matching this product —
          // the winner among platform, brand and category scopes.
          final sales = ref.watch(activeSalesProvider).value;
          final sale =
              sales == null ? null : saleForProduct(sales, product);
          // The sale prices the page at the real discounted amount — the
          // same math placement charges (percent truncates, fixed floors).
          final salePagePrice = displayPriceMinor(sale, pagePriceMinor);
          // Real platform delivery fee for the store-promises card.
          final deliveryFeeMinor =
              ref.watch(deliveryFeeMinorProvider).value;

          // Responsive product page: stacked on phones/tablets, media +
          // information side by side once the window reaches the expanded
          // class (RESP-01/02). The centered max width keeps text readable
          // and stops the media from stretching into a thin banner.
          final size = context.screenSize;
          final wide = size == ScreenSize.expanded;
          // Phones keep the fixed 260dp carousel; tablets get a large 16:9
          // block; expanded windows get a square beside the info column.
          final imageAspect = switch (size) {
            ScreenSize.compact => null,
            ScreenSize.medium => AppWidths.detailImageAspectMedium,
            ScreenSize.expanded => AppWidths.detailImageAspect,
          };
          final pager = _ImagePager(
            imageUrls: carouselImages,
            pageController: _pageController,
            currentPage: _page,
            onPageChanged: (index) => setState(() => _page = index),
            aspectRatio: imageAspect,
          );
          final media = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Phones bleed the carousel edge-to-edge; tablet media is
              // rounded, so it takes the page gutter (expanded already sits
              // inside the two-column page padding).
              if (size == ScreenSize.medium)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: pager,
                )
              else
                pager,
              // Variant thumbnails (Section 9): image + name below the
              // carousel; selecting one re-leads the carousel.
              if (detail.variants.length > 1) ...[
                const SizedBox(height: 8),
                _VariantThumbnailRow(
                  variants: detail.variants,
                  // The effective selection (default preselected) — the rail
                  // highlights what the page already shows.
                  selectedId: _selectedVariantId ?? product.defaultVariantId,
                  defaultVariantId: product.defaultVariantId,
                  defaultImageUrl: product.imageUrls.isEmpty
                      ? null
                      : product.imageUrls.first,
                  onSelect: _selectVariant,
                  // The two-column layout already sits inside page padding.
                  padding: wide
                      ? EdgeInsets.zero
                      : const EdgeInsets.symmetric(horizontal: 16),
                ),
              ],
            ],
          );
          final info = _ProductInfo(
            detail: detail,
            product: product,
            pagePriceMinor: pagePriceMinor,
            salePagePrice: salePagePrice,
            sale: sale,
            deliveryFeeMinor: deliveryFeeMinor,
          );

          return ContentWidth(
            maxWidth: AppWidths.detailMax,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      if (wide)
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 5, child: media),
                              const SizedBox(width: AppSpacing.lg),
                              Expanded(flex: 6, child: info),
                            ],
                          ),
                        )
                      else ...[
                        media,
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: info,
                        ),
                      ],
                      if (state.relatedProducts.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md),
                          child: Text('Related products',
                              style: theme.textTheme.titleMedium),
                        ),
                        const SizedBox(height: 8),
                        // Tall enough for a full ProductCard (metadata
                        // ~110dp, image flexes into the remainder).
                        SizedBox(
                          height: 220,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md),
                            itemCount: state.relatedProducts.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 8),
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
                              : () => widget.onToggleWishlist!(product),
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
                            // Disabled products and out-of-stock products
                            // cannot be purchased (Section 2d); checkout
                            // re-validates both server-side (§53).
                            onPressed: product.isPurchasable
                                ? () => _openVariantSheet(
                                    product, detail.variants, sale)
                                : null,
                            icon: const Icon(Icons.shopping_cart_outlined),
                            label: AnimatedSwitcher(
                              duration:
                                  AppMotion.duration(context, AppMotion.press),
                              switchInCurve: AppMotion.enterCurve,
                              switchOutCurve: AppMotion.exitCurve,
                              child: Column(
                                key: ValueKey(salePagePrice),
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Add to Cart'),
                                  Text(
                                    '${Money(salePagePrice).formatUsd()}'
                                    ' · ≈ ${Money(salePagePrice).formatKhr()}',
                                    style: theme.textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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

/// Product information column, shared by the stacked (compact/medium) and
/// two-column (expanded) detail layouts: brand tag, title, rating, stock,
/// price, sale chip, store promises, description and reviews.
class _ProductInfo extends StatelessWidget {
  const _ProductInfo({
    required this.detail,
    required this.product,
    required this.pagePriceMinor,
    required this.salePagePrice,
    required this.sale,
    required this.deliveryFeeMinor,
  });

  final ProductDetail detail;
  final Product product;
  final int pagePriceMinor;
  final int salePagePrice;
  final ActiveSale? sale;
  final int? deliveryFeeMinor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand tag card (Section 9): taps through to the brand's Discovery
        // feed — same deep-link contract as the home brand cards.
        if (detail.brandName.isNotEmpty && product.brandId != null)
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
        Text(product.name, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        // Rating row (Section 9): stars + value + count — real data from the
        // embedded reviews.
        _RatingSummaryRow(detail: detail),
        const SizedBox(height: 4),
        // Stock line (Section 9): real product-wide stock.
        _StockLine(product: product),
        const SizedBox(height: 12),
        // Dual-currency price (DESIGN.md §1.4): USD primary, KHR
        // approximation secondary — the selected variant's price once one is
        // selected. Percent campaigns strike the original through. Cross-fades
        // when the variant changes (§3.3).
        AnimatedSwitcher(
          duration: AppMotion.duration(context, AppMotion.press),
          switchInCurve: AppMotion.enterCurve,
          switchOutCurve: AppMotion.exitCurve,
          child: Wrap(
            key: ValueKey('$salePagePrice-$pagePriceMinor'),
            spacing: 8,
            runSpacing: 2,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              Text(
                Money(salePagePrice).formatUsd(),
                style: AppTypography.priceHighlight.copyWith(fontSize: 24),
              ),
              if (sale != null)
                Text(
                  Money(pagePriceMinor).formatUsd(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              Text(
                '≈ ${Money(salePagePrice).formatKhr()}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        // Sale chip (Section 9): real sale data.
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              if (sale != null) ...[
                Tooltip(
                  message: 'View sale details',
                  child: InkWell(
                    onTap: () => showSaleDetailSheet(context, sale!),
                    borderRadius: AppRadii.br8,
                    child: Container(
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
                            sale!.chipLabel,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.info_outline,
                              size: 11, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Honest store promises (§2): real platform fee, supported payment
        // methods and the single-seller identity — no invented claims.
        _StorePromises(deliveryFeeMinor: deliveryFeeMinor),
        // Description only when the product carries one.
        if (product.description.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          Text('Description', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(product.description, style: theme.textTheme.bodyMedium),
        ],
        // Reviews (Section 9): always rendered — the empty state was
        // previously unreachable because the whole section was gated on a
        // non-empty list.
        const SizedBox(height: AppSpacing.lg),
        const Divider(),
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
          for (final review in detail.reviews) ReviewCard(review: review),
        const SizedBox(height: AppSpacing.lg),
      ],
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

/// Honest store-promises card (HANDOFF-UX-VISUAL §2): only verifiable facts —
/// the platform delivery fee, supported payment methods and the single-seller
/// identity. No warranty, ETA, returns or social-proof claims.
class _StorePromises extends StatelessWidget {
  const _StorePromises({required this.deliveryFeeMinor});

  /// Null while loading or on failure — the row falls back to "calculated at
  /// checkout" rather than inventing a fee.
  final int? deliveryFeeMinor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final delivery = switch (deliveryFeeMinor) {
      null => 'Calculated at checkout',
      0 => 'Free delivery',
      final fee => '${Money(fee).formatUsd()} platform delivery fee',
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: AppRadii.br16,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          _PromiseRow(
            icon: Icons.local_shipping_outlined,
            title: 'Delivery',
            subtitle: delivery,
          ),
          Divider(
            height: AppSpacing.md,
            color: theme.colorScheme.outlineVariant,
          ),
          const _PromiseRow(
            icon: Icons.qr_code_2,
            title: 'Payment',
            subtitle: 'Cash on delivery or KHQR',
          ),
          Divider(
            height: AppSpacing.md,
            color: theme.colorScheme.outlineVariant,
          ),
          const _PromiseRow(
            icon: Icons.storefront_outlined,
            title: 'Sold by EncueYPay',
            subtitle: 'Official single-seller storefront',
          ),
        ],
      ),
    );
  }
}

/// One compact promise row — icon, title, supporting line.
class _PromiseRow extends StatelessWidget {
  const _PromiseRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm + 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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

/// In-stock row with real product-wide stock; archived/out-of-stock render
/// the error-toned availability text.
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
            '${product.stock} ${product.stock == 1 ? 'unit' : 'units'} available',
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
/// fallback) over its name; the selected one is highlighted. The default
/// variant's chip falls back to the base product image — selecting it
/// displays exactly that image, so the chip shows it too.
class _VariantThumbnailRow extends StatelessWidget {
  const _VariantThumbnailRow({
    required this.variants,
    required this.selectedId,
    required this.defaultVariantId,
    required this.defaultImageUrl,
    required this.onSelect,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final List<ProductVariant> variants;
  final String? selectedId;
  final String? defaultVariantId;
  final String? defaultImageUrl;
  final ValueChanged<ProductVariant> onSelect;

  /// The stacked layout pads to the screen edge; the two-column layout
  /// already sits inside the page padding.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: variants.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final variant = variants[index];
          final isSelected = variant.id == selectedId;
          // The default variant has no image of its own — its chip shows
          // the base product image, matching what selecting it displays.
          // Other image-less variants keep the monogram.
          final chipImageUrl = variant.imageUrl ??
              (variant.id == defaultVariantId ? defaultImageUrl : null);
          return InkWell(
            onTap: () => onSelect(variant),
            borderRadius: AppRadii.br12,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: AppMotion.duration(context, AppMotion.press),
                  curve: AppMotion.layoutCurve,
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
                    imageUrl: chipImageUrl,
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

/// Image carousel (Section 9): paged cover images, dot indicators, a
/// hardcoded "KHQR Ready" badge (the app genuinely settles KHQR), and
/// tap-to-full-screen with the current page preselected.
class _ImagePager extends StatelessWidget {
  const _ImagePager({
    required this.imageUrls,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
    required this.aspectRatio,
  });

  final List<String> imageUrls;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  /// Null keeps the compact 260dp carousel; a value wraps the same content
  /// in a rounded aspect-ratio block (tablet 16:9, expanded square).
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final placeholder = ColoredBox(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(Icons.image_outlined,
          size: 56, color: theme.colorScheme.onSurfaceVariant),
    );
    final content = imageUrls.isEmpty
        ? placeholder
        : Stack(
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
                          size: 56, color: theme.colorScheme.onSurfaceVariant),
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
          );
    if (aspectRatio != null) {
      return ClipRRect(
        borderRadius: AppRadii.br16,
        child: AspectRatio(aspectRatio: aspectRatio!, child: content),
      );
    }
    return SizedBox(height: 260, child: content);
  }
}
