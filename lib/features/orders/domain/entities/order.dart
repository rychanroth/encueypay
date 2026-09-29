import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';

/// Customer order read model (spec §9–§19). The overall status is DERIVED
/// from the independent business/payment/delivery states (§10/§52) — there
/// is no authoritative overall state machine.
@freezed
abstract class CustomerOrder with _$CustomerOrder {
  const factory CustomerOrder({
    required String id,
    required DateTime createdAt,
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
    required List<OrderBusinessPart> businessParts,
    OrderPayment? payment,
    OrderDelivery? delivery,
  }) = _CustomerOrder;

  const CustomerOrder._();

  /// Customer may cancel while every business order is still pending —
  /// mirrored from the server rule in cancel_order.
  bool get cancellable =>
      businessParts.isNotEmpty &&
      businessParts
          .every((part) => part.status == BusinessOrderStatus.pending);

  /// Derived customer-facing status (§10).
  CustomerOrderStatus get derivedStatus {
    if (businessParts.every(
        (p) => p.status == BusinessOrderStatus.cancelled ||
            p.status == BusinessOrderStatus.rejected)) {
      return CustomerOrderStatus.cancelled;
    }
    final payment = this.payment;
    if (payment != null &&
        payment.status == PaymentStatusState.refundRequired) {
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
@freezed
abstract class OrderBusinessPart with _$OrderBusinessPart {
  const factory OrderBusinessPart({
    required String id,
    required String businessId,
    required String businessName,
    required BusinessOrderStatus status,
    required List<OrderItemSnapshot> items,
    required PickupStopInfo? pickupStop,
    String? rejectionReason,
  }) = _OrderBusinessPart;
}

/// Historical purchase line (§19) — current catalog edits never rewrite it.
@freezed
abstract class OrderItemSnapshot with _$OrderItemSnapshot {
  const factory OrderItemSnapshot({
    required String id,
    required String productName,
    required int unitPriceMinor,
    required int quantity,
    required int lineTotalMinor,
    String? variantName,
    @Default(0) int discountMinor,
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

@freezed
abstract class OrderDelivery with _$OrderDelivery {
  const factory OrderDelivery({required DeliveryState status})
      = _OrderDelivery;
}

@freezed
abstract class PickupStopInfo with _$PickupStopInfo {
  const factory PickupStopInfo({
    required String id,
    required int sequence,
    required PickupStopState status,
  }) = _PickupStopInfo;
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
