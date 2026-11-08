import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/presentation/illustrations.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/async_value_widget.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/notification_item.dart';
import '../controllers/notifications_controller.dart';

/// Notification center (spec §30/§31): persistent records over a realtime
/// stream. Order notifications expose the linked order and open its detail
/// screen; legacy rows (no `order_id`) simply mark read.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  Future<void> _open(
    BuildContext context,
    WidgetRef ref,
    NotificationItem item,
  ) async {
    if (!item.read) {
      try {
        await ref
            .read(notificationsControllerProvider.notifier)
            .markRead(item.id);
      } catch (_) {
        // Navigation still works; the realtime stream retries the badge.
      }
    }
    if (!context.mounted) return;
    final orderId = item.orderId;
    if (orderId != null && orderId.isNotEmpty) {
      context.pushNamed(
        AppRoutes.orderDetail,
        pathParameters: {'id': orderId},
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsControllerProvider);
    final unread = notificationsAsync.value?.unreadCount ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: () => ref
                  .read(notificationsControllerProvider.notifier)
                  .markAllRead(),
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AsyncErrorView(
          message: userMessageFor(error),
          retry: () => ref.invalidate(notificationsControllerProvider),
        ),
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
            return const EmptyStateView(
              illustration: AppIllustrations.noNotifications,
              title: 'No notifications yet',
              description:
                  'Order updates and payment alerts will appear here.',
            );
          }

          final groups = _group(state.items, DateTime.now());
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              for (final group in groups) ...[
                _DateHeader(label: group.label),
                for (final item in group.items)
                  _NotificationCard(
                    item: item,
                    onTap: () => _open(context, ref, item),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _DateGroup {
  const _DateGroup(this.label, this.items);

  final String label;
  final List<NotificationItem> items;
}

/// Buckets newest-first items into Today / Yesterday / Earlier.
List<_DateGroup> _group(List<NotificationItem> items, DateTime now) {
  final today = <NotificationItem>[];
  final yesterday = <NotificationItem>[];
  final earlier = <NotificationItem>[];
  final todayStart = DateTime(now.year, now.month, now.day);

  for (final item in items) {
    final local = item.createdAt.toLocal();
    final days = todayStart
        .difference(DateTime(local.year, local.month, local.day))
        .inDays;
    if (days <= 0) {
      today.add(item);
    } else if (days == 1) {
      yesterday.add(item);
    } else {
      earlier.add(item);
    }
  }

  return [
    if (today.isNotEmpty) _DateGroup('Today', today),
    if (yesterday.isNotEmpty) _DateGroup('Yesterday', yesterday),
    if (earlier.isNotEmpty) _DateGroup('Earlier', earlier),
  ];
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.xs,
        AppSpacing.sm,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item, required this.onTap});

  final NotificationItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasOrder = item.orderId != null && item.orderId!.isNotEmpty;
    final canTap = hasOrder || !item.read;
    final accent = theme.colorScheme.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      clipBehavior: Clip.antiAlias,
      color: item.read
          ? null
          : theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
      child: InkWell(
        onTap: canTap ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.read
                      ? theme.colorScheme.surfaceContainerHighest
                      : accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _iconFor(item.type),
                  size: 20,
                  color: item.read
                      ? theme.colorScheme.onSurfaceVariant
                      : accent,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: item.read
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          _timeLabel(item.createdAt),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (!item.read) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (item.content.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (hasOrder) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 14,
                            color: accent,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              'Order #${_shortId(item.orderId!)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

IconData _iconFor(String type) => switch (type) {
      'order' => Icons.receipt_long_outlined,
      'delivery' => Icons.local_shipping_outlined,
      'return' => Icons.assignment_return_outlined,
      'promotion' => Icons.local_offer_outlined,
      'role' => Icons.verified_user_outlined,
      'system' => Icons.campaign_outlined,
      _ => Icons.notifications_none,
    };

String _shortId(String id) =>
    id.length > 8 ? id.substring(0, 8).toUpperCase() : id.toUpperCase();

String _timeLabel(DateTime value) {
  final local = value.toLocal();
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
