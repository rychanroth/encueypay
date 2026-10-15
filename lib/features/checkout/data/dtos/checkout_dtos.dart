import 'package:json_annotation/json_annotation.dart';

part 'checkout_dtos.g.dart';

/// Wire shape of the `addresses` row for checkout (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class CheckoutAddressDto {
  const CheckoutAddressDto({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.line1,
    this.line2,
    required this.city,
  });

  factory CheckoutAddressDto.fromJson(Map<String, dynamic> json) =>
      _$CheckoutAddressDtoFromJson(json);

  final String id;
  final String label;
  final String recipientName;
  final String phone;
  final String line1;
  final String? line2;
  final String city;

  Map<String, dynamic> toJson() => _$CheckoutAddressDtoToJson(this);
}

/// Wire shape of the `cart_items` row with display joins for the checkout
/// summary (DATA-01). Purpose-shaped duplicate of the cart feature's DTO —
/// features never import each other (ARCH-04).
@JsonSerializable(fieldRename: FieldRename.snake)
class CheckoutItemDto {
  const CheckoutItemDto({
    required this.id,
    required this.quantity,
    this.productVariants,
  });

  factory CheckoutItemDto.fromJson(Map<String, dynamic> json) =>
      _$CheckoutItemDtoFromJson(json);

  final String id;
  final int quantity;

  @JsonKey(name: 'product_variants')
  final CheckoutVariantJoinDto? productVariants;

  Map<String, dynamic> toJson() => _$CheckoutItemDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CheckoutVariantJoinDto {
  const CheckoutVariantJoinDto({this.name, this.priceMinor, this.products});

  factory CheckoutVariantJoinDto.fromJson(Map<String, dynamic> json) =>
      _$CheckoutVariantJoinDtoFromJson(json);

  final String? name;

  final int? priceMinor;

  @JsonKey(name: 'products')
  final CheckoutProductJoinDto? products;

  Map<String, dynamic> toJson() => _$CheckoutVariantJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CheckoutProductJoinDto {
  const CheckoutProductJoinDto({
    this.name,
    this.basePriceMinor,
  });

  factory CheckoutProductJoinDto.fromJson(Map<String, dynamic> json) =>
      _$CheckoutProductJoinDtoFromJson(json);

  final String? name;
  final int? basePriceMinor;

  Map<String, dynamic> toJson() => _$CheckoutProductJoinDtoToJson(this);
}

/// Wire shape of the `platform_settings` singleton (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class PlatformSettingsDto {
  const PlatformSettingsDto({this.deliveryFeeMinor});

  factory PlatformSettingsDto.fromJson(Map<String, dynamic> json) =>
      _$PlatformSettingsDtoFromJson(json);

  final int? deliveryFeeMinor;

  Map<String, dynamic> toJson() => _$PlatformSettingsDtoToJson(this);
}
