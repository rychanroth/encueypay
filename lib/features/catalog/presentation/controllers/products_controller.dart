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
  Future<ProductListState> build(
    String? categoryId,
    String? query,
    String? brandId,
  ) async {
    return _fetch(
      ProductListState.initial(
        categoryId: categoryId,
        query: query,
        brandId: brandId,
      ),
    );
  }

  Future<ProductListState> _fetch(ProductListState listState) async {
    final page = await ref.read(catalogRepositoryProvider).fetchProducts(
          query: listState.query,
          categoryId: listState.categoryId,
          brandId: listState.brandId,
          sort: listState.sort,
          limit: _pageSize,
          offset: listState.items.length,
        );
    return ProductListState(
      items: [...listState.items, ...page],
      hasMore: page.length == _pageSize,
      query: listState.query,
      categoryId: listState.categoryId,
      brandId: listState.brandId,
      sort: listState.sort,
    );
  }

  Future<void> setQuery(String query) => _reset(
      query: query,
      categoryId: _base.categoryId,
      brandId: _base.brandId,
      sort: _base.sort);

  /// Passing null clears the category filter — the "All" chip.
  Future<void> setCategory(String? categoryId) => _reset(
      query: _base.query,
      categoryId: categoryId,
      brandId: _base.brandId,
      sort: _base.sort);

  /// Passing null clears the brand filter — the "All" chip (assignment §2).
  Future<void> setBrand(String? brandId) => _reset(
      query: _base.query,
      categoryId: _base.categoryId,
      brandId: brandId,
      sort: _base.sort);

  Future<void> setSort(ProductSort sort) => _reset(
      query: _base.query,
      categoryId: _base.categoryId,
      brandId: _base.brandId,
      sort: sort);

  /// Filters as of the last completed fetch, or the route-seeded defaults.
  /// [state.value] is null while the initial fetch is in flight and after an
  /// error — falling back to the build seed keeps the chips responsive in
  /// both cases instead of silently dropping taps.
  ProductListState get _base =>
      state.value ??
      ProductListState.initial(
        categoryId: categoryId,
        query: query,
        brandId: brandId,
      );

  /// Re-fetch page 0 with a fully-resolved filter set. Parameters are the NEW
  /// values for every filter — a null [categoryId]/[brandId] here means "no
  /// filter", never "keep the current one".
  Future<void> _reset({
    required String? query,
    required String? categoryId,
    required String? brandId,
    required ProductSort sort,
  }) async {
    state = await AsyncValue.guard(
      () => _fetch(ProductListState.initial(
        query: query,
        categoryId: categoryId,
        brandId: brandId,
        sort: sort,
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
