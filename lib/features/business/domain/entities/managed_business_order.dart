/// A business order as seen by its business (spec §11): its own lifecycle,
/// processed independently of sibling business orders.
class ManagedBusinessOrder {
  const ManagedBusinessOrder({
    required this.id,
    required this.orderId,
    required this.customerName,
    required this.status,
    required this.subtotalMinor,
    required this.discountMinor,
    required this.createdAt,
    required this.items,
    this.rejectionReason,
  });

  final String id;
  final String orderId;
  final String customerName;
  final ManagedOrderStatus status;
  final String? rejectionReason;
  final int subtotalMinor;
  final int discountMinor;
  final DateTime createdAt;
  final List<ManagedOrderItem> items;

  bool get canAccept => status == ManagedOrderStatus.pending;
  bool get canReject => status == ManagedOrderStatus.pending;
  bool get canPrepare => status == ManagedOrderStatus.accepted;
  bool get canMarkReady => status == ManagedOrderStatus.preparing;
}

class ManagedOrderItem {
  const ManagedOrderItem({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.lineTotalMinor,
    this.variantName,
  });

  final String id;
  final String productName;
  final String? variantName;
  final int quantity;
  final int lineTotalMinor;
}

enum ManagedOrderStatus {
  pending,
  accepted,
  rejected,
  preparing,
  ready,
  completed,
  cancelled;

  static ManagedOrderStatus fromName(String? name) =>
      ManagedOrderStatus.values.asNameMap()[name] ?? ManagedOrderStatus.pending;
}
