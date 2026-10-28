import 'package:json_annotation/json_annotation.dart';

part 'order_dtos.g.dart';

/// Wire shape of the `orders` row with the direct `order_items` and
/// `payments` embeds (Section 7A) (DATA-01). Never leaves the data layer.
@JsonSerializable(fieldRename: FieldRename.snake)
class OrderDto {
  const OrderDto({
    required this.id,
    required this.createdAt,
    required this.subtotalMinor,
    required this.discountMinor,
    required this.deliveryFeeMinor,
    required this.totalMinor,
    required this.shippingRecipientName,
    required this.shippingPhone,
    required this.shippingLine1,
    required this.shippingCity,
    this.status,
    this.shippingLine2,
    this.note,
    this.cancellationReason,
    this.items = const [],
    this.payments,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);

  final String id;
  final DateTime createdAt;
  final int subtotalMinor;
  final int discountMinor;
  final int deliveryFeeMinor;
  final int totalMinor;

  final String shippingRecipientName;
  final String shippingPhone;
  final String shippingLine1;
  final String? shippingLine2;
  final String shippingCity;

  final String? status;
  final String? note;
  final String? cancellationReason;

  @JsonKey(name: 'order_items', defaultValue: [])
  final List<OrderItemJoinDto> items;

  @JsonKey(name: 'payments')
  final PaymentJoinDto? payments;

  Map<String, dynamic> toJson() => _$OrderDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderItemJoinDto {
  const OrderItemJoinDto({
    required this.id,
    required this.productId,
    required this.productName,
    required this.unitPriceMinor,
    required this.quantity,
    required this.lineTotalMinor,
    this.variantName,
    this.discountMinor,
    this.products,
    this.reviews = const [],
  });

  factory OrderItemJoinDto.fromJson(Map<String, dynamic> json) =>
      _$OrderItemJoinDtoFromJson(json);

  final String id;

  /// Live catalog reference — the OrderItemCard taps through to the
  /// product page (product_id is NOT NULL on order_items).
  final String productId;
  final String productName;
  final String? variantName;
  final int unitPriceMinor;
  final int? discountMinor;
  final int quantity;
  final int lineTotalMinor;

  /// Current product imagery for the card's thumbnail (the historical
  /// snapshot carries no image of its own).
  @JsonKey(name: 'products')
  final OrderItemProductJoinDto? products;

  /// The item's review, if any — `reviews_order_item_id_key` enforces one
  /// per order item, so a non-empty list marks the item as reviewed.
  @JsonKey(name: 'reviews', defaultValue: <Map<String, dynamic>>[])
  final List<Map<String, dynamic>> reviews;

  Map<String, dynamic> toJson() => _$OrderItemJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderItemProductJoinDto {
  const OrderItemProductJoinDto({this.productImages = const []});

  factory OrderItemProductJoinDto.fromJson(Map<String, dynamic> json) =>
      _$OrderItemProductJoinDtoFromJson(json);

  @JsonKey(name: 'product_images', defaultValue: [])
  final List<OrderItemImageJoinDto> productImages;

  Map<String, dynamic> toJson() => _$OrderItemProductJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderItemImageJoinDto {
  const OrderItemImageJoinDto({this.storagePath, this.sortOrder = 0});

  factory OrderItemImageJoinDto.fromJson(Map<String, dynamic> json) =>
      _$OrderItemImageJoinDtoFromJson(json);

  final String? storagePath;

  @JsonKey(defaultValue: 0)
  final int sortOrder;

  Map<String, dynamic> toJson() => _$OrderItemImageJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentJoinDto {
  const PaymentJoinDto({
    this.method,
    this.status,
    this.amountMinor,
  });

  factory PaymentJoinDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentJoinDtoFromJson(json);

  final String? method;
  final String? status;
  final int? amountMinor;

  Map<String, dynamic> toJson() => _$PaymentJoinDtoToJson(this);
}
