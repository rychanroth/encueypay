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
          .from('cart_item_details')
          .select(
            'id, cart_id, created_at, quantity, variant_id, variant_name, '
            'product_id, product_name, unit_price_minor, '
            'sale_unit_price_minor, image_storage_path',
          )
          .eq('cart_id', cart['id'] as String)
          .order('created_at');

      String? publicUrl(String? storagePath) {
        if (storagePath == null || storagePath.isEmpty) return null;
        // Full http(s) references pass through (seed demo imagery).
        if (storagePath.startsWith('http')) return storagePath;
        return _client.storage
            .from('product_images')
            .getPublicUrl(storagePath);
      }

      final items = rows.map((row) {
        final dto = CheckoutItemDto.fromJson(row);
        return dto.toDomain(imageUrl: publicUrl(dto.imageStoragePath));
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

  static int _asInt(Object? value) => (value as num?)?.toInt() ?? 0;

  static DateTime? _asDate(Object? value) =>
      value is String ? DateTime.tryParse(value) : null;

  static CouponPreview _couponFromJson(
    Map<String, dynamic> map, {
    String? fallbackCode,
  }) {
    return CouponPreview(
      code: (map['code'] as String?) ?? fallbackCode ?? '',
      valid: map['valid'] == true,
      discountMinor: _asInt(map['discount_minor']),
      message: map['message'] as String?,
      name: (map['name'] as String?) ?? '',
      discountType: CouponDiscountType.fromName(map['discount_type'] as String?),
      discountValue: _asInt(map['discount_value']),
      minOrderAmountMinor: _asInt(map['min_order_amount_minor']),
      startsAt: _asDate(map['starts_at']),
      endsAt: _asDate(map['ends_at']),
      subtotalMinor: _asInt(map['subtotal_minor']),
      reason: map['reason'] as String?,
    );
  }

  @override
  Future<CouponPreview> validateCoupon(String code) async {
    try {
      final result =
          await _client.rpc('validate_coupon', params: {'p_code': code});
      final map = Map<String, dynamic>.from(result as Map);
      return _couponFromJson(map, fallbackCode: code);
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
          .map(_couponFromJson)
          .toList();
      final rejected = ((map['rejected'] as List? ?? const [])
              .whereType<Map<String, dynamic>>())
          .map(_couponFromJson)
          .toList();
      return OrderTotalsPreview(
        manual: manual,
        rejected: rejected,
        subtotalMinor: _asInt(map['subtotal_minor']),
        totalDiscountMinor: _asInt(map['total_discount_minor']),
        deliveryFeeMinor: _asInt(map['delivery_fee_minor']),
        totalMinor: _asInt(map['total_minor']),
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
