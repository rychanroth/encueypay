import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/catalog_repository_impl.dart';
import '../../domain/entities/active_promo.dart';
import '../../domain/entities/product.dart';

part 'promo_chip_providers.g.dart';

/// One shared fetch of coupon-backed, chip-worthy promotions (Section 9) —
/// every ProductCard and the product detail price block consume this single
/// provider instead of querying per card.
@riverpod
Future<List<ActivePromo>> activePromotions(Ref ref) {
  return ref.watch(catalogRepositoryProvider).fetchActivePromotions();
}

/// The promotion to advertise for [product]: brand-scoped wins over
/// platform (more specific); null → no chip.
ActivePromo? promoForProduct(List<ActivePromo> promos, Product product) {
  for (final promo in promos) {
    if (promo.scope == CatalogPromoScope.brand &&
        promo.brandId == product.brandId) {
      return promo;
    }
  }
  for (final promo in promos) {
    if (promo.scope == CatalogPromoScope.platform) {
      return promo;
    }
  }
  return null;
}
