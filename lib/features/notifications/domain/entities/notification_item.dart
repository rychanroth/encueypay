import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_item.freezed.dart';

/// A persistent application notification (spec §30). Push (FCM) is
/// deferred; this record layer remains available regardless of push.
@freezed
abstract class NotificationItem with _$NotificationItem {
  const factory NotificationItem({
    required String id,
    required String title,
    @Default('') String content,
    required bool read,
    required DateTime createdAt,
  }) = _NotificationItem;
}
