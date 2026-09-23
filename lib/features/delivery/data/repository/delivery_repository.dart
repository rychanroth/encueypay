import '../../domain/entities/delivery.dart';

/// Driver delivery contract (spec §58 Delivery ops) (DATA-03).
abstract interface class IDeliveryRepository {
  Future<List<AvailableDelivery>> fetchAvailableDeliveries();

  /// The driver's currently assigned/in-progress delivery, if any.
  Future<DriverDelivery?> fetchMyActiveDelivery();

  Future<List<DriverDelivery>> fetchMyHistory();

  Future<void> acceptDelivery(String deliveryId);

  Future<void> rejectDelivery(String deliveryId);

  Future<void> completePickupStop(String stopId);

  Future<void> startDelivery(String deliveryId);

  Future<void> markDelivered(String deliveryId);
}
