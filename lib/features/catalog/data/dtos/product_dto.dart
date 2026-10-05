import 'package:json_annotation/json_annotation.dart';

import 'product_image_ref_dto.dart';
import 'product_variant_dto.dart';

part 'product_dto.g.dart';

/// Wire shape of the `products` table row (DATA-01), plus the embedded
/// `product_images` rows resolved through the PostgREST FK embedding.
@JsonSerializable(fieldRename: FieldRename.snake)
class ProductDto {
  const ProductDto({
    required this.id,
    required this.businessId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.basePriceMinor,
    this.brandId,
    this.status,
    this.stock = 0,
    this.productImages = const [],
    this.productVariants = const [],
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  final String id;
  final String businessId;
  final String categoryId;
  final String name;
  final String description;
  final int basePriceMinor;

  /// Direct `products.brand_id` column (Section 2b) — the brand *name* is a
  /// separate embed consumed only where displayed.
  final String? brandId;
  final String? status;

  /// Product-wide stock (Section 2d); column re-added by 0031.
  @JsonKey(defaultValue: 0)
  final int stock;

  /// PostgREST embed key `product_images` (fieldRename.snake matches).
  @JsonKey(defaultValue: [])
  final List<ProductImageRefDto> productImages;

  /// Price-only variant embed for card "from" prices (may be absent from
  /// partial selects; full-variant embeds also parse — extra keys ignored).
  @JsonKey(name: 'product_variants', defaultValue: [])
  final List<ProductVariantPriceDto> productVariants;

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);
}
