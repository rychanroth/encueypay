import 'package:encueypay/features/admin/domain/entities/admin.dart';
import 'package:encueypay/features/admin/presentation/screens/admin_products_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdminProductQueryCodec', () {
    test('empty query encodes to no URL parameters', () {
      expect(AdminProductQueryCodec.encode(const AdminProductQuery()), isEmpty);
      expect(
        AdminProductQueryCodec.decode(const <String, String>{}),
        const AdminProductQuery(),
      );
    });

    test('round-trips every filter through the URL', () {
      final query = AdminProductQuery(
        search: 'lamp',
        from: DateTime(2026, 11, 1),
        to: DateTime(2026, 11, 9),
        statuses: {AdminCatalogStatus.active, AdminCatalogStatus.archived},
        stock: {AdminProductStock.low, AdminProductStock.out},
        brandId: 'brand-1',
        categoryId: 'category-1',
        minPriceMinor: 1000,
        maxPriceMinor: 50000,
        sort: AdminProductSort.priceDesc,
      );

      final encoded = AdminProductQueryCodec.encode(query);
      expect(AdminProductQueryCodec.decode(encoded), query);
    });

    test('sets are serialized in a stable order', () {
      final a = AdminProductQueryCodec.encode(
        const AdminProductQuery(
          statuses: {AdminCatalogStatus.archived, AdminCatalogStatus.active},
          stock: {AdminProductStock.out, AdminProductStock.low},
        ),
      );
      final b = AdminProductQueryCodec.encode(
        const AdminProductQuery(
          statuses: {AdminCatalogStatus.active, AdminCatalogStatus.archived},
          stock: {AdminProductStock.low, AdminProductStock.out},
        ),
      );
      expect(a['status'], 'active,archived');
      expect(a['stock'], 'low,out');
      expect(a, b);
    });

    test('unknown and malformed values fall back safely', () {
      final decoded = AdminProductQueryCodec.decode(const {
        'from': 'not-a-date',
        'min': 'abc',
        'sort': 'bogus',
        'status': 'draft',
        'stock': 'stale',
      });
      expect(decoded.from, isNull);
      expect(decoded.minPriceMinor, isNull);
      expect(decoded.sort, AdminProductSort.newest);
      expect(decoded.statuses, isEmpty);
      expect(decoded.stock, isEmpty);
    });

    test('signature is order independent', () {
      expect(
        AdminProductQueryCodec.signature(const {'a': '1', 'b': '2'}),
        AdminProductQueryCodec.signature(const {'b': '2', 'a': '1'}),
      );
    });
  });

  group('AdminProductQuery', () {
    test('hasFilters ignores sort but sees every narrowing facet', () {
      expect(
        const AdminProductQuery(sort: AdminProductSort.oldest).hasFilters,
        isFalse,
      );
      expect(const AdminProductQuery(search: 'x').hasFilters, isTrue);
      expect(
        const AdminProductQuery(stock: {AdminProductStock.out}).hasFilters,
        isTrue,
      );
      expect(
        const AdminProductQuery(
          statuses: {AdminCatalogStatus.archived},
        ).hasFilters,
        isTrue,
      );
      expect(const AdminProductQuery(minPriceMinor: 1).hasFilters, isTrue);
    });
  });

  group('AdminProductStock', () {
    test('wire names round-trip and unknown values are dropped', () {
      expect(AdminProductStock.fromWire('in'), AdminProductStock.inStock);
      expect(AdminProductStock.fromWire('low'), AdminProductStock.low);
      expect(AdminProductStock.fromWire('out'), AdminProductStock.out);
      expect(AdminProductStock.fromWire('bogus'), isNull);
    });
  });
}
