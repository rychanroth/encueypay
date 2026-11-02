import 'package:json_annotation/json_annotation.dart';

part 'cart_item_dto.g.dart';

/// Wire shape of one `cart_item_details` row (DATA-01). The view resolves the
/// product/variant joins, thumbnail and server-authoritative sale price, so
/// the DTO is flat and never leaves the data layer.
@JsonSerializable(fieldRename: FieldRename.snake)
class CartItemDto {
  const CartItemDto({
    required this.id,
    required this.quantity,
    required this.variantId,
    required this.productId,
    required this.productName,
    required this.unitPriceMinor,
    required this.saleUnitPriceMinor,
    this.variantName,
    this.stock = 0,
    this.brandId,
    this.categoryId,
    this.imageStoragePath,
  });

  factory CartItemDto.fromJson(Map<String, dynamic> json) =>
      _$CartItemDtoFromJson(json);

  final String id;
  final int quantity;
  final String variantId;
  final String productId;
  final String productName;
  final String? variantName;

  /// Variant price, falling back to the product base price (the historical
  /// "was" price when a sale applies).
  final int unitPriceMinor;

  /// Server-computed `best_sale_price_minor` — always <= [unitPriceMinor].
  final int saleUnitPriceMinor;

  @JsonKey(defaultValue: 0)
  final int stock;

  final String? brandId;
  final String? categoryId;
  final String? imageStoragePath;

  Map<String, dynamic> toJson() => _$CartItemDtoToJson(this);
}
