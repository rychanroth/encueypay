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

/// Wire shape of one `cart_item_details` row for checkout (DATA-01).
/// Purpose-shaped duplicate of the cart feature's DTO — features never
/// import each other (ARCH-04). The view supplies the sale-adjusted price.
@JsonSerializable(fieldRename: FieldRename.snake)
class CheckoutItemDto {
  const CheckoutItemDto({
    required this.id,
    required this.quantity,
    required this.variantId,
    required this.productId,
    required this.productName,
    required this.unitPriceMinor,
    required this.saleUnitPriceMinor,
    this.variantName,
    this.imageStoragePath,
  });

  factory CheckoutItemDto.fromJson(Map<String, dynamic> json) =>
      _$CheckoutItemDtoFromJson(json);

  final String id;
  final int quantity;
  final String variantId;
  final String productId;
  final String productName;
  final String? variantName;

  /// Variant price (or product base) — the "was" price when a sale applies.
  final int unitPriceMinor;

  /// Server-computed `best_sale_price_minor` for this line.
  final int saleUnitPriceMinor;

  final String? imageStoragePath;

  Map<String, dynamic> toJson() => _$CheckoutItemDtoToJson(this);
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
