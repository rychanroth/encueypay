import 'dart:math';

import '../../domain/entities/wishlist_item.dart';
import '../dtos/wishlist_item_dto.dart';

extension WishlistItemDtoX on WishlistItemDto {
  WishlistItem toDomain({String? imageUrl}) {
    final product = products;
    final basePriceMinor = product?.basePriceMinor ?? 0;
    final active = (product?.productVariants ?? const [])
        .where(
          (variant) => variant.status == null || variant.status == 'active',
        )
        .toList();
    final priced = active
        .where((variant) => variant.priceMinor != null)
        .toList();
    // Same rule as the catalog: priced variants win; the null-price
    // placeholder is only the single-price product's sole row.
    final variants = priced.isNotEmpty ? priced : active;
    return WishlistItem(
      id: id,
      productId: productId,
      productName: product?.name ?? 'Unknown product',
      priceMinor: basePriceMinor,
      fromPriceMinor: variants.isEmpty
          ? basePriceMinor
          // Same cheapest-selectable rule as the catalog cards — the
          // wishlist must never quote a price the product can't be bought
          // at (the base price is only the null-price variant fallback).
          : variants
                .map((variant) => variant.priceMinor ?? basePriceMinor)
                .reduce(min),
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
      final price = variant.priceMinor ?? basePriceMinor;
      final bestPrice = best.priceMinor ?? basePriceMinor;
      final cheaper = price < bestPrice;
      final tie =
          price == bestPrice && (variant.id ?? '').compareTo(best.id ?? '') < 0;
      if (cheaper || tie) best = variant;
    }
    return best?.id;
  }
}
