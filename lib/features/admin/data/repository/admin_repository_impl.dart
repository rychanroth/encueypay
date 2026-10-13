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
  Future<List<AdminCategory>> fetchCategories() async {
    try {
      final rows = await _client
          .from('categories')
          .select('id, name, parent_id, image_path')
          .order('name');
      return rows.map(AdminCategoryDto.fromJson).map((dto) => AdminCategory(
            id: dto.id,
            name: dto.name,
            imageUrl: _catalogImageUrl(dto.imagePath),
            imagePath: dto.imagePath,
            parentId: dto.parentId,
          )).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  /// Resolves a brand/category `image_path` to a display URL — http(s)
  /// passthrough, bare paths against the public `catalog_assets` bucket.
  String? _catalogImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    return _client.storage.from('catalog_assets').getPublicUrl(path);
  }

  @override
  Future<String> uploadCatalogImage({required String filePath}) async {
    try {
      final fileName = filePath.split(Platform.pathSeparator).last;
      final path = 'catalog/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      final bytes = await File(filePath).readAsBytes();
      await _client.storage.from('catalog_assets').uploadBinary(path, bytes);
      return path;
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } on StorageException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> createCategory({
    required String name,
    String? parentId,
    String? imagePath,
  }) {
    return _rpc('create_category', {
      'p_name': name,
      'p_parent_id': parentId,
      'p_image_path': imagePath,
    });
  }

  @override
  Future<void> renameCategory({
    required String categoryId,
    required String name,
    String? imagePath,
    String? parentId,
  }) {
    return _rpc('rename_category', {
      'p_category_id': categoryId,
      'p_name': name,
      'p_image_path': imagePath,
      'p_parent_id': parentId,
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
      final rows = await _client
          .from('brands')
          .select('id, name, description, image_path, status')
          .order('name');
      return rows.map(AdminBrandDto.fromJson).map((dto) => AdminBrand(
            id: dto.id,
            name: dto.name,
            description: dto.description ?? '',
            imageUrl: _catalogImageUrl(dto.imagePath),
            imagePath: dto.imagePath,
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
    String? imagePath,
  }) async {
    try {
      await _client.from('brands').insert({
        'name': name,
        'description': description ?? '',
        'image_path': imagePath,
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
    String? imagePath,
  }) async {
    try {
      await _client.from('brands').update({
        'name': name,
        'description': description ?? '',
        'image_path': imagePath,
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
    if (storagePath.startsWith('http')) return storagePath;
    return _client.storage.from('product_images').getPublicUrl(storagePath);
  }

  @override
  Future<List<AdminProductSummary>> fetchProducts({String? query}) async {
    try {
      var request = _client.from('products').select(
            '*, brands(name), categories(name), '
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
          categoryName: dto.categories?.name ?? '',
          basePriceMinor: dto.basePriceMinor,
          variantCount: dto.productVariants.length,
          stock: dto.stock,
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
  Future<AdminSalesReport> fetchSalesReport({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final result = await _client.rpc('get_sales_report', params: {
        'p_from': from.toIso8601String().substring(0, 10),
        'p_to': to.toIso8601String().substring(0, 10),
      });
      final map = Map<String, dynamic>.from(result as Map);
      return AdminSalesReport(
        from: DateTime.parse(map['from'] as String),
        to: DateTime.parse(map['to'] as String),
        totalOrders: (map['total_orders'] as int?) ?? 0,
        completedOrders: (map['completed_orders'] as int?) ?? 0,
        cancelledOrders: (map['cancelled_orders'] as int?) ?? 0,
        totalSalesMinor: (map['total_sales_minor'] as int?) ?? 0,
        averageOrderValueMinor:
            (map['average_order_value_minor'] as int?) ?? 0,
        lowStockProducts: (map['low_stock_products'] as int?) ?? 0,
        outOfStockProducts: (map['out_of_stock_products'] as int?) ?? 0,
        bestSellers: ((map['best_sellers'] as List? ?? const [])
                .whereType<Map<String, dynamic>>())
            .map((row) => AdminBestSeller(
                  name: row['name'] as String? ?? '',
                  units: (row['units'] as int?) ?? 0,
                ))
            .toList(),
        topCategories: ((map['top_categories'] as List? ?? const [])
                .whereType<Map<String, dynamic>>())
            .map((row) => AdminCategoryUnits(
                  name: row['name'] as String? ?? '',
                  units: (row['units'] as int?) ?? 0,
                ))
            .toList(),
        purchaseFrequency:
            ((map['purchase_frequency'] as List? ?? const [])
                    .whereType<Map<String, dynamic>>())
                .map((row) => AdminCustomerFrequency(
                      name: row['name'] as String? ?? '',
                      orders: (row['orders'] as int?) ?? 0,
                    ))
                .toList(),
        // DESIGN.md §5.2.4 executive extras (additive RPC keys).
        netSettledMinor: (map['net_settled_minor'] as int?) ?? 0,
        inventoryValuationMinor:
            (map['inventory_valuation_minor'] as int?) ?? 0,
        paymentSplit: () {
          final split = map['payment_split'];
          if (split is! Map) return const AdminPaymentSplit();
          return AdminPaymentSplit(
            qrCount: (split['qr_count'] as int?) ?? 0,
            codCount: (split['cod_count'] as int?) ?? 0,
            qrAmountMinor: (split['qr_amount_minor'] as int?) ?? 0,
            codAmountMinor: (split['cod_amount_minor'] as int?) ?? 0,
          );
        }(),
        brandRevenue: ((map['brand_revenue'] as List? ?? const [])
                .whereType<Map<String, dynamic>>())
            .map((row) => AdminBrandRevenue(
                  name: row['name'] as String? ?? '',
                  revenueMinor: (row['revenue_minor'] as int?) ?? 0,
                ))
            .toList(),
      );
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
        'p_category_id': draft.categoryId,
        'p_name': draft.name,
        'p_description': draft.description,
        'p_base_price_minor': draft.basePriceMinor,
        'p_brand_id': draft.brandId,
        'p_stock': draft.stock,
        // Empty → the server auto-creates the 'Default' variant.
        'p_variants': [
          for (final variant in draft.variants)
            {'name': variant.name, 'price_minor': variant.priceMinor},
        ],
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
        'p_stock': draft.stock,
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
  Future<void> adjustProductStock({
    required String productId,
    required int newStock,
  }) {
    return _rpc('admin_adjust_product_stock', {
      'p_product_id': productId,
      'p_new_stock': newStock,
    });
  }

  @override
  Future<void> addProductImage({
    required String productId,
    required String filePath,
  }) async {
    try {
      // The storage path's first segment must be the owning business id —
      // Images live under the product's own folder (single-seller
      // convention); admins may write any folder in the bucket.
      final fileName = filePath.split(Platform.pathSeparator).last;
      final bytes = await File(filePath).readAsBytes();
      // Single-seller convention: images live under the product's own folder.
      final path =
          '$productId/${DateTime.now().millisecondsSinceEpoch}_$fileName';
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

  // ---------------------------------------------------------- orders (§3)
  @override
  Future<List<AdminOrderSummary>> fetchOrders() async {
    try {
      final rows = await _client
          .from('orders')
          .select(
            'id, status, cancellation_reason, subtotal_minor, '
            'discount_minor, delivery_fee_minor, total_minor, created_at, '
            'users(full_name), payments(method, status), '
            'order_items(product_name, variant_name, '
            'quantity, line_total_minor), '
            // Return reason lives on the return_items lines (per-item
            // reason in request_return), not on the return_requests header
            // — same fix as the customer orders repository.
            'return_requests(id, status, return_items(reason, quantity))',
          )
          .order('created_at', ascending: false)
          .limit(50);
      return rows.map(AdminOrderRowDto.fromJson).map((dto) {
        final payment = dto.payments.firstOrNull;
        return AdminOrderSummary(
          id: dto.id,
          customerName: dto.users?.fullName ?? 'Customer',
          subtotalMinor: dto.subtotalMinor,
          discountMinor: dto.discountMinor,
          deliveryFeeMinor: dto.deliveryFeeMinor,
          totalMinor: dto.totalMinor,
          createdAt: dto.createdAt,
          status: AdminOrderStatus.fromName(dto.status),
          cancellationReason: dto.cancellationReason,
          paymentMethod: payment?.method,
          paymentStatus: payment?.status,
          items: dto.items
              .map((item) => AdminOrderItem(
                    productName: item.productName,
                    variantName: item.variantName,
                    quantity: item.quantity,
                    lineTotalMinor: item.lineTotalMinor,
                  ))
              .toList(),
          returns: dto.returnRequests
              .map((request) => AdminReturnRequest(
                    id: request.id,
                    status: request.status ?? 'pending',
                    // Aggregate the per-line reasons into one display string.
                    reason: request.returnItems
                        .map((item) => item.reason)
                        .where((reason) => reason.isNotEmpty)
                        .join(' · '),
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
  Future<void> transitionOrder({
    required String orderId,
    required String status,
    String? reason,
  }) {
    return _rpc('admin_transition_order', {
      'p_order_id': orderId,
      'p_status': status,
      'p_reason': reason,
    });
  }

  @override
  Future<void> processReturn({
    required String returnId,
    required bool approve,
  }) {
    return _rpc('admin_process_return', {
      'p_return_id': returnId,
      'p_approve': approve,
    });
  }

  @override
  Future<void> markRefunded({
    required String orderId,
    String? reference,
  }) {
    return _rpc('mark_refunded', {
      'p_order_id': orderId,
      'p_reference': reference,
    });
  }

  @override
  Future<void> completeReturn({required String returnId}) {
    return _rpc('admin_complete_return', {'p_return_id': returnId});
  }

  @override
  Future<void> simulateQrPayment({required String orderId}) {
    return _rpc('simulate_qr_payment', {'p_order_id': orderId});
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
      );
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<AdminKpis> fetchAdminKpis() async {
    try {
      final result = await _client.rpc('get_admin_kpis');
      final map = Map<String, dynamic>.from(result as Map);
      return AdminKpis(
        totalProducts: (map['total_products'] as int?) ?? 0,
        activeProducts: (map['active_products'] as int?) ?? 0,
        totalOrders: (map['total_orders'] as int?) ?? 0,
        totalCustomers: (map['total_customers'] as int?) ?? 0,
        totalSalesMinor: (map['total_sales_minor'] as int?) ?? 0,
        lowStockProducts: (map['low_stock_products'] as int?) ?? 0,
        outOfStockProducts: (map['out_of_stock_products'] as int?) ?? 0,
        bestSellers: ((map['best_sellers'] as List? ?? const [])
                .whereType<Map<String, dynamic>>())
            .map((row) => AdminBestSeller(
                  name: row['name'] as String? ?? '',
                  units: (row['units'] as int?) ?? 0,
                ))
            .toList(),
        salesTrend: ((map['sales_trend'] as List? ?? const [])
                .whereType<Map<String, dynamic>>())
            .map((row) => AdminTrendPoint(
                  day: DateTime.parse(row['day'] as String),
                  orders: (row['orders'] as int?) ?? 0,
                  salesMinor: (row['sales_minor'] as int?) ?? 0,
                ))
            .toList(),
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
          paymentAccount: '',
          qrAccountId: '',
        );
      }
      final dto = PlatformSettingsAdminDto.fromJson(row);
      return PlatformSettings(
        deliveryFeeMinor: dto.deliveryFeeMinor,
        platformCommissionPercent: dto.platformCommissionPercent,
        paymentAccount: dto.paymentAccount,
        qrAccountId: dto.qrAccountId,
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
        'payment_account': settings.paymentAccount,
        'qr_account_id': settings.qrAccountId,
      }).eq('id', 1);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }
}
