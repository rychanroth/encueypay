import 'package:flutter/material.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/theme/app_typography.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';
import '../../../../core/presentation/widgets/price_text.dart';
import '../../domain/entities/product.dart';
import 'rating_stars.dart';
import 'product_card_actions.dart';

/// Reusable product grid card (DESIGN.md §6.1): flex image with skeleton →
/// monogram fallback, brand chip (top-left), wishlist heart (top-right),
/// "Unavailable" pill (bottom-center), brand + title + rating + dual-
/// currency price metadata. Price is exact minor-unit money formatted at
/// the display edge (spec §22).
///
/// The image flex-fills the space left by the metadata column, so the card
/// renders overflow-free in any container — 2-col grids and narrow rails
/// alike (the rails' earlier "Bottom overflowed by N px" came from the old
/// fixed-square image starving the metadata column).
///
/// Disabled/out-of-stock products render the availability pill but stay
/// tappable — the detail screen explains the state.
///
/// Tap always navigates to the product detail; long-press (Section 6) opens
/// the quick-actions sheet when [actions] is injected by the composition
/// root (wishlist/cart toggles reflecting current state).
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.actions,
  });

  final Product product;
  final VoidCallback? onTap;
  final ProductCardActions? actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final hasBrand = product.brandName.isNotEmpty;

    return Material(
      color: isLight
          ? AppColors.surfaceLight
          : theme.colorScheme.surfaceContainerLowest,
      borderRadius: AppRadii.br16,
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        onLongPress:
            actions == null ? null : () => actions!.showSheet(context, product),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Image with badge layering ---------------------------------
            // Expanded (not a fixed 1:1 AspectRatio): the image absorbs the
            // height the metadata column doesn't use, so narrow rails and
            // grids of any geometry stay overflow-free.
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MonogramImage(
                    imageUrl: product.thumbnailUrl.isEmpty
                        ? null
                        : product.thumbnailUrl,
                    name: product.name,
                  ),
                  // Top-left: NEW badge (coral) over the brand chip (§6.1) —
                  // the badge uses the same 14-day rule as the Home shelf.
                  if (product.isNewArrival || hasBrand)
                    Positioned(
                      top: AppSpacing.sm,
                      left: AppSpacing.sm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.isNewArrival)
                            _Pill(
                              background: AppColors.promotionCoral,
                              foreground: Colors.white,
                              label: 'NEW',
                            ),
                          if (hasBrand) ...[
                            if (product.isNewArrival)
                              const SizedBox(height: AppSpacing.xs),
                            _Pill(
                              background: isLight
                                  ? Colors.white.withValues(alpha: 0.9)
                                  : theme.colorScheme.surfaceContainerLowest,
                              foreground: theme.colorScheme.onSurfaceVariant,
                              label: product.brandName,
                            ),
                          ],
                        ],
                      ),
                    ),
                  // Top-right: wishlist heart with micro-animation (§6.1).
                  if (actions != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: _WishlistHeart(actions: actions!),
                    ),
                  // Bottom-center: availability pill (§6.1).
                  if (product.availabilityLabel != null)
                    Positioned(
                      left: AppSpacing.sm,
                      right: AppSpacing.sm,
                      bottom: AppSpacing.sm,
                      child: Align(
                        child: _Pill(
                          background: isLight
                              ? AppColors.accentRoseLight
                              : AppColors.errorContainerDark,
                          foreground: isLight
                              ? const Color(0xFFBE123C)
                              : AppColors.onErrorContainerDark,
                          label: product.availabilityLabel!,
                          icon: Icons.block_outlined,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // --- Metadata -----------------------------------------------------
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm + 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasBrand)
                    Text(
                      product.brandName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Star rating with value + review count when the catalog
                  // exposes the aggregate; absent data renders nothing (§6.1).
                  if (product.ratingAvg != null && product.reviewCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: Row(
                        children: [
                          RatingStars(rating: product.ratingAvg!, starSize: 12),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            product.ratingAvg!.toStringAsFixed(1),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '(${product.reviewCount})',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  PriceText(
                    money: Money(product.fromPriceMinor),
                    showKhr: false,
                    mainStyle: theme.textTheme.titleSmall?.copyWith(
                      fontSize: 15,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  Text(
                    Money(product.fromPriceMinor).formatKhr(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Translucent status pill used for the brand chip and availability badge.
class _Pill extends StatelessWidget {
  const _Pill({
    required this.background,
    required this.foreground,
    required this.label,
    this.icon,
  });

  final Color background;
  final Color foreground;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.br8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: foreground),
            const SizedBox(width: AppSpacing.xs),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSmall.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}

/// Heart toggle with a scale micro-animation (§6.1) — rose fill when saved.
class _WishlistHeart extends StatefulWidget {
  const _WishlistHeart({required this.actions});

  final ProductCardActions actions;

  @override
  State<_WishlistHeart> createState() => _WishlistHeartState();
}

class _WishlistHeartState extends State<_WishlistHeart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 240),
    value: 1,
  );
  bool _pending = false;

  Future<void> _toggle() async {
    if (_pending) return;
    _pending = true;
    _pulse.forward(from: 0.55).then((_) => _pulse.animateTo(1));
    await widget.actions.onToggleWishlist();
    _pending = false;
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final saved = widget.actions.inWishlist;
    return ScaleTransition(
      scale: Tween(begin: 0.7, end: 1.0)
          .animate(CurvedAnimation(parent: _pulse, curve: Curves.easeOutBack)),
      child: IconButton(
        tooltip: saved ? 'Remove from wishlist' : 'Add to wishlist',
        // 40dp inside the 1:1 tile — still ≥40 and comfortably in the
        // thumb zone on a 2-col grid (§1.5).
        constraints:
            const BoxConstraints(minWidth: 40, minHeight: 40),
        padding: const EdgeInsets.all(AppSpacing.sm),
        iconSize: 20,
        icon: Icon(
          saved ? Icons.favorite : Icons.favorite_border,
          color: saved
              ? AppColors.accentRose
              : (theme.brightness == Brightness.light
                  ? Colors.white
                  : theme.colorScheme.onSurface),
          shadows: saved || theme.brightness == Brightness.dark
              ? null
              : const [
                  Shadow(color: Color(0x66000000), blurRadius: 4),
                ],
        ),
        onPressed: _toggle,
      ),
    );
  }
}
