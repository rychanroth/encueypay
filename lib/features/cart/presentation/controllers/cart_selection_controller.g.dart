// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_selection_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tick state for the Taobao-style cart (PRES-02). Selection is presentation
/// state only: lines are priced and sent to checkout by id, and the server
/// stays authoritative for what an order contains.
///
/// Implemented as "everything is selected except these ids" so a line added
/// from another tab arrives ticked, and so a server refetch does not silently
/// reselect lines the customer unticked.

@ProviderFor(CartSelectionController)
final cartSelectionControllerProvider = CartSelectionControllerProvider._();

/// Tick state for the Taobao-style cart (PRES-02). Selection is presentation
/// state only: lines are priced and sent to checkout by id, and the server
/// stays authoritative for what an order contains.
///
/// Implemented as "everything is selected except these ids" so a line added
/// from another tab arrives ticked, and so a server refetch does not silently
/// reselect lines the customer unticked.
final class CartSelectionControllerProvider
    extends $NotifierProvider<CartSelectionController, CartSelectionState> {
  /// Tick state for the Taobao-style cart (PRES-02). Selection is presentation
  /// state only: lines are priced and sent to checkout by id, and the server
  /// stays authoritative for what an order contains.
  ///
  /// Implemented as "everything is selected except these ids" so a line added
  /// from another tab arrives ticked, and so a server refetch does not silently
  /// reselect lines the customer unticked.
  CartSelectionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartSelectionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartSelectionControllerHash();

  @$internal
  @override
  CartSelectionController create() => CartSelectionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CartSelectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CartSelectionState>(value),
    );
  }
}

String _$cartSelectionControllerHash() =>
    r'440c16c0e586c9660352fa88265fbb59843a7ba4';

/// Tick state for the Taobao-style cart (PRES-02). Selection is presentation
/// state only: lines are priced and sent to checkout by id, and the server
/// stays authoritative for what an order contains.
///
/// Implemented as "everything is selected except these ids" so a line added
/// from another tab arrives ticked, and so a server refetch does not silently
/// reselect lines the customer unticked.

abstract class _$CartSelectionController extends $Notifier<CartSelectionState> {
  CartSelectionState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CartSelectionState, CartSelectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CartSelectionState, CartSelectionState>,
              CartSelectionState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
