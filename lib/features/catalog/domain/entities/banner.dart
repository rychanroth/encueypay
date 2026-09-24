import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner.freezed.dart';

/// An approved promotional banner for the home feed (spec §27/§48).
/// Display-only in the MVP.
@freezed
abstract class CatalogBanner with _$CatalogBanner {
  const factory CatalogBanner({
    required String id,
    required String name,
    required String imageUrl,
  }) = _CatalogBanner;
}
