import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/admin_repository_impl.dart';
import '../../domain/entities/admin.dart';

part 'admin_orders_controller.g.dart';

/// Admin order oversight + fulfillment (Section 3, spec §8 "manages
/// Orders"): the admin drives the per-business lifecycle and completes the
/// delivery administratively while the operator portals are bypassed
/// (ledger L-07). Mutations persist-then-invalidate (PRES-03); the customer
/// keeps receiving trigger-generated status notifications.
@riverpod
class AdminOrdersController extends _$AdminOrdersController {
  @override
  Future<List<AdminOrderSummary>> build() async {
    return ref.watch(adminRepositoryProvider).fetchOrders();
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

  /// Section 6b: simulate a confirmed gateway webhook (admin authority) so
  /// the QR payment flow demos without external credentials.
  Future<void> simulateQrPayment({required String orderId}) async {
    final current = state.value ?? const <AdminOrderSummary>[];
    state = await AsyncValue.guard(() async {
      await ref
          .read(adminRepositoryProvider)
          .simulateQrPayment(orderId: orderId);
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> decideReturn({
    required String returnId,
    required bool approve,
  }) async {
    final current = state.value ?? const <AdminOrderSummary>[];
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).processReturn(
            returnId: returnId,
            approve: approve,
          );
      ref.invalidateSelf();
      return current;
    });
  }
}
