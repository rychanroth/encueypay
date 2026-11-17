import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/core/presentation/theme/app_theme.dart';
import 'package:encueypay/features/auth/presentation/widgets/onboarding_visuals.dart';

/// The scenes are decorative, but they must still lay out cleanly on a narrow
/// phone and with large accessibility text (the fixed scene is scaled down).
void main() {
  final visuals = <String, Widget>{
    'catalog': const CatalogOnboardingVisual(),
    'payment': const PaymentOnboardingVisual(),
    'delivery': const DeliveryOnboardingVisual(),
  };

  for (final entry in visuals.entries) {
    for (final brightness in Brightness.values) {
      testWidgets(
        '${entry.key} visual lays out at phone width in ${brightness.name}',
        (tester) async {
          tester.view.physicalSize = const Size(360 * 3, 640 * 3);
          tester.view.devicePixelRatio = 3;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            MaterialApp(
              theme: brightness == Brightness.light
                  ? AppTheme.light
                  : AppTheme.dark,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.6)),
                child: child!,
              ),
              home: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(width: 320, height: 240, child: entry.value),
                ),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
