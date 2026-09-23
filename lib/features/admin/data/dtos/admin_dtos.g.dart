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
    );

Map<String, dynamic> _$AdminCategoryDtoToJson(AdminCategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'parent_id': instance.parentId,
    };
