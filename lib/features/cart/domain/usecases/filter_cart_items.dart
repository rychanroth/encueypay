import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/cart_item.dart';
import '../entities/cart_view.dart';

/// Cart browsing rules (DOMAIN-03: real filtering/sorting logic, not a
/// wrapper around a fetch): keyword search over product/variant names, the
/// sale/availability filter chips, and the sort order. Pure and synchronous —
/// the cart is fully loaded, so no server round-trip is involved.
class FilterCartItemsUseCase {
  const FilterCartItemsUseCase();

  List<CartItem> call({
    required List<CartItem> items,
    CartFilter filter = CartFilter.all,
    CartSort sort = CartSort.newest,
    String query = '',
  }) {
    final needle = query.trim().toLowerCase();
    final filtered = items.where((item) {
      final matchesFilter = switch (filter) {
        CartFilter.all => true,
        CartFilter.onSale => item.hasSale,
        // Stock is product-wide (Section 6): zero means the line can no
        // longer be bought.
        CartFilter.soldOut => item.stock <= 0,
      };
      if (!matchesFilter) return false;
      if (needle.isEmpty) return true;
      final name = item.productName.toLowerCase();
      final variant = item.variantName?.toLowerCase() ?? '';
      return name.contains(needle) || variant.contains(needle);
    }).toList();

    switch (sort) {
      case CartSort.newest:
        filtered.sort(_byNewest);
      case CartSort.priceLowHigh:
        filtered.sort(
          (a, b) =>
              a.effectiveUnitPriceMinor.compareTo(b.effectiveUnitPriceMinor),
        );
      case CartSort.priceHighLow:
        filtered.sort(
          (a, b) =>
              b.effectiveUnitPriceMinor.compareTo(a.effectiveUnitPriceMinor),
        );
      case CartSort.name:
        filtered.sort(
          (a, b) => a.productName.toLowerCase().compareTo(
            b.productName.toLowerCase(),
          ),
        );
    }
    return filtered;
  }

  /// Most recently added first. Lines without a timestamp keep their
  /// server order (`created_at` ascending) at the end of the list.
  static int _byNewest(CartItem a, CartItem b) {
    final first = a.createdAt;
    final second = b.createdAt;
    if (first == null && second == null) return 0;
    if (first == null) return 1;
    if (second == null) return -1;
    return second.compareTo(first);
  }
}

final filterCartItemsUseCaseProvider = Provider<FilterCartItemsUseCase>(
  (ref) => const FilterCartItemsUseCase(),
);
