// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemDto _$CartItemDtoFromJson(Map<String, dynamic> json) => CartItemDto(
  id: json['id'] as String,
  quantity: (json['quantity'] as num).toInt(),
  productVariants: json['product_variants'] == null
      ? null
      : CartVariantJoinDto.fromJson(
          json['product_variants'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$CartItemDtoToJson(CartItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'product_variants': instance.productVariants,
    };

CartVariantJoinDto _$CartVariantJoinDtoFromJson(Map<String, dynamic> json) =>
    CartVariantJoinDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      priceMinor: (json['price_minor'] as num?)?.toInt(),
      products: json['products'] == null
          ? null
          : CartProductJoinDto.fromJson(
              json['products'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$CartVariantJoinDtoToJson(CartVariantJoinDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price_minor': instance.priceMinor,
      'products': instance.products,
    };

CartProductJoinDto _$CartProductJoinDtoFromJson(Map<String, dynamic> json) =>
    CartProductJoinDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      basePriceMinor: (json['base_price_minor'] as num?)?.toInt(),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      productImages:
          (json['product_images'] as List<dynamic>?)
              ?.map((e) => CartImageJoinDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CartProductJoinDtoToJson(CartProductJoinDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'base_price_minor': instance.basePriceMinor,
      'stock': instance.stock,
      'product_images': instance.productImages,
    };

CartImageJoinDto _$CartImageJoinDtoFromJson(Map<String, dynamic> json) =>
    CartImageJoinDto(
      storagePath: json['storage_path'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CartImageJoinDtoToJson(CartImageJoinDto instance) =>
    <String, dynamic>{
      'storage_path': instance.storagePath,
      'sort_order': instance.sortOrder,
    };
