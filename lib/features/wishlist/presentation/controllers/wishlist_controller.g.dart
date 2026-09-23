// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WishlistController)
final wishlistControllerProvider = WishlistControllerProvider._();

final class WishlistControllerProvider
    extends $AsyncNotifierProvider<WishlistController, List<WishlistItem>> {
  WishlistControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wishlistControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wishlistControllerHash();

  @$internal
  @override
  WishlistController create() => WishlistController();
}

String _$wishlistControllerHash() =>
    r'934e42fcfea3d3790853acb099871a42782d9595';

abstract class _$WishlistController extends $AsyncNotifier<List<WishlistItem>> {
  FutureOr<List<WishlistItem>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<WishlistItem>>, List<WishlistItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<WishlistItem>>, List<WishlistItem>>,
              AsyncValue<List<WishlistItem>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
