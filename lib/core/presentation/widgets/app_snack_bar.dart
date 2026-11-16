import 'package:flutter/material.dart';

/// Life of a transient in-app message.
///
/// `SnackBarThemeData` has no `duration` field, so the app cannot set this
/// globally through [ThemeData]. [AppSnackBar] is the single place it is
/// declared: every toast uses that constructor instead of `SnackBar`, which
/// keeps the whole app on one value and one edit.
const Duration appSnackBarDuration = Duration(seconds: 1);

/// A SnackBar that carries an action must outlive the tap that uses it (the
/// "Sign in" prompt, an undo). Those call sites pass this instead of the 1 s
/// default, so the action never disappears before it can be pressed.
const Duration appSnackBarActionDuration = Duration(seconds: 4);

/// App-wide SnackBar: same duration everywhere, one constructor to change.
class AppSnackBar extends SnackBar {
  const AppSnackBar({
    super.key,
    required super.content,
    super.action,
    super.showCloseIcon,
    super.duration = appSnackBarDuration,
    super.behavior,
  });
}
