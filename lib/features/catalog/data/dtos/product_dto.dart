import 'package:json_annotation/json_annotation.dart';

import 'product_image_ref_dto.dart';

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
    required this.stock,
    this.status,
    this.productImages = const [],
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  final String id;
  final String businessId;
  final String categoryId;
  final String name;
  final String description;
  final int basePriceMinor;
  final int stock;
  final String? status;

  /// PostgREST embed key `product_images` (fieldRename.snake matches).
  @JsonKey(defaultValue: [])
  final List<ProductImageRefDto> productImages;

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);
}
