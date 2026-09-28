import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/wishlist_item.dart';
import '../dtos/wishlist_item_dto.dart';
import '../mappers/wishlist_item_mapper.dart';
import 'wishlist_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final wishlistRepositoryProvider = Provider<IWishlistRepository>((ref) {
  return WishlistRepositoryImpl(ref.watch(supabaseClientProvider));
});

class WishlistRepositoryImpl implements IWishlistRepository {
  WishlistRepositoryImpl(this._client);

  final SupabaseClient _client;

  String get _uid {
    final user = _client.auth.currentUser;
    if (user == null) throw const ServerFailure('Not authenticated');
    return user.id;
  }

  @override
  Future<List<WishlistItem>> fetchMyWishlist() async {
    try {
      final wishlist = await _client
          .from('wishlists')
          .select('id')
          .eq('user_id', _uid)
          .maybeSingle();
      if (wishlist == null) return const [];

      final rows = await _client
          .from('wishlist_items')
          .select(
            'id, product_id, products(name, base_price_minor, '
            'product_images(storage_path, sort_order))',
          )
          .eq('wishlist_id', wishlist['id'] as String)
          .order('created_at', ascending: false);

      return rows.map((row) {
        final dto = WishlistItemDto.fromJson(row);
        // Thumbnail must match the product page's first (lowest sort_order).
        final images = [...dto.products?.productImages ?? const []]
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        final storagePath = images.firstOrNull?.storagePath;
        return dto.toDomain(
          imageUrl:
              storagePath == null ? null : _publicUrl(storagePath),
        );
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

  /// Wishlist get-or-create + insert in one RPC-free flow: the wishlist row
  /// is created on demand; duplicate products are rejected by the unique
  /// constraint and surfaced as a failure (DATA-05).
  @override
  Future<void> addItem({required String productId}) async {
    try {
      final wishlist = await _getOrCreateWishlist();
      await _client.from('wishlist_items').insert({
        'wishlist_id': wishlist,
        'product_id': productId,
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> removeItem({required String productId}) async {
    try {
      final wishlist = await _getOrCreateWishlist();
      await _client
          .from('wishlist_items')
          .delete()
          .eq('wishlist_id', wishlist)
          .eq('product_id', productId);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  Future<String> _getOrCreateWishlist() async {
    final existing = await _client
        .from('wishlists')
        .select('id')
        .eq('user_id', _uid)
        .maybeSingle();
    if (existing != null) return existing['id'] as String;

    final created = await _client
        .from('wishlists')
        .insert({'user_id': _uid})
        .select('id')
        .single();
    return created['id'] as String;
  }
}
