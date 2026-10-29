import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/catalog_repository_impl.dart';
import '../../domain/entities/active_sale.dart';
import '../../domain/entities/product.dart';

part 'sale_providers.g.dart';

/// One shared fetch of live sales (the `active_sales` view — active and
/// in-window by definition, so the window logic exists only in SQL). Every
/// price surface consumes this single provider instead of querying per
/// card.
@riverpod
Future<List<ActiveSale>> activeSales(Ref ref) {
  return ref.watch(catalogRepositoryProvider).fetchActiveSales();
}

/// The sale that sets [priceMinor] for a product identity: applicable =
/// platform, or the product's brand, or its category. When several apply,
/// the one with the lowest resulting price wins ("higher discount wins" —
/// which also compares percent against dollar amounts by outcome).
ActiveSale? saleForIds(
  List<ActiveSale> sales, {
  String? brandId,
  String? categoryId,
  required int priceMinor,
}) {
  ActiveSale? best;
  var bestPrice = priceMinor;
  for (final sale in sales) {
    final applies = switch (sale.scope) {
      CatalogSaleScope.platform => true,
      CatalogSaleScope.brand => sale.brandId != null && sale.brandId == brandId,
      CatalogSaleScope.category =>
        sale.categoryId != null && sale.categoryId == categoryId,
    };
    if (!applies) continue;
    final price = sale.priceMinorFor(priceMinor);
    if (price < bestPrice) {
      bestPrice = price;
      best = sale;
    }
  }
  return best;
}

/// Convenience over the product's ids for product surfaces.
ActiveSale? saleForProduct(List<ActiveSale> sales, Product product) =>
    saleForIds(
      sales,
      brandId: product.brandId,
      categoryId: product.categoryId,
      priceMinor: product.fromPriceMinor,
    );

/// The unit price to display under [sale] — the sale price when one
/// applies, otherwise the input price. Card, detail, sheet and the
/// composition root's cart pricing all go through this one helper so the
/// display rule can't drift between surfaces.
int displayPriceMinor(ActiveSale? sale, int priceMinor) =>
    sale == null ? priceMinor : sale.priceMinorFor(priceMinor);
