import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_payment.freezed.dart';

/// The order's payment as shown on the order-success screen (Section 6b):
/// realtime ground truth from the `payments` stream, plus the registered
/// KHQR payload. [status] is the raw wire value.
@freezed
abstract class OrderPayment with _$OrderPayment {
  const factory OrderPayment({
    required String status,
    required String method,
    required int amountMinor,
    String? qrPayload,
    String? transactionReference,
  }) = _OrderPayment;

  const OrderPayment._();

  bool get isPendingQr => method == 'qr' && status == 'pending';

  bool get isVerified => status == 'transaction_verified';
}
