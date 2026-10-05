import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/stream_result.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/order.dart';
import '../dtos/order_dtos.dart';
import '../mappers/order_mapper.dart';
import 'orders_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final ordersRepositoryProvider = Provider<IOrdersRepository>((ref) {
  return OrdersRepositoryImpl(ref.watch(supabaseClientProvider));
});

class OrdersRepositoryImpl implements IOrdersRepository {
  OrdersRepositoryImpl(this._client);

  final SupabaseClient _client;

  static const _orderSelect =
      'id, created_at, status, subtotal_minor, discount_minor, '
      'delivery_fee_minor, total_minor, note, cancellation_reason, '
      'shipping_recipient_name, shipping_phone, shipping_line1, '
      'shipping_line2, shipping_city, '
      'order_items(id, product_name, variant_name, business_name, '
      'unit_price_minor, discount_minor, quantity, line_total_minor), '
      'return_requests(id, status, reason), '
      'payments(method, status, amount_minor)';

  String get _uid {
    final user = _client.auth.currentUser;
    if (user == null) throw const ServerFailure('Not authenticated');
    return user.id;
  }

  @override
  Stream<StreamResult<bool>> watchOrderChanges(String orderId) {
    return _client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('id', orderId)
        .map((_) => true)
        .asStreamResult(_mapError);
  }

  Failure _mapError(Object error) {
    if (error is PostgrestException) return ServerFailure(error.message);
    if (error is StorageException) return ServerFailure(error.message);
    return const NetworkFailure();
  }

  CustomerOrder _mapRow(Map<String, dynamic> row) =>
      OrderDto.fromJson(row).toDomain();

  @override
  Future<List<CustomerOrder>> fetchMyOrders({
    int limit = 10,
    int offset = 0,
    List<String>? statuses,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      var request = _client
          .from('orders')
          .select(_orderSelect)
          .eq('customer_id', _uid);
      if (statuses != null && statuses.isNotEmpty) {
        request = request.inFilter('status', statuses);
      }
      if (fromDate != null) {
        request = request.gte(
          'created_at',
          DateTime(fromDate.year, fromDate.month, fromDate.day)
              .toIso8601String(),
        );
      }
      if (toDate != null) {
        // Inclusive of the whole end day.
        request = request.lte(
          'created_at',
          DateTime(toDate.year, toDate.month, toDate.day, 23, 59, 59)
              .toIso8601String(),
        );
      }
      final rows = await request
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);
      return rows.map(_mapRow).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<CustomerOrder> fetchOrder(String orderId) async {
    try {
      final row = await _client
          .from('orders')
          .select(_orderSelect)
          .eq('id', orderId)
          .maybeSingle();
      if (row == null) throw const ServerFailure('Order not found');
      return _mapRow(row);
    } on ServerFailure {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    try {
      await _client.rpc('cancel_order', params: {'p_order_id': orderId});
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> submitPaymentProof({
    required String orderId,
    required String filePath,
    required String fileName,
  }) async {
    try {
      final bytes = await File(filePath).readAsBytes();
      final path = '$_uid/$orderId/'
          '${DateTime.now().millisecondsSinceEpoch}_$fileName';
      await _client.storage.from('payment_proofs').uploadBinary(path, bytes);
      await _client.rpc('submit_payment_proof', params: {
        'p_order_id': orderId,
        'p_path': path,
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } on StorageException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }
}
