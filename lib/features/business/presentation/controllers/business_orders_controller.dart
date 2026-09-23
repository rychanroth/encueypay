import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/business_repository_impl.dart';
import '../../domain/entities/managed_business_order.dart';

part 'business_orders_controller.g.dart';

/// Incoming/active business orders. Realtime arrives in Phase 11; until
/// then the list refreshes via invalidate (pull-to-refresh + after each
/// transition).
@riverpod
class BusinessOrdersController extends _$BusinessOrdersController {
  @override
  Future<List<ManagedBusinessOrder>> build() async {
    return ref.watch(businessRepositoryProvider).fetchMyBusinessOrders();
  }

  Future<void> transition({
    required String businessOrderId,
    required ManagedOrderStatus target,
    String? reason,
  }) async {
    final current = state.value ?? const <ManagedBusinessOrder>[];
    state = await AsyncValue.guard(() async {
      await ref.read(businessRepositoryProvider).transitionBusinessOrder(
            businessOrderId: businessOrderId,
            target: target,
            reason: reason,
          );
      ref.invalidateSelf();
      return current;
    });
  }
}
