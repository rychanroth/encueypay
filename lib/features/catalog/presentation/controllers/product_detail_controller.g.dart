// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProductDetailController)
final productDetailControllerProvider = ProductDetailControllerFamily._();

final class ProductDetailControllerProvider
    extends
        $AsyncNotifierProvider<ProductDetailController, ProductDetailState> {
  ProductDetailControllerProvider._({
    required ProductDetailControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productDetailControllerHash();

  @override
  String toString() {
    return r'productDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProductDetailController create() => ProductDetailController();

  @override
  bool operator ==(Object other) {
    return other is ProductDetailControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productDetailControllerHash() =>
    r'8e99fa1e7af11d7a06908ceec10eb10f77df7614';

final class ProductDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ProductDetailController,
          AsyncValue<ProductDetailState>,
          ProductDetailState,
          FutureOr<ProductDetailState>,
          String
        > {
  ProductDetailControllerFamily._()
    : super(
        retry: null,
        name: r'productDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductDetailControllerProvider call(String productId) =>
      ProductDetailControllerProvider._(argument: productId, from: this);

  @override
  String toString() => r'productDetailControllerProvider';
}

abstract class _$ProductDetailController
    extends $AsyncNotifier<ProductDetailState> {
  late final _$args = ref.$arg as String;
  String get productId => _$args;

  FutureOr<ProductDetailState> build(String productId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ProductDetailState>, ProductDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProductDetailState>, ProductDetailState>,
              AsyncValue<ProductDetailState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
