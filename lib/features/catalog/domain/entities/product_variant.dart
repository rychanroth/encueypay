import 'package:freezed_annotation/freezed_annotation.dart';

import 'product.dart';

part 'product_variant.freezed.dart';

/// A sellable variant of a product (spec §5.3). The variant is the selected
/// sellable unit in the cart where applicable. A variant price of `null`
/// falls back to the product's base price.
@freezed
abstract class ProductVariant with _$ProductVariant {
  const factory ProductVariant({
    required String id,
    required String productId,
    required String name,
    Map<String, dynamic>? attributes,
    required int? priceMinor,
    required int stock,
    required ProductStatus status,
  }) = _ProductVariant;

  const ProductVariant._();

  int effectivePriceMinor(Product product) =>
      priceMinor ?? product.basePriceMinor;
}
