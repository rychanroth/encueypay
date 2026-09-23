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

/// Server-computed analytics (§58) — plain one-shot fetch consumed
/// directly by the dashboard (DOMAIN-03).

@ProviderFor(businessAnalytics)
final businessAnalyticsProvider = BusinessAnalyticsProvider._();

/// Server-computed analytics (§58) — plain one-shot fetch consumed
/// directly by the dashboard (DOMAIN-03).

final class BusinessAnalyticsProvider
    extends
        $FunctionalProvider<
          AsyncValue<BusinessAnalytics>,
          BusinessAnalytics,
          FutureOr<BusinessAnalytics>
        >
    with
        $FutureModifier<BusinessAnalytics>,
        $FutureProvider<BusinessAnalytics> {
  /// Server-computed analytics (§58) — plain one-shot fetch consumed
  /// directly by the dashboard (DOMAIN-03).
  BusinessAnalyticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessAnalyticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessAnalyticsHash();

  @$internal
  @override
  $FutureProviderElement<BusinessAnalytics> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BusinessAnalytics> create(Ref ref) {
    return businessAnalytics(ref);
  }
}

String _$businessAnalyticsHash() => r'45c2c3d72311210b0b7a2e558033f9beacad20e6';
