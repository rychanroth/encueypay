import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/async_value_widget.dart';
import '../../../../core/presentation/widgets/status_badge.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/order.dart';
import '../controllers/orders_controller.dart';
import '../states/order_history_state.dart';

/// Customer tab 4 — Order History (DESIGN.md §5.1.4): status-group filter
/// tabs, date-range picker, and order cards with the §2.2 status badge,
/// dual-currency totals and per-card actions (Track Order / Leave Review /
/// Request Return). Server-paginated — Section 7B.
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  Future<void> _pickDateRange(BuildContext context, WidgetRef ref) async {
    final current = ref.read(ordersControllerProvider).value;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      initialDateRange: current?.fromDate != null && current?.toDate != null
          ? DateTimeRange(start: current!.fromDate!, end: current.toDate!)
          : null,
    );
    if (picked != null) {
      await ref.read(ordersControllerProvider.notifier).setFilters(
            fromDate: picked.start,
            toDate: picked.end,
          );
    }
  }

  static String _day(DateTime value) =>
      value.toLocal().toString().substring(0, 10);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(ordersControllerProvider);
    final controller = ref.read(ordersControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$error', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(ordersControllerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (historyState) {
          final orders = historyState.items;
          return Column(
            children: [
              // Section 7B filters: the assignment's filtered views + date
              // range, applied server-side.
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    for (final group in OrderHistoryGroup.values)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(switch (group) {
                            OrderHistoryGroup.all => 'All',
                            OrderHistoryGroup.active => 'Active',
                            OrderHistoryGroup.completed => 'Completed',
                            OrderHistoryGroup.cancelled => 'Cancelled',
                            OrderHistoryGroup.returned => 'Returned',
                          }),
                          selected: historyState.group == group,
                          onSelected: (_) =>
                              controller.setFilters(group: group),
                        ),
                      ),
                    const SizedBox(width: 8),
                    ActionChip(
                      avatar: Icon(
                        Icons.date_range,
                        size: 18,
                        color: historyState.fromDate != null
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      label: Text(
                        historyState.fromDate != null &&
                                historyState.toDate != null
                            ? '${_day(historyState.fromDate!)} – ${_day(historyState.toDate!)}'
                            : 'All time',
                      ),
                      onPressed: () => _pickDateRange(context, ref),
                    ),
                    if (historyState.fromDate != null)
                      IconButton(
                        tooltip: 'Clear date range',
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => controller.clearDateRange(),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: orders.isEmpty
                    ? const EmptyStateView(
                        icon: Icons.receipt_long_outlined,
                        title: 'No orders match',
                        description:
                            'Orders you place will appear here with live '
                            'tracking.',
                      )
                    : NotificationListener<ScrollEndNotification>(
                        onNotification: (notification) {
                          if (notification.metrics.extentAfter < 400) {
                            ref
                                .read(ordersControllerProvider.notifier)
                                .loadMore();
                          }
                          return false;
                        },
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount:
                              orders.length + (historyState.hasMore ? 1 : 0),
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.sm + 2),
                          itemBuilder: (context, index) {
                            if (index >= orders.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                ),
                              );
                            }
                            final order = orders[index];
                            return _OrderCard(order: order);
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Order card (DESIGN.md §5.1.4): header row (id + status badge), date and
/// dual-currency total, and per-status quick actions.
class _OrderCard extends ConsumerWidget {
  const _OrderCard({required this.order});

  final CustomerOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final money = Money(order.totalMinor);
    final statusLabel = switch (order.status) {
      OrderStatus.outForDelivery => 'Out for delivery',
      final status => status.wireName,
    };

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: AppRadii.br16,
        onTap: () => context.pushNamed(
          AppRoutes.orderDetail,
          pathParameters: {'id': order.id},
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Order ${order.id.substring(0, 8)}',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  // §2.2 lifecycle palette, keyed by the wire name.
                  StatusBadge(wireName: order.status.wireName, label: statusLabel),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${order.createdAt.toLocal().toString().substring(0, 16)}'
                '${order.items.isEmpty ? '' : ' · ${order.items.length} item(s)'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    money.formatUsd(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '≈ ${money.formatKhr()}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              // Per-card actions (§5.1.4): Track always; Review/Return on
              // delivered orders.
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => context.pushNamed(
                      AppRoutes.orderDetail,
                      pathParameters: {'id': order.id},
                    ),
                    icon: const Icon(Icons.local_shipping_outlined, size: 16),
                    label: const Text('Track Order'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  if (order.delivered) ...[
                    TextButton.icon(
                      onPressed: () => context.pushNamed(
                        AppRoutes.orderDetail,
                        pathParameters: {'id': order.id},
                      ),
                      icon: const Icon(Icons.rate_review_outlined, size: 16),
                      label: const Text('Leave Review'),
                    ),
                    TextButton.icon(
                      onPressed: () => context.pushNamed(
                        AppRoutes.returnRequest,
                        pathParameters: {'id': order.id},
                      ),
                      icon: const Icon(Icons.assignment_return_outlined,
                          size: 16),
                      label: const Text('Request Return'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
