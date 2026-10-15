// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_promo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivePromoDto _$ActivePromoDtoFromJson(Map<String, dynamic> json) =>
    ActivePromoDto(
      scope: json['scope'] as String?,
      discountType: json['discount_type'] as String?,
      discountValue: (json['discount_value'] as num?)?.toInt() ?? 0,
      brandId: json['brand_id'] as String?,
    );

Map<String, dynamic> _$ActivePromoDtoToJson(ActivePromoDto instance) =>
    <String, dynamic>{
      'scope': instance.scope,
      'discount_type': instance.discountType,
      'discount_value': instance.discountValue,
      'brand_id': instance.brandId,
    };
