import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/core/presentation/theme/app_theme.dart';
import 'package:encueypay/core/presentation/widgets/status_badge.dart';

/// Guards the reported mix-up where a cancelled lifecycle looked green:
/// the palette must stay keyed by the wire name (cancelled = rose,
/// delivered = emerald) even when the visible label is different.
void main() {
  Future<Color> backgroundOf(WidgetTester tester, Widget badge) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(body: Center(child: badge)),
      ),
    );
    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(StatusBadge),
            matching: find.byType(Container),
          )
          .first,
    );
    return (container.decoration! as BoxDecoration).color!;
  }

  testWidgets('cancelled uses the rose palette', (tester) async {
    final color = await backgroundOf(
      tester,
      const StatusBadge(wireName: 'cancelled', label: 'Cancelled'),
    );
    expect(color, const Color(0xFFFFF1F2));
  });

  testWidgets('delivered uses the emerald palette', (tester) async {
    final color = await backgroundOf(
      tester,
      const StatusBadge(wireName: 'delivered', label: 'Delivered'),
    );
    expect(color, const Color(0xFFECFDF5));
  });
}
