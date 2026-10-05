import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';

/// Customer order read model (Section 7A): ONE lifecycle on the order —
/// `status` IS the customer-facing state (assignment vocabulary), read
/// verbatim by the tracking timeline. Payment stays its own flow.
@freezed
abstract class CustomerOrder with _$CustomerOrder {
  const factory CustomerOrder({
    required String id,
    required DateTime createdAt,
    required OrderStatus status,
    required int subtotalMinor,
    required int discountMinor,
    required int deliveryFeeMinor,
    required int totalMinor,
    // Historical address snapshot (§17).
    required String shippingRecipientName,
    @Default('') String shippingPhone,
    required String shippingLine1,
    String? shippingLine2,
    required String shippingCity,
    @Default('') String note,
    @Default('') String cancellationReason,
    @Default([]) List<OrderItemSnapshot> items,
    @Default([]) List<ReturnRequestInfo> returns,
    OrderPayment? payment,
  }) = _CustomerOrder;

  const CustomerOrder._();

  /// Customer may cancel while the order is still pending/confirmed —
  /// mirrored from the server rule in cancel_order (§7D refines paid-QR).
  bool get cancellable =>
      status == OrderStatus.pending || status == OrderStatus.confirmed;

  /// Delivered orders unlock reviews and returns.
  bool get delivered => status == OrderStatus.delivered;
}

/// Historical purchase line (§19) — current catalog edits never rewrite it.
/// [businessName] is a display snapshot from the owning business.
@freezed
abstract class OrderItemSnapshot with _$OrderItemSnapshot {
  const factory OrderItemSnapshot({
    required String id,
    required String productName,
    required int unitPriceMinor,
    required int quantity,
    required int lineTotalMinor,
    String? variantName,
    @Default('') String businessName,
    @Default(0) int discountMinor,
  }) = _OrderItemSnapshot;
}

/// The customer's return request on this order (Section 7E): its status is
/// the customer's progress tracker. 'Requested' is the submission act; a
/// pending request is under review.
@freezed
abstract class ReturnRequestInfo with _$ReturnRequestInfo {
  const factory ReturnRequestInfo({
    required String id,
    required ReturnStatus status,
    @Default('') String reason,
  }) = _ReturnRequestInfo;
}

/// The return lifecycle (assignment §7 vocabulary; wire: pending = under
/// review).
enum ReturnStatus {
  pending,
  approved,
  rejected,
  completed;

  static ReturnStatus fromName(String? name) =>
      ReturnStatus.values.asNameMap()[name] ?? ReturnStatus.pending;

  String get label => switch (this) {
        ReturnStatus.pending => 'Under review',
        ReturnStatus.approved => 'Approved — refund pending',
        ReturnStatus.rejected => 'Rejected',
        ReturnStatus.completed => 'Completed',
      };
}

@freezed
abstract class OrderPayment with _$OrderPayment {
  const factory OrderPayment({
    required PaymentMethodKind method,
    required PaymentStatusState status,
    required int amountMinor,
  }) = _OrderPayment;
}

/// The assignment's lifecycle vocabulary (§7A) — one status on the order.
enum OrderStatus {
  pending,
  confirmed,
  processing,
  packed,
  shipped,
  outForDelivery,
  delivered,
  cancelled,
  returned;

  static OrderStatus fromName(String? name) =>
      OrderStatus.values.asNameMap()[name] ?? OrderStatus.pending;

  /// Wire value (snake_case on the wire).
  String get wireName => switch (this) {
        OrderStatus.outForDelivery => 'out_for_delivery',
        _ => name,
      };
}

enum PaymentMethodKind {
  cod,
  bankTransfer,
  qr;

  static PaymentMethodKind fromName(String? name) =>
      PaymentMethodKind.values.asNameMap()[name] ?? PaymentMethodKind.cod;
}

enum PaymentStatusState {
  pending,
  awaitingPaymentVerification,
  transactionVerified,
  refundRequired,
  refunded;

  static PaymentStatusState fromName(String? name) =>
      PaymentStatusState.values.asNameMap()[name] ??
      PaymentStatusState.pending;
}
