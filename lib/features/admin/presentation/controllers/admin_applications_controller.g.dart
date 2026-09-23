// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_applications_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminApplicationsController)
final adminApplicationsControllerProvider =
    AdminApplicationsControllerProvider._();

final class AdminApplicationsControllerProvider
    extends
        $AsyncNotifierProvider<
          AdminApplicationsController,
          List<AdminApplication>
        > {
  AdminApplicationsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminApplicationsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminApplicationsControllerHash();

  @$internal
  @override
  AdminApplicationsController create() => AdminApplicationsController();
}

String _$adminApplicationsControllerHash() =>
    r'2dbf2305ede7fbc3a08765203ee4b9cfd9e8bb8e';

abstract class _$AdminApplicationsController
    extends $AsyncNotifier<List<AdminApplication>> {
  FutureOr<List<AdminApplication>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<AdminApplication>>, List<AdminApplication>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AdminApplication>>,
                List<AdminApplication>
              >,
              AsyncValue<List<AdminApplication>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
