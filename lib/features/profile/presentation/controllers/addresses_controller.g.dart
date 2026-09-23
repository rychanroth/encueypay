// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addresses_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Address book list + mutations. No optimistic UI: mutations persist via
/// the repository, then `ref.invalidateSelf()` refetches ground truth
/// (PRES-03).

@ProviderFor(AddressesController)
final addressesControllerProvider = AddressesControllerProvider._();

/// Address book list + mutations. No optimistic UI: mutations persist via
/// the repository, then `ref.invalidateSelf()` refetches ground truth
/// (PRES-03).
final class AddressesControllerProvider
    extends $AsyncNotifierProvider<AddressesController, List<Address>> {
  /// Address book list + mutations. No optimistic UI: mutations persist via
  /// the repository, then `ref.invalidateSelf()` refetches ground truth
  /// (PRES-03).
  AddressesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addressesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addressesControllerHash();

  @$internal
  @override
  AddressesController create() => AddressesController();
}

String _$addressesControllerHash() =>
    r'027a52e758459e6f3d4cf61289fc10f7ad5a13f7';

/// Address book list + mutations. No optimistic UI: mutations persist via
/// the repository, then `ref.invalidateSelf()` refetches ground truth
/// (PRES-03).

abstract class _$AddressesController extends $AsyncNotifier<List<Address>> {
  FutureOr<List<Address>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Address>>, List<Address>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Address>>, List<Address>>,
              AsyncValue<List<Address>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
