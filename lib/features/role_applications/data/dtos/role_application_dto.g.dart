// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_application_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleApplicationDto _$RoleApplicationDtoFromJson(Map<String, dynamic> json) =>
    RoleApplicationDto(
      id: json['id'] as String,
      requestedRole: json['requested_role'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: json['status'] as String?,
      decisionReason: json['decision_reason'] as String?,
    );

Map<String, dynamic> _$RoleApplicationDtoToJson(RoleApplicationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requested_role': instance.requestedRole,
      'created_at': instance.createdAt.toIso8601String(),
      'status': instance.status,
      'decision_reason': instance.decisionReason,
    };
