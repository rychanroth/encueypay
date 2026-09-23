import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

/// Wire shape of the `users` table row (DATA-01). Never leaves the data
/// layer. Enum columns arrive as snake_case text and are parsed in the
/// mapper, not here.
@JsonSerializable(fieldRename: FieldRename.snake)
class UserDto {
  const UserDto({
    required this.id,
    this.fullName,
    this.avatarUrl,
    this.phone,
    this.activeRole,
    this.accountStatus,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  final String id;
  final String? fullName;
  final String? avatarUrl;
  final String? phone;
  final String? activeRole;
  final String? accountStatus;

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
