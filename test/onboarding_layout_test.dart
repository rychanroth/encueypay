import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/core/presentation/theme/app_theme.dart';
import 'package:encueypay/features/auth/domain/entities/app_user.dart';
import 'package:encueypay/features/auth/presentation/controllers/auth_controller.dart';
import 'package:encueypay/features/auth/presentation/screens/onboarding_screen.dart';

class _FakeAuthController extends AuthController {
  @override
  Stream<AppUser?> build() =>
      Stream.value(const AppUser(id: 'user-1', fullName: 'Dara'));
}

/// The CTA belongs to its slide: a pinned footer used to leave a large dead
/// gap between the copy and the Next button on tall screens.
void main() {
  Future<void> pumpOnboarding(
    WidgetTester tester, {
    double textScale = 1,
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(_FakeAuthController.new),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: const OnboardingScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Next sits right under the intro copy', (tester) async {
    await pumpOnboarding(tester);

    final body = tester.getRect(find.textContaining('Browse curated'));
    final button = tester.getRect(
      find.widgetWithText(FilledButton, 'Next').first,
    );

    expect(button.top - body.bottom, lessThan(96));
  });

  testWidgets('large text scrolls instead of overflowing', (tester) async {
    await pumpOnboarding(tester, textScale: 1.6);

    expect(tester.takeException(), isNull);
  });

  testWidgets('compact phone still lays out cleanly', (tester) async {
    await pumpOnboarding(tester, size: const Size(360, 640));

    expect(tester.takeException(), isNull);
    expect(find.text('Next'), findsWidgets);
  });

  testWidgets('profile step lays out at large text', (tester) async {
    await pumpOnboarding(tester, textScale: 1.6);

    await tester.tap(find.text('Skip intro'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Start shopping'), findsOneWidget);
  });
}
