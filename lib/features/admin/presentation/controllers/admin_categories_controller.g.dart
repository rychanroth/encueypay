// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_categories_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminCategoriesController)
final adminCategoriesControllerProvider = AdminCategoriesControllerProvider._();

final class AdminCategoriesControllerProvider
    extends
        $AsyncNotifierProvider<AdminCategoriesController, List<AdminCategory>> {
  AdminCategoriesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminCategoriesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminCategoriesControllerHash();

  @$internal
  @override
  AdminCategoriesController create() => AdminCategoriesController();
}

String _$adminCategoriesControllerHash() =>
    r'7e7cd31f3c3b58ca78e2c5a966497686b9dd7c8a';

abstract class _$AdminCategoriesController
    extends $AsyncNotifier<List<AdminCategory>> {
  FutureOr<List<AdminCategory>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<AdminCategory>>, List<AdminCategory>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<AdminCategory>>, List<AdminCategory>>,
              AsyncValue<List<AdminCategory>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
