// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brands_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Active brands for discovery filters (assignment §2). Plain one-shot fetch
/// consumed directly by the controller (DOMAIN-03).

@ProviderFor(brands)
final brandsProvider = BrandsProvider._();

/// Active brands for discovery filters (assignment §2). Plain one-shot fetch
/// consumed directly by the controller (DOMAIN-03).

final class BrandsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Brand>>,
          List<Brand>,
          FutureOr<List<Brand>>
        >
    with $FutureModifier<List<Brand>>, $FutureProvider<List<Brand>> {
  /// Active brands for discovery filters (assignment §2). Plain one-shot fetch
  /// consumed directly by the controller (DOMAIN-03).
  BrandsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brandsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brandsHash();

  @$internal
  @override
  $FutureProviderElement<List<Brand>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Brand>> create(Ref ref) {
    return brands(ref);
  }
}

String _$brandsHash() => r'4112807edefbdf49aa529853dafcb23f804e96ab';
