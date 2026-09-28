// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_image_ref_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductImageRefDto _$ProductImageRefDtoFromJson(Map<String, dynamic> json) =>
    ProductImageRefDto(
      storagePath: json['storage_path'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ProductImageRefDtoToJson(ProductImageRefDto instance) =>
    <String, dynamic>{
      'storage_path': instance.storagePath,
      'sort_order': instance.sortOrder,
    };
