import 'dart:math';

import '../../domain/entities/wishlist_item.dart';
import '../dtos/wishlist_item_dto.dart';

extension WishlistItemDtoX on WishlistItemDto {
  WishlistItem toDomain({String? imageUrl}) {
    final product = products;
    final basePriceMinor = product?.basePriceMinor ?? 0;
    // Active variants only; a business-authored "Default" is just an option.
    final variants = (product?.productVariants ?? const [])
        .where(
          (variant) => variant.status == null || variant.status == 'active',
        )
        .toList();
    return WishlistItem(
      id: id,
      productId: productId,
      productName: product?.name ?? 'Unknown product',
      priceMinor: basePriceMinor,
      fromPriceMinor: variants.isEmpty
          ? basePriceMinor
          : variants.map((variant) => variant.priceMinor).reduce(min),
      stock: product?.stock ?? 0,
      status: product?.status,
      defaultVariantId: _defaultVariantId(variants, basePriceMinor),
      imageUrl: imageUrl,
      brandId: product?.brandId,
      categoryId: product?.categoryId,
      brandName: product?.brands?.name ?? '',
      ratingAvg: product?.productRatings.firstOrNull?.ratingAvg,
      reviewCount: product?.productRatings.firstOrNull?.reviewCount ?? 0,
    );
  }

  /// Cheapest visible variant, matching the catalog card's "from" price.
  String? _defaultVariantId(
    List<WishlistVariantJoinDto> variants,
    int basePriceMinor,
  ) {
    WishlistVariantJoinDto? best;
    for (final variant in variants) {
      if (best == null) {
        best = variant;
        continue;
      }
      final price = variant.priceMinor;
      final bestPrice = best.priceMinor;
      final cheaper = price < bestPrice;
      final tie =
          price == bestPrice && (variant.id ?? '').compareTo(best.id ?? '') < 0;
      if (cheaper || tie) best = variant;
    }
    return best?.id;
  }
}
