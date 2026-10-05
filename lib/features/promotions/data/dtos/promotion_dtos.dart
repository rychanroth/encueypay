import 'package:json_annotation/json_annotation.dart';

part 'promotion_dtos.g.dart';

/// Wire shape of the `promotions` row with the coupons join (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class PromotionDto {
  const PromotionDto({
    required this.id,
    required this.name,
    required this.description,
    required this.discountValue,
    this.scope,
    this.discountType,
    this.bannerImagePath,
    this.bannerStatus,
    this.endsAt,
    this.coupons = const [],
  });

  factory PromotionDto.fromJson(Map<String, dynamic> json) =>
      _$PromotionDtoFromJson(json);

  final String id;
  final String name;
  final String description;
  final String? scope;
  final String? discountType;
  final int discountValue;
  final String? bannerImagePath;
  final String? bannerStatus;
  final DateTime? endsAt;

  @JsonKey(name: 'coupons', defaultValue: [])
  final List<CouponJoinDto> coupons;

  Map<String, dynamic> toJson() => _$PromotionDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PromoBrandRefDto {
  const PromoBrandRefDto({required this.id, required this.name});

  factory PromoBrandRefDto.fromJson(Map<String, dynamic> json) =>
      _$PromoBrandRefDtoFromJson(json);

  final String id;
  final String name;

  Map<String, dynamic> toJson() => _$PromoBrandRefDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CouponJoinDto {
  const CouponJoinDto({
    required this.id,
    required this.code,
    required this.active,
    this.expiresAt,
  });

  factory CouponJoinDto.fromJson(Map<String, dynamic> json) =>
      _$CouponJoinDtoFromJson(json);

  final String id;
  final String code;
  final bool active;
  final DateTime? expiresAt;

  Map<String, dynamic> toJson() => _$CouponJoinDtoToJson(this);
}
