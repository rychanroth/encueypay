// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_variant_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductVariantDto _$ProductVariantDtoFromJson(Map<String, dynamic> json) =>
    ProductVariantDto(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      name: json['name'] as String,
      attributes: json['attributes'] as Map<String, dynamic>?,
      priceMinor: (json['price_minor'] as num?)?.toInt(),
      stock: (json['stock'] as num).toInt(),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$ProductVariantDtoToJson(ProductVariantDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'name': instance.name,
      'attributes': instance.attributes,
      'price_minor': instance.priceMinor,
      'stock': instance.stock,
      'status': instance.status,
    };
