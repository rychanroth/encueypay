/// An approved promotional banner for the home feed (spec §27/§48).
/// Display-only in the MVP.
class CatalogBanner {
  const CatalogBanner({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String imageUrl;
}
