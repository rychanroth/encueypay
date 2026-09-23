// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Single source of truth for theme state (THEME-01). The theme mode is the
/// only sanctioned local persistence in the app (THEME-02, the one exception
/// to CORE-05).

@ProviderFor(ThemeController)
final themeControllerProvider = ThemeControllerProvider._();

/// Single source of truth for theme state (THEME-01). The theme mode is the
/// only sanctioned local persistence in the app (THEME-02, the one exception
/// to CORE-05).
final class ThemeControllerProvider
    extends $NotifierProvider<ThemeController, ThemeMode> {
  /// Single source of truth for theme state (THEME-01). The theme mode is the
  /// only sanctioned local persistence in the app (THEME-02, the one exception
  /// to CORE-05).
  ThemeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeControllerHash();

  @$internal
  @override
  ThemeController create() => ThemeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeControllerHash() => r'fd52608323fbf3269f866c8f365012474b30a3f4';

/// Single source of truth for theme state (THEME-01). The theme mode is the
/// only sanctioned local persistence in the app (THEME-02, the one exception
/// to CORE-05).

abstract class _$ThemeController extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeMode, ThemeMode>,
              ThemeMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
