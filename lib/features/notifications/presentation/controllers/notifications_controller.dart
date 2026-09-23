import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/stream_result.dart';
import '../../data/repository/notifications_repository_impl.dart';
import '../states/notifications_state.dart';

part 'notifications_controller.g.dart';

/// Realtime notification inbox (§31: notifications area). The stream IS the
/// ground truth — no manual refresh needed.
@riverpod
class NotificationsController extends _$NotificationsController {
  @override
  Stream<NotificationsState> build() {
    final repository = ref.watch(notificationsRepositoryProvider);
    return repository.watchMyNotifications().map((result) {
      return switch (result) {
        StreamData(:final data) => NotificationsState(items: data),
        StreamError(:final failure) =>
          NotificationsState(error: failure.message),
      };
    });
  }

  Future<void> markRead(String notificationId) async {
    await ref.read(notificationsRepositoryProvider).markRead(notificationId);
  }

  Future<void> markAllRead() async {
    await ref.read(notificationsRepositoryProvider).markAllRead();
  }
}
