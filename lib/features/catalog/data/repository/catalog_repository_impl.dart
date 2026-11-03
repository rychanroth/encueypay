import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/failure_mapping.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/active_sale.dart';
import '../../domain/entities/banner.dart';
import '../../domain/entities/brand.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/entities/product_sort.dart';
import '../dtos/active_sale_dto.dart';
import '../dtos/brand_dto.dart';
import '../dtos/category_dto.dart';
import '../dtos/product_dto.dart';
import '../dtos/product_review_join_dto.dart';
import '../dtos/product_variant_dto.dart';
import '../mappers/active_sale_mapper.dart';
import '../mappers/brand_mapper.dart';
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
  // price-only variants feed the card "from" price; `brands(name)` feeds the
  // card badge. Card ratings come from the product_ratings view (§6.1) —
  // plain SQL aggregation, embeddable via the reviews.product_id FK, because
  // inline PostgREST aggregates (avg()/count() in the select parameter)
  // require PostgREST ≥ 12 and fail to parse on this backend.
  static const _productSelect =
      '*, brands(name), product_ratings(rating_avg, review_count), '
      'product_images(storage_path, sort_order), '
      'product_variants(id, price_minor, status)';

  /// §48: Storage owns the binary; DB owns the reference. Public URLs are
  /// resolved here in the data layer — never in the UI. Full http(s)
  /// references pass through (the seed carries remote demo imagery; the
  /// same convention as banners and catalog assets).
  String _publicUrl(String storagePath) {
    if (storagePath.startsWith('http')) return storagePath;
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
          .select('id, name, parent_id, image_path')
          .order('name');
      return rows
          .map(CategoryDto.fromJson)
          .map((d) => d.toDomain(imageUrl: _catalogImageUrl(d.imagePath)))
          .toList();
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<List<Brand>> fetchBrands() async {
    try {
      final rows = await _client
          .from('brands')
          .select('id, name, image_path')
          .eq('status', 'active')
          .order('name');
      return rows
          .map(BrandDto.fromJson)
          .map((d) => d.toDomain(imageUrl: _catalogImageUrl(d.imagePath)))
          .toList();
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
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
    DateTime? createdAfter,
    bool activeOnly = false,
    bool inStockOnly = false,
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
        // Assignment §2 / §5.1.2: search matches product name OR brand name.
        // The or-filter syntax reserves commas/parens — sanitize them out of
        // user input. Brand matching resolves matching brand ids first and
        // ORs the plain `brand_id.in.(...)` column reference — embed columns
        // inside or() (brands.name.ilike) require PostgREST ≥ 12 semantics
        // this backend does not guarantee.
        final q = query.trim().replaceAll(RegExp(r'[,()]'), ' ').trim();
        if (q.isNotEmpty) {
          final brandIds = await _client
              .from('brands')
              .select('id')
              .ilike('name', '%$q%');
          final idList = [
            for (final row in brandIds) row['id'] as String,
          ];
          request = idList.isEmpty
              ? request.ilike('name', '%$q%')
              : request.or(
                  'name.ilike.%$q%,brand_id.in.(${idList.join(',')})',
                );
        }
      }
      // New-arrivals qualification (§5.1.1): recency window + merchandising
      // eligibility — server-executed filters (§1.2 server authority).
      final cutoff = createdAfter?.toUtc().toIso8601String();
      if (cutoff != null) {
        request = request.gte('created_at', cutoff);
      }
      if (activeOnly) {
        request = request.eq('status', 'active');
      }
      if (inStockOnly) {
        request = request.gt('stock', 0);
      }

      // order()/range() are transforms — they run last, off the filtered
      // builder. `id` tiebreak keeps equal-timestamp order deterministic.
      final ordered = switch (sort) {
        ProductSort.newest => request
            .order('created_at', ascending: false)
            .order('id'),
        ProductSort.priceAsc => request.order('base_price_minor'),
        ProductSort.priceDesc =>
          request.order('base_price_minor', ascending: false),
        ProductSort.name => request.order('name'),
      };
      final rows =
          await ordered.range(offset, offset + limit - 1);
      return _mapProductRows(rows);
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<ProductDetail> fetchProductDetail(String productId) async {
    try {
      final data = await _client
          .from('products')
          .select(
            '*, brands(name), product_variants(*), '
            'product_images(*), '
            'reviews(id, rating, text, created_at, users(full_name, avatar_url))',
          )
          .eq('id', productId)
          .maybeSingle();
      if (data == null) {
        throw const ServerFailure('Product not found');
      }

      final productDto = ProductDto.fromJson(data);
      final brandName =
          ((data['brands'] as Map<String, dynamic>?)?['name'] as String?) ??
              '';
      final activeVariants = ((data['product_variants'] as List? ?? const [])
              .whereType<Map<String, dynamic>>())
          .map(ProductVariantDto.fromJson)
          .map((d) => d.toDomain(resolveImageUrl: _publicUrl))
          // Archived variants are soft-deleted rows (order_items keeps
          // referencing them) — customers never see them.
          .where((variant) => variant.status != ProductStatus.archived)
          .toList();
      // A null-price row is the single-price placeholder, not a selectable
      // option. Keep it only when there is no priced variant to choose.
      final pricedVariants =
          activeVariants.where((variant) => variant.priceMinor != null).toList();
      final variants =
          pricedVariants.isNotEmpty ? pricedVariants : activeVariants;
      final reviews = ((data['reviews'] as List? ?? const [])
              .whereType<Map<String, dynamic>>())
          .map(ProductReviewJoinDto.fromJson)
          .map((d) => ProductReviewInfo(
                authorName: d.users?.fullName ?? 'Customer',
                rating: d.rating,
                text: d.text ?? '',
                createdAt: d.createdAt,
                avatarUrl: d.users?.avatarUrl,
              ))
          .toList();

      return ProductDetail(
        product: productDto.toDomain(imageUrls: _resolveUrls(productDto)),
        variants: variants,
        brandName: brandName,
        reviews: reviews,
      );
    } on ServerFailure {
      rethrow;
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
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
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  /// Resolves a brand/category `image_path` to a display URL (DESIGN.md
  /// imagery pipeline): full http(s) references pass through (the seed and
  /// legacy rows may carry them), bare paths resolve against the public
  /// `catalog_assets` bucket — same convention as banners (§5b).
  String? _catalogImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    return _client.storage.from('catalog_assets').getPublicUrl(path);
  }

  @override
  Future<List<CatalogBanner>> fetchApprovedBanners({int limit = 5}) async {
    try {
      // Section 5b: banners are their own table — approved rows within
      // their display window (the window filter is applied here in the
      // data layer; PostgREST cannot call now() inside or-filters).
      final now = DateTime.now().toUtc();
      final nowIso = now.toIso8601String();
      final rows = await _client
          .from('banners')
          .select(
            'id, name, image_path, starts_at, ends_at, '
            'sales(scope, brand_id, category_id, active, starts_at, ends_at, '
            'name, brands(name), categories(name))',
          )
          .eq('status', 'approved')
          .order('created_at', ascending: false)
          .limit(limit * 2);
      final banners = <CatalogBanner>[];
      for (final row in rows) {
        final startsAt = row['starts_at'] as String?;
        final endsAt = row['ends_at'] as String?;
        final started = startsAt == null || startsAt.compareTo(nowIso) <= 0;
        final notEnded = endsAt == null || endsAt.compareTo(nowIso) > 0;
        if (!started || !notEnded) continue;

        // A sale-linked banner is an advertisement for a live discount: it
        // hides itself when that sale ends or is switched off. Rows without
        // a sale are display-only and render inert.
        final sale = row['sales'] as Map<String, dynamic>?;
        String? saleScope;
        String? targetId;
        String? targetName;
        var target = CatalogBannerTarget.none;
        if (sale != null) {
          final saleActive = sale['active'] as bool? ?? false;
          final saleStarts = sale['starts_at'] as String?;
          final saleEnds = sale['ends_at'] as String?;
          final saleStarted =
              saleStarts == null || saleStarts.compareTo(nowIso) <= 0;
          final saleNotEnded =
              saleEnds == null || saleEnds.compareTo(nowIso) > 0;
          if (!saleActive || !saleStarted || !saleNotEnded) continue;
          saleScope = sale['scope'] as String?;
          final saleBrandId = sale['brand_id'] as String?;
          final saleCategoryId = sale['category_id'] as String?;
          switch (saleScope) {
            case 'brand' when saleBrandId != null:
              target = CatalogBannerTarget.brand;
              targetId = saleBrandId;
              targetName = (sale['brands'] as Map<String, dynamic>?)?['name']
                  as String?;
            case 'category' when saleCategoryId != null:
              target = CatalogBannerTarget.category;
              targetId = saleCategoryId;
              targetName =
                  (sale['categories'] as Map<String, dynamic>?)?['name']
                      as String?;
            case 'platform':
              target = CatalogBannerTarget.platform;
              targetName = sale['name'] as String?;
          }
        }

        final path = row['image_path'] as String?;
        if (path == null || path.isEmpty) continue;
        banners.add(CatalogBanner(
          id: row['id'] as String,
          name: row['name'] as String? ?? '',
          // Full public URLs pass through; only bare paths get re-wrapped.
          imageUrl: path.startsWith('http')
              ? path
              : _client.storage.from('promo_assets').getPublicUrl(path),
          target: target,
          targetId: targetId,
          targetName: targetName,
        ));
        if (banners.length >= limit) break;
      }
      return banners;
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<List<ActiveSale>> fetchActiveSales() async {
    try {
      // The view already filters active + window — the pricing rule lives
      // in SQL only; the client never re-derives eligibility.
      final rows = await _client.from('active_sales').select(
          'id, name, description, scope, discount_type, discount_value, '
          'starts_at, ends_at, brand_id, category_id');
      final sales = <ActiveSale>[];
      for (final row in rows) {
        final sale = ActiveSaleDto.fromJson(
          Map<String, dynamic>.from(row as Map),
        ).toDomain();
        if (sale != null) sales.add(sale);
      }
      return sales;
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<int> fetchDeliveryFeeMinor() async {
    try {
      // Singleton row (`id = 1`) shared with checkout/admin; the storefront
      // only reads the fee so it can state the real platform rate.
      final row = await _client
          .from('platform_settings')
          .select('delivery_fee_minor')
          .eq('id', 1)
          .maybeSingle();
      return (row?['delivery_fee_minor'] as int?) ?? 0;
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }
}
