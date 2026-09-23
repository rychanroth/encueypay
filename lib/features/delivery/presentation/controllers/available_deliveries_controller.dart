import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/stream_result.dart';
import '../../data/repository/delivery_repository_impl.dart';
import '../../domain/entities/delivery.dart';

part 'available_deliveries_controller.g.dart';

/// Available deliveries for drivers. Realtime is a sync signal (§31/§54):
/// stream events trigger a refetch of ground truth.
@riverpod
class AvailableDeliveriesController extends _$AvailableDeliveriesController {
  @override
  Future<List<AvailableDelivery>> build() async {
    final repository = ref.watch(deliveryRepositoryProvider);
    final subscription =
        repository.watchAvailableChanges().listen((result) {
      if (result is StreamData) ref.invalidateSelf();
    });
    ref.onDispose(subscription.cancel);
    return repository.fetchAvailableDeliveries();
  }

  Future<void> accept(String deliveryId) async {
    final current = state.value ?? const <AvailableDelivery>[];
    state = await AsyncValue.guard(() async {
      await ref.read(deliveryRepositoryProvider).acceptDelivery(deliveryId);
      ref.invalidateSelf();
      return current;
    });
  }
}
