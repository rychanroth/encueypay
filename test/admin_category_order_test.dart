import 'package:encueypay/features/admin/domain/entities/admin.dart';
import 'package:encueypay/features/admin/presentation/screens/categories_admin_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('orderedAdminCategories', () {
    test('parents stay alphabetical, each followed by its children', () {
      final ordered = orderedAdminCategories(const [
        AdminCategory(id: 'p-sports', name: 'Sports'),
        AdminCategory(id: 'c-phones', name: 'Phones', parentId: 'p-electronics'),
        AdminCategory(id: 'p-electronics', name: 'Electronics'),
        AdminCategory(id: 'c-laptops', name: 'Laptops', parentId: 'p-electronics'),
        AdminCategory(id: 'p-fashion', name: 'Fashion'),
      ]);

      expect(
        ordered.map((category) => category.id),
        ['p-electronics', 'c-laptops', 'c-phones', 'p-fashion', 'p-sports'],
      );
    });

    test('ordering is case-insensitive', () {
      final ordered = orderedAdminCategories(const [
        AdminCategory(id: 'b', name: 'beauty'),
        AdminCategory(id: 'a', name: 'Electronics'),
        AdminCategory(id: 'c', name: 'fashion'),
      ]);

      expect(ordered.map((category) => category.id), ['b', 'a', 'c']);
    });

    test('orphaned children stay visible at the end', () {
      final ordered = orderedAdminCategories(const [
        AdminCategory(id: 'parent', name: 'Home'),
        AdminCategory(id: 'orphan', name: 'Beauty', parentId: 'missing'),
      ]);

      expect(ordered.map((category) => category.id), ['parent', 'orphan']);
    });
  });
}
