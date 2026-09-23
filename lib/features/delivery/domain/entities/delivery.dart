/// A delivery waiting for a driver (spec §14/§15.1). Slim purpose-shaped
/// view — the orders feature keeps its own read model (ARCH-04).
class AvailableDelivery {
  const AvailableDelivery({
    required this.id,
    required this.orderId,
    required this.dropoffCity,
    required this.pickupBusinessNames,
    required this.stopCount,
    required this.deliveryFeeMinor,
    required this.createdAt,
  });

  final String id;
  final String orderId;
  final String dropoffCity;
  final List<String> pickupBusinessNames;
  final int stopCount;
  final int deliveryFeeMinor;
  final DateTime createdAt;
}

/// The driver's assigned (or in-progress) delivery with its pickup route
/// (spec §16).
class DriverDelivery {
  const DriverDelivery({
    required this.id,
    required this.orderId,
    required this.status,
    required this.customerName,
    required this.dropoffLine1,
    required this.dropoffCity,
    required this.earningMinor,
    required this.createdAt,
    required this.stops,
  });

  final String id;
  final String orderId;
  final DeliveryStateValue status;
  final String customerName;
  final String dropoffLine1;
  final String dropoffCity;
  final int earningMinor;
  final DateTime createdAt;
  final List<DriverStop> stops;

  bool get allStopsCompleted => stops.isNotEmpty && stops.every((s) => s.completed);
  bool get canReject => status == DeliveryStateValue.assigned;
  bool get canStart =>
      status == DeliveryStateValue.pickupInProgress && allStopsCompleted;
  bool get canComplete => status == DeliveryStateValue.deliveryInProgress;
}

class DriverStop {
  const DriverStop({
    required this.id,
    required this.businessName,
    required this.sequence,
    required this.completed,
  });

  final String id;
  final String businessName;
  final int sequence;
  final bool completed;
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
