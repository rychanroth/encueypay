// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_sale_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveSaleDto _$ActiveSaleDtoFromJson(Map<String, dynamic> json) =>
    ActiveSaleDto(
      scope: json['scope'] as String?,
      discountType: json['discount_type'] as String?,
      discountValue: (json['discount_value'] as num?)?.toInt() ?? 0,
      brandId: json['brand_id'] as String?,
      categoryId: json['category_id'] as String?,
    );

Map<String, dynamic> _$ActiveSaleDtoToJson(ActiveSaleDto instance) =>
    <String, dynamic>{
      'scope': instance.scope,
      'discount_type': instance.discountType,
      'discount_value': instance.discountValue,
      'brand_id': instance.brandId,
      'category_id': instance.categoryId,
    };
