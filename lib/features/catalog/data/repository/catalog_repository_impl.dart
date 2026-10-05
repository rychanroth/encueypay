import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/banner.dart';
import '../../domain/entities/brand.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/business_detail.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/entities/product_sort.dart';
import '../dtos/brand_dto.dart';
import '../dtos/business_dto.dart';
import '../dtos/category_dto.dart';
import '../dtos/product_dto.dart';
import '../dtos/product_review_join_dto.dart';
import '../dtos/product_variant_dto.dart';
import '../mappers/brand_mapper.dart';
import '../mappers/business_mapper.dart';
import '../mappers/category_mapper.dart';
import '../mappers/product_mapper.dart';
import '../mappers/product_variant_mapper.dart';
import 'catalog_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final catalogRepositoryProvider = Provider<ICatalogRepository>((ref) {
  return CatalogRepositoryImpl(ref.watch(supabaseClientProvider));
});

class CatalogRepositoryImpl implements ICatalogRepository {
  CatalogRepositoryImpl(this._client);

  final SupabaseClient _client;

  // `*` is required: an embed-only select makes PostgREST omit the product's
  // own columns, which then fail ProductDto.fromJson's required fields.
  // price-only variants feed the card "from" price. `brands(name)` backs the
  // brand-name search filter (assignment §2); ProductDto ignores the extra
  // embed key.
  static const _productSelect =
      '*, brands(name), product_images(storage_path, sort_order), '
      'product_variants(price_minor)';

  /// §48: Storage owns the binary; DB owns the reference. Public URLs are
  /// resolved here in the data layer — never in the UI.
  String _publicUrl(String storagePath) {
    return _client.storage.from('product_images').getPublicUrl(storagePath);
  }

  List<String> _resolveUrls(ProductDto dto) {
    // Display order comes from sort_order (server-assigned); ties keep the
    // embed's own order.
    final images = [...dto.productImages]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return images
        .map((image) => image.storagePath)
        .whereType<String>()
        .map(_publicUrl)
        .toList();
  }

  List<Product> _mapProductRows(List<Map<String, dynamic>> rows) {
    return rows.map(ProductDto.fromJson).map((dto) {
      return dto.toDomain(imageUrls: _resolveUrls(dto));
    }).toList();
  }

  @override
  Future<List<Category>> fetchCategories() async {
    try {
      final rows = await _client
          .from('categories')
          .select()
          .order('name');
      return rows.map(CategoryDto.fromJson).map((d) => d.toDomain()).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<List<Brand>> fetchBrands() async {
    try {
      final rows = await _client
          .from('brands')
          .select('id, name, image_url')
          .eq('status', 'active')
          .order('name');
      return rows.map(BrandDto.fromJson).map((d) => d.toDomain()).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<List<Business>> fetchBusinesses({int limit = 10}) async {
    try {
      final rows = await _client
          .from('businesses')
          .select()
          .eq('status', 'active')
          .order('created_at', ascending: false)
          .limit(limit);
      return rows.map(BusinessDto.fromJson).map((d) => d.toDomain()).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<List<Product>> fetchProducts({
    String? query,
    String? categoryId,
    String? brandId,
    ProductSort sort = ProductSort.newest,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      var request = _client
          .from('products')
          .select(_productSelect);
      // Visibility (Section 2d): products of active businesses are listed
      // regardless of product status — archived ones render as "Unavailable"
      // in the UI and fail checkout server-side.
      if (categoryId != null) {
        // Discovery aggregates: a parent category includes its own products
        // plus all sub-category products (2-level hierarchy, Section 2c).
        final childRows = await _client
            .from('categories')
            .select('id')
            .eq('parent_id', categoryId);
        final categoryIds = [
          categoryId,
          for (final row in childRows) row['id'] as String,
        ];
        request = request.inFilter('category_id', categoryIds);
      }
      if (brandId != null) {
        request = request.eq('brand_id', brandId);
      }
      if (query != null && query.trim().isNotEmpty) {
        // Assignment §2: search matches product name OR brand name. The
        // PostgREST or-filter syntax reserves commas/parens — sanitize them
        // out of user input.
        final q = query.trim().replaceAll(RegExp(r'[,()]'), ' ').trim();
        if (q.isNotEmpty) {
          request = request.or('name.ilike.%$q%,brands.name.ilike.%$q%');
        }
      }
      // order()/range() are transforms — they run last, off the filtered
      // builder.
      final ordered = switch (sort) {
        ProductSort.newest =>
          request.order('created_at', ascending: false),
        ProductSort.priceAsc => request.order('base_price_minor'),
        ProductSort.priceDesc =>
          request.order('base_price_minor', ascending: false),
        ProductSort.name => request.order('name'),
      };
      final rows =
          await ordered.range(offset, offset + limit - 1);
      return _mapProductRows(rows);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<ProductDetail> fetchProductDetail(String productId) async {
    try {
      final data = await _client
          .from('products')
          .select(
            '*, businesses(name), brands(name), product_variants(*), '
            'product_images(*), '
            'reviews(id, rating, text, created_at, users(full_name))',
          )
          .eq('id', productId)
          .maybeSingle();
      if (data == null) {
        throw const ServerFailure('Product not found');
      }

      final productDto = ProductDto.fromJson(data);
      final businessName =
          ((data['businesses'] as Map<String, dynamic>?)?['name'] as String?)
              ??
              '';
      final brandName =
          ((data['brands'] as Map<String, dynamic>?)?['name'] as String?) ??
              '';
      final variants = ((data['product_variants'] as List? ?? const [])
              .whereType<Map<String, dynamic>>())
          .map(ProductVariantDto.fromJson)
          .map((d) => d.toDomain(resolveImageUrl: _publicUrl))
          .toList();
      final reviews = ((data['reviews'] as List? ?? const [])
              .whereType<Map<String, dynamic>>())
          .map(ProductReviewJoinDto.fromJson)
          .map((d) => ProductReviewInfo(
                authorName: d.users?.fullName ?? 'Customer',
                rating: d.rating,
                text: d.text ?? '',
                createdAt: d.createdAt,
              ))
          .toList();

      return ProductDetail(
        product: productDto.toDomain(imageUrls: _resolveUrls(productDto)),
        variants: variants,
        businessName: businessName,
        brandName: brandName,
        reviews: reviews,
      );
    } on ServerFailure {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<List<Product>> fetchRelatedProducts({
    required String categoryId,
    required String excludeProductId,
    int limit = 6,
  }) async {
    try {
      final rows = await _client
          .from('products')
          .select(_productSelect)
          .eq('category_id', categoryId)
          .neq('id', excludeProductId)
          .limit(limit);
      return _mapProductRows(rows);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<List<CatalogBanner>> fetchApprovedBanners({int limit = 5}) async {
    try {
      final rows = await _client
          .from('promotions')
          .select('id, name, banner_image_path')
          .eq('banner_status', 'approved')
          .not('banner_image_path', 'is', null)
          .order('created_at', ascending: false)
          .limit(limit);
      return rows.map((row) {
        final path = row['banner_image_path'] as String;
        return CatalogBanner(
          id: row['id'] as String,
          name: row['name'] as String? ?? '',
          // submit_banner stores a FULL public URL; only re-wrap bare paths.
          imageUrl: path.startsWith('http')
              ? path
              : _client.storage.from('promo_assets').getPublicUrl(path),
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<BusinessDetail> fetchBusinessDetail(String businessId) async {
    try {
      final results = await Future.wait([
        _client.from('businesses').select().eq('id', businessId).maybeSingle(),
        _client
            .from('products')
            .select(_productSelect)
            .eq('status', 'active')
            .eq('business_id', businessId)
            .order('created_at', ascending: false)
            .limit(20),
      ]);
      final businessRow = results[0] as Map<String, dynamic>?;
      final productRows = results[1] as List<Map<String, dynamic>>;
      if (businessRow == null) {
        throw const ServerFailure('Business not found');
      }

      return BusinessDetail(
        business: BusinessDto.fromJson(businessRow).toDomain(),
        products: _mapProductRows(productRows),
      );
    } on ServerFailure {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }
}
