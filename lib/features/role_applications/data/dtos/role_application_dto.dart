import 'package:json_annotation/json_annotation.dart';

part 'role_application_dto.g.dart';

/// Wire shape of the `role_applications` row for the applicant (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class RoleApplicationDto {
  const RoleApplicationDto({
    required this.id,
    required this.requestedRole,
    required this.createdAt,
    this.status,
    this.decisionReason,
  });

  factory RoleApplicationDto.fromJson(Map<String, dynamic> json) =>
      _$RoleApplicationDtoFromJson(json);

  final String id;
  final String requestedRole;
  final DateTime createdAt;
  final String? status;
  final String? decisionReason;

  Map<String, dynamic> toJson() => _$RoleApplicationDtoToJson(this);
}
