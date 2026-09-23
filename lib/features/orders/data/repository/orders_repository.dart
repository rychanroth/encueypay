import '../../../../core/domain/stream_result.dart';
import '../../domain/entities/order.dart';

/// Orders contract (spec §58 Orders ops) (DATA-03).
abstract interface class IOrdersRepository {
  /// Realtime sync signals (§31/§54): order record changes and its
  /// delivery changes.
  Stream<StreamResult<bool>> watchOrderChanges(String orderId);

  Stream<StreamResult<bool>> watchDeliveryChanges(String orderId);

  Future<List<CustomerOrder>> fetchMyOrders({int limit = 10, int offset = 0});

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
