import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/stream_result.dart';
import '../../data/repository/admin_repository_impl.dart';
import '../../domain/entities/admin.dart';

part 'admin_orders_controller.freezed.dart';
part 'admin_orders_controller.g.dart';

/// Applied filter/sort state for the Orders tab. Kept separate from the list
/// controller so the screen (and the URL codec) own one source of truth and
/// changing a filter rebuilds exactly one fetch.
@Riverpod(keepAlive: true)
class AdminOrdersQueryController extends _$AdminOrdersQueryController {
  @override
  AdminOrderQuery build() => const AdminOrderQuery();

  void update(AdminOrderQuery query) {
    if (state == query) return;
    state = query;
  }

  void reset() => update(const AdminOrderQuery());
}

/// One page of orders plus the full matching totals and the query that
/// produced it.
@freezed
abstract class AdminOrdersState with _$AdminOrdersState {
  const factory AdminOrdersState({
    required AdminOrderQuery query,
    @Default(<AdminOrderSummary>[]) List<AdminOrderSummary> orders,
    @Default(0) int totalCount,
    @Default(0) int totalMinor,
    @Default(false) bool loadingMore,
  }) = _AdminOrdersState;

  const AdminOrdersState._();

  bool get hasMore => orders.length < totalCount;
}

/// Admin order oversight + fulfillment (Section 3, spec §8 "manages
/// Orders"): the admin drives the single lifecycle one step at a time
/// (server-enforced). Mutations persist-then-invalidate (PRES-03); order/
/// payment changes from any source refetch the feed, and the customer keeps
/// receiving trigger-generated status notifications.
@riverpod
class AdminOrdersController extends _$AdminOrdersController {
  static const _pageSize = 25;

  Timer? _refreshDebounce;

  @override
  Future<AdminOrdersState> build() async {
    final query = ref.watch(adminOrdersQueryControllerProvider);
    final repository = ref.watch(adminRepositoryProvider);
    final subscription = repository.watchOrderFeedChanges().listen((result) {
      if (result is StreamData) _scheduleRefresh();
    });
    ref.onDispose(() {
      _refreshDebounce?.cancel();
      subscription.cancel();
    });
    final page = await repository.searchOrders(query, limit: _pageSize);
    return AdminOrdersState(
      query: query,
      orders: page.orders,
      totalCount: page.totalCount,
      totalMinor: page.totalMinor,
    );
  }

  void _scheduleRefresh() {
    _refreshDebounce?.cancel();
    _refreshDebounce = Timer(
      const Duration(milliseconds: 200),
      () {
        if (ref.mounted) ref.invalidateSelf();
      },
    );
  }

  void refresh() => ref.invalidateSelf();

  /// Appends the next page. On failure the already-loaded rows stay visible
  /// (the screen surfaces the error as a snackbar).
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.loadingMore || !current.hasMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final page = await ref.read(adminRepositoryProvider).searchOrders(
            current.query,
            limit: _pageSize,
            offset: current.orders.length,
          );
      final seen = <String>{};
      final merged = [
        for (final order in [...current.orders, ...page.orders])
          if (seen.add(order.id)) order,
      ];
      state = AsyncData(
        current.copyWith(
          orders: merged,
          totalCount: page.totalCount,
          totalMinor: page.totalMinor,
          loadingMore: false,
        ),
      );
    } catch (error, stackTrace) {
      // Keep the already-loaded rows; the screen surfaces the failure. The
      // error is rethrown so the caller can show a snackbar.
      state = AsyncData(current.copyWith(loadingMore: false));
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  /// Every matching order (not just the loaded page) for CSV export.
  Future<List<AdminOrderSummary>> fetchAllForExport() async {
    final query = ref.read(adminOrdersQueryControllerProvider);
    final page = await ref
        .read(adminRepositoryProvider)
        .searchOrders(query, limit: 5000);
    return page.orders;
  }

  /// Advances each selected order one lifecycle step. Orders without a next
  /// step (terminal/cancelled) are skipped.
  Future<int> advanceSelected(Set<String> orderIds) async {
    final orders = state.value?.orders ?? const <AdminOrderSummary>[];
    final repository = ref.read(adminRepositoryProvider);
    var changed = 0;
    for (final order in orders) {
      if (!orderIds.contains(order.id)) continue;
      final next = order.nextTransition;
      if (next == null) continue;
      await repository.transitionOrder(
        orderId: order.id,
        status: next.wireName,
      );
      changed++;
    }
    ref.invalidateSelf();
    return changed;
  }

  /// Cancels the selected orders that are still cancellable, with one shared
  /// reason. Terminal/shipped orders are skipped (server enforces the rule).
  Future<int> cancelSelected(Set<String> orderIds, String reason) async {
    final orders = state.value?.orders ?? const <AdminOrderSummary>[];
    final repository = ref.read(adminRepositoryProvider);
    var changed = 0;
    for (final order in orders) {
      if (!orderIds.contains(order.id) || !order.cancellable) continue;
      await repository.transitionOrder(
        orderId: order.id,
        status: 'cancelled',
        reason: reason,
      );
      changed++;
    }
    ref.invalidateSelf();
    return changed;
  }
}

/// One order, fetched by id. The detail screen uses this instead of the list
/// state so an active filter or a page boundary cannot make it disappear.
@riverpod
class AdminOrderDetailController extends _$AdminOrderDetailController {
  @override
  Future<AdminOrderSummary> build(String orderId) {
    return ref.watch(adminRepositoryProvider).fetchOrder(orderId);
  }

  Future<void> transition({
    required String status,
    String? reason,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).transitionOrder(
            orderId: orderId,
            status: status,
            reason: reason,
          );
      ref.invalidate(adminOrdersControllerProvider);
      return ref.read(adminRepositoryProvider).fetchOrder(orderId);
    });
  }

  Future<void> markCodPaid() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).markCodPaid(orderId);
      ref.invalidate(adminOrdersControllerProvider);
      return ref.read(adminRepositoryProvider).fetchOrder(orderId);
    });
  }
}
