import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner.freezed.dart';

/// Where a targeted banner sends the customer (Section 9). Catalog-local
/// vocabulary mirroring the promotions feature's BannerTargetKind —
/// features never import each other (ARCH-04).
enum CatalogBannerTarget { none, brand, category }

/// An approved promotional banner for the home feed (spec §27/§48). When
/// [target] is set, tapping deep-links into the Discovery feed pre-filtered
/// to the target (brand/category); 'none' renders an inert banner.
@freezed
abstract class CatalogBanner with _$CatalogBanner {
  const factory CatalogBanner({
    required String id,
    required String name,
    required String imageUrl,
    @Default(CatalogBannerTarget.none) CatalogBannerTarget target,
    String? targetId,
    String? targetName,
  }) = _CatalogBanner;
}
