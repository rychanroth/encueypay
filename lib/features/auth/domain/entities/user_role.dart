/// The single active role of a user (spec §3). Exactly one role per user;
/// every new account defaults to [customer].
enum UserRole {
  customer,
  business,
  driver,
  admin;

  /// Server values are snake_case text; unknown values fall back to
  /// [customer] (mapper-level default, DATA-02 — never in the UI).
  static UserRole fromName(String? name) =>
      UserRole.values.asNameMap()[name] ?? UserRole.customer;
}

enum AccountStatus {
  active,
  suspended,
  banned;

  static AccountStatus fromName(String? name) =>
      AccountStatus.values.asNameMap()[name] ?? AccountStatus.active;
}
