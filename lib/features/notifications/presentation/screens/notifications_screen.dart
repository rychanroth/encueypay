import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/notifications_controller.dart';

/// Notification center (spec §30/§31): persistent records over a realtime
/// stream. FCM push is a deferred decision; this layer stands alone.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          notificationsAsync.maybeWhen(
            data: (state) => state.items.isEmpty
                ? const SizedBox.shrink()
                : TextButton(
                    onPressed: () => ref
                        .read(notificationsControllerProvider.notifier)
                        .markAllRead(),
                    child: const Text('Mark all read'),
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (state) {
          // Stream errors arrive as StreamError *data* events (DATA-06) —
          // the controller keeps items empty for them. Never show the empty
          // state for a failure; surface it with a retry instead.
          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.error!, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  FilledButton.tonal(
                    onPressed: () => ref
                        .invalidate(notificationsControllerProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state.items.isEmpty) {
            return const Center(child: Text('No notifications yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final notification = state.items[index];
              return Card(
                color: notification.read
                    ? null
                    : theme.colorScheme.primaryContainer,
                child: ListTile(
                  leading: Icon(
                    notification.read
                        ? Icons.notifications_none
                        : Icons.notifications_active,
                  ),
                  title: Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight:
                          notification.read ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${notification.content.isEmpty ? '—' : notification.content}\n'
                    '${notification.createdAt.toLocal().toString().substring(0, 16)}',
                  ),
                  isThreeLine: true,
                  onTap: notification.read
                      ? null
                      : () => ref
                          .read(notificationsControllerProvider.notifier)
                          .markRead(notification.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
