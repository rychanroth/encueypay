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
);

Map<String, dynamic> _$PlatformSettingsAdminDtoToJson(
  PlatformSettingsAdminDto instance,
) => <String, dynamic>{
  'delivery_fee_minor': instance.deliveryFeeMinor,
  'platform_commission_percent': instance.platformCommissionPercent,
  'driver_commission_percent': instance.driverCommissionPercent,
  'payment_account': instance.paymentAccount,
};

AdminApplicationDto _$AdminApplicationDtoFromJson(Map<String, dynamic> json) =>
    AdminApplicationDto(
      id: json['id'] as String,
      requestedRole: json['requested_role'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: json['status'] as String?,
      users: json['users'] == null
          ? null
          : AdminApplicantJoinDto.fromJson(
              json['users'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$AdminApplicationDtoToJson(
  AdminApplicationDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'requested_role': instance.requestedRole,
  'created_at': instance.createdAt.toIso8601String(),
  'status': instance.status,
  'users': instance.users,
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
