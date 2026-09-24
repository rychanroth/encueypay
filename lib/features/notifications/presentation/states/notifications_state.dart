import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notification_item.dart';

part 'notifications_state.freezed.dart';

/// Immutable notifications state (PRES-02): items + last stream error.
@freezed
abstract class NotificationsState with _$NotificationsState {
  const factory NotificationsState({
    @Default([]) List<NotificationItem> items,
    String? error,
  }) = _NotificationsState;

  const NotificationsState._();

  int get unreadCount => items.where((item) => !item.read).length;
}
