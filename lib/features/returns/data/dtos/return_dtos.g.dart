// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReturnRequestDto _$ReturnRequestDtoFromJson(Map<String, dynamic> json) =>
    ReturnRequestDto(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: json['status'] as String?,
      returnItems:
          (json['return_items'] as List<dynamic>?)
              ?.map(
                (e) => ReturnItemJoinDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$ReturnRequestDtoToJson(ReturnRequestDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'created_at': instance.createdAt.toIso8601String(),
      'status': instance.status,
      'return_items': instance.returnItems,
    };

ReturnItemJoinDto _$ReturnItemJoinDtoFromJson(Map<String, dynamic> json) =>
    ReturnItemJoinDto(
      id: json['id'] as String,
      orderItemId: json['order_item_id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      reason: json['reason'] as String,
      orderItems: json['order_items'] == null
          ? null
          : ReturnOrderItemJoinDto.fromJson(
              json['order_items'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ReturnItemJoinDtoToJson(ReturnItemJoinDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_item_id': instance.orderItemId,
      'quantity': instance.quantity,
      'reason': instance.reason,
      'order_items': instance.orderItems,
    };

ReturnOrderItemJoinDto _$ReturnOrderItemJoinDtoFromJson(
  Map<String, dynamic> json,
) => ReturnOrderItemJoinDto(
  productName: json['product_name'] as String?,
  variantName: json['variant_name'] as String?,
);

Map<String, dynamic> _$ReturnOrderItemJoinDtoToJson(
  ReturnOrderItemJoinDto instance,
) => <String, dynamic>{
  'product_name': instance.productName,
  'variant_name': instance.variantName,
};

ReturnableItemDto _$ReturnableItemDtoFromJson(Map<String, dynamic> json) =>
    ReturnableItemDto(
      id: json['id'] as String,
      productName: json['product_name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      variantName: json['variant_name'] as String?,
    );

Map<String, dynamic> _$ReturnableItemDtoToJson(ReturnableItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_name': instance.productName,
      'variant_name': instance.variantName,
      'quantity': instance.quantity,
    };
