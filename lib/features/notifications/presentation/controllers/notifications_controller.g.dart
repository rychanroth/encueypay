// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Realtime notification inbox (§31: notifications area). The stream IS the
/// ground truth — no manual refresh needed.

@ProviderFor(NotificationsController)
final notificationsControllerProvider = NotificationsControllerProvider._();

/// Realtime notification inbox (§31: notifications area). The stream IS the
/// ground truth — no manual refresh needed.
final class NotificationsControllerProvider
    extends
        $StreamNotifierProvider<NotificationsController, NotificationsState> {
  /// Realtime notification inbox (§31: notifications area). The stream IS the
  /// ground truth — no manual refresh needed.
  NotificationsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsControllerHash();

  @$internal
  @override
  NotificationsController create() => NotificationsController();
}

String _$notificationsControllerHash() =>
    r'17f10805f79be991c358621fe9480fc64261b310';

/// Realtime notification inbox (§31: notifications area). The stream IS the
/// ground truth — no manual refresh needed.

abstract class _$NotificationsController
    extends $StreamNotifier<NotificationsState> {
  Stream<NotificationsState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<NotificationsState>, NotificationsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<NotificationsState>, NotificationsState>,
              AsyncValue<NotificationsState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
