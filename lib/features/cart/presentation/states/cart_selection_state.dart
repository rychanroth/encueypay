import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_selection_state.freezed.dart';

/// Ticked cart lines (PRES-02, immutable). Only selected lines are priced in
/// the dock and sent to checkout; an empty set disables checkout.
@freezed
abstract class CartSelectionState with _$CartSelectionState {
  const factory CartSelectionState({@Default(<String>{}) Set<String> ids}) =
      _CartSelectionState;

  const CartSelectionState._();

  bool contains(String itemId) => ids.contains(itemId);
}
