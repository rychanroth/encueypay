import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/order.dart';
import '../controllers/orders_controller.dart';
import '../states/order_history_state.dart';

/// Customer tab 3 — Order History (spec §7 "Order History"; §58
/// GetMyOrders). Server-paginated, sorted by time, with the assignment's
/// filtered views (Active/Completed/Cancelled/Returned) plus a date range —
/// Section 7B.
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  Color _statusColor(BuildContext context, OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Theme.of(context).colorScheme.secondary;
      case OrderStatus.cancelled:
      case OrderStatus.returned:
        return Theme.of(context).colorScheme.error;
      case OrderStatus.delivered:
        return Colors.green;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

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
      appBar: AppBar(title: const Text('Order History')),
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
                    ? const Center(child: Text('No orders match.'))
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
                              const SizedBox(height: 8),
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
                            final status = order.status;
                            return Card(
                              child: ListTile(
                                title: Text(
                                  'Order ${order.id.substring(0, 8)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${order.createdAt.toLocal().toString().substring(0, 16)}'
                                  ' · ${Money(order.totalMinor).format()}',
                                ),
                                trailing: Chip(
                                  label: Text(
                                    status.wireName,
                                    style: TextStyle(
                                      color: _statusColor(context, status),
                                      fontSize: 12,
                                    ),
                                  ),
                                  visualDensity: VisualDensity.compact,
                                ),
                                onTap: () => context.pushNamed(
                                  AppRoutes.orderDetail,
                                  pathParameters: {'id': order.id},
                                ),
                              ),
                            );
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
