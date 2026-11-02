// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemDto _$CartItemDtoFromJson(Map<String, dynamic> json) => CartItemDto(
  id: json['id'] as String,
  quantity: (json['quantity'] as num).toInt(),
  variantId: json['variant_id'] as String,
  productId: json['product_id'] as String,
  productName: json['product_name'] as String,
  unitPriceMinor: (json['unit_price_minor'] as num).toInt(),
  saleUnitPriceMinor: (json['sale_unit_price_minor'] as num).toInt(),
  variantName: json['variant_name'] as String?,
  stock: (json['stock'] as num?)?.toInt() ?? 0,
  brandId: json['brand_id'] as String?,
  categoryId: json['category_id'] as String?,
  imageStoragePath: json['image_storage_path'] as String?,
);

Map<String, dynamic> _$CartItemDtoToJson(CartItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'variant_id': instance.variantId,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'variant_name': instance.variantName,
      'unit_price_minor': instance.unitPriceMinor,
      'sale_unit_price_minor': instance.saleUnitPriceMinor,
      'stock': instance.stock,
      'brand_id': instance.brandId,
      'category_id': instance.categoryId,
      'image_storage_path': instance.imageStoragePath,
    };
