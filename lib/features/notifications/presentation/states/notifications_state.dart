import '../../domain/entities/notification_item.dart';

/// Immutable notifications state (PRES-02): items + last stream error.
class NotificationsState {
  const NotificationsState({
    this.items = const [],
    this.error,
  });

  final List<NotificationItem> items;
  final String? error;

  int get unreadCount => items.where((item) => !item.read).length;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationsState &&
          other.items.length == items.length &&
          other.unreadCount == unreadCount &&
          other.error == error;

  @override
  int get hashCode => Object.hash(items.length, unreadCount, error);
}
