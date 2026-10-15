import 'package:json_annotation/json_annotation.dart';

part 'active_promo_dto.g.dart';

/// Wire shape of a coupon-backed active promotion for the merchandising
/// chip (DATA-01). The coupon window is checked in the repository before
/// mapping — this DTO carries only the promotion-level display fields.
@JsonSerializable(fieldRename: FieldRename.snake)
class ActivePromoDto {
  const ActivePromoDto({
    this.scope,
    this.discountType,
    this.discountValue = 0,
    this.brandId,
  });

  factory ActivePromoDto.fromJson(Map<String, dynamic> json) =>
      _$ActivePromoDtoFromJson(json);

  final String? scope;
  final String? discountType;

  @JsonKey(defaultValue: 0)
  final int discountValue;

  final String? brandId;

  Map<String, dynamic> toJson() => _$ActivePromoDtoToJson(this);
}
