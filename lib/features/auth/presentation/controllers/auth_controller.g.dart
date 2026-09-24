// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Session stream controller — the single provider the router redirect
/// (ROUTE-10) and the shell listen to.
///
/// State is exactly what the docs-style pattern needs: `AsyncValue<AppUser?>`
/// — loading while the first event arrives, `data: null` = signed out,
/// `data: user` = signed in (with the role from the `users` table), error on
/// failure. No custom auth state class. Mutations never set optimistic state
/// (PRES-03); the SDK handles session persistence, token refreshes and deep
/// links internally.

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// Session stream controller — the single provider the router redirect
/// (ROUTE-10) and the shell listen to.
///
/// State is exactly what the docs-style pattern needs: `AsyncValue<AppUser?>`
/// — loading while the first event arrives, `data: null` = signed out,
/// `data: user` = signed in (with the role from the `users` table), error on
/// failure. No custom auth state class. Mutations never set optimistic state
/// (PRES-03); the SDK handles session persistence, token refreshes and deep
/// links internally.
final class AuthControllerProvider
    extends $StreamNotifierProvider<AuthController, AppUser?> {
  /// Session stream controller — the single provider the router redirect
  /// (ROUTE-10) and the shell listen to.
  ///
  /// State is exactly what the docs-style pattern needs: `AsyncValue<AppUser?>`
  /// — loading while the first event arrives, `data: null` = signed out,
  /// `data: user` = signed in (with the role from the `users` table), error on
  /// failure. No custom auth state class. Mutations never set optimistic state
  /// (PRES-03); the SDK handles session persistence, token refreshes and deep
  /// links internally.
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'47a8486ba77aa653af184be0317594932c7dd6eb';

/// Session stream controller — the single provider the router redirect
/// (ROUTE-10) and the shell listen to.
///
/// State is exactly what the docs-style pattern needs: `AsyncValue<AppUser?>`
/// — loading while the first event arrives, `data: null` = signed out,
/// `data: user` = signed in (with the role from the `users` table), error on
/// failure. No custom auth state class. Mutations never set optimistic state
/// (PRES-03); the SDK handles session persistence, token refreshes and deep
/// links internally.

abstract class _$AuthController extends $StreamNotifier<AppUser?> {
  Stream<AppUser?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppUser?>, AppUser?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppUser?>, AppUser?>,
              AsyncValue<AppUser?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
