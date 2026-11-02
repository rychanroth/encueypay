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

    /// Variant price (or product base) — the "was" price when a sale applies.
    required int unitPriceMinor,

    /// Server-computed sale price for this line.
    required int saleUnitPriceMinor,
    required int quantity,
    String? variantName,
    String? imageUrl,
  }) = _CheckoutItem;

  const CheckoutItem._();

  bool get hasSale => saleUnitPriceMinor < unitPriceMinor;

  int get effectiveUnitPriceMinor => saleUnitPriceMinor;

  int get lineTotalMinor => saleUnitPriceMinor * quantity;
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
