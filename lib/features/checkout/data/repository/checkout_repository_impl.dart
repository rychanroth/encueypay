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
            'id, quantity, product_variants(name, '
            'products(name, base_price_minor, businesses(name)))',
          )
          .eq('cart_id', cart['id'] as String)
          .order('created_at');

      final items = rows
          .map(CheckoutItemDto.fromJson)
          .map((dto) => dto.toDomain())
          .toList();
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
  }) async {
    try {
      final orderId = await _client.rpc('create_order_from_cart', params: {
        'p_address_id': addressId,
        'p_payment_method': method.wireName,
        'p_coupon_codes': couponCodes,
      });
      return orderId as String;
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }
}
