import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_application.freezed.dart';

/// A role application (spec §3): at most one pending per user; a new
/// submission replaces the previous pending one.
@freezed
abstract class RoleApplication with _$RoleApplication {
  const factory RoleApplication({
    required String id,
    required String requestedRole,
    required RoleApplicationStatus status,
    required DateTime createdAt,
    String? decisionReason,
  }) = _RoleApplication;
}

enum RoleApplicationStatus {
  pending,
  approved,
  rejected;

  static RoleApplicationStatus fromName(String? name) =>
      RoleApplicationStatus.values.asNameMap()[name] ??
      RoleApplicationStatus.pending;
}
