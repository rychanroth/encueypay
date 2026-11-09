import 'package:encueypay/features/admin/domain/entities/admin.dart';
import 'package:encueypay/features/admin/presentation/screens/admin_orders_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdminOrderQueryCodec', () {
    test('empty query encodes to no URL parameters', () {
      expect(AdminOrderQueryCodec.encode(const AdminOrderQuery()), isEmpty);
      expect(
        AdminOrderQueryCodec.decode(const <String, String>{}),
        const AdminOrderQuery(),
      );
    });

    test('round-trips every filter through the URL', () {
      final query = AdminOrderQuery(
        search: 'sokha',
        from: DateTime(2026, 11, 1),
        to: DateTime(2026, 11, 9),
        statuses: {'pending', 'confirmed'},
        paymentStatuses: {'pending', 'transaction_verified'},
        paymentMethods: {'cod', 'qr'},
        brandId: 'brand-1',
        categoryId: 'category-1',
        minTotalMinor: 1000,
        maxTotalMinor: 50000,
        excludeCancelled: true,
        needsAttention: true,
        sort: AdminOrderSort.totalDesc,
      );

      final encoded = AdminOrderQueryCodec.encode(query);
      expect(AdminOrderQueryCodec.decode(encoded), query);
    });

    test('sets are serialized in a stable order', () {
      final a = AdminOrderQueryCodec.encode(
        const AdminOrderQuery(statuses: {'pending', 'confirmed'}),
      );
      final b = AdminOrderQueryCodec.encode(
        const AdminOrderQuery(statuses: {'confirmed', 'pending'}),
      );
      expect(a['status'], 'confirmed,pending');
      expect(a, b);
    });

    test('unknown and malformed values fall back safely', () {
      final decoded = AdminOrderQueryCodec.decode(const {
        'from': 'not-a-date',
        'min': 'abc',
        'sort': 'bogus',
        'status': '',
      });
      expect(decoded.from, isNull);
      expect(decoded.minTotalMinor, isNull);
      expect(decoded.sort, AdminOrderSort.newest);
      expect(decoded.statuses, isEmpty);
    });

    test('signature is order independent', () {
      expect(
        AdminOrderQueryCodec.signature(const {'a': '1', 'b': '2'}),
        AdminOrderQueryCodec.signature(const {'b': '2', 'a': '1'}),
      );
    });
  });

  group('AdminOrderQuery', () {
    test('hasFilters ignores sort but sees every narrowing facet', () {
      expect(
        const AdminOrderQuery(sort: AdminOrderSort.oldest).hasFilters,
        isFalse,
      );
      expect(const AdminOrderQuery(search: 'x').hasFilters, isTrue);
      expect(const AdminOrderQuery(needsAttention: true).hasFilters, isTrue);
      expect(const AdminOrderQuery(excludeCancelled: true).hasFilters, isTrue);
      expect(
        const AdminOrderQuery(minTotalMinor: 1).hasFilters,
        isTrue,
      );
    });
  });

  group('AdminOrderStatus', () {
    test('returned is a real lifecycle value', () {
      final status = AdminOrderStatus.fromName('returned');
      expect(status, AdminOrderStatus.returned);
      expect(status.wireName, 'returned');
    });
  });
}
