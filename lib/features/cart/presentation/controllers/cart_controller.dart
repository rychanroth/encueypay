import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/cart_repository_impl.dart';
import '../../domain/entities/cart_item.dart';

part 'cart_controller.g.dart';

/// Cart state — server-authoritative contents (spec §8). Mutations persist
/// first, then `ref.invalidateSelf()` refetches ground truth (PRES-03) —
/// the client never applies optimistic quantity changes.
@riverpod
class CartController extends _$CartController {
  @override
  Future<List<CartItem>> build() async {
    return ref.watch(cartRepositoryProvider).fetchMyCart();
  }

  Future<void> add({
    required String variantId,
    int quantity = 1,
  }) async {
    final current = state.value ?? const <CartItem>[];
    state = await AsyncValue.guard(() async {
      await ref
          .read(cartRepositoryProvider)
          .addItem(variantId: variantId, quantity: quantity);
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> updateQuantity({
    required String itemId,
    required int quantity,
  }) async {
    final current = state.value ?? const <CartItem>[];
    state = await AsyncValue.guard(() async {
      await ref
          .read(cartRepositoryProvider)
          .updateQuantity(itemId: itemId, quantity: quantity);
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> remove({required String itemId}) async {
    final current = state.value ?? const <CartItem>[];
    state = await AsyncValue.guard(() async {
      await ref.read(cartRepositoryProvider).removeItem(itemId: itemId);
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> clear() async {
    final current = state.value ?? const <CartItem>[];
    state = await AsyncValue.guard(() async {
      await ref.read(cartRepositoryProvider).clear();
      ref.invalidateSelf();
      return current;
    });
  }
}
