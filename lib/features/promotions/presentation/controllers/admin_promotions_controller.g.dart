// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_promotions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminPromotionsController)
final adminPromotionsControllerProvider = AdminPromotionsControllerProvider._();

final class AdminPromotionsControllerProvider
    extends
        $AsyncNotifierProvider<AdminPromotionsController, List<MyPromotion>> {
  AdminPromotionsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminPromotionsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminPromotionsControllerHash();

  @$internal
  @override
  AdminPromotionsController create() => AdminPromotionsController();
}

String _$adminPromotionsControllerHash() =>
    r'efa34b8f965c9fda042c80dfb4df299d24d70569';

abstract class _$AdminPromotionsController
    extends $AsyncNotifier<List<MyPromotion>> {
  FutureOr<List<MyPromotion>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<MyPromotion>>, List<MyPromotion>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<MyPromotion>>, List<MyPromotion>>,
              AsyncValue<List<MyPromotion>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
