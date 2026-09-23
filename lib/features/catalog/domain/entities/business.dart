/// A vendor store (spec §4/§37): one Business owned by one user.
class Business {
  const Business({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String description;
  final String? imageUrl;
}

enum BusinessStatus {
  pending,
  active,
  suspended;

  static BusinessStatus fromName(String? name) =>
      BusinessStatus.values.asNameMap()[name] ?? BusinessStatus.pending;
}
