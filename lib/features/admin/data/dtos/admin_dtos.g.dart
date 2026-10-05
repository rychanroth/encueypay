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
  driverCommissionPercent: (json['driver_commission_percent'] as num).toInt(),
  paymentAccount: json['payment_account'] as String,
  qrAccountId: json['qr_account_id'] as String? ?? '',
);

Map<String, dynamic> _$PlatformSettingsAdminDtoToJson(
  PlatformSettingsAdminDto instance,
) => <String, dynamic>{
  'delivery_fee_minor': instance.deliveryFeeMinor,
  'platform_commission_percent': instance.platformCommissionPercent,
  'driver_commission_percent': instance.driverCommissionPercent,
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
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$AdminCategoryDtoToJson(AdminCategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'parent_id': instance.parentId,
      'image_url': instance.imageUrl,
    };

AdminBrandDto _$AdminBrandDtoFromJson(Map<String, dynamic> json) =>
    AdminBrandDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$AdminBrandDtoToJson(AdminBrandDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image_url': instance.imageUrl,
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

AdminBusinessRefDto _$AdminBusinessRefDtoFromJson(Map<String, dynamic> json) =>
    AdminBusinessRefDto(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$AdminBusinessRefDtoToJson(
  AdminBusinessRefDto instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

AdminOrderRowDto _$AdminOrderRowDtoFromJson(
  Map<String, dynamic> json,
) => AdminOrderRowDto(
  id: json['id'] as String,
  subtotalMinor: (json['subtotal_minor'] as num).toInt(),
  discountMinor: (json['discount_minor'] as num).toInt(),
  deliveryFeeMinor: (json['delivery_fee_minor'] as num).toInt(),
  totalMinor: (json['total_minor'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  users: json['users'] == null
      ? null
      : AdminApplicantJoinDto.fromJson(json['users'] as Map<String, dynamic>),
  payments:
      (json['payments'] as List<dynamic>?)
          ?.map((e) => AdminPaymentJoinDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  deliveries:
      (json['deliveries'] as List<dynamic>?)
          ?.map((e) => AdminDeliveryJoinDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  businessOrders:
      (json['business_orders'] as List<dynamic>?)
          ?.map(
            (e) =>
                AdminBusinessOrderJoinDto.fromJson(e as Map<String, dynamic>),
          )
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
      'users': instance.users,
      'payments': instance.payments,
      'deliveries': instance.deliveries,
      'business_orders': instance.businessOrders,
      'return_requests': instance.returnRequests,
    };

AdminDeliveryJoinDto _$AdminDeliveryJoinDtoFromJson(
  Map<String, dynamic> json,
) => AdminDeliveryJoinDto(status: json['status'] as String?);

Map<String, dynamic> _$AdminDeliveryJoinDtoToJson(
  AdminDeliveryJoinDto instance,
) => <String, dynamic>{'status': instance.status};

AdminPaymentJoinDto _$AdminPaymentJoinDtoFromJson(Map<String, dynamic> json) =>
    AdminPaymentJoinDto(
      method: json['method'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$AdminPaymentJoinDtoToJson(
  AdminPaymentJoinDto instance,
) => <String, dynamic>{'method': instance.method, 'status': instance.status};

AdminBusinessOrderJoinDto _$AdminBusinessOrderJoinDtoFromJson(
  Map<String, dynamic> json,
) => AdminBusinessOrderJoinDto(
  id: json['id'] as String,
  subtotalMinor: (json['subtotal_minor'] as num).toInt(),
  discountMinor: (json['discount_minor'] as num).toInt(),
  status: json['status'] as String?,
  rejectionReason: json['rejection_reason'] as String?,
  businesses: json['businesses'] == null
      ? null
      : AdminNamedJoinDto.fromJson(json['businesses'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AdminBusinessOrderJoinDtoToJson(
  AdminBusinessOrderJoinDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'subtotal_minor': instance.subtotalMinor,
  'discount_minor': instance.discountMinor,
  'status': instance.status,
  'rejection_reason': instance.rejectionReason,
  'businesses': instance.businesses,
};

AdminReturnJoinDto _$AdminReturnJoinDtoFromJson(Map<String, dynamic> json) =>
    AdminReturnJoinDto(
      id: json['id'] as String,
      status: json['status'] as String?,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$AdminReturnJoinDtoToJson(AdminReturnJoinDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'reason': instance.reason,
    };
