import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/order.dart';

part 'order_history_state.freezed.dart';

/// Which assignment §7 filtered view is active on Order History. The groups
/// map onto the single lifecycle (Section 7A):
/// active = pending…out_for_delivery, completed = delivered.
enum OrderHistoryGroup {
  all,
  active,
  completed,
  cancelled;

  /// Wire values for the server-side status filter; null = no filter.
  List<String>? get wireStatuses => switch (this) {
        OrderHistoryGroup.all => null,
        OrderHistoryGroup.active => const [
            'pending',
            'confirmed',
            'processing',
            'packed',
            'shipped',
            'out_for_delivery',
          ],
        OrderHistoryGroup.completed => const ['delivered'],
        OrderHistoryGroup.cancelled => const ['cancelled'],
      };
}

/// Immutable Order History state (PRES-02): items + pagination + the active
/// server-side filters (Section 7B — status group, date range, search and
/// the "to review" view).
@freezed
abstract class OrderHistoryState with _$OrderHistoryState {
  const factory OrderHistoryState({
    @Default([]) List<CustomerOrder> items,
    @Default(true) bool hasMore,
    @Default(false) bool isLoadingMore,
    @Default(OrderHistoryGroup.all) OrderHistoryGroup group,
    DateTime? fromDate,
    DateTime? toDate,
    @Default('') String search,
    @Default(false) bool toReview,
  }) = _OrderHistoryState;

  const OrderHistoryState._();

  /// True when anything narrows the list (drives the empty state and its
  /// clear-filters action).
  bool get hasActiveFilters =>
      group != OrderHistoryGroup.all ||
      fromDate != null ||
      toDate != null ||
      search.isNotEmpty ||
      toReview;
}
