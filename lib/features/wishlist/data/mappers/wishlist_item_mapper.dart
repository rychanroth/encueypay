import 'dart:math';

import '../../domain/entities/wishlist_item.dart';
import '../dtos/wishlist_item_dto.dart';

extension WishlistItemDtoX on WishlistItemDto {
  WishlistItem toDomain({String? imageUrl}) {
    final product = products;
    final basePriceMinor = product?.basePriceMinor ?? 0;
    final variants = product?.productVariants ?? const [];
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
      defaultVariantId: product?.productVariants.firstOrNull?.id,
      imageUrl: imageUrl,
      brandId: product?.brandId,
      categoryId: product?.categoryId,
      brandName: product?.brands?.name ?? '',
      ratingAvg: product?.productRatings.firstOrNull?.ratingAvg,
      reviewCount: product?.productRatings.firstOrNull?.reviewCount ?? 0,
    );
  }
}
