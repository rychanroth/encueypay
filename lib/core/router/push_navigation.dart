import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/user_role.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../presentation/app_keys.dart';
import '../presentation/push_target.dart';
import 'app_routes.dart';

/// Composition-root destination for a push tap (ROUTE-08).
///
/// Order pushes open the order; anything else opens the inbox. Only customer
/// notifications exist today, and the inbox route lives under the customer
/// home branch, so admins are ignored.
void openPushTarget(
  ProviderContainer container,
  PushOpenTarget target, {
  int attempt = 0,
}) {
  final auth = container.read(authControllerProvider);
  final user = auth.value;
  if (user == null) {
    // The FCM auth event can land a beat before the Riverpod controller
    // processes the same session event. Wait briefly for the role, but do
    // not spin forever on a signed-out session.
    if (auth.isLoading && attempt < 20) {
      Future<void>.delayed(
        const Duration(milliseconds: 100),
        () => openPushTarget(container, target, attempt: attempt + 1),
      );
    }
    return;
  }
  if (user.activeRole != UserRole.customer) return;

  final context = appNavigatorKey.currentContext;
  if (context == null) {
    // Cold start: the navigator mounts after the first frame.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => openPushTarget(container, target, attempt: attempt),
    );
    return;
  }

  if (target.hasOrder) {
    context.pushNamed(
      AppRoutes.orderDetail,
      pathParameters: {'id': target.orderId!},
    );
  } else {
    context.goNamed(AppRoutes.notifications);
  }
}
