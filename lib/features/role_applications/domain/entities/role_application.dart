/// A role application (spec §3): at most one pending per user; a new
/// submission replaces the previous pending one.
class RoleApplication {
  const RoleApplication({
    required this.id,
    required this.requestedRole,
    required this.status,
    required this.createdAt,
    this.decisionReason,
  });

  final String id;

  /// Only business/driver are requestable.
  final String requestedRole;
  final RoleApplicationStatus status;
  final DateTime createdAt;
  final String? decisionReason;
}

enum RoleApplicationStatus {
  pending,
  approved,
  rejected;

  static RoleApplicationStatus fromName(String? name) =>
      RoleApplicationStatus.values.asNameMap()[name] ??
      RoleApplicationStatus.pending;
}
