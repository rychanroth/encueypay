import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist_item.freezed.dart';

/// A wishlisted product with display data joined server-side (spec §38).
/// The product-wide stock/status/default-variant fields (Section 6) let the
/// composition root rebuild a full ProductCard with quick actions.
@freezed
abstract class WishlistItem with _$WishlistItem {
  const factory WishlistItem({
    required String id,
    required String productId,
    required String productName,
    required int priceMinor,
    @Default(0) int stock,
    String? status,
    String? defaultVariantId,
    String? imageUrl,
  }) = _WishlistItem;
}
