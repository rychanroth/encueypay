// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
  id: json['id'] as String,
  fullName: json['full_name'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  phone: json['phone'] as String?,
  activeRole: json['active_role'] as String?,
  accountStatus: json['account_status'] as String?,
);

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
  'id': instance.id,
  'full_name': instance.fullName,
  'avatar_url': instance.avatarUrl,
  'phone': instance.phone,
  'active_role': instance.activeRole,
  'account_status': instance.accountStatus,
};
