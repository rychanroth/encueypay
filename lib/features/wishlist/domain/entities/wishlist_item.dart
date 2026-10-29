import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist_item.freezed.dart';

/// A wishlisted product with display data joined server-side (spec §38).
/// The product-wide stock/status/default-variant fields (Section 6) let the
/// composition root rebuild a full ProductCard with quick actions; brand and
/// rating aggregates feed the card's brand chip and star row.
@freezed
abstract class WishlistItem with _$WishlistItem {
  const factory WishlistItem({
    required String id,
    required String productId,
    required String productName,
    required int priceMinor,

    /// The card's "from" price — the same cheapest-selectable rule the
    /// catalog cards use (min over variant prices, base as the null-price
    /// fallback), so every surface shows the same number for a product.
    /// [priceMinor] stays the raw base price.
    required int fromPriceMinor,
    @Default(0) int stock,
    String? status,
    String? defaultVariantId,
    String? imageUrl,
    String? brandId,

    /// Group ids ride along so brand- and category-scoped sales can match
    /// wishlist cards (the composition root's synthetic Product needs them).
    String? categoryId,
    @Default('') String brandName,
    double? ratingAvg,
    @Default(0) int reviewCount,
  }) = _WishlistItem;
}
