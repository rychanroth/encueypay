// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessProfileDto _$BusinessProfileDtoFromJson(Map<String, dynamic> json) =>
    BusinessProfileDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$BusinessProfileDtoToJson(BusinessProfileDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image_url': instance.imageUrl,
    };

BusinessProductDto _$BusinessProductDtoFromJson(Map<String, dynamic> json) =>
    BusinessProductDto(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      basePriceMinor: (json['base_price_minor'] as num).toInt(),
      stock: (json['stock'] as num).toInt(),
      status: json['status'] as String?,
      productVariants:
          (json['product_variants'] as List<dynamic>?)
              ?.map(
                (e) => ManagementVariantDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$BusinessProductDtoToJson(BusinessProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'name': instance.name,
      'description': instance.description,
      'base_price_minor': instance.basePriceMinor,
      'stock': instance.stock,
      'status': instance.status,
      'product_variants': instance.productVariants,
    };

ManagementVariantDto _$ManagementVariantDtoFromJson(
  Map<String, dynamic> json,
) => ManagementVariantDto(
  id: json['id'] as String,
  name: json['name'] as String,
  stock: (json['stock'] as num).toInt(),
  priceMinor: (json['price_minor'] as num?)?.toInt(),
);

Map<String, dynamic> _$ManagementVariantDtoToJson(
  ManagementVariantDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'price_minor': instance.priceMinor,
  'stock': instance.stock,
};

CategoryOptionDto _$CategoryOptionDtoFromJson(Map<String, dynamic> json) =>
    CategoryOptionDto(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$CategoryOptionDtoToJson(CategoryOptionDto instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

ManagedOrderDto _$ManagedOrderDtoFromJson(
  Map<String, dynamic> json,
) => ManagedOrderDto(
  id: json['id'] as String,
  orderId: json['order_id'] as String,
  subtotalMinor: (json['subtotal_minor'] as num).toInt(),
  discountMinor: (json['discount_minor'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  status: json['status'] as String?,
  rejectionReason: json['rejection_reason'] as String?,
  orderItems:
      (json['order_items'] as List<dynamic>?)
          ?.map((e) => ManagedOrderItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  orders: json['orders'] == null
      ? null
      : ManagedOrderParentDto.fromJson(json['orders'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ManagedOrderDtoToJson(ManagedOrderDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'subtotal_minor': instance.subtotalMinor,
      'discount_minor': instance.discountMinor,
      'created_at': instance.createdAt.toIso8601String(),
      'status': instance.status,
      'rejection_reason': instance.rejectionReason,
      'order_items': instance.orderItems,
      'orders': instance.orders,
    };

ManagedOrderItemDto _$ManagedOrderItemDtoFromJson(Map<String, dynamic> json) =>
    ManagedOrderItemDto(
      id: json['id'] as String,
      productName: json['product_name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      lineTotalMinor: (json['line_total_minor'] as num).toInt(),
      variantName: json['variant_name'] as String?,
    );

Map<String, dynamic> _$ManagedOrderItemDtoToJson(
  ManagedOrderItemDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'product_name': instance.productName,
  'variant_name': instance.variantName,
  'quantity': instance.quantity,
  'line_total_minor': instance.lineTotalMinor,
};

ManagedOrderParentDto _$ManagedOrderParentDtoFromJson(
  Map<String, dynamic> json,
) => ManagedOrderParentDto(
  users: json['users'] == null
      ? null
      : ManagedOrderCustomerDto.fromJson(json['users'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ManagedOrderParentDtoToJson(
  ManagedOrderParentDto instance,
) => <String, dynamic>{'users': instance.users};

ManagedOrderCustomerDto _$ManagedOrderCustomerDtoFromJson(
  Map<String, dynamic> json,
) => ManagedOrderCustomerDto(fullName: json['full_name'] as String?);

Map<String, dynamic> _$ManagedOrderCustomerDtoToJson(
  ManagedOrderCustomerDto instance,
) => <String, dynamic>{'full_name': instance.fullName};
