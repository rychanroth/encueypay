import 'package:flutter/material.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/presentation/widgets/app_snack_bar.dart';

/// Surfaces an async failure from the auth session stream (`watchSession`).
///
/// The stream survives errors (DATA-06), but without this surfacing a failed
/// profile fetch is silent: the user just bounces to login with no
/// explanation (e.g. a backend/403 during sign-in).
void showAuthStreamError(BuildContext context, Object? error) {
  final detail = error == null
      ? 'Please sign in again.'
      : userMessageFor(error);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(AppSnackBar(content: Text('Session error — $detail')));
}
