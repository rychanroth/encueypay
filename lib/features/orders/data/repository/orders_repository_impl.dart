import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/failure_mapping.dart';
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
      'order_items(id, product_id, product_name, variant_name, '
      'unit_price_minor, discount_minor, quantity, line_total_minor, '
      'products(product_images(storage_path, sort_order))), '
      // return reason lives on the return_items lines (per-item reason in
      // request_return), not on the return_requests header.
      'return_requests(id, status, return_items(reason, quantity)), '
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

  Failure _mapError(Object error, [StackTrace? stackTrace]) =>
      mapRepositoryError(error, stackTrace);

  CustomerOrder _mapRow(Map<String, dynamic> row) {
    final dto = OrderDto.fromJson(row);
    final itemImageUrls = <String, String?>{
      for (final item in dto.items) item.id: _itemImageUrl(item),
    };
    return dto.toDomain(itemImageUrls: itemImageUrls);
  }

  /// Item thumbnails come from the live catalog (order_items → products →
  /// product_images, first by sort_order). Full http(s) references pass
  /// through — the seed imagery convention shared with cart/wishlist.
  String? _itemImageUrl(OrderItemJoinDto item) {
    final images = [
      ...item.products?.productImages ?? const <OrderItemImageJoinDto>[],
    ]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    final storagePath = images.firstOrNull?.storagePath;
    if (storagePath == null) return null;
    if (storagePath.startsWith('http')) return storagePath;
    return _client.storage.from('product_images').getPublicUrl(storagePath);
  }

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
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
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
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    try {
      await _client.rpc('cancel_order', params: {'p_order_id': orderId});
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
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
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }
}
