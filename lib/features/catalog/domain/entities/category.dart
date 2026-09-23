/// Platform-level catalog structure (spec §5.1) with optional parent/child
/// hierarchy. Plain immutable entity (DOMAIN-01).
class Category {
  const Category({
    required this.id,
    required this.name,
    this.parentId,
  });

  final String id;
  final String name;
  final String? parentId;

  bool get isTopLevel => parentId == null;
}
