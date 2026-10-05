import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/orders_repository_impl.dart';
import '../states/order_history_state.dart';

part 'orders_controller.g.dart';

/// Paginated "my orders" list with server-side history filters
/// (Section 7B: status group + date range). Changing a filter refetches
/// page 0; loadMore carries the active filter set.
@riverpod
class OrdersController extends _$OrdersController {
  static const _pageSize = 10;

  @override
  Future<OrderHistoryState> build() async {
    return _fetch(const OrderHistoryState());
  }

  Future<OrderHistoryState> _fetch(OrderHistoryState historyState) async {
    final page = await ref.read(ordersRepositoryProvider).fetchMyOrders(
          limit: _pageSize,
          statuses: historyState.group.wireStatuses,
          fromDate: historyState.fromDate,
          toDate: historyState.toDate,
        );
    return historyState.copyWith(
      items: [...historyState.items, ...page],
      hasMore: page.length == _pageSize,
      isLoadingMore: false,
    );
  }

  /// Section 7B: apply a new filter set — refetches page 0.
  Future<void> setFilters({
    OrderHistoryGroup? group,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final current = state.value ?? const OrderHistoryState();
    state = await AsyncValue.guard(
      () => _fetch(current.copyWith(
        group: group ?? current.group,
        fromDate: fromDate ?? current.fromDate,
        toDate: toDate ?? current.toDate,
        // Reset the list when the filter set changes.
        items: [],
        hasMore: true,
        isLoadingMore: false,
      )),
    );
  }

  Future<void> clearDateRange() async {
    final current = state.value ?? const OrderHistoryState();
    state = await AsyncValue.guard(
      () => _fetch(current.copyWith(fromDate: null, toDate: null, items: [], hasMore: true)),
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;
    state = await AsyncValue.guard(() async {
      final page = await ref.read(ordersRepositoryProvider).fetchMyOrders(
            limit: _pageSize,
            offset: current.items.length,
            statuses: current.group.wireStatuses,
            fromDate: current.fromDate,
            toDate: current.toDate,
          );
      return current.copyWith(
        items: [...current.items, ...page],
        hasMore: page.length == _pageSize,
        isLoadingMore: false,
      );
    });
  }
}
