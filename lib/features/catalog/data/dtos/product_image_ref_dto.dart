import 'package:json_annotation/json_annotation.dart';

part 'product_image_ref_dto.g.dart';

/// Slim wire shape of an embedded `product_images` row (DATA-01). Catalog
/// queries embed only what they need; nullable fields keep partial embeds
/// (`select('product_images(storage_path)')`) parseable.
@JsonSerializable(fieldRename: FieldRename.snake)
class ProductImageRefDto {
  const ProductImageRefDto({this.storagePath, this.sortOrder = 0});

  factory ProductImageRefDto.fromJson(Map<String, dynamic> json) =>
      _$ProductImageRefDtoFromJson(json);

  final String? storagePath;

  /// Display order; absent from slim embeds that don't request it.
  @JsonKey(defaultValue: 0)
  final int sortOrder;

  Map<String, dynamic> toJson() => _$ProductImageRefDtoToJson(this);
}
