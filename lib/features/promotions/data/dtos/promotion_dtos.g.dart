// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleDto _$SaleDtoFromJson(Map<String, dynamic> json) => SaleDto(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  discountValue: (json['discount_value'] as num).toInt(),
  scope: json['scope'] as String?,
  discountType: json['discount_type'] as String?,
  active: json['active'] as bool? ?? true,
  startsAt: json['starts_at'] == null
      ? null
      : DateTime.parse(json['starts_at'] as String),
  endsAt: json['ends_at'] == null
      ? null
      : DateTime.parse(json['ends_at'] as String),
  brands: json['brands'] == null
      ? null
      : PromoBrandRefDto.fromJson(json['brands'] as Map<String, dynamic>),
  categories: json['categories'] == null
      ? null
      : PromoCategoryRefDto.fromJson(
          json['categories'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$SaleDtoToJson(SaleDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'scope': instance.scope,
  'discount_type': instance.discountType,
  'discount_value': instance.discountValue,
  'active': instance.active,
  'starts_at': instance.startsAt?.toIso8601String(),
  'ends_at': instance.endsAt?.toIso8601String(),
  'brands': instance.brands,
  'categories': instance.categories,
};

CouponDto _$CouponDtoFromJson(Map<String, dynamic> json) => CouponDto(
  id: json['id'] as String,
  code: json['code'] as String,
  discountValue: (json['discount_value'] as num).toInt(),
  name: json['name'] as String? ?? '',
  discountType: json['discount_type'] as String?,
  minOrderAmountMinor: (json['min_order_amount_minor'] as num?)?.toInt() ?? 0,
  active: json['active'] as bool? ?? true,
  startsAt: json['starts_at'] == null
      ? null
      : DateTime.parse(json['starts_at'] as String),
  endsAt: json['ends_at'] == null
      ? null
      : DateTime.parse(json['ends_at'] as String),
);

Map<String, dynamic> _$CouponDtoToJson(CouponDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'code': instance.code,
  'discount_type': instance.discountType,
  'discount_value': instance.discountValue,
  'min_order_amount_minor': instance.minOrderAmountMinor,
  'active': instance.active,
  'starts_at': instance.startsAt?.toIso8601String(),
  'ends_at': instance.endsAt?.toIso8601String(),
};

BannerDto _$BannerDtoFromJson(Map<String, dynamic> json) => BannerDto(
  id: json['id'] as String,
  name: json['name'] as String,
  imagePath: json['image_path'] as String,
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
  'status': instance.status,
  'starts_at': instance.startsAt?.toIso8601String(),
  'ends_at': instance.endsAt?.toIso8601String(),
};

PromoCategoryRefDto _$PromoCategoryRefDtoFromJson(Map<String, dynamic> json) =>
    PromoCategoryRefDto(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$PromoCategoryRefDtoToJson(
  PromoCategoryRefDto instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

PromoBrandRefDto _$PromoBrandRefDtoFromJson(Map<String, dynamic> json) =>
    PromoBrandRefDto(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$PromoBrandRefDtoToJson(PromoBrandRefDto instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
