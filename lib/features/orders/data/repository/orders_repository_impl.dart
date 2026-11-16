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
      'reviews(id), '
      'products(product_images(storage_path, sort_order))), '
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

  @override
  Stream<StreamResult<bool>> watchMyOrderChanges() {
    return _client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('customer_id', _uid)
        .map((_) => true)
        .asStreamResult(_mapError);
  }

  Failure _mapError(Object error, [StackTrace? stackTrace]) =>
      mapRepositoryError(error, stackTrace);

  @override
  Future<void> expireUnpaidQrOrders() async {
    try {
      await _client.rpc('expire_unpaid_qr_orders');
    } catch (error, stackTrace) {
      // Best-effort maintenance: a failure must not break the orders list.
      logSuppressedError(error, stackTrace);
    }
  }

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

  String _dateOnly(DateTime value) {
    final day = value.toLocal();
    return '${day.year.toString().padLeft(4, '0')}-'
        '${day.month.toString().padLeft(2, '0')}-'
        '${day.day.toString().padLeft(2, '0')}';
  }

  @override
  Future<List<CustomerOrder>> fetchMyOrders({
    int limit = 10,
    int offset = 0,
    List<String>? statuses,
    DateTime? fromDate,
    DateTime? toDate,
    String? search,
    bool toReview = false,
  }) async {
    try {
      final query = search?.trim() ?? '';
      // Free-text and the unreviewed view need server-side matching against
      // order_items; the plain browse path stays a PostgREST select.
      if (query.isNotEmpty || toReview) {
        final result = await _client.rpc('customer_search_orders', params: {
          'p_search': query.isEmpty ? null : query,
          'p_statuses': statuses ?? const <String>[],
          'p_from': fromDate == null ? null : _dateOnly(fromDate),
          'p_to': toDate == null ? null : _dateOnly(toDate),
          'p_to_review': toReview,
          'p_limit': limit,
          'p_offset': offset,
        });
        final rows = (result as List? ?? const [])
            .cast<Map<String, dynamic>>();
        return rows.map(_mapRow).toList();
      }
      var request = _client
          .from('orders')
          .select(_orderSelect)
          .eq('customer_id', _uid);
      if (statuses != null && statuses.isNotEmpty) {
        request = request.inFilter('status', statuses);
      }
      if (fromDate != null) {
        // Local midnight of the requested day, sent as an absolute instant:
        // a bare wall-clock string is parsed in the server's timezone (UTC on
        // hosted Supabase) and silently shifts the day by the UTC offset.
        request = request.gte(
          'created_at',
          DateTime(fromDate.year, fromDate.month, fromDate.day)
              .toUtc()
              .toIso8601String(),
        );
      }
      if (toDate != null) {
        // Inclusive of the whole end day.
        request = request.lte(
          'created_at',
          DateTime(toDate.year, toDate.month, toDate.day, 23, 59, 59)
              .toUtc()
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
}
