import 'package:json_annotation/json_annotation.dart';

part 'active_sale_dto.g.dart';

/// Wire shape of one `active_sales` row for display (DATA-01). The view
/// already filters active + window — this DTO carries only the
/// display/matching fields. Never leaves the data layer.
@JsonSerializable(fieldRename: FieldRename.snake)
class ActiveSaleDto {
  const ActiveSaleDto({
    this.id,
    this.name = '',
    this.description = '',
    this.scope,
    this.discountType,
    this.discountValue = 0,
    this.startsAt,
    this.endsAt,
    this.brandId,
    this.categoryId,
  });

  factory ActiveSaleDto.fromJson(Map<String, dynamic> json) =>
      _$ActiveSaleDtoFromJson(json);

  @JsonKey(defaultValue: '')
  final String? id;

  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: '')
  final String description;

  final String? scope;
  final String? discountType;

  @JsonKey(defaultValue: 0)
  final int discountValue;

  final DateTime? startsAt;
  final DateTime? endsAt;

  final String? brandId;
  final String? categoryId;

  Map<String, dynamic> toJson() => _$ActiveSaleDtoToJson(this);
}
