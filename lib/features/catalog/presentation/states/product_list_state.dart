import '../../domain/entities/product.dart';
import '../../domain/entities/product_sort.dart';

/// Immutable state for product discovery (PRES-02): items + pagination +
/// active filters. Filter changes build a fresh state via the constructor;
/// [copyWith] covers the non-nullable pagination fields.
class ProductListState {
  const ProductListState({
    required this.items,
    required this.hasMore,
    this.isLoadingMore = false,
    this.query,
    this.categoryId,
    this.sort = ProductSort.newest,
  });

  const ProductListState.initial({
    this.query,
    this.categoryId,
    this.sort = ProductSort.newest,
  })  : items = const [],
        hasMore = true,
        isLoadingMore = false;

  final List<Product> items;
  final bool hasMore;
  final bool isLoadingMore;
  final String? query;
  final String? categoryId;
  final ProductSort sort;

  ProductListState copyWith({
    List<Product>? items,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ProductListState(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      query: query,
      categoryId: categoryId,
      sort: sort,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductListState &&
          other.items.length == items.length &&
          other.hasMore == hasMore &&
          other.isLoadingMore == isLoadingMore &&
          other.query == query &&
          other.categoryId == categoryId &&
          other.sort == sort;

  @override
  int get hashCode => Object.hash(items.length, hasMore, isLoadingMore, query, categoryId, sort);
}
