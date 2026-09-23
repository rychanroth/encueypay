import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/promotion.dart';
import '../dtos/promotion_dtos.dart';
import '../mappers/promotion_mapper.dart';
import 'promotions_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final promotionsRepositoryProvider = Provider<IPromotionsRepository>((ref) {
  return PromotionsRepositoryImpl(ref.watch(supabaseClientProvider));
});

class PromotionsRepositoryImpl implements IPromotionsRepository {
  PromotionsRepositoryImpl(this._client);

  final SupabaseClient _client;

  String get _uid {
    final user = _client.auth.currentUser;
    if (user == null) throw const ServerFailure('Not authenticated');
    return user.id;
  }

  List<MyPromotion> _mapRows(List<Map<String, dynamic>> rows) {
    return rows.map((row) {
      final dto = PromotionDto.fromJson(row);
      final bannerPath = dto.bannerImagePath;
      return dto.toDomain(
        bannerUrl: bannerPath == null
            ? null
            : _client.storage.from('promo_assets').getPublicUrl(bannerPath),
      );
    }).toList();
  }

  Future<void> _rpc(String function, Map<String, dynamic> params) async {
    try {
      await _client.rpc(function, params: params);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<List<MyPromotion>> fetchMyPromotions() async {
    try {
      final rows = await _client
          .from('promotions')
          .select('id, name, description, scope, discount_type, '
              'discount_value, banner_image_path, banner_status, ends_at, '
              'coupons(id, code, active, expires_at)')
          .eq('created_by', _uid)
          .order('created_at', ascending: false);
      return _mapRows(rows);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<List<MyPromotion>> fetchAllPromotions() async {
    try {
      final rows = await _client
          .from('promotions')
          .select('id, name, description, scope, discount_type, '
              'discount_value, banner_image_path, banner_status, ends_at, '
              'coupons(id, code, active, expires_at)')
          .order('created_at', ascending: false);
      return _mapRows(rows);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> createCouponPromotion({
    required String name,
    required String description,
    required PromoDiscountType discountType,
    required int discountValue,
    required String code,
    DateTime? expiresAt,
  }) {
    return _rpc('create_coupon_promotion', {
      'p_name': name,
      'p_description': description,
      'p_discount_type': discountType.wireName,
      'p_discount_value': discountValue,
      'p_code': code,
      'p_expires_at': expiresAt?.toIso8601String(),
    });
  }

  @override
  Future<void> createPlatformPromotion({
    required String name,
    required String description,
    required PromoDiscountType discountType,
    required int discountValue,
    required String code,
    DateTime? expiresAt,
  }) {
    return _rpc('create_platform_promotion', {
      'p_name': name,
      'p_description': description,
      'p_discount_type': discountType.wireName,
      'p_discount_value': discountValue,
      'p_code': code,
      'p_expires_at': expiresAt?.toIso8601String(),
    });
  }

  @override
  Future<void> submitBanner({
    required String name,
    required String description,
    required String filePath,
    required String fileName,
    DateTime? endsAt,
  }) async {
    try {
      final bytes = await File(filePath).readAsBytes();
      final path = '$_uid/'
          '${DateTime.now().millisecondsSinceEpoch}_$fileName';
      await _client.storage.from('promo_assets').uploadBinary(path, bytes);
      final url = _client.storage.from('promo_assets').getPublicUrl(path);
      await _client.rpc('submit_banner', params: {
        'p_name': name,
        'p_description': description,
        'p_image_url': url,
        'p_ends_at': endsAt?.toIso8601String(),
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } on StorageException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> moderateBanner({
    required String promotionId,
    required String action,
  }) {
    return _rpc('moderate_banner', {
      'p_promotion_id': promotionId,
      'p_action': action,
    });
  }

  @override
  Future<void> setCouponActive({
    required String couponId,
    required bool active,
  }) {
    return _rpc('set_coupon_active', {
      'p_coupon_id': couponId,
      'p_active': active,
    });
  }
}
