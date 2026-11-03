import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/network/supabase_client_provider.dart';
import '../../../../core/presentation/push_target.dart';
import 'repository/notifications_repository.dart';
import 'repository/notifications_repository_impl.dart';

/// FCM lifecycle + open routing (Section 8E).
///
/// Verifies Firebase once, keeps the token in sync with the Supabase session,
/// removes it before sign-out, and surfaces foreground/opened messages to the
/// composition root. All failures are best-effort: the in-app realtime inbox
/// keeps working even when Firebase/platform config is absent (Part A.6).
class PushNotificationsService {
  PushNotificationsService(this._client, this._repository);

  final SupabaseClient _client;
  final INotificationsRepository _repository;

  final List<StreamSubscription<dynamic>> _subscriptions = [];
  bool _started = false;
  bool _ready = false;
  bool _permissionRequested = false;
  bool _pendingOpen = false;
  PushOpenTarget? _pendingTarget;

  /// Called after the app is mounted so navigation/UI keys are available.
  /// [onOpen] receives the deep-link target; [onForeground] renders the
  /// in-app banner for a message received while the app is foregrounded.
  Future<void> start({
    void Function(PushOpenTarget target)? onOpen,
    void Function(
      String title,
      String body,
      PushOpenTarget target,
      void Function() onView,
    )? onForeground,
  }) async {
    if (_started) return;
    _started = true;
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      _ready = true;
    } catch (error, stackTrace) {
      // Missing google-services.json / GoogleService-Info.plist — push
      // stays inert; the in-app inbox is unaffected.
      debugPrint('Push notifications disabled: $error\n$stackTrace');
      return;
    }

    final messaging = FirebaseMessaging.instance;
    _subscriptions.add(messaging.onTokenRefresh.listen((token) {
      unawaited(_registerToken(token));
    }));
    _subscriptions.add(_client.auth.onAuthStateChange.listen((event) {
      final type = event.event;
      if (type == AuthChangeEvent.initialSession ||
          type == AuthChangeEvent.signedIn ||
          type == AuthChangeEvent.tokenRefreshed) {
        unawaited(_onAuthenticated(onOpen));
      }
    }));
    _subscriptions.add(FirebaseMessaging.onMessage.listen((message) {
      final target = _targetFor(message);
      onForeground?.call(
        message.notification?.title ?? 'EncueYPay',
        message.notification?.body ?? '',
        target,
        () => _handleOpen(target, onOpen),
      );
    }));
    _subscriptions.add(FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleOpen(_targetFor(message), onOpen);
    }));

    try {
      final initial = await messaging.getInitialMessage();
      if (initial != null) {
        final target = _targetFor(initial);
        if (_client.auth.currentUser == null) {
          _pendingTarget = target;
          _pendingOpen = true;
        } else {
          _handleOpen(target, onOpen);
        }
      }
    } catch (error, stackTrace) {
      debugPrint('Push initial message failed: $error\n$stackTrace');
    }

    // Covers a session that was already restored before the auth stream
    // delivered its initial event.
    if (_client.auth.currentUser != null) {
      await _onAuthenticated(onOpen);
    }
  }

  /// Removes this device's token. Called before signOut, while the user is
  /// still authenticated so the own-row RLS delete succeeds.
  Future<void> unregisterCurrentDevice() async {
    if (!_ready) return;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _repository.unregisterDeviceToken(token);
      }
    } catch (error, stackTrace) {
      debugPrint('Push unregister failed: $error\n$stackTrace');
    }
  }

  Future<void> _onAuthenticated(
    void Function(PushOpenTarget target)? onOpen,
  ) async {
    await _ensurePermission();
    await _registerCurrentToken();
    if (_pendingOpen) {
      _pendingOpen = false;
      final target = _pendingTarget;
      _pendingTarget = null;
      if (target != null) _handleOpen(target, onOpen);
    }
  }

  Future<void> _ensurePermission() async {
    if (_permissionRequested) return;
    _permissionRequested = true;
    try {
      await FirebaseMessaging.instance.requestPermission();
    } catch (error, stackTrace) {
      debugPrint('Push permission request failed: $error\n$stackTrace');
    }
  }

  Future<void> _registerCurrentToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await _registerToken(token);
    } catch (error, stackTrace) {
      debugPrint('Push token fetch failed: $error\n$stackTrace');
    }
  }

  Future<void> _registerToken(String token) async {
    if (_client.auth.currentUser == null) return;
    try {
      await _repository.registerDeviceToken(
        token: token,
        platform: defaultTargetPlatform.name.toLowerCase(),
      );
    } catch (error, stackTrace) {
      debugPrint('Push token registration failed: $error\n$stackTrace');
    }
  }

  void _handleOpen(
    PushOpenTarget target,
    void Function(PushOpenTarget target)? onOpen,
  ) {
    final notificationId = target.notificationId;
    if (notificationId != null) {
      unawaited(_markRead(notificationId));
    }
    onOpen?.call(target);
  }

  Future<void> _markRead(String notificationId) async {
    try {
      await _repository.markRead(notificationId);
    } catch (error, stackTrace) {
      debugPrint('Push mark-read failed: $error\n$stackTrace');
    }
  }

  PushOpenTarget _targetFor(RemoteMessage message) {
    String? value(String key) {
      final raw = message.data[key];
      return raw is String && raw.isNotEmpty ? raw : null;
    }

    return PushOpenTarget(
      orderId: value('order_id'),
      notificationId: value('notification_id'),
    );
  }

  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }
}

/// Manual provider (wiring only, PRES-01).
final pushNotificationsServiceProvider =
    Provider<PushNotificationsService>((ref) {
  return PushNotificationsService(
    ref.watch(supabaseClientProvider),
    ref.watch(notificationsRepositoryProvider),
  );
});
