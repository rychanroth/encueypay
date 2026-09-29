import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product.dart';
import '../../domain/entities/product_detail.dart';

part 'product_detail_state.freezed.dart';

/// Immutable state for the product detail screen (PRES-02). Variant selection
/// lives inside the variant picker sheet, not here.
@freezed
abstract class ProductDetailState with _$ProductDetailState {
  const factory ProductDetailState({
    required ProductDetail detail,
    @Default([]) List<Product> relatedProducts,
  }) = _ProductDetailState;
}
