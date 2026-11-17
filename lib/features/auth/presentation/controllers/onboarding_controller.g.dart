// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the final onboarding step. The write is server-confirmed before the
/// session state is updated (PRES-03): the router only leaves `/onboarding`
/// once `onboarded_at` is actually set.

@ProviderFor(OnboardingController)
final onboardingControllerProvider = OnboardingControllerProvider._();

/// Drives the final onboarding step. The write is server-confirmed before the
/// session state is updated (PRES-03): the router only leaves `/onboarding`
/// once `onboarded_at` is actually set.
final class OnboardingControllerProvider
    extends $AsyncNotifierProvider<OnboardingController, void> {
  /// Drives the final onboarding step. The write is server-confirmed before the
  /// session state is updated (PRES-03): the router only leaves `/onboarding`
  /// once `onboarded_at` is actually set.
  OnboardingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingControllerHash();

  @$internal
  @override
  OnboardingController create() => OnboardingController();
}

String _$onboardingControllerHash() =>
    r'66474447cbfc7f6cbb3f5b99c5181d6d9fad7635';

/// Drives the final onboarding step. The write is server-confirmed before the
/// session state is updated (PRES-03): the router only leaves `/onboarding`
/// once `onboarded_at` is actually set.

abstract class _$OnboardingController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
