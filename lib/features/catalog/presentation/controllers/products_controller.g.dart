// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Product discovery with server-side search/filter/sort and offset
/// pagination. The controller instance is keyed by the INITIAL route
/// parameters; in-screen filter changes go through the methods below.

@ProviderFor(ProductsController)
final productsControllerProvider = ProductsControllerFamily._();

/// Product discovery with server-side search/filter/sort and offset
/// pagination. The controller instance is keyed by the INITIAL route
/// parameters; in-screen filter changes go through the methods below.
final class ProductsControllerProvider
    extends $AsyncNotifierProvider<ProductsController, ProductListState> {
  /// Product discovery with server-side search/filter/sort and offset
  /// pagination. The controller instance is keyed by the INITIAL route
  /// parameters; in-screen filter changes go through the methods below.
  ProductsControllerProvider._({
    required ProductsControllerFamily super.from,
    required (String?, String?) super.argument,
  }) : super(
         retry: null,
         name: r'productsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productsControllerHash();

  @override
  String toString() {
    return r'productsControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ProductsController create() => ProductsController();

  @override
  bool operator ==(Object other) {
    return other is ProductsControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productsControllerHash() =>
    r'eec0a23630f33c9557cd678560ed51ca338e666d';

/// Product discovery with server-side search/filter/sort and offset
/// pagination. The controller instance is keyed by the INITIAL route
/// parameters; in-screen filter changes go through the methods below.

final class ProductsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ProductsController,
          AsyncValue<ProductListState>,
          ProductListState,
          FutureOr<ProductListState>,
          (String?, String?)
        > {
  ProductsControllerFamily._()
    : super(
        retry: null,
        name: r'productsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Product discovery with server-side search/filter/sort and offset
  /// pagination. The controller instance is keyed by the INITIAL route
  /// parameters; in-screen filter changes go through the methods below.

  ProductsControllerProvider call(String? categoryId, String? query) =>
      ProductsControllerProvider._(argument: (categoryId, query), from: this);

  @override
  String toString() => r'productsControllerProvider';
}

/// Product discovery with server-side search/filter/sort and offset
/// pagination. The controller instance is keyed by the INITIAL route
/// parameters; in-screen filter changes go through the methods below.

abstract class _$ProductsController extends $AsyncNotifier<ProductListState> {
  late final _$args = ref.$arg as (String?, String?);
  String? get categoryId => _$args.$1;
  String? get query => _$args.$2;

  FutureOr<ProductListState> build(String? categoryId, String? query);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ProductListState>, ProductListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProductListState>, ProductListState>,
              AsyncValue<ProductListState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
