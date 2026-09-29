import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/cart_repository.dart';
import '../../data/repository/cart_repository_impl.dart';
import '../../domain/entities/cart_item.dart';

part 'cart_controller.g.dart';

/// Cart state — server-authoritative contents (spec §8). Mutations persist
/// first, then refetch ground truth (PRES-03) — the client never applies
/// optimistic quantity changes.
///
/// Mutations may run while nothing listens (e.g. add-to-cart from the product
/// detail sheet): the autoDispose element is then disposed during the RPC
/// await, so afterwards `ref` is unmounted — the persisted mutation still
/// stands and the next listener (opening the cart tab) refetches fresh.
@riverpod
class CartController extends _$CartController {
  @override
  Future<List<CartItem>> build() async {
    return ref.watch(cartRepositoryProvider).fetchMyCart();
  }

  /// Refetches ground truth after a successful mutation — never re-assigns
  /// stale `current` state.
  Future<void> _refetch(ICartRepository repository) async {
    if (!ref.mounted) return;
    state = await AsyncValue.guard(repository.fetchMyCart);
  }

  Future<void> add({
    required String variantId,
    int quantity = 1,
  }) async {
    final repository = ref.read(cartRepositoryProvider);
    await repository.addItem(variantId: variantId, quantity: quantity);
    await _refetch(repository);
  }

  Future<void> updateQuantity({
    required String itemId,
    required int quantity,
  }) async {
    final repository = ref.read(cartRepositoryProvider);
    await repository.updateQuantity(itemId: itemId, quantity: quantity);
    await _refetch(repository);
  }

  Future<void> remove({required String itemId}) async {
    final repository = ref.read(cartRepositoryProvider);
    await repository.removeItem(itemId: itemId);
    await _refetch(repository);
  }

  Future<void> clear() async {
    final repository = ref.read(cartRepositoryProvider);
    await repository.clear();
    await _refetch(repository);
  }
}
