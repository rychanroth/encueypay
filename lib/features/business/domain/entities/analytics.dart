import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics.freezed.dart';

/// Business analytics read model (spec §58 GetBusinessAnalytics).
/// Server-computed aggregates — display only.
@freezed
abstract class BusinessAnalytics with _$BusinessAnalytics {
  const factory BusinessAnalytics({
    required int totalSalesMinor,
    required int orderCount,
    required int pendingCount,
    required int completedCount,
    required int rejectedCount,
    required List<TopProduct> topProducts,
  }) = _BusinessAnalytics;
}

@freezed
abstract class TopProduct with _$TopProduct {
  const factory TopProduct({
    required String name,
    required int quantity,
    required int revenueMinor,
  }) = _TopProduct;
}
