import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/stream_result.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/notification_item.dart';
import '../dtos/notification_dto.dart';
import '../mappers/notification_mapper.dart';
import 'notifications_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final notificationsRepositoryProvider = Provider<INotificationsRepository>((ref) {
  return NotificationsRepositoryImpl(ref.watch(supabaseClientProvider));
});

class NotificationsRepositoryImpl implements INotificationsRepository {
  NotificationsRepositoryImpl(this._client);

  final SupabaseClient _client;

  String get _uid {
    final user = _client.auth.currentUser;
    if (user == null) throw const ServerFailure('Not authenticated');
    return user.id;
  }

  @override
  Stream<StreamResult<List<NotificationItem>>> watchMyNotifications() {
    return _client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('recipient_id', _uid)
        .order('created_at')
        .map((rows) => rows
            .map(NotificationDto.fromJson)
            .map((dto) => dto.toDomain())
            .toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt)))
        .asStreamResult(_mapError);
  }

  @override
  Future<void> markRead(String notificationId) async {
    try {
      await _client.rpc('mark_notification_read',
          params: {'p_notification_id': notificationId});
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> markAllRead() async {
    try {
      await _client.rpc('mark_all_notifications_read');
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  Failure _mapError(Object error) {
    if (error is PostgrestException) return ServerFailure(error.message);
    return const NetworkFailure();
  }
}
