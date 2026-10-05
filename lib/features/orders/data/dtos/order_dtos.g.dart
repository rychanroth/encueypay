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
  status: json['status'] as String?,
  shippingLine2: json['shipping_line2'] as String?,
  note: json['note'] as String?,
  cancellationReason: json['cancellation_reason'] as String?,
  items:
      (json['order_items'] as List<dynamic>?)
          ?.map((e) => OrderItemJoinDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  returnRequests:
      (json['return_requests'] as List<dynamic>?)
          ?.map((e) => ReturnRequestJoinDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  payments: json['payments'] == null
      ? null
      : PaymentJoinDto.fromJson(json['payments'] as Map<String, dynamic>),
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
  'status': instance.status,
  'note': instance.note,
  'cancellation_reason': instance.cancellationReason,
  'order_items': instance.items,
  'return_requests': instance.returnRequests,
  'payments': instance.payments,
};

OrderItemJoinDto _$OrderItemJoinDtoFromJson(Map<String, dynamic> json) =>
    OrderItemJoinDto(
      id: json['id'] as String,
      productName: json['product_name'] as String,
      unitPriceMinor: (json['unit_price_minor'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      lineTotalMinor: (json['line_total_minor'] as num).toInt(),
      variantName: json['variant_name'] as String?,
      businessName: json['business_name'] as String?,
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
      'business_name': instance.businessName,
    };

ReturnRequestJoinDto _$ReturnRequestJoinDtoFromJson(
  Map<String, dynamic> json,
) => ReturnRequestJoinDto(
  id: json['id'] as String,
  status: json['status'] as String?,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$ReturnRequestJoinDtoToJson(
  ReturnRequestJoinDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'reason': instance.reason,
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
