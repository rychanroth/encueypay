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
    OrderPayment? payment,
  }) = _CustomerOrder;

  const CustomerOrder._();

  /// Customer may cancel while the order is pending/confirmed — except a
  /// QR order whose payment already went through (nothing refunds it; the
  /// server rule in cancel_order enforces the same).
  bool get cancellable {
    if (status != OrderStatus.pending && status != OrderStatus.confirmed) {
      return false;
    }
    final payment = this.payment;
    if (payment == null) return true;
    return !(payment.method == PaymentMethodKind.qr &&
        payment.status != PaymentStatusState.pending);
  }

  /// Delivered orders unlock reviews.
  bool get delivered => status == OrderStatus.delivered;

  /// Payment-aware customer label. An unpaid QR order is `pending` on the
  /// server (the order exists so PayWay can reference it), but calling that
  /// "Order placed" makes it look finalized before payment.
  String get statusLabel {
    if (status == OrderStatus.pending) {
      final payment = this.payment;
      if (payment != null && payment.method == PaymentMethodKind.qr) {
        return payment.status == PaymentStatusState.transactionVerified
            ? 'Payment received'
            : 'Awaiting payment';
      }
    }
    return status.label;
  }
}

/// Historical purchase line (§19) — current catalog edits never rewrite it.
/// [productId] + [imageUrl] ride along for the tappable OrderItemCard
/// (the image is the product's CURRENT first photo, resolved from the
/// live catalog — the historical snapshot only stores the id reference).
@freezed
abstract class OrderItemSnapshot with _$OrderItemSnapshot {
  const factory OrderItemSnapshot({
    required String id,
    required String productId,
    required String productName,
    required int unitPriceMinor,
    required int quantity,
    required int lineTotalMinor,
    String? variantName,
    @Default(0) int discountMinor,
    String? imageUrl,

    /// One review per order item (DB unique constraint) — drives the
    /// order detail screen's Reviewed state.
    @Default(false) bool reviewed,
  }) = _OrderItemSnapshot;
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
  cancelled;

  static OrderStatus fromName(String? name) {
    if (name == null) return OrderStatus.pending;
    // Wire values are snake_case ('out_for_delivery') while enum `.name` is
    // camelCase — match both, or multi-word statuses collapse to the
    // fallback and the timeline shows the wrong stage.
    for (final value in OrderStatus.values) {
      if (value.name == name || value.wireName == name) return value;
    }
    return OrderStatus.pending;
  }

  /// Wire value (snake_case on the wire).
  String get wireName => switch (this) {
        OrderStatus.outForDelivery => 'out_for_delivery',
        _ => name,
      };

  /// Simplified customer-facing label: the nine wire statuses collapse to
  /// four coarse stages plus the terminal state. The exact §7A
  /// vocabulary stays server truth and remains visible through the detail
  /// screen's "Show exact status" reveal; admins always see wire values.
  String get label => switch (this) {
        OrderStatus.pending => 'Order placed',
        OrderStatus.confirmed ||
        OrderStatus.processing ||
        OrderStatus.packed => 'Preparing',
        OrderStatus.shipped ||
        OrderStatus.outForDelivery => 'On its way',
        OrderStatus.delivered => 'Delivered',
        OrderStatus.cancelled => 'Cancelled',
      };
}

enum PaymentMethodKind {
  cod,
  bankTransfer,
  qr;

  /// Wire value (snake_case on the wire).
  String get wireName => switch (this) {
        PaymentMethodKind.bankTransfer => 'bank_transfer',
        _ => name,
      };

  static PaymentMethodKind fromName(String? name) {
    if (name == null) return PaymentMethodKind.cod;
    for (final value in PaymentMethodKind.values) {
      if (value.name == name || value.wireName == name) return value;
    }
    return PaymentMethodKind.cod;
  }
}

enum PaymentStatusState {
  pending,
  awaitingPaymentVerification,
  transactionVerified;

  /// Wire value (snake_case on the wire).
  String get wireName => switch (this) {
        PaymentStatusState.awaitingPaymentVerification =>
          'awaiting_payment_verification',
        PaymentStatusState.transactionVerified => 'transaction_verified',
        _ => name,
      };

  static PaymentStatusState fromName(String? name) {
    if (name == null) return PaymentStatusState.pending;
    for (final value in PaymentStatusState.values) {
      if (value.name == name || value.wireName == name) return value;
    }
    return PaymentStatusState.pending;
  }
}
