import 'package:json_annotation/json_annotation.dart';

part 'promotion_dtos.g.dart';

/// Wire shape of the `promotions` row (the discount RULE, Section 5b) with
/// its coupon instruments and brand name join (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class PromotionDto {
  const PromotionDto({
    required this.id,
    required this.name,
    required this.description,
    required this.discountValue,
    this.scope,
    this.discountType,
    this.active = true,
    this.brands,
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

  /// Admin kill switch (Section 5b) — window expiry is derived on coupons.
  @JsonKey(defaultValue: true)
  final bool active;

  @JsonKey(name: 'brands')
  final PromoBrandRefDto? brands;

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
    this.minOrderAmountMinor = 0,
    this.startsAt,
    this.endsAt,
  });

  factory CouponJoinDto.fromJson(Map<String, dynamic> json) =>
      _$CouponJoinDtoFromJson(json);

  final String id;
  final String code;
  final bool active;

  /// Assignment §5 attribute set (Section 5b).
  @JsonKey(defaultValue: 0)
  final int minOrderAmountMinor;
  final DateTime? startsAt;
  final DateTime? endsAt;

  Map<String, dynamic> toJson() => _$CouponJoinDtoToJson(this);
}

/// Wire shape of the `banners` row for management views (Section 5b).
@JsonSerializable(fieldRename: FieldRename.snake)
class BannerDto {
  const BannerDto({
    required this.id,
    required this.name,
    required this.imagePath,
    this.description,
    this.status,
    this.startsAt,
    this.endsAt,
  });

  factory BannerDto.fromJson(Map<String, dynamic> json) =>
      _$BannerDtoFromJson(json);

  final String id;
  final String name;
  final String imagePath;
  final String? description;
  final String? status;
  final DateTime? startsAt;
  final DateTime? endsAt;

  Map<String, dynamic> toJson() => _$BannerDtoToJson(this);
}
