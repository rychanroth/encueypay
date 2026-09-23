import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/catalog_repository_impl.dart';
import '../states/product_detail_state.dart';

part 'product_detail_controller.g.dart';

@riverpod
class ProductDetailController extends _$ProductDetailController {
  @override
  Future<ProductDetailState> build(String productId) async {
    final repository = ref.watch(catalogRepositoryProvider);
    final detail =
        await repository.fetchProductDetail(productId);
    final related = await repository.fetchRelatedProducts(
      categoryId: detail.product.categoryId,
      excludeProductId: detail.product.id,
    );
    return ProductDetailState(detail: detail, relatedProducts: related);
  }

  /// UI-only selection change — no backend mutation involved, so a plain
  /// state update is correct here (PRES-03 governs *mutations*).
  void selectVariant(String? variantId) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(selectedVariantId: variantId));
  }
}
