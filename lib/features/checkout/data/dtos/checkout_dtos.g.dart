// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutAddressDto _$CheckoutAddressDtoFromJson(Map<String, dynamic> json) =>
    CheckoutAddressDto(
      id: json['id'] as String,
      label: json['label'] as String,
      recipientName: json['recipient_name'] as String,
      phone: json['phone'] as String,
      line1: json['line1'] as String,
      line2: json['line2'] as String?,
      city: json['city'] as String,
    );

Map<String, dynamic> _$CheckoutAddressDtoToJson(CheckoutAddressDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'recipient_name': instance.recipientName,
      'phone': instance.phone,
      'line1': instance.line1,
      'line2': instance.line2,
      'city': instance.city,
    };

CheckoutItemDto _$CheckoutItemDtoFromJson(Map<String, dynamic> json) =>
    CheckoutItemDto(
      id: json['id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      variantId: json['variant_id'] as String,
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      unitPriceMinor: (json['unit_price_minor'] as num).toInt(),
      saleUnitPriceMinor: (json['sale_unit_price_minor'] as num).toInt(),
      variantName: json['variant_name'] as String?,
      imageStoragePath: json['image_storage_path'] as String?,
    );

Map<String, dynamic> _$CheckoutItemDtoToJson(CheckoutItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'variant_id': instance.variantId,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'variant_name': instance.variantName,
      'unit_price_minor': instance.unitPriceMinor,
      'sale_unit_price_minor': instance.saleUnitPriceMinor,
      'image_storage_path': instance.imageStoragePath,
    };

PlatformSettingsDto _$PlatformSettingsDtoFromJson(Map<String, dynamic> json) =>
    PlatformSettingsDto(
      deliveryFeeMinor: (json['delivery_fee_minor'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PlatformSettingsDtoToJson(
  PlatformSettingsDto instance,
) => <String, dynamic>{'delivery_fee_minor': instance.deliveryFeeMinor};
