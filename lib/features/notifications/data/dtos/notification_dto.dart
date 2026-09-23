import 'package:json_annotation/json_annotation.dart';

part 'notification_dto.g.dart';

/// Wire shape of the `notifications` row (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationDto {
  const NotificationDto({
    required this.id,
    required this.title,
    required this.content,
    required this.read,
    required this.createdAt,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);

  final String id;
  final String title;
  final String content;
  final bool read;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => _$NotificationDtoToJson(this);
}
