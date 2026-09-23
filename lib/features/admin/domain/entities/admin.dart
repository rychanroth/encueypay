/// Admin management read models (spec §2.4/§35.4). Plain immutable
/// entities (DOMAIN-01).
class AdminApplication {
  const AdminApplication({
    required this.id,
    required this.applicantName,
    required this.requestedRole,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String applicantName;
  final String requestedRole;
  final String status;
  final DateTime createdAt;
}

class AdminCategory {
  const AdminCategory({required this.id, required this.name});

  final String id;
  final String name;
}

class AuditEntry {
  const AuditEntry({
    required this.id,
    required this.action,
    required this.targetType,
    required this.createdAt,
    this.actor,
    this.targetId,
  });

  final String id;
  final String? actor;
  final String action;
  final String targetType;
  final String? targetId;
  final DateTime createdAt;
}

/// Platform-wide report for admins (spec §2.4) — server-computed.
class PlatformAnalyticsReport {
  const PlatformAnalyticsReport({
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

/// The singleton platform configuration (spec §47).
class PlatformSettings {
  const PlatformSettings({
    required this.deliveryFeeMinor,
    required this.platformCommissionPercent,
    required this.driverCommissionPercent,
    required this.paymentAccount,
  });

  final int deliveryFeeMinor;
  final int platformCommissionPercent;
  final int driverCommissionPercent;
  final String paymentAccount;

  PlatformSettings copyWith({
    int? deliveryFeeMinor,
    int? platformCommissionPercent,
    int? driverCommissionPercent,
    String? paymentAccount,
  }) {
    return PlatformSettings(
      deliveryFeeMinor: deliveryFeeMinor ?? this.deliveryFeeMinor,
      platformCommissionPercent:
          platformCommissionPercent ?? this.platformCommissionPercent,
      driverCommissionPercent:
          driverCommissionPercent ?? this.driverCommissionPercent,
      paymentAccount: paymentAccount ?? this.paymentAccount,
    );
  }
}
