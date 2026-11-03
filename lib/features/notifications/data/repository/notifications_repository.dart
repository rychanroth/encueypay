import '../../../../core/domain/stream_result.dart';
import '../../domain/entities/notification_item.dart';

/// Notifications contract (spec §30/§58) (DATA-03).
abstract interface class INotificationsRepository {
  /// Realtime stream of the user's notifications — the flagship DATA-06
  /// stream: failures surface as [StreamError] data events and the stream
  /// never terminates.
  Stream<StreamResult<List<NotificationItem>>> watchMyNotifications();

  Future<void> markRead(String notificationId);

  Future<void> markAllRead();

  /// Upserts the FCM token for the signed-in user (register_device_token).
  Future<void> registerDeviceToken({
    required String token,
    required String platform,
  });

  /// Removes this device's token before sign-out (own-row RLS).
  Future<void> unregisterDeviceToken(String token);
}
