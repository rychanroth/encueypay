// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_products_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminProductsFilterController)
final adminProductsFilterControllerProvider =
    AdminProductsFilterControllerProvider._();

final class AdminProductsFilterControllerProvider
    extends
        $NotifierProvider<AdminProductsFilterController, AdminProductsState> {
  AdminProductsFilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminProductsFilterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminProductsFilterControllerHash();

  @$internal
  @override
  AdminProductsFilterController create() => AdminProductsFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminProductsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminProductsState>(value),
    );
  }
}

String _$adminProductsFilterControllerHash() =>
    r'a4f12605eadb42fdb71e1ca3d4962285cd3d2f08';

abstract class _$AdminProductsFilterController
    extends $Notifier<AdminProductsState> {
  AdminProductsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AdminProductsState, AdminProductsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AdminProductsState, AdminProductsState>,
              AdminProductsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

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
    r'23d3485a54983231fe1cd01a5a580765c708790f';

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
