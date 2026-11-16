import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/features/profile/presentation/screens/address_edit_screen.dart';

/// Regression: the address hierarchy dropdowns were empty on web because the
/// location repository constructed the (web-unsupported) geocoding plugin
/// eagerly, failing the geo providers. The provider now loads the bundled
/// hierarchy on every platform and the picker must expose its choices.
void main() {
  testWidgets('province dropdown populates from bundled assets',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: AddressEditScreen()),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -700));
    await tester.pumpAndSettle();

    final dropdowns = find.byType(DropdownButton<String>);
    expect(dropdowns, findsNWidgets(4));

    final province = tester.widget<DropdownButton<String>>(dropdowns.first);
    expect(province.onChanged, isNotNull);
    expect(province.items, hasLength(25));

    await tester.tap(dropdowns.first);
    await tester.pumpAndSettle();
    expect(find.textContaining('Banteay Meanchey'), findsWidgets);
  });
}
