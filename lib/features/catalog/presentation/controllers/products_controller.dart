import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/catalog_repository_impl.dart';
import '../../domain/entities/product_sort.dart';
import '../states/product_list_state.dart';

part 'products_controller.g.dart';

/// Product discovery with server-side search/filter/sort and offset
/// pagination. The controller instance is keyed by the INITIAL route
/// parameters; in-screen filter changes go through the methods below.
@riverpod
class ProductsController extends _$ProductsController {
  static const _pageSize = 20;

  @override
  Future<ProductListState> build(String? categoryId, String? query) async {
    return _fetch(
      ProductListState.initial(categoryId: categoryId, query: query),
    );
  }

  Future<ProductListState> _fetch(ProductListState listState) async {
    final page = await ref.read(catalogRepositoryProvider).fetchProducts(
          query: listState.query,
          categoryId: listState.categoryId,
          sort: listState.sort,
          limit: _pageSize,
          offset: listState.items.length,
        );
    return ProductListState(
      items: [...listState.items, ...page],
      hasMore: page.length == _pageSize,
      query: listState.query,
      categoryId: listState.categoryId,
      sort: listState.sort,
    );
  }

  Future<void> setQuery(String query) => _resetWith(query: query);

  Future<void> setCategory(String? categoryId) =>
      _resetWith(categoryId: categoryId);

  Future<void> setSort(ProductSort sort) => _resetWith(sort: sort);

  /// Re-fetch from page 0 with the new filter set.
  Future<void> _resetWith({
    String? query,
    String? categoryId,
    ProductSort? sort,
  }) async {
    final current = state.value;
    if (current == null) return;
    state = await AsyncValue.guard(
      () => _fetch(ProductListState.initial(
        query: query ?? current.query,
        categoryId: categoryId ?? current.categoryId,
        sort: sort ?? current.sort,
      )),
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;
    state = await AsyncValue.guard(
      () => _fetch(current.copyWith(isLoadingMore: true)),
    );
  }
}
