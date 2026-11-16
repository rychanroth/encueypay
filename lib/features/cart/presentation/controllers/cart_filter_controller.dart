import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/cart_view.dart';
import '../states/cart_filter_state.dart';

part 'cart_filter_controller.g.dart';

/// Search/filter/sort state for the cart list (PRES-02). Presentation-only —
/// the repository and RPCs never see it.
@riverpod
class CartFilterController extends _$CartFilterController {
  @override
  CartFilterState build() => const CartFilterState();

  void setQuery(String value) {
    state = state.copyWith(query: value);
  }

  void setFilter(CartFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void setSort(CartSort sort) {
    state = state.copyWith(sort: sort);
  }

  void clear() {
    state = const CartFilterState();
  }
}
