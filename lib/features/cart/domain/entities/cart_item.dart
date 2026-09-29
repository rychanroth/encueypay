import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';

/// A cart line with denormalized display data (product/variant/business)
/// joined server-side. Slim, purpose-shaped entity — features never import
/// each other (ARCH-04); the server stays authoritative for price (spec §8).
@freezed
abstract class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    required String variantId,
    required String productId,
    required String productName,
    String? variantName,
    required int unitPriceMinor,
    required int quantity,
    String? businessId,
    String? businessName,
    String? imageUrl,
  }) = _CartItem;

  const CartItem._();

  int get lineTotalMinor => unitPriceMinor * quantity;
}
