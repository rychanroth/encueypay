// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_application_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RoleApplicationController)
final roleApplicationControllerProvider = RoleApplicationControllerProvider._();

final class RoleApplicationControllerProvider
    extends
        $AsyncNotifierProvider<RoleApplicationController, RoleApplication?> {
  RoleApplicationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roleApplicationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roleApplicationControllerHash();

  @$internal
  @override
  RoleApplicationController create() => RoleApplicationController();
}

String _$roleApplicationControllerHash() =>
    r'834c5490615a937715df705d5fb067112e96846f';

abstract class _$RoleApplicationController
    extends $AsyncNotifier<RoleApplication?> {
  FutureOr<RoleApplication?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<RoleApplication?>, RoleApplication?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RoleApplication?>, RoleApplication?>,
              AsyncValue<RoleApplication?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
