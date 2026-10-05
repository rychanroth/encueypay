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
  bannerImagePath: json['banner_image_path'] as String?,
  bannerStatus: json['banner_status'] as String?,
  endsAt: json['ends_at'] == null
      ? null
      : DateTime.parse(json['ends_at'] as String),
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
      'banner_image_path': instance.bannerImagePath,
      'banner_status': instance.bannerStatus,
      'ends_at': instance.endsAt?.toIso8601String(),
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
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$CouponJoinDtoToJson(CouponJoinDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'active': instance.active,
      'expires_at': instance.expiresAt?.toIso8601String(),
    };
