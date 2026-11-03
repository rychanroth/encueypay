/// A push-open destination parsed from the FCM data payload.
///
/// Both fields are optional: legacy notifications have no order link, and a
/// malformed payload must still open the inbox rather than crash.
class PushOpenTarget {
  const PushOpenTarget({this.orderId, this.notificationId});

  final String? orderId;
  final String? notificationId;

  bool get hasOrder => orderId != null && orderId!.isNotEmpty;
}
