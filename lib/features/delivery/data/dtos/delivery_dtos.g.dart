// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryDto _$DeliveryDtoFromJson(Map<String, dynamic> json) => DeliveryDto(
  id: json['id'] as String,
  orderId: json['order_id'] as String,
  deliveryFeeMinor: (json['delivery_fee_minor'] as num).toInt(),
  driverEarningMinor: (json['driver_earning_minor'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  status: json['status'] as String?,
  orders: json['orders'] == null
      ? null
      : DeliveryOrderJoinDto.fromJson(json['orders'] as Map<String, dynamic>),
  pickupStops:
      (json['pickup_stops'] as List<dynamic>?)
          ?.map((e) => PickupStopJoinDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$DeliveryDtoToJson(DeliveryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'delivery_fee_minor': instance.deliveryFeeMinor,
      'driver_earning_minor': instance.driverEarningMinor,
      'created_at': instance.createdAt.toIso8601String(),
      'status': instance.status,
      'orders': instance.orders,
      'pickup_stops': instance.pickupStops,
    };

DeliveryOrderJoinDto _$DeliveryOrderJoinDtoFromJson(
  Map<String, dynamic> json,
) => DeliveryOrderJoinDto(
  shippingLine1: json['shipping_line1'] as String?,
  shippingCity: json['shipping_city'] as String?,
  users: json['users'] == null
      ? null
      : DeliveryCustomerJoinDto.fromJson(json['users'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DeliveryOrderJoinDtoToJson(
  DeliveryOrderJoinDto instance,
) => <String, dynamic>{
  'shipping_line1': instance.shippingLine1,
  'shipping_city': instance.shippingCity,
  'users': instance.users,
};

DeliveryCustomerJoinDto _$DeliveryCustomerJoinDtoFromJson(
  Map<String, dynamic> json,
) => DeliveryCustomerJoinDto(fullName: json['full_name'] as String?);

Map<String, dynamic> _$DeliveryCustomerJoinDtoToJson(
  DeliveryCustomerJoinDto instance,
) => <String, dynamic>{'full_name': instance.fullName};

PickupStopJoinDto _$PickupStopJoinDtoFromJson(Map<String, dynamic> json) =>
    PickupStopJoinDto(
      id: json['id'] as String,
      sequence: (json['sequence'] as num).toInt(),
      status: json['status'] as String?,
      businessOrders: json['business_orders'] == null
          ? null
          : StopBusinessOrderJoinDto.fromJson(
              json['business_orders'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$PickupStopJoinDtoToJson(PickupStopJoinDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sequence': instance.sequence,
      'status': instance.status,
      'business_orders': instance.businessOrders,
    };

StopBusinessOrderJoinDto _$StopBusinessOrderJoinDtoFromJson(
  Map<String, dynamic> json,
) => StopBusinessOrderJoinDto(
  businesses: json['businesses'] == null
      ? null
      : StopBusinessJoinDto.fromJson(
          json['businesses'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$StopBusinessOrderJoinDtoToJson(
  StopBusinessOrderJoinDto instance,
) => <String, dynamic>{'businesses': instance.businesses};

StopBusinessJoinDto _$StopBusinessJoinDtoFromJson(Map<String, dynamic> json) =>
    StopBusinessJoinDto(name: json['name'] as String?);

Map<String, dynamic> _$StopBusinessJoinDtoToJson(
  StopBusinessJoinDto instance,
) => <String, dynamic>{'name': instance.name};
