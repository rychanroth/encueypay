import 'package:json_annotation/json_annotation.dart';

part 'product_variant_dto.g.dart';

/// Wire shape of the `product_variants` table row (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class ProductVariantDto {
  const ProductVariantDto({
    required this.id,
    required this.productId,
    required this.name,
    this.attributes,
    this.priceMinor,
    required this.stock,
    this.status,
  });

  factory ProductVariantDto.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantDtoFromJson(json);

  final String id;
  final String productId;
  final String name;
  final Map<String, dynamic>? attributes;
  final int? priceMinor;
  final int stock;
  final String? status;

  Map<String, dynamic> toJson() => _$ProductVariantDtoToJson(this);
}
