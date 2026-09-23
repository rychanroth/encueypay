// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminSettingsController)
final adminSettingsControllerProvider = AdminSettingsControllerProvider._();

final class AdminSettingsControllerProvider
    extends $AsyncNotifierProvider<AdminSettingsController, PlatformSettings> {
  AdminSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminSettingsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminSettingsControllerHash();

  @$internal
  @override
  AdminSettingsController create() => AdminSettingsController();
}

String _$adminSettingsControllerHash() =>
    r'c43b4fbca62ad965446373c5ee0965bf73206b38';

abstract class _$AdminSettingsController
    extends $AsyncNotifier<PlatformSettings> {
  FutureOr<PlatformSettings> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<PlatformSettings>, PlatformSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlatformSettings>, PlatformSettings>,
              AsyncValue<PlatformSettings>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
