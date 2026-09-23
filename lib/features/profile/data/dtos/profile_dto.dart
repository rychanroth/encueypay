import 'package:json_annotation/json_annotation.dart';

part 'profile_dto.g.dart';

/// Wire shape of the profile feature's subset of the `users` table row
/// (DATA-01). Slim, purpose-shaped duplicate of the auth feature's DTO —
/// features never import each other (ARCH-04).
@JsonSerializable(fieldRename: FieldRename.snake)
class ProfileDto {
  const ProfileDto({
    required this.id,
    this.fullName,
    this.phone,
    this.avatarUrl,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  final String id;
  final String? fullName;
  final String? phone;
  final String? avatarUrl;

  Map<String, dynamic> toJson() => _$ProfileDtoToJson(this);
}
