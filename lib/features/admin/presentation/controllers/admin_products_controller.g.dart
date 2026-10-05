// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_products_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Admin product catalog (Section 2b, spec §8 "manages Products"): all
/// statuses, name search, archive/activate, and the draft mutations backing
/// the product form. List is capped at 100 rows — prototype scale.

@ProviderFor(AdminProductsController)
final adminProductsControllerProvider = AdminProductsControllerFamily._();

/// Admin product catalog (Section 2b, spec §8 "manages Products"): all
/// statuses, name search, archive/activate, and the draft mutations backing
/// the product form. List is capped at 100 rows — prototype scale.
final class AdminProductsControllerProvider
    extends
        $AsyncNotifierProvider<
          AdminProductsController,
          List<AdminProductSummary>
        > {
  /// Admin product catalog (Section 2b, spec §8 "manages Products"): all
  /// statuses, name search, archive/activate, and the draft mutations backing
  /// the product form. List is capped at 100 rows — prototype scale.
  AdminProductsControllerProvider._({
    required AdminProductsControllerFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'adminProductsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminProductsControllerHash();

  @override
  String toString() {
    return r'adminProductsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AdminProductsController create() => AdminProductsController();

  @override
  bool operator ==(Object other) {
    return other is AdminProductsControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminProductsControllerHash() =>
    r'b4b2f1809ccc77bd9c51c602a52485a7dc6de4fc';

/// Admin product catalog (Section 2b, spec §8 "manages Products"): all
/// statuses, name search, archive/activate, and the draft mutations backing
/// the product form. List is capped at 100 rows — prototype scale.

final class AdminProductsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AdminProductsController,
          AsyncValue<List<AdminProductSummary>>,
          List<AdminProductSummary>,
          FutureOr<List<AdminProductSummary>>,
          String?
        > {
  AdminProductsControllerFamily._()
    : super(
        retry: null,
        name: r'adminProductsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Admin product catalog (Section 2b, spec §8 "manages Products"): all
  /// statuses, name search, archive/activate, and the draft mutations backing
  /// the product form. List is capped at 100 rows — prototype scale.

  AdminProductsControllerProvider call(String? query) =>
      AdminProductsControllerProvider._(argument: query, from: this);

  @override
  String toString() => r'adminProductsControllerProvider';
}

/// Admin product catalog (Section 2b, spec §8 "manages Products"): all
/// statuses, name search, archive/activate, and the draft mutations backing
/// the product form. List is capped at 100 rows — prototype scale.

abstract class _$AdminProductsController
    extends $AsyncNotifier<List<AdminProductSummary>> {
  late final _$args = ref.$arg as String?;
  String? get query => _$args;

  FutureOr<List<AdminProductSummary>> build(String? query);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<AdminProductSummary>>,
              List<AdminProductSummary>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AdminProductSummary>>,
                List<AdminProductSummary>
              >,
              AsyncValue<List<AdminProductSummary>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Slim business references for the product form's store picker.

@ProviderFor(adminActiveBusinesses)
final adminActiveBusinessesProvider = AdminActiveBusinessesProvider._();

/// Slim business references for the product form's store picker.

final class AdminActiveBusinessesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AdminBusinessRef>>,
          List<AdminBusinessRef>,
          FutureOr<List<AdminBusinessRef>>
        >
    with
        $FutureModifier<List<AdminBusinessRef>>,
        $FutureProvider<List<AdminBusinessRef>> {
  /// Slim business references for the product form's store picker.
  AdminActiveBusinessesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminActiveBusinessesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminActiveBusinessesHash();

  @$internal
  @override
  $FutureProviderElement<List<AdminBusinessRef>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AdminBusinessRef>> create(Ref ref) {
    return adminActiveBusinesses(ref);
  }
}

String _$adminActiveBusinessesHash() =>
    r'03f163a8c6267c75500788bad82e49fae88652ac';
