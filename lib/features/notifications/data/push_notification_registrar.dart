import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/supabase_client_provider.dart';

/// FCM push registration (Section 8E). Called once from `main()` after the
/// Supabase container exists.
///
/// Deliberately forgiving: when the Firebase platform config is absent
/// (no google-services.json / GoogleService-Info.plist yet — Part A.6),
/// initialization fails and this no-ops; the in-app realtime inbox is
/// unaffected. Push registration only completes for signed-in users.
Future<void> registerPushNotifications(ProviderContainer container) async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  } catch (_) {
    // No Firebase platform config — push stays unconfigured.
    return;
  }

  final messaging = FirebaseMessaging.instance;
  try {
    await messaging.requestPermission();
    final token = await messaging.getToken();
    if (token != null) {
      await _registerToken(container, token);
    }
    // Tokens rotate — re-register on refresh.
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      _registerToken(container, token);
    });
  } on PlatformException {
    // Push unavailable (e.g. simulator without APNs) — ignore.
  } catch (_) {
    // Any messaging failure must never block startup.
  }
}

Future<void> _registerToken(ProviderContainer container, String token) async {
  final client = container.read(supabaseClientProvider);
  final user = client.auth.currentUser;
  if (user == null) return; // Re-registered on the next sign-in session.
  try {
    await client.rpc('register_device_token', params: {
      'p_token': token,
      'p_platform': defaultTargetPlatform.name.toLowerCase(),
    });
  } catch (_) {
    // Best-effort registration.
  }
}
