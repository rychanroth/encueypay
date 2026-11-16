import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/cart_item.dart';
import '../states/cart_selection_state.dart';
import 'cart_controller.dart';

part 'cart_selection_controller.g.dart';

/// Tick state for the Taobao-style cart (PRES-02). Selection is presentation
/// state only: lines are priced and sent to checkout by id, and the server
/// stays authoritative for what an order contains.
///
/// Implemented as "everything is selected except these ids" so a line added
/// from another tab arrives ticked, and so a server refetch does not silently
/// reselect lines the customer unticked.
@riverpod
class CartSelectionController extends _$CartSelectionController {
  Set<String> _excluded = <String>{};

  @override
  CartSelectionState build() {
    final items = ref.watch(cartControllerProvider).value ?? const <CartItem>[];
    final available = {for (final item in items) item.id};
    // Exclusions only make sense for lines still in the cart.
    _excluded = _excluded.intersection(available);
    return CartSelectionState(ids: available.difference(_excluded));
  }

  void toggle(String itemId) {
    final available = _availableIds();
    if (!available.contains(itemId)) return;
    final excluded = {..._excluded};
    if (!excluded.remove(itemId)) excluded.add(itemId);
    _excluded = excluded;
    state = CartSelectionState(ids: available.difference(excluded));
  }

  /// Ticks or unticks every line currently in the cart. Sold-out lines are
  /// still tickable so the customer can see the checkout block; the stepper
  /// and checkout validate against stock server-side.
  void setAll({required bool selected}) {
    final available = _availableIds();
    _excluded = selected ? <String>{} : {...available};
    state = CartSelectionState(ids: selected ? available : const <String>{});
  }

  Set<String> _availableIds() {
    final items = ref.read(cartControllerProvider).value ?? const <CartItem>[];
    return {for (final item in items) item.id};
  }
}
