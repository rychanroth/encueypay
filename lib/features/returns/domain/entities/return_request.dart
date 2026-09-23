/// Customer return request (spec §28): multiple items from one order,
/// quantities capped at purchased, business decides the outcome (§28.1).
class ReturnRequest {
  const ReturnRequest({
    required this.id,
    required this.orderId,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  final String id;
  final String orderId;
  final ReturnStatus status;
  final DateTime createdAt;
  final List<ReturnItemInfo> items;
}

class ReturnItemInfo {
  const ReturnItemInfo({
    required this.id,
    required this.orderItemId,
    required this.quantity,
    required this.reason,
    required this.productName,
  });

  final String id;
  final String orderItemId;
  final int quantity;
  final String reason;
  final String productName;
}

/// An order line offered for return in the request form.
class ReturnableItem {
  const ReturnableItem({
    required this.orderItemId,
    required this.productName,
    required this.purchasedQuantity,
    this.variantName,
  });

  final String orderItemId;
  final String productName;
  final String? variantName;
  final int purchasedQuantity;
}

/// Input shape for a requested return line.
class ReturnItemDraft {
  const ReturnItemDraft({
    required this.orderItemId,
    required this.quantity,
    required this.reason,
  });

  final String orderItemId;
  final int quantity;
  final String reason;
}

enum ReturnStatus {
  pending,
  approved,
  rejected;

  static ReturnStatus fromName(String? name) =>
      ReturnStatus.values.asNameMap()[name] ?? ReturnStatus.pending;
}
