import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/return_request.dart';
import '../dtos/return_dtos.dart';
import '../mappers/return_mapper.dart';
import 'returns_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final returnsRepositoryProvider = Provider<IReturnsRepository>((ref) {
  return ReturnsRepositoryImpl(ref.watch(supabaseClientProvider));
});

class ReturnsRepositoryImpl implements IReturnsRepository {
  ReturnsRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<List<ReturnableItem>> fetchReturnableItems(String orderId) async {
    try {
      final rows = await _client
          .from('order_items')
          .select('id, product_name, variant_name, quantity')
          .eq('order_id', orderId)
          .order('created_at');
      return rows
          .map(ReturnableItemDto.fromJson)
          .map((dto) => dto.toDomain())
          .toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> requestReturn({
    required String orderId,
    required List<ReturnItemDraft> items,
  }) async {
    try {
      await _client.rpc('request_return', params: {
        'p_order_id': orderId,
        'p_items': items
            .map((item) => {
                  'order_item_id': item.orderItemId,
                  'quantity': item.quantity,
                  'reason': item.reason,
                })
            .toList(),
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

}
