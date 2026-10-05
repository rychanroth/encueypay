import 'package:json_annotation/json_annotation.dart';

part 'brand_dto.g.dart';

/// Wire shape of the `brands` table row (DATA-01) — active rows only for the
/// customer read path (RLS `brands_public_read_active`).
@JsonSerializable(fieldRename: FieldRename.snake)
class BrandDto {
  const BrandDto({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory BrandDto.fromJson(Map<String, dynamic> json) =>
      _$BrandDtoFromJson(json);

  final String id;
  final String name;
  final String? imageUrl;

  Map<String, dynamic> toJson() => _$BrandDtoToJson(this);
}
