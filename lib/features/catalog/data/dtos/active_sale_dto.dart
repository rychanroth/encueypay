import 'package:json_annotation/json_annotation.dart';

part 'active_sale_dto.g.dart';

/// Wire shape of one `active_sales` row for display (DATA-01). The view
/// already filters active + window — this DTO carries only the
/// display/matching fields. Never leaves the data layer.
@JsonSerializable(fieldRename: FieldRename.snake)
class ActiveSaleDto {
  const ActiveSaleDto({
    this.scope,
    this.discountType,
    this.discountValue = 0,
    this.brandId,
    this.categoryId,
  });

  factory ActiveSaleDto.fromJson(Map<String, dynamic> json) =>
      _$ActiveSaleDtoFromJson(json);

  final String? scope;
  final String? discountType;

  @JsonKey(defaultValue: 0)
  final int discountValue;

  final String? brandId;
  final String? categoryId;

  Map<String, dynamic> toJson() => _$ActiveSaleDtoToJson(this);
}
