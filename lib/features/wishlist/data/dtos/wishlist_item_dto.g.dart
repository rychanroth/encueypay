// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistItemDto _$WishlistItemDtoFromJson(Map<String, dynamic> json) =>
    WishlistItemDto(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      products: json['products'] == null
          ? null
          : WishlistProductJoinDto.fromJson(
              json['products'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$WishlistItemDtoToJson(WishlistItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'products': instance.products,
    };

WishlistProductJoinDto _$WishlistProductJoinDtoFromJson(
  Map<String, dynamic> json,
) => WishlistProductJoinDto(
  name: json['name'] as String?,
  basePriceMinor: (json['base_price_minor'] as num?)?.toInt(),
  stock: (json['stock'] as num?)?.toInt() ?? 0,
  status: json['status'] as String?,
  productVariants:
      (json['product_variants'] as List<dynamic>?)
          ?.map(
            (e) => WishlistVariantJoinDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  productImages:
      (json['product_images'] as List<dynamic>?)
          ?.map((e) => WishlistImageJoinDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$WishlistProductJoinDtoToJson(
  WishlistProductJoinDto instance,
) => <String, dynamic>{
  'name': instance.name,
  'base_price_minor': instance.basePriceMinor,
  'stock': instance.stock,
  'status': instance.status,
  'product_variants': instance.productVariants,
  'product_images': instance.productImages,
};

WishlistVariantJoinDto _$WishlistVariantJoinDtoFromJson(
  Map<String, dynamic> json,
) => WishlistVariantJoinDto(id: json['id'] as String?);

Map<String, dynamic> _$WishlistVariantJoinDtoToJson(
  WishlistVariantJoinDto instance,
) => <String, dynamic>{'id': instance.id};

WishlistImageJoinDto _$WishlistImageJoinDtoFromJson(
  Map<String, dynamic> json,
) => WishlistImageJoinDto(
  storagePath: json['storage_path'] as String?,
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$WishlistImageJoinDtoToJson(
  WishlistImageJoinDto instance,
) => <String, dynamic>{
  'storage_path': instance.storagePath,
  'sort_order': instance.sortOrder,
};
