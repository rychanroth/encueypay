// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) => ProductDto(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  categoryId: json['category_id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  basePriceMinor: (json['base_price_minor'] as num).toInt(),
  status: json['status'] as String?,
  productImages:
      (json['product_images'] as List<dynamic>?)
          ?.map((e) => ProductImageRefDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  productVariants:
      (json['product_variants'] as List<dynamic>?)
          ?.map(
            (e) => ProductVariantPriceDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$ProductDtoToJson(ProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'category_id': instance.categoryId,
      'name': instance.name,
      'description': instance.description,
      'base_price_minor': instance.basePriceMinor,
      'status': instance.status,
      'product_images': instance.productImages,
      'product_variants': instance.productVariants,
    };
