// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressDto _$AddressDtoFromJson(Map<String, dynamic> json) => AddressDto(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  label: json['label'] as String,
  recipientName: json['recipient_name'] as String,
  phone: json['phone'] as String,
  line1: json['line1'] as String,
  line2: json['line2'] as String?,
  city: json['city'] as String,
  provinceCode: json['province_code'] as String?,
  districtCode: json['district_code'] as String?,
  communeCode: json['commune_code'] as String?,
  villageCode: json['village_code'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  isDefault: json['is_default'] as bool? ?? false,
);

Map<String, dynamic> _$AddressDtoToJson(AddressDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'label': instance.label,
      'recipient_name': instance.recipientName,
      'phone': instance.phone,
      'line1': instance.line1,
      'line2': instance.line2,
      'city': instance.city,
      'province_code': instance.provinceCode,
      'district_code': instance.districtCode,
      'commune_code': instance.communeCode,
      'village_code': instance.villageCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'is_default': instance.isDefault,
    };
