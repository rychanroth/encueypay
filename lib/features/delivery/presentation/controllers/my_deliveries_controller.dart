import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/stream_result.dart';
import '../../data/repository/delivery_repository_impl.dart';
import '../../domain/entities/delivery.dart';

part 'my_deliveries_controller.g.dart';

class MyDeliveriesState {
  const MyDeliveriesState({this.activeDelivery, this.history = const []});

  final DriverDelivery? activeDelivery;
  final List<DriverDelivery> history;

  MyDeliveriesState copyWith({
    DriverDelivery? activeDelivery,
    List<DriverDelivery>? history,
  }) {
    return MyDeliveriesState(
      activeDelivery: activeDelivery ?? this.activeDelivery,
      history: history ?? this.history,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyDeliveriesState &&
          other.activeDelivery?.id == activeDelivery?.id &&
          other.history.length == history.length;

  @override
  int get hashCode =>
      Object.hash(activeDelivery?.id, history.length);
}

@riverpod
class MyDeliveriesController extends _$MyDeliveriesController {
  @override
  Future<MyDeliveriesState> build() async {
    final repository = ref.watch(deliveryRepositoryProvider);
    final subscription =
        repository.watchMyDeliveryChanges().listen((result) {
      if (result is StreamData) ref.invalidateSelf();
    });
    ref.onDispose(subscription.cancel);
    final results = await (
      repository.fetchMyActiveDelivery(),
      repository.fetchMyHistory(),
    ).wait;
    return MyDeliveriesState(
      activeDelivery: results.$1,
      history: results.$2,
    );
  }

  Future<void> reject(String deliveryId) async {
    final current = state.value ?? const MyDeliveriesState();
    state = await AsyncValue.guard(() async {
      await ref.read(deliveryRepositoryProvider).rejectDelivery(deliveryId);
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> completeStop(String stopId) async {
    final current = state.value ?? const MyDeliveriesState();
    state = await AsyncValue.guard(() async {
      await ref.read(deliveryRepositoryProvider).completePickupStop(stopId);
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> start(String deliveryId) async {
    final current = state.value ?? const MyDeliveriesState();
    state = await AsyncValue.guard(() async {
      await ref.read(deliveryRepositoryProvider).startDelivery(deliveryId);
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> markDelivered(String deliveryId) async {
    final current = state.value ?? const MyDeliveriesState();
    state = await AsyncValue.guard(() async {
      await ref.read(deliveryRepositoryProvider).markDelivered(deliveryId);
      ref.invalidateSelf();
      return current;
    });
  }
}
