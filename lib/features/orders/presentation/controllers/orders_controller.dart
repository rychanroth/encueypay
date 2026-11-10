import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/stream_result.dart';
import '../../../../core/network/failure_mapping.dart';
import '../../data/repository/orders_repository_impl.dart';
import '../states/order_history_state.dart';

part 'orders_controller.g.dart';

/// Paginated "my orders" list with server-side history filters
/// (Section 7B: status group + date range). Changing a filter refetches
/// page 0; loadMore carries the active filter set. A customer-scoped order
/// stream keeps the already-loaded window fresh without resetting filters.
@riverpod
class OrdersController extends _$OrdersController {
  static const _pageSize = 10;

  Timer? _refreshDebounce;

  /// Guards against a slow earlier fetch overwriting a newer filter result.
  int _request = 0;

  @override
  Future<OrderHistoryState> build() async {
    final repository = ref.watch(ordersRepositoryProvider);
    final subscription = repository
        .watchMyOrderChanges()
        .skipInitialSnapshot()
        .listen((result) {
      if (result is StreamData) _scheduleRefresh();
    });
    ref.onDispose(() {
      _refreshDebounce?.cancel();
      subscription.cancel();
    });
    // Lazy expiry fallback when pg_cron is unavailable; best-effort only.
    await ref.read(ordersRepositoryProvider).expireUnpaidQrOrders();
    return _fetch(const OrderHistoryState());
  }

  void _scheduleRefresh() {
    _refreshDebounce?.cancel();
    _refreshDebounce = Timer(
      const Duration(milliseconds: 250),
      () => unawaited(_refreshLoaded()),
    );
  }

  /// Refetches the currently loaded window so new/updated orders appear
  /// without dropping the active filter or pagination position.
  Future<void> _refreshLoaded() async {
    if (!ref.mounted) return;
    final current = state.value;
    if (current == null) return;
    final request = _request;
    final limit = current.items.isEmpty ? _pageSize : current.items.length;
    try {
      final page = await ref.read(ordersRepositoryProvider).fetchMyOrders(
            limit: limit,
            statuses: current.group.wireStatuses,
            fromDate: current.fromDate,
            toDate: current.toDate,
            search: current.search,
            toReview: current.toReview,
          );
      if (!ref.mounted || request != _request) return;
      state = AsyncData(current.copyWith(
        items: page,
        hasMore: page.length == limit,
        isLoadingMore: false,
      ));
    } catch (error, stackTrace) {
      // Keep the current list on transient refresh failures.
      logSuppressedError(error, stackTrace);
    }
  }

  Future<OrderHistoryState> _fetch(OrderHistoryState historyState) async {
    final page = await ref.read(ordersRepositoryProvider).fetchMyOrders(
          limit: _pageSize,
          statuses: historyState.group.wireStatuses,
          fromDate: historyState.fromDate,
          toDate: historyState.toDate,
          search: historyState.search,
          toReview: historyState.toReview,
        );
    return historyState.copyWith(
      items: [...historyState.items, ...page],
      hasMore: page.length == _pageSize,
      isLoadingMore: false,
    );
  }

  /// Section 7B: apply a complete filter set — resets to page 0. The filter
  /// fields update immediately (the list shows a spinner while the page
  /// loads) so chips/search never lag behind the tap.
  Future<void> applyFilters({
    required OrderHistoryGroup group,
    required DateTime? fromDate,
    required DateTime? toDate,
    required String search,
    required bool toReview,
  }) async {
    final current = state.value ?? const OrderHistoryState();
    final next = current.copyWith(
      group: group,
      fromDate: fromDate,
      toDate: toDate,
      search: search,
      toReview: toReview,
      items: const [],
      hasMore: true,
      isLoadingMore: false,
    );
    final request = ++_request;
    state = AsyncData(next);
    final result = await AsyncValue.guard(() => _fetch(next));
    if (!ref.mounted || request != _request) return;
    state = result;
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;
    final request = _request;
    state = AsyncData(current.copyWith(isLoadingMore: true));
    final result = await AsyncValue.guard(() async {
      final page = await ref.read(ordersRepositoryProvider).fetchMyOrders(
            limit: _pageSize,
            offset: current.items.length,
            statuses: current.group.wireStatuses,
            fromDate: current.fromDate,
            toDate: current.toDate,
            search: current.search,
            toReview: current.toReview,
          );
      return current.copyWith(
        items: [...current.items, ...page],
        hasMore: page.length == _pageSize,
        isLoadingMore: false,
      );
    });
    if (!ref.mounted || request != _request) return;
    state = result;
  }
}
