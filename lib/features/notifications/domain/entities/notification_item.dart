import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_item.freezed.dart';

/// A persistent application notification (spec §30). This record layer is
/// the in-app source of truth; FCM is the delivery channel on top of it.
///
/// [type] mirrors the `notifications.type` wire value; [orderId] links an
/// order event to its detail screen (null for legacy rows / non-order types).
@freezed
abstract class NotificationItem with _$NotificationItem {
  const factory NotificationItem({
    required String id,
    required String title,
    @Default('') String content,
    required bool read,
    required DateTime createdAt,
    @Default('system') String type,
    String? orderId,
  }) = _NotificationItem;
}
