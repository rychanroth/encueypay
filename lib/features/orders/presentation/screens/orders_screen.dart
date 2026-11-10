import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/presentation/illustrations.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/async_value_widget.dart';
import '../../../../core/presentation/widgets/status_badge.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/order.dart';
import '../controllers/orders_controller.dart';
import '../states/order_history_state.dart';

/// Customer tab 4 — Order History (DESIGN.md §5.1.4): status-group filter
/// tabs, a date range (presets + custom), search by order id/product, a
/// "to review" view, and order cards with the §2.2 status badge,
/// dual-currency totals and per-card actions. Server-paginated — Section 7B.
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchController.text =
          ref.read(ordersControllerProvider).value?.search ?? '';
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  OrderHistoryState get _current =>
      ref.read(ordersControllerProvider).value ?? const OrderHistoryState();

  Future<void> _apply({
    required OrderHistoryGroup group,
    required DateTime? fromDate,
    required DateTime? toDate,
    required String search,
    required bool toReview,
  }) {
    return ref.read(ordersControllerProvider.notifier).applyFilters(
          group: group,
          fromDate: fromDate,
          toDate: toDate,
          search: search,
          toReview: toReview,
        );
  }

  void _selectGroup(OrderHistoryGroup group) {
    final state = _current;
    _apply(
      group: group,
      fromDate: state.fromDate,
      toDate: state.toDate,
      search: state.search,
      toReview: false,
    );
  }

  void _selectDateRange(DateTime? from, DateTime? to) {
    final state = _current;
    _apply(
      group: state.group,
      fromDate: from,
      toDate: to,
      search: state.search,
      toReview: state.toReview,
    );
  }

  void _toggleToReview(bool value) {
    final state = _current;
    _apply(
      // The server view is delivered-only; clear the status group so the
      // chip doesn't imply a conflicting filter.
      group: value ? OrderHistoryGroup.all : state.group,
      fromDate: state.fromDate,
      toDate: state.toDate,
      search: state.search,
      toReview: value,
    );
  }

  void _setSearch(String value) {
    final state = _current;
    _apply(
      group: state.group,
      fromDate: state.fromDate,
      toDate: state.toDate,
      search: value.trim(),
      toReview: state.toReview,
    );
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(
      const Duration(milliseconds: 350),
      () => _setSearch(value),
    );
  }

  void _clearFilters() {
    _searchController.clear();
    _apply(
      group: OrderHistoryGroup.all,
      fromDate: null,
      toDate: null,
      search: '',
      toReview: false,
    );
  }

  Future<void> _pickCustomRange() async {
    final state = _current;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      initialDateRange: state.fromDate != null && state.toDate != null
          ? DateTimeRange(start: state.fromDate!, end: state.toDate!)
          : null,
    );
    if (picked != null) _selectDateRange(picked.start, picked.end);
  }

  static String _day(DateTime value) =>
      value.toLocal().toString().substring(0, 10);

  static DateTime get _today => DateUtils.dateOnly(DateTime.now());

  bool _isPreset(OrderHistoryState state, DateTime from) =>
      DateUtils.isSameDay(state.fromDate, from) &&
      DateUtils.isSameDay(state.toDate, _today);

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(ordersControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(userMessageFor(error), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(ordersControllerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (state) {
          final theme = Theme.of(context);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  0,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Order ID or product name',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: state.search.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _setSearch('');
                            },
                          ),
                  ),
                ),
              ),
              // Section 7B status groups + the review queue.
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  children: [
                    for (final group in OrderHistoryGroup.values)
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: ChoiceChip(
                          label: Text(switch (group) {
                            OrderHistoryGroup.all => 'All',
                            OrderHistoryGroup.active => 'Active',
                            OrderHistoryGroup.completed => 'Completed',
                            OrderHistoryGroup.cancelled => 'Cancelled',
                          }),
                          selected: !state.toReview && state.group == group,
                          onSelected: (_) => _selectGroup(group),
                        ),
                      ),
                    const SizedBox(width: AppSpacing.sm),
                    Center(
                      child: Container(
                        width: 1,
                        height: 24,
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    FilterChip(
                      avatar: const Icon(Icons.rate_review_outlined, size: 16),
                      label: const Text('To review'),
                      selected: state.toReview,
                      onSelected: _toggleToReview,
                    ),
                  ],
                ),
              ),
              // Date presets + custom range.
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: ChoiceChip(
                        label: const Text('All time'),
                        selected: state.fromDate == null && state.toDate == null,
                        onSelected: (_) => _selectDateRange(null, null),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: ChoiceChip(
                        label: const Text('30 days'),
                        selected: _isPreset(
                          state,
                          _today.subtract(const Duration(days: 29)),
                        ),
                        onSelected: (_) => _selectDateRange(
                          _today.subtract(const Duration(days: 29)),
                          _today,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: ChoiceChip(
                        label: const Text('3 months'),
                        selected: _isPreset(
                          state,
                          DateTime(_today.year, _today.month - 3, _today.day),
                        ),
                        onSelected: (_) => _selectDateRange(
                          DateTime(_today.year, _today.month - 3, _today.day),
                          _today,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: ChoiceChip(
                        label: const Text('This year'),
                        selected: _isPreset(state, DateTime(_today.year)),
                        onSelected: (_) => _selectDateRange(
                          DateTime(_today.year),
                          _today,
                        ),
                      ),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.date_range, size: 18),
                      label: Text(
                        state.fromDate == null || state.toDate == null
                            ? 'Custom…'
                            : '${_day(state.fromDate!)} – '
                                '${_day(state.toDate!)}',
                      ),
                      onPressed: _pickCustomRange,
                    ),
                    if (state.fromDate != null || state.toDate != null)
                      IconButton(
                        tooltip: 'Clear date range',
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => _selectDateRange(null, null),
                      ),
                  ],
                ),
              ),
              Expanded(child: _list(state)),
            ],
          );
        },
      ),
    );
  }

  Widget _list(OrderHistoryState state) {
    final orders = state.items;
    if (orders.isEmpty) {
      // A filter fetch clears the list and keeps hasMore true while the page
      // loads — show progress, not a premature empty state.
      if (state.hasMore) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state.hasActiveFilters) {
        return EmptyStateView(
          illustration: AppIllustrations.noSearch,
          title: 'No orders match',
          description: 'Try another status, date range or search term.',
          actionLabel: 'Clear filters',
          onAction: _clearFilters,
        );
      }
      return EmptyStateView(
        illustration: AppIllustrations.noOrders,
        title: 'No orders yet',
        description: 'Orders you place will appear here with live tracking.',
        actionLabel: 'Browse products',
        onAction: () => context.goNamed(AppRoutes.home),
      );
    }
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < 400) {
          ref.read(ordersControllerProvider.notifier).loadMore();
        }
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: orders.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm + 2),
        itemBuilder: (context, index) {
          if (index >= orders.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }
          return _OrderCard(order: orders[index]);
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
                  // §2.2 lifecycle palette, keyed by the wire name; the
                  // label is the simplified customer vocabulary.
                  StatusBadge(
                    wireName: order.status.wireName,
                    label: order.statusLabel,
                  ),
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
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: 4,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => context.pushNamed(
                      AppRoutes.orderDetail,
                      pathParameters: {'id': order.id},
                    ),
                    icon: const Icon(Icons.local_shipping_outlined, size: 16),
                    label: const Text('Track Order'),
                  ),
                  if (order.delivered)
                    TextButton.icon(
                      onPressed: () => context.pushNamed(
                        AppRoutes.orderDetail,
                        pathParameters: {'id': order.id},
                      ),
                      icon: const Icon(Icons.rate_review_outlined, size: 16),
                      label: const Text('Leave Review'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
