import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/presentation/theme/app_theme.dart';
import 'core/presentation/theme/theme_controller.dart';
import 'core/router/app_router.dart';
import 'features/notifications/data/push_notification_registrar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabasePublishableKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
  if (supabaseUrl.isEmpty || supabasePublishableKey.isEmpty) {
    // Fail fast with actionable instructions.
    throw StateError(
      'Missing Supabase configuration. Run with:\n'
      'flutter run \\\n'
      '  --dart-define=SUPABASE_URL=<your-project-url> \\\n'
      '  --dart-define=SUPABASE_PUBLISHABLE_KEY=<your-publishable-key>',
    );
  }
  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabasePublishableKey,
  );

  // Hydrate theme before the first frame (THEME-04) — no theme flash and no
  // side effects inside build().
  final container = ProviderContainer();
  await container.read(themeControllerProvider.notifier).hydrate();

  // FCM push registration (Section 8E) — best-effort: no-ops when the
  // Firebase platform config is absent (Part A.6).
  await registerPushNotifications(container);

  runApp(
    UncontrolledProviderScope(container: container, child: const EncueYPayApp()),
  );
}

class EncueYPayApp extends ConsumerWidget {
  const EncueYPayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'EncueYPay',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeControllerProvider),
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
