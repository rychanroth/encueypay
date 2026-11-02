import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';

/// A cart line with denormalized display data (product/variant) joined
/// server-side. Slim, purpose-shaped entity — features never import
/// each other (ARCH-04); the server stays authoritative for price (spec §8).
@freezed
abstract class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    required String variantId,
    required String productId,
    required String productName,
    String? variantName,

    /// Variant price (or the product base price) — the "was" price when a
    /// sale applies.
    required int unitPriceMinor,

    /// Server-computed sale price for this line (`best_sale_price_minor`).
    required int saleUnitPriceMinor,
    required int quantity,

    /// Product-wide stock snapshot (Section 6): all variants of the product
    /// share it; caps the tile's quantity stepper. The server re-validates
    /// authoritatively at checkout (§53).
    @Default(0) int stock,
    String? imageUrl,

    /// Product group ids from the cart read model (kept for display/
    /// diagnostics; pricing already arrives resolved as
    /// [saleUnitPriceMinor]).
    String? brandId,
    String? categoryId,
  }) = _CartItem;

  const CartItem._();

  bool get hasSale => saleUnitPriceMinor < unitPriceMinor;

  int get effectiveUnitPriceMinor => saleUnitPriceMinor;

  int get lineTotalMinor => saleUnitPriceMinor * quantity;
}
