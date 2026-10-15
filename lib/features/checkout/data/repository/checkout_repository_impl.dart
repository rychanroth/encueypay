import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/address_option.dart';
import '../../domain/entities/checkout_summary.dart';
import '../../domain/entities/coupon_preview.dart';
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
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
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
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
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
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
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
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }
  // -------------------------------------------------- QR payment (§6b)
  @override
  Future<String> fetchQrAccountId() async {
    try {
      final row = await _client
          .from('platform_settings')
          .select('qr_account_id')
          .eq('id', 1)
          .maybeSingle();
      return (row?['qr_account_id'] as String?) ?? '';
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> registerQrPayment({
    required String orderId,
    required String payload,
  }) async {
    try {
      await _client.rpc('register_qr_payment', params: {
        'p_order_id': orderId,
        'p_payload': payload,
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
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
  Future<bool?> checkBakongPayment(String orderId) async {
    try {
      final functions = _client.functions;
      final response = await functions.invoke(
        'bakong-check',
        body: {'orderId': orderId},
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data['configured'] == true && data['paid'] == true;
      }
      return null;
    } on FunctionException {
      // Function not deployed/running — the simulation path covers demos.
      return null;
    } catch (_) {
      return null;
    }
  }
}
