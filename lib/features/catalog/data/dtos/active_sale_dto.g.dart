// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_sale_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveSaleDto _$ActiveSaleDtoFromJson(Map<String, dynamic> json) =>
    ActiveSaleDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      scope: json['scope'] as String?,
      discountType: json['discount_type'] as String?,
      discountValue: (json['discount_value'] as num?)?.toInt() ?? 0,
      startsAt: json['starts_at'] == null
          ? null
          : DateTime.parse(json['starts_at'] as String),
      endsAt: json['ends_at'] == null
          ? null
          : DateTime.parse(json['ends_at'] as String),
      brandId: json['brand_id'] as String?,
      categoryId: json['category_id'] as String?,
      categoryIds: (json['category_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ActiveSaleDtoToJson(ActiveSaleDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'scope': instance.scope,
      'discount_type': instance.discountType,
      'discount_value': instance.discountValue,
      'starts_at': instance.startsAt?.toIso8601String(),
      'ends_at': instance.endsAt?.toIso8601String(),
      'brand_id': instance.brandId,
      'category_id': instance.categoryId,
      'category_ids': instance.categoryIds,
    };
