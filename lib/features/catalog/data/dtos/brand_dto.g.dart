// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandDto _$BrandDtoFromJson(Map<String, dynamic> json) => BrandDto(
  id: json['id'] as String,
  name: json['name'] as String,
  imageUrl: json['image_url'] as String?,
);

Map<String, dynamic> _$BrandDtoToJson(BrandDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'image_url': instance.imageUrl,
};
