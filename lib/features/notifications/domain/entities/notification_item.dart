/// A persistent application notification (spec §30). Push (FCM) is
/// deferred; this record layer remains available regardless of push.
class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.content,
    required this.read,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String content;
  final bool read;
  final DateTime createdAt;
}
