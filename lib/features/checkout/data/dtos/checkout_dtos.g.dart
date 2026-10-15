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
      productVariants: json['product_variants'] == null
          ? null
          : CheckoutVariantJoinDto.fromJson(
              json['product_variants'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$CheckoutItemDtoToJson(CheckoutItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'product_variants': instance.productVariants,
    };

CheckoutVariantJoinDto _$CheckoutVariantJoinDtoFromJson(
  Map<String, dynamic> json,
) => CheckoutVariantJoinDto(
  name: json['name'] as String?,
  priceMinor: (json['price_minor'] as num?)?.toInt(),
  products: json['products'] == null
      ? null
      : CheckoutProductJoinDto.fromJson(
          json['products'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$CheckoutVariantJoinDtoToJson(
  CheckoutVariantJoinDto instance,
) => <String, dynamic>{
  'name': instance.name,
  'price_minor': instance.priceMinor,
  'products': instance.products,
};

CheckoutProductJoinDto _$CheckoutProductJoinDtoFromJson(
  Map<String, dynamic> json,
) => CheckoutProductJoinDto(
  name: json['name'] as String?,
  basePriceMinor: (json['base_price_minor'] as num?)?.toInt(),
  productImages:
      (json['product_images'] as List<dynamic>?)
          ?.map((e) => CheckoutImageJoinDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$CheckoutProductJoinDtoToJson(
  CheckoutProductJoinDto instance,
) => <String, dynamic>{
  'name': instance.name,
  'base_price_minor': instance.basePriceMinor,
  'product_images': instance.productImages,
};

CheckoutImageJoinDto _$CheckoutImageJoinDtoFromJson(
  Map<String, dynamic> json,
) => CheckoutImageJoinDto(
  storagePath: json['storage_path'] as String?,
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CheckoutImageJoinDtoToJson(
  CheckoutImageJoinDto instance,
) => <String, dynamic>{
  'storage_path': instance.storagePath,
  'sort_order': instance.sortOrder,
};

PlatformSettingsDto _$PlatformSettingsDtoFromJson(Map<String, dynamic> json) =>
    PlatformSettingsDto(
      deliveryFeeMinor: (json['delivery_fee_minor'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PlatformSettingsDtoToJson(
  PlatformSettingsDto instance,
) => <String, dynamic>{'delivery_fee_minor': instance.deliveryFeeMinor};
