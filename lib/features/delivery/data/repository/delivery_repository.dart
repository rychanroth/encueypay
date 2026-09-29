import '../../../../core/domain/stream_result.dart';
import '../../domain/entities/delivery.dart';
import '../../domain/entities/transaction.dart';

/// Driver delivery contract (spec §58 Delivery ops) (DATA-03).
abstract interface class IDeliveryRepository {
  /// Realtime sync signals (§31/§54): available-delivery changes and
  /// changes to the driver's own deliveries.
  Stream<StreamResult<bool>> watchAvailableChanges();

  Stream<StreamResult<bool>> watchMyDeliveryChanges();

  Future<List<AvailableDelivery>> fetchAvailableDeliveries();

  /// The driver's currently assigned/in-progress delivery, if any.
  Future<DriverDelivery?> fetchMyActiveDelivery();

  Future<List<DriverDelivery>> fetchMyHistory();

  /// Realized earning lines (delivered deliveries) for [day] —
  /// server-computed, booked at delivery completion (§58).
  Future<List<DriverTransactionEntry>> fetchDriverTransactions(DateTime day);

  Future<void> acceptDelivery(String deliveryId);

  Future<void> rejectDelivery(String deliveryId);

  Future<void> completePickupStop(String stopId);

  Future<void> startDelivery(String deliveryId);

  Future<void> markDelivered(String deliveryId);
}
