import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist_item.freezed.dart';

/// A wishlisted product with display data joined server-side (spec §38).
@freezed
abstract class WishlistItem with _$WishlistItem {
  const factory WishlistItem({
    required String id,
    required String productId,
    required String productName,
    required int priceMinor,
    String? imageUrl,
  }) = _WishlistItem;
}
