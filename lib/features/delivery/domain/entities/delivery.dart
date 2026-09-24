import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery.freezed.dart';

/// A delivery waiting for a driver (spec §14/§15.1). Slim purpose-shaped
/// view — the orders feature keeps its own read model (ARCH-04).
@freezed
abstract class AvailableDelivery with _$AvailableDelivery {
  const factory AvailableDelivery({
    required String id,
    required String orderId,
    required String dropoffCity,
    required List<String> pickupBusinessNames,
    required int stopCount,
    required int deliveryFeeMinor,
    required DateTime createdAt,
  }) = _AvailableDelivery;
}

/// The driver's assigned (or in-progress) delivery with its pickup route
/// (spec §16).
@freezed
abstract class DriverDelivery with _$DriverDelivery {
  const factory DriverDelivery({
    required String id,
    required String orderId,
    required DeliveryStateValue status,
    required String customerName,
    required String dropoffLine1,
    required String dropoffCity,
    required int earningMinor,
    required DateTime createdAt,
    required List<DriverStop> stops,
  }) = _DriverDelivery;

  const DriverDelivery._();

  bool get allStopsCompleted =>
      stops.isNotEmpty && stops.every((s) => s.completed);
  bool get canReject => status == DeliveryStateValue.assigned;
  bool get canStart =>
      status == DeliveryStateValue.pickupInProgress && allStopsCompleted;
  bool get canComplete => status == DeliveryStateValue.deliveryInProgress;
}

@freezed
abstract class DriverStop with _$DriverStop {
  const factory DriverStop({
    required String id,
    required String businessName,
    required int sequence,
    required bool completed,
  }) = _DriverStop;
}

/// Duplicated per feature on purpose (ARCH-04) — the orders feature owns
/// its own enum.
enum DeliveryStateValue {
  available,
  assigned,
  pickupInProgress,
  deliveryInProgress,
  delivered,
  cancelled;

  static DeliveryStateValue fromName(String? name) =>
      DeliveryStateValue.values.asNameMap()[name] ??
      DeliveryStateValue.available;
}
