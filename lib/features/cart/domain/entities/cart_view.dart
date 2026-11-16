/// Cart view dimensions (client-side only): filtering and ordering over the
/// already-loaded cart. The server stays authoritative for contents and
/// pricing; these enums never reach the wire.
enum CartFilter {
  all,
  onSale,
  soldOut;

  String get label => switch (this) {
    CartFilter.all => 'All',
    CartFilter.onSale => 'On sale',
    CartFilter.soldOut => 'Sold out',
  };
}

enum CartSort {
  newest,
  priceLowHigh,
  priceHighLow,
  name;

  String get label => switch (this) {
    CartSort.newest => 'Newest added',
    CartSort.priceLowHigh => 'Price: low to high',
    CartSort.priceHighLow => 'Price: high to low',
    CartSort.name => 'Product name',
  };
}
