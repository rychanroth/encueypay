import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/failure_mapping.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/address_option.dart';
import '../../domain/entities/checkout_summary.dart';
import '../../domain/entities/coupon_preview.dart';
import '../../domain/entities/order_totals_preview.dart';
import '../../domain/entities/payment_method.dart';
import '../dtos/checkout_dtos.dart';
import '../mappers/checkout_mapper.dart';
import 'checkout_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final checkoutRepositoryProvider = Provider<ICheckoutRepository>((ref) {
  return CheckoutRepositoryImpl(ref.watch(supabaseClientProvider));
});

class CheckoutRepositoryImpl implements ICheckoutRepository {
  CheckoutRepositoryImpl(this._client);

  final SupabaseClient _client;

  String get _uid {
    final user = _client.auth.currentUser;
    if (user == null) throw const ServerFailure('Not authenticated');
    return user.id;
  }

  @override
  Future<List<AddressOption>> fetchMyAddressOptions() async {
    try {
      final rows = await _client
          .from('addresses')
          .select()
          .eq('user_id', _uid)
          .order('created_at');
      return rows
          .map(CheckoutAddressDto.fromJson)
          .map((dto) => dto.toDomain())
          .toList();
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<CheckoutSummary> fetchMySummary() async {
    try {
      final results = await Future.wait([
        _client.from('carts').select('id').eq('user_id', _uid).maybeSingle(),
        _client.from('platform_settings').select().eq('id', 1).maybeSingle(),
      ]);
      final cart = results[0];
      final settingsRow = results[1];
      final deliveryFeeMinor =
          settingsRow == null ? 0 : PlatformSettingsDto.fromJson(settingsRow).deliveryFeeMinorOrDefault;
      if (cart == null) {
        return CheckoutSummary(items: const [], subtotalMinor: 0, deliveryFeeMinor: deliveryFeeMinor);
      }

      final rows = await _client
          .from('cart_items')
          .select(
            'id, quantity, product_variants(name, price_minor, '
            'products(name, base_price_minor, '
            'product_images(storage_path, sort_order)))',
          )
          .eq('cart_id', cart['id'] as String)
          .order('created_at');

      String? publicUrl(String? storagePath) {
        if (storagePath == null) return null;
        // Full http(s) references pass through (seed demo imagery).
        if (storagePath.startsWith('http')) return storagePath;
        return _client.storage
            .from('product_images')
            .getPublicUrl(storagePath);
      }

      final items = rows.map((row) {
        final dto = CheckoutItemDto.fromJson(row);
        final images = [
          ...dto.productVariants?.products?.productImages ??
              const <CheckoutImageJoinDto>[],
        ]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        return dto.toDomain(
          imageUrl: publicUrl(images.firstOrNull?.storagePath),
        );
      }).toList();
      final subtotal = items.fold<int>(0, (sum, item) => sum + item.lineTotalMinor);
      return CheckoutSummary(
        items: items,
        subtotalMinor: subtotal,
        deliveryFeeMinor: deliveryFeeMinor,
      );
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<CouponPreview> validateCoupon(String code) async {
    try {
      final result =
          await _client.rpc('validate_coupon', params: {'p_code': code});
      final map = Map<String, dynamic>.from(result as Map);
      return CouponPreview(
        code: code,
        valid: map['valid'] == true,
        discountMinor: (map['discount_minor'] as int?) ?? 0,
        message: map['message'] as String?,
      );
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<OrderTotalsPreview> previewOrderTotals({
    required List<String> couponCodes,
  }) async {
    try {
      final result = await _client.rpc('preview_order_totals',
          params: {'p_codes': couponCodes});
      final map = Map<String, dynamic>.from(result as Map);
      final manual = ((map['manual'] as List? ?? const [])
              .whereType<Map<String, dynamic>>())
          .map((row) => CouponPreview(
                code: row['code'] as String? ?? '',
                valid: true,
                discountMinor: (row['discount_minor'] as int?) ?? 0,
              ))
          .toList();
      return OrderTotalsPreview(
        manual: manual,
        subtotalMinor: (map['subtotal_minor'] as int?) ?? 0,
        totalDiscountMinor: (map['total_discount_minor'] as int?) ?? 0,
        deliveryFeeMinor: (map['delivery_fee_minor'] as int?) ?? 0,
        totalMinor: (map['total_minor'] as int?) ?? 0,
      );
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<String> placeOrder({
    required String addressId,
    required PaymentMethod method,
    required List<String> couponCodes,
    String note = '',
  }) async {
    try {
      final orderId = await _client.rpc('create_order_from_cart', params: {
        'p_address_id': addressId,
        'p_payment_method': method.wireName,
        'p_coupon_codes': couponCodes,
        'p_note': note,
      });
      return orderId as String;
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }
  // -------------------------------------------------- QR payment (§6b)
  @override
  Future<String> createPaywayQr({required String orderId}) async {
    try {
      final response = await _client.functions
          .invoke('payway-create', body: {'orderId': orderId});
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final qr = data['qrPayload'];
        if (qr is String && qr.isNotEmpty) return qr;
        // Soft failure — the function's `reason` names the failing stage.
        final reason = data['reason'] as String? ?? 'unavailable';
        throw ServerFailure('PayWay QR unavailable ($reason)');
      }
      throw const ServerFailure('PayWay QR unavailable');
    } on Failure {
      rethrow; // Already classified above — DATA-05: no re-mapping.
    } on FunctionException catch (error, stackTrace) {
      // Function not deployed/running — the simulation path covers demos.
      logSuppressedError(error, stackTrace);
      throw const NetworkFailure('PayWay service unreachable');
    } catch (error, stackTrace) {
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Stream<Map<String, dynamic>?> streamOrderPayment(String orderId) {
    // Realtime on `payments` (publication member since 0038); the stream
    // starts from the current row (initial snapshot, Part D).
    return _client
        .from('payments')
        .stream(primaryKey: ['id'])
        .eq('order_id', orderId)
        .map((rows) => rows.isEmpty ? null : rows.first);
  }

  @override
  Future<Map<String, dynamic>?> fetchOrderPayment(String orderId) async {
    try {
      final row = await _client
          .from('payments')
          .select()
          .eq('order_id', orderId)
          .maybeSingle();
      return row == null ? null : Map<String, dynamic>.from(row);
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }
}
