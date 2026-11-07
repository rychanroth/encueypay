import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  static const _channel = AndroidNotificationChannel(
    'order_updates',
    'Order updates',
    description: 'Order and payment status updates',
    importance: Importance.high,
  );

  final SupabaseClient _client;
  final INotificationsRepository _repository;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final List<StreamSubscription<dynamic>> _subscriptions = [];
  bool _started = false;
  bool _ready = false;
  bool _localReady = false;
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

    await _initLocalNotifications(onOpen);

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
      unawaited(
        _presentForeground(
          title: message.notification?.title ?? 'EncueYPay',
          body: message.notification?.body ?? '',
          target: _targetFor(message),
          onOpen: onOpen,
          onFallback: onForeground,
        ),
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

  /// Foreground messages are not auto-rendered by Android. Show a native
  /// heads-up notification (dismissible like any system notification) and
  /// keep the injected SnackBar only as a fallback if the plugin failed.
  Future<void> _initLocalNotifications(
    void Function(PushOpenTarget target)? onOpen,
  ) async {
    try {
      const settings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      );
      final initialized = await _localNotifications.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: (response) {
          final target = _targetFromPayload(response.payload);
          if (target != null) _handleOpen(target, onOpen);
        },
      );
      _localReady = initialized ?? false;
      if (!_localReady) return;

      final android = _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await android?.createNotificationChannel(_channel);
      await android?.requestNotificationsPermission();

      final launch =
          await _localNotifications.getNotificationAppLaunchDetails();
      final target = launch?.didNotificationLaunchApp == true
          ? _targetFromPayload(launch?.notificationResponse?.payload)
          : null;
      if (target != null) {
        if (_client.auth.currentUser == null) {
          _pendingTarget = target;
          _pendingOpen = true;
        } else {
          _handleOpen(target, onOpen);
        }
      }
    } catch (error, stackTrace) {
      debugPrint('Local notifications disabled: $error\n$stackTrace');
      _localReady = false;
    }
  }

  Future<void> _presentForeground({
    required String title,
    required String body,
    required PushOpenTarget target,
    void Function(PushOpenTarget target)? onOpen,
    void Function(
      String title,
      String body,
      PushOpenTarget target,
      void Function() onView,
    )? onFallback,
  }) async {
    if (_localReady) {
      try {
        await _localNotifications.show(
          id: _localId(target),
          title: title,
          body: body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: 'Order and payment status updates',
              importance: Importance.high,
              priority: Priority.high,
              autoCancel: true,
            ),
          ),
          payload: _payloadFor(target),
        );
        return;
      } catch (error, stackTrace) {
        debugPrint('Local notification failed: $error\n$stackTrace');
      }
    }
    onFallback?.call(title, body, target, () => _handleOpen(target, onOpen));
  }

  int _localId(PushOpenTarget target) {
    final key = target.notificationId ?? target.orderId;
    return key != null
        ? key.hashCode & 0x7fffffff
        : DateTime.now().millisecondsSinceEpoch.remainder(1 << 31);
  }

  String _payloadFor(PushOpenTarget target) => jsonEncode({
        'order_id': target.orderId ?? '',
        'notification_id': target.notificationId ?? '',
      });

  PushOpenTarget? _targetFromPayload(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map) return null;
      String? value(String key) {
        final raw = decoded[key];
        return raw is String && raw.isNotEmpty ? raw : null;
      }

      final target = PushOpenTarget(
        orderId: value('order_id'),
        notificationId: value('notification_id'),
      );
      return target.hasOrder || target.notificationId != null ? target : null;
    } catch (error, stackTrace) {
      debugPrint('Push payload parse failed: $error\n$stackTrace');
      return null;
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
