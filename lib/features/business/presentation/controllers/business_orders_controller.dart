import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/stream_result.dart';
import '../../data/repository/business_repository_impl.dart';
import '../../domain/entities/managed_business_order.dart';

part 'business_orders_controller.g.dart';

/// Incoming/active business orders. Realtime is a sync signal (§31/§54):
/// stream events trigger a refetch of ground truth.
@riverpod
class BusinessOrdersController extends _$BusinessOrdersController {
  @override
  Future<List<ManagedBusinessOrder>> build() async {
    final repository = ref.watch(businessRepositoryProvider);
    final subscription = repository.watchOrderChanges().listen((result) {
      if (result is StreamData) ref.invalidateSelf();
    });
    ref.onDispose(subscription.cancel);
    return repository.fetchMyBusinessOrders();
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
