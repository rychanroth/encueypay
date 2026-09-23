import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/delivery_repository_impl.dart';
import '../../domain/entities/delivery.dart';

part 'available_deliveries_controller.g.dart';

/// Available deliveries for drivers. Realtime (§31) arrives in Phase 11;
/// pull-to-refresh until then.
@riverpod
class AvailableDeliveriesController extends _$AvailableDeliveriesController {
  @override
  Future<List<AvailableDelivery>> build() async {
    return ref.watch(deliveryRepositoryProvider).fetchAvailableDeliveries();
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
