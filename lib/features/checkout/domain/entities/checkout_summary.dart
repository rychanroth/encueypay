import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkout_summary.freezed.dart';

/// Checkout read model (spec §23): server-derived itemization and totals.
/// These are display previews — the server recalculates authoritatively
/// inside create_order_from_cart (§25/§53).
@freezed
abstract class CheckoutItem with _$CheckoutItem {
  const factory CheckoutItem({
    required String id,
    required String productName,
    required int unitPriceMinor,
    required int quantity,
    String? variantName,
  }) = _CheckoutItem;

  const CheckoutItem._();

  int get lineTotalMinor => unitPriceMinor * quantity;
}

@freezed
abstract class CheckoutSummary with _$CheckoutSummary {
  const factory CheckoutSummary({
    required List<CheckoutItem> items,
    required int subtotalMinor,
    required int deliveryFeeMinor,
  }) = _CheckoutSummary;

  const CheckoutSummary._();

  int get totalMinor => subtotalMinor + deliveryFeeMinor;
}
