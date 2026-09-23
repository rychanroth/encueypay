// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the login form. Mutations follow PRES-03: `AsyncValue.guard`,
/// no optimistic UI — on success the session stream updates and the router
/// redirect takes over (ROUTE-10).

@ProviderFor(LoginController)
final loginControllerProvider = LoginControllerProvider._();

/// Drives the login form. Mutations follow PRES-03: `AsyncValue.guard`,
/// no optimistic UI — on success the session stream updates and the router
/// redirect takes over (ROUTE-10).
final class LoginControllerProvider
    extends $AsyncNotifierProvider<LoginController, void> {
  /// Drives the login form. Mutations follow PRES-03: `AsyncValue.guard`,
  /// no optimistic UI — on success the session stream updates and the router
  /// redirect takes over (ROUTE-10).
  LoginControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginControllerHash();

  @$internal
  @override
  LoginController create() => LoginController();
}

String _$loginControllerHash() => r'7e88e10157357cf4178fe06c8069306990cea07e';

/// Drives the login form. Mutations follow PRES-03: `AsyncValue.guard`,
/// no optimistic UI — on success the session stream updates and the router
/// redirect takes over (ROUTE-10).

abstract class _$LoginController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
