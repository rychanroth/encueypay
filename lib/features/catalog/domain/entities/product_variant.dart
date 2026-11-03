import 'package:freezed_annotation/freezed_annotation.dart';

import 'product.dart';

part 'product_variant.freezed.dart';

/// A sellable variant of a product (spec §5.3). The variant is the selected
/// sellable unit in the cart where applicable. Every variant has an explicit
/// price; a null [imageUrl] falls back to the product's own images in the UI.
@freezed
abstract class ProductVariant with _$ProductVariant {
  const factory ProductVariant({
    required String id,
    required String productId,
    required String name,
    required int priceMinor,
    String? imageUrl,
    required ProductStatus status,
  }) = _ProductVariant;
}
