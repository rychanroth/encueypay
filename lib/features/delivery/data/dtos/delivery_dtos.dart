import 'package:json_annotation/json_annotation.dart';

part 'delivery_dtos.g.dart';

/// Wire shape of the `deliveries` row for the driver feature (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class DeliveryDto {
  const DeliveryDto({
    required this.id,
    required this.orderId,
    required this.deliveryFeeMinor,
    required this.driverEarningMinor,
    required this.createdAt,
    this.status,
    this.orders,
    this.pickupStops = const [],
  });

  factory DeliveryDto.fromJson(Map<String, dynamic> json) =>
      _$DeliveryDtoFromJson(json);

  final String id;
  final String orderId;
  final int deliveryFeeMinor;
  final int driverEarningMinor;
  final DateTime createdAt;
  final String? status;

  @JsonKey(name: 'orders')
  final DeliveryOrderJoinDto? orders;

  @JsonKey(name: 'pickup_stops', defaultValue: [])
  final List<PickupStopJoinDto> pickupStops;

  Map<String, dynamic> toJson() => _$DeliveryDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class DeliveryOrderJoinDto {
  const DeliveryOrderJoinDto({
    this.shippingLine1,
    this.shippingCity,
    this.users,
  });

  factory DeliveryOrderJoinDto.fromJson(Map<String, dynamic> json) =>
      _$DeliveryOrderJoinDtoFromJson(json);

  final String? shippingLine1;
  final String? shippingCity;

  @JsonKey(name: 'users')
  final DeliveryCustomerJoinDto? users;

  Map<String, dynamic> toJson() => _$DeliveryOrderJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class DeliveryCustomerJoinDto {
  const DeliveryCustomerJoinDto({this.fullName});

  factory DeliveryCustomerJoinDto.fromJson(Map<String, dynamic> json) =>
      _$DeliveryCustomerJoinDtoFromJson(json);

  final String? fullName;

  Map<String, dynamic> toJson() => _$DeliveryCustomerJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PickupStopJoinDto {
  const PickupStopJoinDto({
    required this.id,
    required this.sequence,
    this.status,
    this.businessOrders,
  });

  factory PickupStopJoinDto.fromJson(Map<String, dynamic> json) =>
      _$PickupStopJoinDtoFromJson(json);

  final String id;
  final int sequence;
  final String? status;

  @JsonKey(name: 'business_orders')
  final StopBusinessOrderJoinDto? businessOrders;

  Map<String, dynamic> toJson() => _$PickupStopJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class StopBusinessOrderJoinDto {
  const StopBusinessOrderJoinDto({this.businesses});

  factory StopBusinessOrderJoinDto.fromJson(Map<String, dynamic> json) =>
      _$StopBusinessOrderJoinDtoFromJson(json);

  @JsonKey(name: 'businesses')
  final StopBusinessJoinDto? businesses;

  Map<String, dynamic> toJson() => _$StopBusinessOrderJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class StopBusinessJoinDto {
  const StopBusinessJoinDto({this.name});

  factory StopBusinessJoinDto.fromJson(Map<String, dynamic> json) =>
      _$StopBusinessJoinDtoFromJson(json);

  final String? name;

  Map<String, dynamic> toJson() => _$StopBusinessJoinDtoToJson(this);
}
