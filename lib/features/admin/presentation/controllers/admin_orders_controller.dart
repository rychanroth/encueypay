import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/stream_result.dart';
import '../../data/repository/admin_repository_impl.dart';
import '../../domain/entities/admin.dart';

part 'admin_orders_controller.g.dart';

/// Admin order oversight + fulfillment (Section 3, spec §8 "manages
/// Orders"): the admin drives the single lifecycle one step at a time
/// (server-enforced) while the operator portals are bypassed. Mutations
/// persist-then-invalidate (PRES-03); order/payment changes from any source
/// refetch the feed, and the customer keeps receiving trigger-generated
/// status notifications.
@riverpod
class AdminOrdersController extends _$AdminOrdersController {
  Timer? _refreshDebounce;

  @override
  Future<List<AdminOrderSummary>> build() async {
    final repository = ref.watch(adminRepositoryProvider);
    final subscription = repository.watchOrderFeedChanges().listen((result) {
      if (result is StreamData) _scheduleRefresh();
    });
    ref.onDispose(() {
      _refreshDebounce?.cancel();
      subscription.cancel();
    });
    return repository.fetchOrders();
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

  /// Section 7A: one-step lifecycle transition (or cancel with reason).
  Future<void> transition({
    required String orderId,
    required String status,
    String? reason,
  }) async {
    final current = state.value ?? const <AdminOrderSummary>[];
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).transitionOrder(
            orderId: orderId,
            status: status,
            reason: reason,
          );
      ref.invalidateSelf();
      return current;
    });
  }

}
