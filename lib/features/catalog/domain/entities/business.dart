import 'package:freezed_annotation/freezed_annotation.dart';

part 'business.freezed.dart';

/// A vendor store (spec §4/§37): one Business owned by one user. The
/// catalog feature keeps this slim public-display entity; the business
/// portal has its own management view (ARCH-04).
@freezed
abstract class Business with _$Business {
  const factory Business({
    required String id,
    required String name,
    @Default('') String description,
    String? imageUrl,
  }) = _Business;
}

enum BusinessStatus {
  pending,
  active,
  suspended;

  static BusinessStatus fromName(String? name) =>
      BusinessStatus.values.asNameMap()[name] ?? BusinessStatus.pending;
}
