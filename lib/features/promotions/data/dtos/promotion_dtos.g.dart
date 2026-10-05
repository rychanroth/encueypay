// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromotionDto _$PromotionDtoFromJson(Map<String, dynamic> json) => PromotionDto(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  discountValue: (json['discount_value'] as num).toInt(),
  scope: json['scope'] as String?,
  discountType: json['discount_type'] as String?,
  active: json['active'] as bool? ?? true,
  brands: json['brands'] == null
      ? null
      : PromoBrandRefDto.fromJson(json['brands'] as Map<String, dynamic>),
  coupons:
      (json['coupons'] as List<dynamic>?)
          ?.map((e) => CouponJoinDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$PromotionDtoToJson(PromotionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'scope': instance.scope,
      'discount_type': instance.discountType,
      'discount_value': instance.discountValue,
      'active': instance.active,
      'brands': instance.brands,
      'coupons': instance.coupons,
    };

PromoBrandRefDto _$PromoBrandRefDtoFromJson(Map<String, dynamic> json) =>
    PromoBrandRefDto(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$PromoBrandRefDtoToJson(PromoBrandRefDto instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

CouponJoinDto _$CouponJoinDtoFromJson(Map<String, dynamic> json) =>
    CouponJoinDto(
      id: json['id'] as String,
      code: json['code'] as String,
      active: json['active'] as bool,
      minOrderAmountMinor:
          (json['min_order_amount_minor'] as num?)?.toInt() ?? 0,
      startsAt: json['starts_at'] == null
          ? null
          : DateTime.parse(json['starts_at'] as String),
      endsAt: json['ends_at'] == null
          ? null
          : DateTime.parse(json['ends_at'] as String),
    );

Map<String, dynamic> _$CouponJoinDtoToJson(CouponJoinDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'active': instance.active,
      'min_order_amount_minor': instance.minOrderAmountMinor,
      'starts_at': instance.startsAt?.toIso8601String(),
      'ends_at': instance.endsAt?.toIso8601String(),
    };

BannerDto _$BannerDtoFromJson(Map<String, dynamic> json) => BannerDto(
  id: json['id'] as String,
  name: json['name'] as String,
  imagePath: json['image_path'] as String,
  description: json['description'] as String?,
  status: json['status'] as String?,
  startsAt: json['starts_at'] == null
      ? null
      : DateTime.parse(json['starts_at'] as String),
  endsAt: json['ends_at'] == null
      ? null
      : DateTime.parse(json['ends_at'] as String),
);

Map<String, dynamic> _$BannerDtoToJson(BannerDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'image_path': instance.imagePath,
  'description': instance.description,
  'status': instance.status,
  'starts_at': instance.startsAt?.toIso8601String(),
  'ends_at': instance.endsAt?.toIso8601String(),
};
