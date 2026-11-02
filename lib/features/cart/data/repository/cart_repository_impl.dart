import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/failure_mapping.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/cart_item.dart';
import '../dtos/cart_item_dto.dart';
import '../mappers/cart_item_mapper.dart';
import 'cart_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final cartRepositoryProvider = Provider<ICartRepository>((ref) {
  return CartRepositoryImpl(ref.watch(supabaseClientProvider));
});

class CartRepositoryImpl implements ICartRepository {
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
          .from('cart_item_details')
          .select(
            'id, cart_id, created_at, quantity, variant_id, variant_name, '
            'product_id, product_name, unit_price_minor, '
            'sale_unit_price_minor, stock, brand_id, category_id, '
            'image_storage_path',
          )
          .eq('cart_id', cart['id'] as String)
          .order('created_at');

      return rows.map((row) {
        final dto = CartItemDto.fromJson(row);
        return dto.toDomain(imageUrl: _publicUrl(dto.imageStoragePath));
      }).toList();
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  /// §48: Storage owns the binary; DB owns the reference. Full http(s)
  /// references pass through (the seed carries remote demo imagery — the
  /// same convention as the catalog; wrapping a full URL inside a storage
  /// public-URL produced the broken cart thumbnails).
  String? _publicUrl(String? storagePath) {
    if (storagePath == null || storagePath.isEmpty) return null;
    if (storagePath.startsWith('http')) return storagePath;
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
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
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
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<void> removeItem({required String itemId}) async {
    try {
      await _client.rpc('remove_cart_item', params: {'p_item_id': itemId});
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _client.rpc('clear_cart');
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }
}
