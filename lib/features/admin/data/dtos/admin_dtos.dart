import 'package:json_annotation/json_annotation.dart';

part 'admin_dtos.g.dart';

/// Wire shape of the `audit_logs` row (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class AuditLogDto {
  const AuditLogDto({
    required this.id,
    required this.action,
    required this.targetType,
    required this.createdAt,
    this.actor,
    this.targetId,
  });

  factory AuditLogDto.fromJson(Map<String, dynamic> json) =>
      _$AuditLogDtoFromJson(json);

  final String id;
  final String? actor;
  final String action;
  final String targetType;
  final String? targetId;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => _$AuditLogDtoToJson(this);
}

/// Wire shape of the `platform_settings` singleton (admin view, DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class PlatformSettingsAdminDto {
  const PlatformSettingsAdminDto({
    required this.deliveryFeeMinor,
    required this.platformCommissionPercent,
    required this.driverCommissionPercent,
    required this.paymentAccount,
  });

  factory PlatformSettingsAdminDto.fromJson(Map<String, dynamic> json) =>
      _$PlatformSettingsAdminDtoFromJson(json);

  final int deliveryFeeMinor;
  final int platformCommissionPercent;
  final int driverCommissionPercent;
  final String paymentAccount;

  Map<String, dynamic> toJson() => _$PlatformSettingsAdminDtoToJson(this);
}

/// Wire shape of a `role_applications` row with the applicant join
/// (admin review, DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class AdminApplicationDto {
  const AdminApplicationDto({
    required this.id,
    required this.requestedRole,
    required this.createdAt,
    this.status,
    this.users,
  });

  factory AdminApplicationDto.fromJson(Map<String, dynamic> json) =>
      _$AdminApplicationDtoFromJson(json);

  final String id;
  final String requestedRole;
  final DateTime createdAt;
  final String? status;

  @JsonKey(name: 'users')
  final AdminApplicantJoinDto? users;

  Map<String, dynamic> toJson() => _$AdminApplicationDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AdminApplicantJoinDto {
  const AdminApplicantJoinDto({this.fullName});

  factory AdminApplicantJoinDto.fromJson(Map<String, dynamic> json) =>
      _$AdminApplicantJoinDtoFromJson(json);

  final String? fullName;

  Map<String, dynamic> toJson() => _$AdminApplicantJoinDtoToJson(this);
}

/// Wire shape of the `categories` row for admin management (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class AdminCategoryDto {
  const AdminCategoryDto({
    required this.id,
    required this.name,
    this.parentId,
  });

  factory AdminCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$AdminCategoryDtoFromJson(json);

  final String id;
  final String name;
  final String? parentId;

  Map<String, dynamic> toJson() => _$AdminCategoryDtoToJson(this);
}
