// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// null state = not onboarded yet → the dashboard shows the wizard
/// (Phase 6 decision: onboarding fills the CreateBusiness spec gap).

@ProviderFor(BusinessProfileController)
final businessProfileControllerProvider = BusinessProfileControllerProvider._();

/// null state = not onboarded yet → the dashboard shows the wizard
/// (Phase 6 decision: onboarding fills the CreateBusiness spec gap).
final class BusinessProfileControllerProvider
    extends
        $AsyncNotifierProvider<BusinessProfileController, BusinessProfile?> {
  /// null state = not onboarded yet → the dashboard shows the wizard
  /// (Phase 6 decision: onboarding fills the CreateBusiness spec gap).
  BusinessProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessProfileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessProfileControllerHash();

  @$internal
  @override
  BusinessProfileController create() => BusinessProfileController();
}

String _$businessProfileControllerHash() =>
    r'b544d23a019d422ba5f90c9cdfca0d2b02b947dc';

/// null state = not onboarded yet → the dashboard shows the wizard
/// (Phase 6 decision: onboarding fills the CreateBusiness spec gap).

abstract class _$BusinessProfileController
    extends $AsyncNotifier<BusinessProfile?> {
  FutureOr<BusinessProfile?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<BusinessProfile?>, BusinessProfile?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BusinessProfile?>, BusinessProfile?>,
              AsyncValue<BusinessProfile?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
