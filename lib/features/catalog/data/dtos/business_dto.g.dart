// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessDto _$BusinessDtoFromJson(Map<String, dynamic> json) => BusinessDto(
  id: json['id'] as String,
  ownerId: json['owner_id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  imageUrl: json['image_url'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$BusinessDtoToJson(BusinessDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'name': instance.name,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'status': instance.status,
    };
