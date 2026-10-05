import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/admin.dart';
import '../dtos/admin_dtos.dart';
import 'admin_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final adminRepositoryProvider = Provider<IAdminRepository>((ref) {
  return AdminRepositoryImpl(ref.watch(supabaseClientProvider));
});

class AdminRepositoryImpl implements IAdminRepository {
  AdminRepositoryImpl(this._client);

  final SupabaseClient _client;

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
  Future<List<AdminApplication>> fetchPendingApplications() async {
    try {
      final rows = await _client
          .from('role_applications')
          .select('id, requested_role, status, created_at, '
              'users!role_applications_user_id_fkey(full_name)')
          .eq('status', 'pending')
          .order('created_at');
      return rows
          .map(AdminApplicationDto.fromJson)
          .map((dto) => AdminApplication(
                id: dto.id,
                applicantName: dto.users?.fullName ?? 'Applicant',
                requestedRole: dto.requestedRole,
                status: dto.status ?? 'pending',
                createdAt: dto.createdAt,
              ))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> reviewApplication({
    required String applicationId,
    required bool approve,
    String? reason,
  }) {
    return _rpc('review_role_application', {
      'p_application_id': applicationId,
      'p_approve': approve,
      'p_reason': reason,
    });
  }

  @override
  Future<List<AdminCategory>> fetchCategories() async {
    try {
      final rows = await _client
          .from('categories')
          .select('id, name, image_url')
          .order('name');
      return rows.map(AdminCategoryDto.fromJson).map((dto) => AdminCategory(
            id: dto.id,
            name: dto.name,
            imageUrl: dto.imageUrl,
          )).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> createCategory({
    required String name,
    String? parentId,
    String? imageUrl,
  }) {
    return _rpc('create_category', {
      'p_name': name,
      'p_parent_id': parentId,
      'p_image_url': imageUrl,
    });
  }

  @override
  Future<void> renameCategory({
    required String categoryId,
    required String name,
    String? imageUrl,
  }) {
    return _rpc('rename_category', {
      'p_category_id': categoryId,
      'p_name': name,
      'p_image_url': imageUrl,
    });
  }

  @override
  Future<void> deleteCategory({required String categoryId}) {
    return _rpc('delete_category', {'p_category_id': categoryId});
  }

  // --------------------------------------------------------- brands (2b)
  @override
  Future<List<AdminBrand>> fetchBrands() async {
    try {
      final rows = await _client.from('brands').select().order('name');
      return rows.map(AdminBrandDto.fromJson).map((dto) => AdminBrand(
            id: dto.id,
            name: dto.name,
            description: dto.description ?? '',
            imageUrl: dto.imageUrl,
            status: AdminCatalogStatus.fromName(dto.status),
          )).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> createBrand({
    required String name,
    String? description,
    String? imageUrl,
  }) async {
    try {
      await _client.from('brands').insert({
        'name': name,
        'description': description ?? '',
        'image_url': imageUrl,
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> updateBrand({
    required String brandId,
    required String name,
    String? description,
    String? imageUrl,
  }) async {
    try {
      await _client.from('brands').update({
        'name': name,
        'description': description ?? '',
        'image_url': imageUrl,
      }).eq('id', brandId);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> setBrandArchived({
    required String brandId,
    required bool archived,
  }) async {
    try {
      await _client.from('brands').update({
        'status': archived ? 'archived' : 'active',
      }).eq('id', brandId);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> deleteBrand({required String brandId}) async {
    try {
      // products.brand_id is ON DELETE SET NULL — referenced products keep
      // existing, just brand-less.
      await _client.from('brands').delete().eq('id', brandId);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  // -------------------------------------------------------- products (2b)
  String _productImageUrl(String storagePath) {
    return _client.storage.from('product_images').getPublicUrl(storagePath);
  }

  @override
  Future<List<AdminProductSummary>> fetchProducts({String? query}) async {
    try {
      var request = _client.from('products').select(
            '*, brands(name), categories(name), businesses(name), '
            'product_variants(id), product_images(id, storage_path, sort_order)',
          );
      final q = query?.trim() ?? '';
      if (q.isNotEmpty) {
        request = request.ilike('name', '%$q%');
      }
      final rows =
          await request.order('created_at', ascending: false).limit(100);
      return rows.map(AdminProductRowDto.fromJson).map((dto) {
        final images = [...dto.productImages]
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        return AdminProductSummary(
          id: dto.id,
          name: dto.name,
          categoryId: dto.categoryId,
          businessId: dto.businessId,
          categoryName: dto.categories?.name ?? '',
          businessName: dto.businesses?.name ?? '',
          basePriceMinor: dto.basePriceMinor,
          variantCount: dto.productVariants.length,
          description: dto.description ?? '',
          status: AdminCatalogStatus.fromName(dto.status),
          brandId: dto.brandId,
          brandName: dto.brands?.name,
          images: images
              .map((image) => AdminProductImageRef(
                    id: image.id,
                    storagePath: image.storagePath,
                    url: _productImageUrl(image.storagePath),
                  ))
              .toList(),
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<List<AdminBusinessRef>> fetchActiveBusinesses() async {
    try {
      final rows = await _client
          .from('businesses')
          .select('id, name')
          .eq('status', 'active')
          .order('name');
      return rows
          .map(AdminBusinessRefDto.fromJson)
          .map((dto) => AdminBusinessRef(id: dto.id, name: dto.name))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<String> createProduct(AdminProductDraft draft) async {
    try {
      // p_variants stays empty: admin_create_product auto-creates a 'Default'
      // variant with a null price, which keeps tracking the base price.
      final productId = await _client.rpc('admin_create_product', params: {
        'p_business_id': draft.businessId,
        'p_category_id': draft.categoryId,
        'p_name': draft.name,
        'p_description': draft.description,
        'p_base_price_minor': draft.basePriceMinor,
        'p_brand_id': draft.brandId,
        'p_variants': <Map<String, dynamic>>[],
      }) as String;
      return productId;
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> updateProduct(AdminProductDraft draft) async {
    final id = draft.id;
    if (id == null) {
      throw const ServerFailure('Product id is required to update');
    }
    try {
      await _client.rpc('admin_update_product', params: {
        'p_product_id': id,
        'p_category_id': draft.categoryId,
        'p_name': draft.name,
        'p_description': draft.description,
        'p_base_price_minor': draft.basePriceMinor,
        'p_brand_id': draft.brandId,
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> setProductArchived({
    required String productId,
    required bool archived,
  }) {
    return _rpc('admin_set_product_archived', {
      'p_product_id': productId,
      'p_archived': archived,
    });
  }

  @override
  Future<void> addProductImage({
    required String productId,
    required String filePath,
  }) async {
    try {
      // The storage path's first segment must be the owning business id —
      // the same {business_id}/... convention the storage policies enforce
      // for owners (0020); admins may write any folder in the bucket.
      final row = await _client
          .from('products')
          .select('business_id')
          .eq('id', productId)
          .maybeSingle();
      final businessId = row?['business_id'] as String?;
      if (businessId == null) {
        throw const ServerFailure('Product not found');
      }
      final fileName = filePath.split(Platform.pathSeparator).last;
      final bytes = await File(filePath).readAsBytes();
      final path =
          '$businessId/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      await _client.storage.from('product_images').uploadBinary(path, bytes);
      await _client.rpc('admin_add_product_image', params: {
        'p_product_id': productId,
        'p_storage_path': path,
      });
    } on ServerFailure {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } on StorageException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> removeProductImage({
    required String imageId,
    required String storagePath,
  }) async {
    try {
      await _client.from('product_images').delete().eq('id', imageId);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
    // The reference is gone — the binary is cleaned up best-effort. An
    // orphaned public object is harmless, so storage failures don't fail
    // the mutation (mirrors the business portal's removal path).
    try {
      await _client.storage.from('product_images').remove([storagePath]);
    } catch (_) {}
  }

  @override
  Future<List<AuditEntry>> fetchAuditLogs() async {
    try {
      final rows = await _client
          .from('audit_logs')
          .select()
          .order('created_at', ascending: false)
          .limit(100);
      return rows
          .map(AuditLogDto.fromJson)
          .map((dto) => AuditEntry(
                id: dto.id,
                actor: dto.actor,
                action: dto.action,
                targetType: dto.targetType,
                targetId: dto.targetId,
                createdAt: dto.createdAt,
              ))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<PlatformAnalyticsReport> fetchPlatformReport() async {
    try {
      final result = await _client.rpc('get_platform_report');
      final map = Map<String, dynamic>.from(result as Map);
      return PlatformAnalyticsReport(
        orderCount: (map['order_count'] as int?) ?? 0,
        gmvMinor: (map['gmv_minor'] as int?) ?? 0,
        deliveryFeesMinor: (map['delivery_fees_minor'] as int?) ?? 0,
        activeBusinesses: (map['active_businesses'] as int?) ?? 0,
        activeProducts: (map['active_products'] as int?) ?? 0,
        pendingApplications: (map['pending_applications'] as int?) ?? 0,
      );
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<PlatformSettings> fetchPlatformSettings() async {
    try {
      final row = await _client
          .from('platform_settings')
          .select()
          .eq('id', 1)
          .maybeSingle();
      if (row == null) {
        return const PlatformSettings(
          deliveryFeeMinor: 0,
          platformCommissionPercent: 0,
          driverCommissionPercent: 0,
          paymentAccount: '',
        );
      }
      final dto = PlatformSettingsAdminDto.fromJson(row);
      return PlatformSettings(
        deliveryFeeMinor: dto.deliveryFeeMinor,
        platformCommissionPercent: dto.platformCommissionPercent,
        driverCommissionPercent: dto.driverCommissionPercent,
        paymentAccount: dto.paymentAccount,
      );
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> updatePlatformSettings(PlatformSettings settings) async {
    try {
      await _client.from('platform_settings').update({
        'delivery_fee_minor': settings.deliveryFeeMinor,
        'platform_commission_percent': settings.platformCommissionPercent,
        'driver_commission_percent': settings.driverCommissionPercent,
        'payment_account': settings.paymentAccount,
      }).eq('id', 1);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }
}
