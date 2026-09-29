// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDto _$OrderDtoFromJson(Map<String, dynamic> json) => OrderDto(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  subtotalMinor: (json['subtotal_minor'] as num).toInt(),
  discountMinor: (json['discount_minor'] as num).toInt(),
  deliveryFeeMinor: (json['delivery_fee_minor'] as num).toInt(),
  totalMinor: (json['total_minor'] as num).toInt(),
  shippingRecipientName: json['shipping_recipient_name'] as String,
  shippingPhone: json['shipping_phone'] as String,
  shippingLine1: json['shipping_line1'] as String,
  shippingCity: json['shipping_city'] as String,
  shippingLine2: json['shipping_line2'] as String?,
  businessOrders:
      (json['business_orders'] as List<dynamic>?)
          ?.map((e) => BusinessOrderJoinDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  payments: json['payments'] == null
      ? null
      : PaymentJoinDto.fromJson(json['payments'] as Map<String, dynamic>),
  deliveries: json['deliveries'] == null
      ? null
      : DeliveryJoinDto.fromJson(json['deliveries'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OrderDtoToJson(OrderDto instance) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt.toIso8601String(),
  'subtotal_minor': instance.subtotalMinor,
  'discount_minor': instance.discountMinor,
  'delivery_fee_minor': instance.deliveryFeeMinor,
  'total_minor': instance.totalMinor,
  'shipping_recipient_name': instance.shippingRecipientName,
  'shipping_phone': instance.shippingPhone,
  'shipping_line1': instance.shippingLine1,
  'shipping_line2': instance.shippingLine2,
  'shipping_city': instance.shippingCity,
  'business_orders': instance.businessOrders,
  'payments': instance.payments,
  'deliveries': instance.deliveries,
};

BusinessOrderJoinDto _$BusinessOrderJoinDtoFromJson(
  Map<String, dynamic> json,
) => BusinessOrderJoinDto(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  status: json['status'] as String?,
  rejectionReason: json['rejection_reason'] as String?,
  businesses: json['businesses'] == null
      ? null
      : BusinessNameJoinDto.fromJson(
          json['businesses'] as Map<String, dynamic>,
        ),
  orderItems:
      (json['order_items'] as List<dynamic>?)
          ?.map((e) => OrderItemJoinDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  pickupStops: json['pickup_stops'] == null
      ? null
      : PickupStopJoinDto.fromJson(
          json['pickup_stops'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$BusinessOrderJoinDtoToJson(
  BusinessOrderJoinDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'status': instance.status,
  'rejection_reason': instance.rejectionReason,
  'businesses': instance.businesses,
  'order_items': instance.orderItems,
  'pickup_stops': instance.pickupStops,
};

BusinessNameJoinDto _$BusinessNameJoinDtoFromJson(Map<String, dynamic> json) =>
    BusinessNameJoinDto(name: json['name'] as String?);

Map<String, dynamic> _$BusinessNameJoinDtoToJson(
  BusinessNameJoinDto instance,
) => <String, dynamic>{'name': instance.name};

OrderItemJoinDto _$OrderItemJoinDtoFromJson(Map<String, dynamic> json) =>
    OrderItemJoinDto(
      id: json['id'] as String,
      productName: json['product_name'] as String,
      unitPriceMinor: (json['unit_price_minor'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      lineTotalMinor: (json['line_total_minor'] as num).toInt(),
      variantName: json['variant_name'] as String?,
      discountMinor: (json['discount_minor'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrderItemJoinDtoToJson(OrderItemJoinDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_name': instance.productName,
      'variant_name': instance.variantName,
      'unit_price_minor': instance.unitPriceMinor,
      'discount_minor': instance.discountMinor,
      'quantity': instance.quantity,
      'line_total_minor': instance.lineTotalMinor,
    };

PickupStopJoinDto _$PickupStopJoinDtoFromJson(Map<String, dynamic> json) =>
    PickupStopJoinDto(
      id: json['id'] as String,
      sequence: (json['sequence'] as num).toInt(),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$PickupStopJoinDtoToJson(PickupStopJoinDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sequence': instance.sequence,
      'status': instance.status,
    };

PaymentJoinDto _$PaymentJoinDtoFromJson(Map<String, dynamic> json) =>
    PaymentJoinDto(
      method: json['method'] as String?,
      status: json['status'] as String?,
      amountMinor: (json['amount_minor'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaymentJoinDtoToJson(PaymentJoinDto instance) =>
    <String, dynamic>{
      'method': instance.method,
      'status': instance.status,
      'amount_minor': instance.amountMinor,
    };

DeliveryJoinDto _$DeliveryJoinDtoFromJson(Map<String, dynamic> json) =>
    DeliveryJoinDto(
      id: json['id'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$DeliveryJoinDtoToJson(DeliveryJoinDto instance) =>
    <String, dynamic>{'id': instance.id, 'status': instance.status};
