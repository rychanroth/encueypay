import 'package:flutter/material.dart';

/// Root navigator — lets the push-tap handler deep-link before any screen
/// has built its own context (cold start from a tray notification).
final appNavigatorKey = GlobalKey<NavigatorState>();

/// Root messenger — foreground FCM messages surface without a screen ref.
final appScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
