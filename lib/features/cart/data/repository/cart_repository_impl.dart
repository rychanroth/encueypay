import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/cart_coupon.dart';
import '../../domain/entities/cart_item.dart';
import '../dtos/cart_item_dto.dart';
import '../mappers/cart_item_mapper.dart';
import 'cart_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final cartRepositoryProvider = Provider<ICartRepository>((ref) {
  return CartRepositoryImpl(ref.watch(supabaseClientProvider));
});

class CartRepositoryImpl implements ICartRepository {
  @override
  Future<CartCoupon> validateCoupon(String code) async {
    try {
      final result =
          await _client.rpc('validate_coupon', params: {'p_code': code});
      final map = Map<String, dynamic>.from(result as Map);
      final rawScope = map['scope'] as String?;
      return CartCoupon(
        code: code,
        valid: map['valid'] == true,
        discountMinor: (map['discount_minor'] as int?) ?? 0,
        message: map['message'] as String?,
        // Scope recognition (§5.1.3): brand-scoped promotions badge as
        // 'Brand'; platform/business act cart-wide in the 2-role prototype.
        scopeLabel: rawScope == 'brand' ? 'Brand' : 'Platform',
      );
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  CartRepositoryImpl(this._client);

  final SupabaseClient _client;

  String get _uid {
    final user = _client.auth.currentUser;
    if (user == null) throw const ServerFailure('Not authenticated');
    return user.id;
  }

  @override
  Future<List<CartItem>> fetchMyCart() async {
    try {
      final cart = await _client
          .from('carts')
          .select('id')
          .eq('user_id', _uid)
          .maybeSingle();
      if (cart == null) return const [];

      final rows = await _client
          .from('cart_items')
          .select(
            'id, quantity, product_variants(id, name, price_minor, '
            'products(id, name, base_price_minor, stock, '
            'product_images(storage_path, sort_order), businesses(id, name)))',
          )
          .eq('cart_id', cart['id'] as String)
          .order('created_at');

      return rows.map((row) {
        final dto = CartItemDto.fromJson(row);
        // Thumbnail must match the product page's first (lowest sort_order).
        final images = [
          ...dto.productVariants?.products?.productImages ?? const <CartImageJoinDto>[],
        ]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        final storagePath = images.firstOrNull?.storagePath;
        final imageUrl =
            storagePath == null ? null : _publicUrl(storagePath);
        return dto.toDomain(imageUrl: imageUrl);
      }).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  String _publicUrl(String storagePath) {
    return _client.storage.from('product_images').getPublicUrl(storagePath);
  }

  @override
  Future<void> addItem({
    required String variantId,
    required int quantity,
  }) async {
    try {
      await _client.rpc('add_cart_item', params: {
        'p_variant_id': variantId,
        'p_quantity': quantity,
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> updateQuantity({
    required String itemId,
    required int quantity,
  }) async {
    try {
      await _client.rpc('update_cart_item', params: {
        'p_item_id': itemId,
        'p_quantity': quantity,
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> removeItem({required String itemId}) async {
    try {
      await _client.rpc('remove_cart_item', params: {'p_item_id': itemId});
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _client.rpc('clear_cart');
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }
}
