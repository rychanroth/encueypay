/// Checkout read model (spec §23): server-derived itemization and totals.
/// These are display previews — the server recalculates authoritatively
/// inside create_order_from_cart (§25/§53).
class CheckoutItem {
  const CheckoutItem({
    required this.id,
    required this.productName,
    required this.businessName,
    required this.unitPriceMinor,
    required this.quantity,
    this.variantName,
  });

  final String id;
  final String productName;
  final String? variantName;
  final String businessName;
  final int unitPriceMinor;
  final int quantity;

  int get lineTotalMinor => unitPriceMinor * quantity;
}

class CheckoutSummary {
  const CheckoutSummary({
    required this.items,
    required this.subtotalMinor,
    required this.deliveryFeeMinor,
  });

  final List<CheckoutItem> items;
  final int subtotalMinor;
  final int deliveryFeeMinor;

  int get totalMinor => subtotalMinor + deliveryFeeMinor;
}
