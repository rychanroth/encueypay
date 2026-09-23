import '../../domain/entities/notification_item.dart';
import '../dtos/notification_dto.dart';

extension NotificationDtoX on NotificationDto {
  NotificationItem toDomain() {
    return NotificationItem(
      id: id,
      title: title,
      content: content,
      read: read,
      createdAt: createdAt,
    );
  }
}
