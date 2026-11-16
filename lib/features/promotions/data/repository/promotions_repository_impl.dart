import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/picked_file.dart';
import '../../../../core/network/failure_mapping.dart';
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

  static const _saleSelect =
      'id, name, description, scope, discount_type, discount_value, active, '
      'starts_at, ends_at, archived_at, brands(name), categories(name)';
  static const _couponSelect =
      'id, name, code, discount_type, discount_value, '
      'min_order_amount_minor, active, starts_at, ends_at, archived_at';

  Future<void> _rpc(String function, Map<String, dynamic> params) async {
    try {
      await _client.rpc(function, params: params);
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  /// Uploads the image and returns its storage path plus full public URL
  /// (the sale/banner RPCs store URLs, not bare paths). The path is kept
  /// separately so a rejected sale write can clean up the orphan object.
  Future<({String path, String url})> _uploadPromoAsset({
    required PickedFile image,
  }) async {
    final path =
        '$_uid/${DateTime.now().millisecondsSinceEpoch}_${image.fileName}';
    await _client.storage.from('promo_assets').uploadBinary(path, image.bytes);
    return (
      path: path,
      url: _client.storage.from('promo_assets').getPublicUrl(path),
    );
  }

  @override
  Future<List<ManagedSale>> fetchSales() async {
    try {
      final rows = await _client
          .from('sales')
          .select(_saleSelect)
          .order('created_at', ascending: false);
      return rows
          .map(SaleDto.fromJson)
          .map((dto) => dto.toDomain())
          .toList();
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<List<ManagedCoupon>> fetchCoupons() async {
    try {
      final rows = await _client
          .from('coupons')
          .select(_couponSelect)
          .order('created_at', ascending: false);
      return rows
          .map(CouponDto.fromJson)
          .map((dto) => dto.toDomain())
          .toList();
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<List<ManagedBanner>> fetchBanners() async {
    try {
      final rows = await _client
          .from('banners')
          .select()
          .order('created_at', ascending: false);
      return rows.map(BannerDto.fromJson).map((dto) {
        final path = dto.imagePath;
        // Full public URLs pass through; only re-wrap bare paths. A missing
        // path renders a placeholder instead of crashing the moderation list.
        return dto.toDomain(
          imageUrl: path == null || path.isEmpty
              ? ''
              : path.startsWith('http')
                  ? path
                  : _client.storage.from('promo_assets').getPublicUrl(path),
        );
      }).toList();
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<List<PromoBrandRef>> fetchActiveBrands() async {
    try {
      final rows = await _client
          .from('brands')
          .select('id, name')
          .eq('status', 'active')
          .order('name');
      return rows
          .map(PromoBrandRefDto.fromJson)
          .map((dto) => PromoBrandRef(id: dto.id, name: dto.name))
          .toList();
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<List<PromoCategoryRef>> fetchCategories() async {
    try {
      final rows = await _client.from('categories').select('id, name').order('name');
      return rows
          .map(PromoCategoryRefDto.fromJson)
          .map((dto) => PromoCategoryRef(id: dto.id, name: dto.name))
          .toList();
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<void> createSale({
    required String name,
    required String description,
    required SaleScope scope,
    required PromoDiscountType discountType,
    required int discountValue,
    DateTime? startsAt,
    DateTime? endsAt,
    String? brandId,
    String? categoryId,
    PickedFile? image,
  }) async {
    ({String path, String url})? uploaded;
    try {
      if (image != null) {
        uploaded = await _uploadPromoAsset(image: image);
      }
      await _client.rpc('admin_create_sale', params: {
        'p_name': name,
        'p_description': description,
        'p_discount_type': discountType.wireName,
        'p_discount_value': discountValue,
        'p_scope': scope.wireName,
        'p_brand_id': brandId,
        'p_category_id': categoryId,
        'p_starts_at': startsAt?.toIso8601String(),
        'p_ends_at': endsAt?.toIso8601String(),
        'p_image_path': uploaded?.url,
      });
    } on PostgrestException catch (error, stackTrace) {
      // The RPC transaction rolled back, so the uploaded object is an
      // orphan. Best-effort cleanup; a network ambiguity after a successful
      // commit must not delete a banner image, so only a definite backend
      // rejection cleans up.
      if (uploaded != null) {
        try {
          await _client.storage
              .from('promo_assets')
              .remove([uploaded.path]);
        } catch (cleanupError, cleanupStack) {
          logSuppressedError(cleanupError, cleanupStack);
        }
      }
      throw mapRepositoryError(error, stackTrace);
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<void> setSaleActive({required String saleId, required bool active}) {
    return _rpc('admin_set_sale_active', {
      'p_sale_id': saleId,
      'p_active': active,
    });
  }

  @override
  Future<void> setSaleArchived({
    required String saleId,
    required bool archived,
  }) {
    return _rpc('admin_set_sale_archived', {
      'p_sale_id': saleId,
      'p_archived': archived,
    });
  }

  @override
  Future<void> createCoupon({
    required String name,
    required String code,
    required PromoDiscountType discountType,
    required int discountValue,
    int minOrderAmountMinor = 0,
    DateTime? startsAt,
    DateTime? endsAt,
  }) {
    return _rpc('admin_create_coupon', {
      'p_name': name,
      'p_code': code,
      'p_discount_type': discountType.wireName,
      'p_discount_value': discountValue,
      'p_min_order_amount_minor': minOrderAmountMinor,
      'p_starts_at': startsAt?.toIso8601String(),
      'p_ends_at': endsAt?.toIso8601String(),
    });
  }

  @override
  Future<void> createBanner({
    required String name,
    required String description,
    required PickedFile image,
  }) async {
    try {
      final path = '$_uid/'
          '${DateTime.now().millisecondsSinceEpoch}_${image.fileName}';
      await _client.storage
          .from('promo_assets')
          .uploadBinary(path, image.bytes);
      final url = _client.storage.from('promo_assets').getPublicUrl(path);
      await _client.rpc('admin_create_banner', params: {
        'p_name': name,
        'p_description': description,
        'p_image_url': url,
        'p_ends_at': null,
      });
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<void> moderateBanner({
    required String bannerId,
    required String action,
  }) {
    return _rpc('moderate_banner', {
      'p_banner_id': bannerId,
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

  @override
  Future<void> setCouponArchived({
    required String couponId,
    required bool archived,
  }) {
    return _rpc('admin_set_coupon_archived', {
      'p_coupon_id': couponId,
      'p_archived': archived,
    });
  }

  @override
  Future<void> deleteCoupon({required String couponId}) {
    return _rpc('admin_delete_coupon', {'p_coupon_id': couponId});
  }
}
