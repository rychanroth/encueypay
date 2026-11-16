import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/cart_view.dart';

part 'cart_filter_state.freezed.dart';

/// Cart search/filter/sort UI state (PRES-02). Presentation-only — the
/// server does not see these values; the cart is filtered client-side.
@freezed
abstract class CartFilterState with _$CartFilterState {
  const factory CartFilterState({
    @Default('') String query,
    @Default(CartFilter.all) CartFilter filter,
    @Default(CartSort.newest) CartSort sort,
  }) = _CartFilterState;

  const CartFilterState._();

  /// A filter is "active" only when it narrows the visible lines — the
  /// default chip, empty query and newest sort are the resting state.
  bool get hasActiveFilter =>
      query.trim().isNotEmpty ||
      filter != CartFilter.all ||
      sort != CartSort.newest;
}
