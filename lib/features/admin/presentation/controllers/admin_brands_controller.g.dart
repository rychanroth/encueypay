// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_brands_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Brand management (Section 2b, assignment §2/§3): list + create + edit +
/// archive/activate + delete. Mutations persist-then-invalidate (PRES-03).

@ProviderFor(AdminBrandsController)
final adminBrandsControllerProvider = AdminBrandsControllerProvider._();

/// Brand management (Section 2b, assignment §2/§3): list + create + edit +
/// archive/activate + delete. Mutations persist-then-invalidate (PRES-03).
final class AdminBrandsControllerProvider
    extends $AsyncNotifierProvider<AdminBrandsController, List<AdminBrand>> {
  /// Brand management (Section 2b, assignment §2/§3): list + create + edit +
  /// archive/activate + delete. Mutations persist-then-invalidate (PRES-03).
  AdminBrandsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminBrandsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminBrandsControllerHash();

  @$internal
  @override
  AdminBrandsController create() => AdminBrandsController();
}

String _$adminBrandsControllerHash() =>
    r'ce55afd69130e696886ac530fa1406aa796a114f';

/// Brand management (Section 2b, assignment §2/§3): list + create + edit +
/// archive/activate + delete. Mutations persist-then-invalidate (PRES-03).

abstract class _$AdminBrandsController
    extends $AsyncNotifier<List<AdminBrand>> {
  FutureOr<List<AdminBrand>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<AdminBrand>>, List<AdminBrand>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<AdminBrand>>, List<AdminBrand>>,
              AsyncValue<List<AdminBrand>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
