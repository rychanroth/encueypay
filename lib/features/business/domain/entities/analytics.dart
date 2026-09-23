/// Business analytics read model (spec §58 GetBusinessAnalytics).
/// Server-computed aggregates — display-only.
class BusinessAnalytics {
  const BusinessAnalytics({
    required this.totalSalesMinor,
    required this.orderCount,
    required this.pendingCount,
    required this.completedCount,
    required this.rejectedCount,
    required this.topProducts,
  });

  final int totalSalesMinor;
  final int orderCount;
  final int pendingCount;
  final int completedCount;
  final int rejectedCount;
  final List<TopProduct> topProducts;
}

class TopProduct {
  const TopProduct({
    required this.name,
    required this.quantity,
    required this.revenueMinor,
  });

  final String name;
  final int quantity;
  final int revenueMinor;
}

/// Platform report for admins (spec §2.4).
class PlatformReport {
  const PlatformReport({
    required this.orderCount,
    required this.gmvMinor,
    required this.deliveryFeesMinor,
    required this.activeBusinesses,
    required this.activeProducts,
    required this.pendingApplications,
  });

  final int orderCount;
  final int gmvMinor;
  final int deliveryFeesMinor;
  final int activeBusinesses;
  final int activeProducts;
  final int pendingApplications;
}
