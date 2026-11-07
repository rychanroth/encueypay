import '../../../../core/domain/stream_result.dart';
import '../../domain/entities/order.dart';

/// Orders contract (spec §58 Orders ops) (DATA-03).
abstract interface class IOrdersRepository {
  /// Realtime sync signal (§31/§54): order record changes (incl. status).
  Stream<StreamResult<bool>> watchOrderChanges(String orderId);

  /// Realtime sync signal for the customer's order-history list.
  Stream<StreamResult<bool>> watchMyOrderChanges();

  /// Best-effort cleanup: cancels stale unpaid QR orders and restores stock.
  /// Failures are logged, never surfaced as an orders-list error.
  Future<void> expireUnpaidQrOrders();

  /// Section 7B: server-side history filters — [statuses] are wire values
  /// (null = no status filter); [fromDate]/[toDate] bound created_at (the
  /// to-date is inclusive of its whole day).
  Future<List<CustomerOrder>> fetchMyOrders({
    int limit = 10,
    int offset = 0,
    List<String>? statuses,
    DateTime? fromDate,
    DateTime? toDate,
  });

  Future<CustomerOrder> fetchOrder(String orderId);

  /// Throws [Failure] only; the server decides whether cancellation is
  /// permitted and releases reservations (§12/§50).
  Future<void> cancelOrder(String orderId);

  /// Uploads a bank-transfer proof to Storage and transitions the payment
  /// server-side (§20.2). [fileName] preserves the original extension.
  Future<void> submitPaymentProof({
    required String orderId,
    required String filePath,
    required String fileName,
  });
}
