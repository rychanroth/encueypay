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
  cancelled,
  returned;

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
        OrderHistoryGroup.returned => const ['returned'],
      };
}

/// Immutable Order History state (PRES-02): items + pagination + the active
/// server-side filters (Section 7B — status group + date range).
@freezed
abstract class OrderHistoryState with _$OrderHistoryState {
  const factory OrderHistoryState({
    @Default([]) List<CustomerOrder> items,
    @Default(true) bool hasMore,
    @Default(false) bool isLoadingMore,
    @Default(OrderHistoryGroup.all) OrderHistoryGroup group,
    DateTime? fromDate,
    DateTime? toDate,
  }) = _OrderHistoryState;
}
