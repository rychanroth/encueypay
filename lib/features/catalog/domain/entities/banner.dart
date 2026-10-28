import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner.freezed.dart';

/// Where a targeted banner sends the customer (Section 9). Catalog-local
/// vocabulary mirroring the promotions feature's BannerTargetKind —
/// features never import each other (ARCH-04).
enum CatalogBannerTarget { none, brand, category, platform }

/// An approved promotional banner for the home feed (spec §27/§48). When
/// [target] is set, tapping deep-links into the Discovery feed —
/// brand-filtered for brand targets, the full feed for a store-wide
/// campaign ([CatalogBannerTarget.platform]); 'none' renders an inert
/// display-only banner.
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
