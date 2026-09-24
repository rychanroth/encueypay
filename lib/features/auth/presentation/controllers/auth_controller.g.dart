// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Session stream controller — the single provider the router redirect
/// (ROUTE-10) and the shell listen to. State is ground truth from the
/// backend; mutations never set optimistic state (PRES-03).

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// Session stream controller — the single provider the router redirect
/// (ROUTE-10) and the shell listen to. State is ground truth from the
/// backend; mutations never set optimistic state (PRES-03).
final class AuthControllerProvider
    extends $StreamNotifierProvider<AuthController, AuthState> {
  /// Session stream controller — the single provider the router redirect
  /// (ROUTE-10) and the shell listen to. State is ground truth from the
  /// backend; mutations never set optimistic state (PRES-03).
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

String _$authControllerHash() => r'c674f556aa8f83df715a44516d036891757e4f47';

/// Session stream controller — the single provider the router redirect
/// (ROUTE-10) and the shell listen to. State is ground truth from the
/// backend; mutations never set optimistic state (PRES-03).

abstract class _$AuthController extends $StreamNotifier<AuthState> {
  Stream<AuthState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AuthState>, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthState>, AuthState>,
              AsyncValue<AuthState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
