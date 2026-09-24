import 'package:freezed_annotation/freezed_annotation.dart';

part 'managed_business_order.freezed.dart';

/// A business order as seen by its business (spec §11): its own lifecycle,
/// processed independently of sibling business orders.
@freezed
abstract class ManagedBusinessOrder with _$ManagedBusinessOrder {
  const factory ManagedBusinessOrder({
    required String id,
    required String orderId,
    required String customerName,
    required ManagedOrderStatus status,
    required int subtotalMinor,
    required int discountMinor,
    required DateTime createdAt,
    required List<ManagedOrderItem> items,
    String? rejectionReason,
  }) = _ManagedBusinessOrder;

  const ManagedBusinessOrder._();

  bool get canAccept => status == ManagedOrderStatus.pending;
  bool get canReject => status == ManagedOrderStatus.pending;
  bool get canPrepare => status == ManagedOrderStatus.accepted;
  bool get canMarkReady => status == ManagedOrderStatus.preparing;
}

@freezed
abstract class ManagedOrderItem with _$ManagedOrderItem {
  const factory ManagedOrderItem({
    required String id,
    required String productName,
    required int quantity,
    required int lineTotalMinor,
    String? variantName,
  }) = _ManagedOrderItem;
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
      ManagedOrderStatus.values.asNameMap()[name] ??
      ManagedOrderStatus.pending;
}
