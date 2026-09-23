/// Customer order read model (spec §9–§19). The overall status is DERIVED
/// from the independent business/payment/delivery states (§10/§52) — there
/// is no authoritative overall state machine.
class CustomerOrder {
  const CustomerOrder({
    required this.id,
    required this.createdAt,
    required this.subtotalMinor,
    required this.discountMinor,
    required this.deliveryFeeMinor,
    required this.totalMinor,
    required this.shippingRecipientName,
    required this.shippingPhone,
    required this.shippingLine1,
    required this.shippingCity,
    required this.businessParts,
    this.shippingLine2,
    this.payment,
    this.delivery,
  });

  final String id;
  final DateTime createdAt;
  final int subtotalMinor;
  final int discountMinor;
  final int deliveryFeeMinor;
  final int totalMinor;

  // Historical address snapshot (§17).
  final String shippingRecipientName;
  final String shippingPhone;
  final String shippingLine1;
  final String? shippingLine2;
  final String shippingCity;

  final List<OrderBusinessPart> businessParts;
  final OrderPayment? payment;
  final OrderDelivery? delivery;

  /// Customer may cancel while every business order is still pending —
  /// mirrored from the server rule in cancel_order.
  bool get cancellable =>
      businessParts.isNotEmpty &&
      businessParts.every((part) => part.status == BusinessOrderStatus.pending);

  /// Derived customer-facing status (§10).
  CustomerOrderStatus get derivedStatus {
    if (businessParts.every((p) => p.status == BusinessOrderStatus.cancelled ||
        p.status == BusinessOrderStatus.rejected)) {
      return CustomerOrderStatus.cancelled;
    }
    final payment = this.payment;
    if (payment != null && payment.status == PaymentStatusState.refundRequired) {
      return CustomerOrderStatus.refundRequired;
    }
    final delivery = this.delivery;
    if (delivery != null) {
      if (delivery.status == DeliveryState.delivered) {
        return CustomerOrderStatus.delivered;
      }
      if (delivery.status == DeliveryState.deliveryInProgress ||
          delivery.status == DeliveryState.pickupInProgress) {
        return CustomerOrderStatus.outForDelivery;
      }
    }
    final statuses = businessParts.map((p) => p.status).toSet();
    if (statuses.contains(BusinessOrderStatus.ready)) {
      return CustomerOrderStatus.ready;
    }
    if (statuses.contains(BusinessOrderStatus.preparing)) {
      return CustomerOrderStatus.preparing;
    }
    if (statuses.contains(BusinessOrderStatus.accepted)) {
      return CustomerOrderStatus.accepted;
    }
    return CustomerOrderStatus.pending;
  }
}

/// One business's portion of the order, with its own lifecycle (§11).
class OrderBusinessPart {
  const OrderBusinessPart({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.status,
    required this.items,
    required this.pickupStops,
    this.rejectionReason,
  });

  final String id;
  final String businessId;
  final String businessName;
  final BusinessOrderStatus status;
  final String? rejectionReason;
  final List<OrderItemSnapshot> items;
  final List<PickupStopInfo> pickupStops;
}

/// Historical purchase line (§19) — current catalog edits never rewrite it.
class OrderItemSnapshot {
  const OrderItemSnapshot({
    required this.id,
    required this.productName,
    required this.unitPriceMinor,
    required this.quantity,
    required this.lineTotalMinor,
    this.variantName,
    this.discountMinor = 0,
  });

  final String id;
  final String productName;
  final String? variantName;
  final int unitPriceMinor;
  final int discountMinor;
  final int quantity;
  final int lineTotalMinor;
}

class OrderPayment {
  const OrderPayment({
    required this.method,
    required this.status,
    required this.amountMinor,
  });

  final PaymentMethodKind method;
  final PaymentStatusState status;
  final int amountMinor;
}

class OrderDelivery {
  const OrderDelivery({required this.status});

  final DeliveryState status;
}

class PickupStopInfo {
  const PickupStopInfo({
    required this.id,
    required this.sequence,
    required this.status,
  });

  final String id;
  final int sequence;
  final PickupStopState status;
}

enum BusinessOrderStatus {
  pending,
  accepted,
  rejected,
  preparing,
  ready,
  completed,
  cancelled;

  static BusinessOrderStatus fromName(String? name) =>
      BusinessOrderStatus.values.asNameMap()[name] ??
      BusinessOrderStatus.pending;
}

enum PaymentMethodKind {
  cod,
  bankTransfer;

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

enum DeliveryState {
  available,
  assigned,
  pickupInProgress,
  deliveryInProgress,
  delivered,
  cancelled;

  static DeliveryState fromName(String? name) =>
      DeliveryState.values.asNameMap()[name] ?? DeliveryState.available;
}

enum PickupStopState {
  pending,
  completed;

  static PickupStopState fromName(String? name) =>
      PickupStopState.values.asNameMap()[name] ?? PickupStopState.pending;
}

enum CustomerOrderStatus {
  pending,
  accepted,
  preparing,
  ready,
  outForDelivery,
  delivered,
  cancelled,
  refundRequired;
}
