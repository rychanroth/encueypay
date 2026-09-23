import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/business_profile.dart';
import '../../domain/entities/managed_business_order.dart';
import '../dtos/business_dtos.dart';
import '../mappers/business_mapper.dart';
import 'business_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final businessRepositoryProvider = Provider<IBusinessRepository>((ref) {
  return BusinessRepositoryImpl(ref.watch(supabaseClientProvider));
});

class BusinessRepositoryImpl implements IBusinessRepository {
  BusinessRepositoryImpl(this._client);

  final SupabaseClient _client;

  String get _uid {
    final user = _client.auth.currentUser;
    if (user == null) throw const ServerFailure('Not authenticated');
    return user.id;
  }

  @override
  Future<BusinessProfile?> fetchMyBusiness() async {
    try {
      final row = await _client
          .from('businesses')
          .select()
          .eq('owner_id', _uid)
          .maybeSingle();
      if (row == null) return null;
      return BusinessProfileDto.fromJson(row).toDomain();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<String> uploadBusinessImage({
    required String filePath,
    required String fileName,
  }) async {
    try {
      final bytes = await File(filePath).readAsBytes();
      final path = '$_uid/'
          '${DateTime.now().millisecondsSinceEpoch}_$fileName';
      await _client.storage.from('business_images').uploadBinary(path, bytes);
      return _client.storage.from('business_images').getPublicUrl(path);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } on StorageException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> createBusiness({
    required String name,
    required String description,
    String? imageUrl,
  }) async {
    try {
      await _client.rpc('create_business', params: {
        'p_name': name,
        'p_description': description,
        'p_image_url': imageUrl,
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> updateMyBusiness({
    required String name,
    required String description,
  }) async {
    try {
      await _client.rpc('update_my_business', params: {
        'p_name': name,
        'p_description': description,
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<List<CategoryOption>> fetchCategoryOptions() async {
    try {
      final rows = await _client.from('categories').select('id, name').order('name');
      return rows
          .map(CategoryOptionDto.fromJson)
          .map((dto) => dto.toDomain())
          .toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<List<BusinessProduct>> fetchMyProducts() async {
    try {
      final rows = await _client
          .from('products')
          .select(
            'id, category_id, name, description, base_price_minor, stock, status, '
            'product_variants(id, name, price_minor, stock)',
          )
          .order('created_at', ascending: false);
      return rows
          .map(BusinessProductDto.fromJson)
          .map((dto) => dto.toDomain())
          .toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<String> createProduct({
    required String categoryId,
    required String name,
    required String description,
    required int basePriceMinor,
    required int stock,
    required List<VariantDraft> variants,
  }) async {
    try {
      final productId = await _client.rpc('create_product', params: {
        'p_category_id': categoryId,
        'p_name': name,
        'p_description': description,
        'p_base_price_minor': basePriceMinor,
        'p_stock': stock,
        'p_variants': variants
            .map((v) => {
                  'name': v.name,
                  'price_minor': v.priceMinor,
                  'stock': v.stock,
                })
            .toList(),
      });
      return productId as String;
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> updateProduct({
    required String productId,
    required String categoryId,
    required String name,
    required String description,
    required int basePriceMinor,
  }) async {
    try {
      await _client.rpc('update_product', params: {
        'p_product_id': productId,
        'p_category_id': categoryId,
        'p_name': name,
        'p_description': description,
        'p_base_price_minor': basePriceMinor,
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> setProductArchived({
    required String productId,
    required bool archived,
  }) async {
    try {
      await _client.rpc('set_product_archived', params: {
        'p_product_id': productId,
        'p_archived': archived,
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> updateVariantStock({
    required String variantId,
    required int stock,
  }) async {
    try {
      await _client.rpc('update_variant_stock', params: {
        'p_variant_id': variantId,
        'p_stock': stock,
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<List<ManagedBusinessOrder>> fetchMyBusinessOrders() async {
    try {
      final rows = await _client
          .from('business_orders')
          .select(
            'id, order_id, status, rejection_reason, subtotal_minor, '
            'discount_minor, created_at, '
            'order_items(id, product_name, variant_name, quantity, line_total_minor), '
            'orders(users(full_name))',
          )
          .order('created_at', ascending: false)
          .limit(50);
      return rows
          .map(ManagedOrderDto.fromJson)
          .map((dto) => dto.toDomain())
          .toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> transitionBusinessOrder({
    required String businessOrderId,
    required ManagedOrderStatus target,
    String? reason,
  }) async {
    try {
      await _client.rpc('transition_business_order', params: {
        'p_business_order_id': businessOrderId,
        'p_target': target.name,
        'p_reason': reason,
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }
}
