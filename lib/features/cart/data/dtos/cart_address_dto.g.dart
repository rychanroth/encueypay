// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_address_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartAddressDto _$CartAddressDtoFromJson(Map<String, dynamic> json) =>
    CartAddressDto(
      id: json['id'] as String,
      label: json['label'] as String,
      city: json['city'] as String,
    );

Map<String, dynamic> _$CartAddressDtoToJson(CartAddressDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'city': instance.city,
    };
