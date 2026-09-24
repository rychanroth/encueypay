import 'package:freezed_annotation/freezed_annotation.dart';

part 'return_request.freezed.dart';

/// Customer return request (spec §28): multiple items from one order,
/// quantities capped at purchased, business decides the outcome (§28.1).
@freezed
abstract class ReturnRequest with _$ReturnRequest {
  const factory ReturnRequest({
    required String id,
    required String orderId,
    required ReturnStatus status,
    required DateTime createdAt,
    required List<ReturnItemInfo> items,
  }) = _ReturnRequest;
}

@freezed
abstract class ReturnItemInfo with _$ReturnItemInfo {
  const factory ReturnItemInfo({
    required String id,
    required String orderItemId,
    required int quantity,
    required String reason,
    required String productName,
  }) = _ReturnItemInfo;
}

/// An order line offered for return in the request form.
@freezed
abstract class ReturnableItem with _$ReturnableItem {
  const factory ReturnableItem({
    required String orderItemId,
    required String productName,
    required int purchasedQuantity,
    String? variantName,
  }) = _ReturnableItem;
}

/// Input shape for a requested return line.
@freezed
abstract class ReturnItemDraft with _$ReturnItemDraft {
  const factory ReturnItemDraft({
    required String orderItemId,
    required int quantity,
    required String reason,
  }) = _ReturnItemDraft;
}

enum ReturnStatus {
  pending,
  approved,
  rejected;

  static ReturnStatus fromName(String? name) =>
      ReturnStatus.values.asNameMap()[name] ?? ReturnStatus.pending;
}
