// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Plain one-shot fetch + mutation — controllers MAY call the repository
/// directly for fetches (DOMAIN-03). Mutations follow PRES-03.

@ProviderFor(ProfileController)
final profileControllerProvider = ProfileControllerProvider._();

/// Plain one-shot fetch + mutation — controllers MAY call the repository
/// directly for fetches (DOMAIN-03). Mutations follow PRES-03.
final class ProfileControllerProvider
    extends $AsyncNotifierProvider<ProfileController, UserProfile> {
  /// Plain one-shot fetch + mutation — controllers MAY call the repository
  /// directly for fetches (DOMAIN-03). Mutations follow PRES-03.
  ProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileControllerHash();

  @$internal
  @override
  ProfileController create() => ProfileController();
}

String _$profileControllerHash() => r'75cb2306f93f58034afb3d3fb2262e05196ee245';

/// Plain one-shot fetch + mutation — controllers MAY call the repository
/// directly for fetches (DOMAIN-03). Mutations follow PRES-03.

abstract class _$ProfileController extends $AsyncNotifier<UserProfile> {
  FutureOr<UserProfile> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserProfile>, UserProfile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserProfile>, UserProfile>,
              AsyncValue<UserProfile>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
