// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditLogDto _$AuditLogDtoFromJson(Map<String, dynamic> json) => AuditLogDto(
  id: json['id'] as String,
  action: json['action'] as String,
  targetType: json['target_type'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  actor: json['actor'] as String?,
  targetId: json['target_id'] as String?,
);

Map<String, dynamic> _$AuditLogDtoToJson(AuditLogDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'actor': instance.actor,
      'action': instance.action,
      'target_type': instance.targetType,
      'target_id': instance.targetId,
      'created_at': instance.createdAt.toIso8601String(),
    };

PlatformSettingsAdminDto _$PlatformSettingsAdminDtoFromJson(
  Map<String, dynamic> json,
) => PlatformSettingsAdminDto(
  deliveryFeeMinor: (json['delivery_fee_minor'] as num).toInt(),
  platformCommissionPercent: (json['platform_commission_percent'] as num)
      .toInt(),
  paymentAccount: json['payment_account'] as String,
  qrAccountId: json['qr_account_id'] as String? ?? '',
);

Map<String, dynamic> _$PlatformSettingsAdminDtoToJson(
  PlatformSettingsAdminDto instance,
) => <String, dynamic>{
  'delivery_fee_minor': instance.deliveryFeeMinor,
  'platform_commission_percent': instance.platformCommissionPercent,
  'payment_account': instance.paymentAccount,
  'qr_account_id': instance.qrAccountId,
};

AdminApplicantJoinDto _$AdminApplicantJoinDtoFromJson(
  Map<String, dynamic> json,
) => AdminApplicantJoinDto(fullName: json['full_name'] as String?);

Map<String, dynamic> _$AdminApplicantJoinDtoToJson(
  AdminApplicantJoinDto instance,
) => <String, dynamic>{'full_name': instance.fullName};

AdminCategoryDto _$AdminCategoryDtoFromJson(Map<String, dynamic> json) =>
    AdminCategoryDto(
      id: json['id'] as String,
      name: json['name'] as String,
      parentId: json['parent_id'] as String?,
      imagePath: json['image_path'] as String?,
    );

Map<String, dynamic> _$AdminCategoryDtoToJson(AdminCategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'parent_id': instance.parentId,
      'image_path': instance.imagePath,
    };

AdminBrandDto _$AdminBrandDtoFromJson(Map<String, dynamic> json) =>
    AdminBrandDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imagePath: json['image_path'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$AdminBrandDtoToJson(AdminBrandDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image_path': instance.imagePath,
      'status': instance.status,
    };

AdminNamedJoinDto _$AdminNamedJoinDtoFromJson(Map<String, dynamic> json) =>
    AdminNamedJoinDto(name: json['name'] as String?);

Map<String, dynamic> _$AdminNamedJoinDtoToJson(AdminNamedJoinDto instance) =>
    <String, dynamic>{'name': instance.name};

AdminProductRowDto _$AdminProductRowDtoFromJson(
  Map<String, dynamic> json,
) => AdminProductRowDto(
  id: json['id'] as String,
  name: json['name'] as String,
  categoryId: json['category_id'] as String,
  businessId: json['business_id'] as String,
  basePriceMinor: (json['base_price_minor'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  description: json['description'] as String?,
  brandId: json['brand_id'] as String?,
  status: json['status'] as String?,
  stock: (json['stock'] as num?)?.toInt() ?? 0,
  brands: json['brands'] == null
      ? null
      : AdminNamedJoinDto.fromJson(json['brands'] as Map<String, dynamic>),
  categories: json['categories'] == null
      ? null
      : AdminNamedJoinDto.fromJson(json['categories'] as Map<String, dynamic>),
  businesses: json['businesses'] == null
      ? null
      : AdminNamedJoinDto.fromJson(json['businesses'] as Map<String, dynamic>),
  productVariants:
      (json['product_variants'] as List<dynamic>?)
          ?.map(
            (e) => AdminVariantIdJoinDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  productImages:
      (json['product_images'] as List<dynamic>?)
          ?.map(
            (e) => AdminProductImagePathDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$AdminProductRowDtoToJson(AdminProductRowDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category_id': instance.categoryId,
      'business_id': instance.businessId,
      'base_price_minor': instance.basePriceMinor,
      'created_at': instance.createdAt.toIso8601String(),
      'description': instance.description,
      'brand_id': instance.brandId,
      'status': instance.status,
      'stock': instance.stock,
      'brands': instance.brands,
      'categories': instance.categories,
      'businesses': instance.businesses,
      'product_variants': instance.productVariants,
      'product_images': instance.productImages,
    };

AdminVariantIdJoinDto _$AdminVariantIdJoinDtoFromJson(
  Map<String, dynamic> json,
) => AdminVariantIdJoinDto(id: json['id'] as String?);

Map<String, dynamic> _$AdminVariantIdJoinDtoToJson(
  AdminVariantIdJoinDto instance,
) => <String, dynamic>{'id': instance.id};

AdminProductImagePathDto _$AdminProductImagePathDtoFromJson(
  Map<String, dynamic> json,
) => AdminProductImagePathDto(
  id: json['id'] as String,
  storagePath: json['storage_path'] as String,
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AdminProductImagePathDtoToJson(
  AdminProductImagePathDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'storage_path': instance.storagePath,
  'sort_order': instance.sortOrder,
};

AdminOrderRowDto _$AdminOrderRowDtoFromJson(
  Map<String, dynamic> json,
) => AdminOrderRowDto(
  id: json['id'] as String,
  subtotalMinor: (json['subtotal_minor'] as num).toInt(),
  discountMinor: (json['discount_minor'] as num).toInt(),
  deliveryFeeMinor: (json['delivery_fee_minor'] as num).toInt(),
  totalMinor: (json['total_minor'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  status: json['status'] as String,
  cancellationReason: json['cancellation_reason'] as String? ?? '',
  users: json['users'] == null
      ? null
      : AdminApplicantJoinDto.fromJson(json['users'] as Map<String, dynamic>),
  payments:
      (json['payments'] as List<dynamic>?)
          ?.map((e) => AdminPaymentJoinDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  items:
      (json['order_items'] as List<dynamic>?)
          ?.map((e) => AdminItemJoinDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  returnRequests:
      (json['return_requests'] as List<dynamic>?)
          ?.map((e) => AdminReturnJoinDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$AdminOrderRowDtoToJson(AdminOrderRowDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subtotal_minor': instance.subtotalMinor,
      'discount_minor': instance.discountMinor,
      'delivery_fee_minor': instance.deliveryFeeMinor,
      'total_minor': instance.totalMinor,
      'created_at': instance.createdAt.toIso8601String(),
      'status': instance.status,
      'cancellation_reason': instance.cancellationReason,
      'users': instance.users,
      'payments': instance.payments,
      'order_items': instance.items,
      'return_requests': instance.returnRequests,
    };

AdminPaymentJoinDto _$AdminPaymentJoinDtoFromJson(Map<String, dynamic> json) =>
    AdminPaymentJoinDto(
      method: json['method'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$AdminPaymentJoinDtoToJson(
  AdminPaymentJoinDto instance,
) => <String, dynamic>{'method': instance.method, 'status': instance.status};

AdminItemJoinDto _$AdminItemJoinDtoFromJson(Map<String, dynamic> json) =>
    AdminItemJoinDto(
      productName: json['product_name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      lineTotalMinor: (json['line_total_minor'] as num).toInt(),
      variantName: json['variant_name'] as String?,
      businessName: json['business_name'] as String?,
    );

Map<String, dynamic> _$AdminItemJoinDtoToJson(AdminItemJoinDto instance) =>
    <String, dynamic>{
      'product_name': instance.productName,
      'quantity': instance.quantity,
      'line_total_minor': instance.lineTotalMinor,
      'variant_name': instance.variantName,
      'business_name': instance.businessName,
    };

AdminReturnJoinDto _$AdminReturnJoinDtoFromJson(Map<String, dynamic> json) =>
    AdminReturnJoinDto(
      id: json['id'] as String,
      status: json['status'] as String?,
      returnItems:
          (json['return_items'] as List<dynamic>?)
              ?.map(
                (e) =>
                    AdminReturnItemJoinDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$AdminReturnJoinDtoToJson(AdminReturnJoinDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'return_items': instance.returnItems,
    };

AdminReturnItemJoinDto _$AdminReturnItemJoinDtoFromJson(
  Map<String, dynamic> json,
) => AdminReturnItemJoinDto(
  quantity: (json['quantity'] as num?)?.toInt() ?? 0,
  reason: json['reason'] as String? ?? '',
);

Map<String, dynamic> _$AdminReturnItemJoinDtoToJson(
  AdminReturnItemJoinDto instance,
) => <String, dynamic>{
  'quantity': instance.quantity,
  'reason': instance.reason,
};
