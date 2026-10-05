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
    this.returnRequests = const [],
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

  @JsonKey(name: 'return_requests', defaultValue: [])
  final List<ReturnRequestJoinDto> returnRequests;

  @JsonKey(name: 'payments')
  final PaymentJoinDto? payments;

  Map<String, dynamic> toJson() => _$OrderDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderItemJoinDto {
  const OrderItemJoinDto({
    required this.id,
    required this.productName,
    required this.unitPriceMinor,
    required this.quantity,
    required this.lineTotalMinor,
    this.variantName,
    this.businessName,
    this.discountMinor,
  });

  factory OrderItemJoinDto.fromJson(Map<String, dynamic> json) =>
      _$OrderItemJoinDtoFromJson(json);

  final String id;
  final String productName;
  final String? variantName;
  final int unitPriceMinor;
  final int? discountMinor;
  final int quantity;
  final int lineTotalMinor;
  final String? businessName;

  Map<String, dynamic> toJson() => _$OrderItemJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ReturnRequestJoinDto {
  const ReturnRequestJoinDto({
    required this.id,
    this.status,
    this.reason,
  });

  factory ReturnRequestJoinDto.fromJson(Map<String, dynamic> json) =>
      _$ReturnRequestJoinDtoFromJson(json);

  final String id;
  final String? status;
  final String? reason;

  Map<String, dynamic> toJson() => _$ReturnRequestJoinDtoToJson(this);
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
