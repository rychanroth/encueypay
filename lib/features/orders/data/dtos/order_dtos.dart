import 'package:json_annotation/json_annotation.dart';

part 'order_dtos.g.dart';

/// Wire shape of the `orders` row with nested PostgREST joins
/// (business_orders → businesses/order_items/pickup_stops, payments,
/// deliveries) (DATA-01). Never leaves the data layer.
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
    this.shippingLine2,
    this.businessOrders = const [],
    this.payments,
    this.deliveries,
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

  @JsonKey(name: 'business_orders', defaultValue: [])
  final List<BusinessOrderJoinDto> businessOrders;

  @JsonKey(name: 'payments')
  final PaymentJoinDto? payments;

  @JsonKey(name: 'deliveries')
  final DeliveryJoinDto? deliveries;

  Map<String, dynamic> toJson() => _$OrderDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BusinessOrderJoinDto {
  const BusinessOrderJoinDto({
    required this.id,
    required this.businessId,
    this.status,
    this.rejectionReason,
    this.businesses,
    this.orderItems = const [],
    this.pickupStops = const [],
  });

  factory BusinessOrderJoinDto.fromJson(Map<String, dynamic> json) =>
      _$BusinessOrderJoinDtoFromJson(json);

  final String id;
  final String businessId;
  final String? status;
  final String? rejectionReason;

  @JsonKey(name: 'businesses')
  final BusinessNameJoinDto? businesses;

  @JsonKey(name: 'order_items', defaultValue: [])
  final List<OrderItemJoinDto> orderItems;

  @JsonKey(name: 'pickup_stops', defaultValue: [])
  final List<PickupStopJoinDto> pickupStops;

  Map<String, dynamic> toJson() => _$BusinessOrderJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BusinessNameJoinDto {
  const BusinessNameJoinDto({this.name});

  factory BusinessNameJoinDto.fromJson(Map<String, dynamic> json) =>
      _$BusinessNameJoinDtoFromJson(json);

  final String? name;

  Map<String, dynamic> toJson() => _$BusinessNameJoinDtoToJson(this);
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

  Map<String, dynamic> toJson() => _$OrderItemJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PickupStopJoinDto {
  const PickupStopJoinDto({
    required this.id,
    required this.sequence,
    this.status,
  });

  factory PickupStopJoinDto.fromJson(Map<String, dynamic> json) =>
      _$PickupStopJoinDtoFromJson(json);

  final String id;
  final int sequence;
  final String? status;

  Map<String, dynamic> toJson() => _$PickupStopJoinDtoToJson(this);
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

@JsonSerializable(fieldRename: FieldRename.snake)
class DeliveryJoinDto {
  const DeliveryJoinDto({this.id, this.status});

  factory DeliveryJoinDto.fromJson(Map<String, dynamic> json) =>
      _$DeliveryJoinDtoFromJson(json);

  final String? id;
  final String? status;

  Map<String, dynamic> toJson() => _$DeliveryJoinDtoToJson(this);
}
