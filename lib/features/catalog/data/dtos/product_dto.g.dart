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
  brandId: json['brand_id'] as String?,
  status: json['status'] as String?,
  stock: (json['stock'] as num?)?.toInt() ?? 0,
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
  brand: json['brands'] == null
      ? null
      : BrandEmbedDto.fromJson(json['brands'] as Map<String, dynamic>),
  reviews:
      (json['reviews'] as List<dynamic>?)
          ?.map((e) => ReviewAggregateDto.fromJson(e as Map<String, dynamic>))
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
      'brand_id': instance.brandId,
      'status': instance.status,
      'stock': instance.stock,
      'product_images': instance.productImages,
      'product_variants': instance.productVariants,
      'brands': instance.brand,
      'reviews': instance.reviews,
    };

BrandEmbedDto _$BrandEmbedDtoFromJson(Map<String, dynamic> json) =>
    BrandEmbedDto(name: json['name'] as String?);

Map<String, dynamic> _$BrandEmbedDtoToJson(BrandEmbedDto instance) =>
    <String, dynamic>{'name': instance.name};

ReviewAggregateDto _$ReviewAggregateDtoFromJson(Map<String, dynamic> json) =>
    ReviewAggregateDto(
      ratingAvg: (json['rating_avg'] as num?)?.toDouble(),
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ReviewAggregateDtoToJson(ReviewAggregateDto instance) =>
    <String, dynamic>{
      'rating_avg': instance.ratingAvg,
      'review_count': instance.reviewCount,
    };
