import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/features/cart/domain/entities/cart_item.dart';
import 'package:encueypay/features/cart/domain/entities/cart_view.dart';
import 'package:encueypay/features/cart/domain/usecases/filter_cart_items.dart';

CartItem _item({
  required String id,
  required String name,
  String? variant,
  int price = 1000,
  int? salePrice,
  int quantity = 1,
  int stock = 10,
  DateTime? createdAt,
}) {
  return CartItem(
    id: id,
    variantId: 'variant-$id',
    productId: 'product-$id',
    productName: name,
    variantName: variant,
    unitPriceMinor: price,
    saleUnitPriceMinor: salePrice ?? price,
    quantity: quantity,
    stock: stock,
    createdAt: createdAt,
  );
}

void main() {
  const useCase = FilterCartItemsUseCase();
  final items = [
    _item(
      id: 'a',
      name: 'Canvas Tote',
      variant: 'Black',
      price: 1200,
      salePrice: 900,
      createdAt: DateTime.utc(2026, 11, 1),
    ),
    _item(
      id: 'b',
      name: 'Mug',
      price: 500,
      stock: 0,
      createdAt: DateTime.utc(2026, 11, 2),
    ),
    _item(
      id: 'c',
      name: 'Postpartum Socks',
      variant: 'White',
      price: 400,
      createdAt: DateTime.utc(2026, 11, 3),
    ),
  ];

  test('all filter keeps every line', () {
    final result = useCase(items: items);
    expect(result.map((item) => item.id), ['c', 'b', 'a']);
  });

  test('on sale keeps only discounted lines', () {
    final result = useCase(items: items, filter: CartFilter.onSale);
    expect(result.map((item) => item.id), ['a']);
  });

  test('sold out keeps only zero-stock lines', () {
    final result = useCase(items: items, filter: CartFilter.soldOut);
    expect(result.map((item) => item.id), ['b']);
  });

  test('search matches product and variant names, case-insensitively', () {
    expect(
      useCase(items: items, query: 'toTe').map((item) => item.id),
      ['a'],
    );
    expect(
      useCase(items: items, query: 'white').map((item) => item.id),
      ['c'],
    );
    expect(useCase(items: items, query: 'nothing'), isEmpty);
  });

  test('newest sort puts lines without a timestamp last', () {
    final mixed = [
      _item(id: 'old', name: 'Old', createdAt: DateTime.utc(2026, 11, 1)),
      _item(id: 'none', name: 'None'),
      _item(id: 'new', name: 'New', createdAt: DateTime.utc(2026, 11, 5)),
    ];
    final result = useCase(items: mixed, sort: CartSort.newest);
    expect(result.map((item) => item.id), ['new', 'old', 'none']);
  });

  test('price sorts use the effective (sale) unit price', () {
    expect(
      useCase(items: items, sort: CartSort.priceLowHigh)
          .map((item) => item.id),
      ['c', 'b', 'a'],
    );
    expect(
      useCase(items: items, sort: CartSort.priceHighLow)
          .map((item) => item.id),
      ['a', 'b', 'c'],
    );
  });

  test('name sort is case-insensitive', () {
    final named = [
      _item(id: '1', name: 'zebra'),
      _item(id: '2', name: 'Apple'),
    ];
    expect(
      useCase(items: named, sort: CartSort.name).map((item) => item.id),
      ['2', '1'],
    );
  });

  test('filter and query combine', () {
    final result = useCase(items: items, filter: CartFilter.all, query: 'o');
    // Canvas Tote (product), Postpartum Socks (variant White)
    expect(result.map((item) => item.id), ['c', 'a']);
  });
}
