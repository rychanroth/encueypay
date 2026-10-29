// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One shared fetch of live sales (the `active_sales` view — active and
/// in-window by definition, so the window logic exists only in SQL). Every
/// price surface consumes this single provider instead of querying per
/// card.

@ProviderFor(activeSales)
final activeSalesProvider = ActiveSalesProvider._();

/// One shared fetch of live sales (the `active_sales` view — active and
/// in-window by definition, so the window logic exists only in SQL). Every
/// price surface consumes this single provider instead of querying per
/// card.

final class ActiveSalesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActiveSale>>,
          List<ActiveSale>,
          FutureOr<List<ActiveSale>>
        >
    with $FutureModifier<List<ActiveSale>>, $FutureProvider<List<ActiveSale>> {
  /// One shared fetch of live sales (the `active_sales` view — active and
  /// in-window by definition, so the window logic exists only in SQL). Every
  /// price surface consumes this single provider instead of querying per
  /// card.
  ActiveSalesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeSalesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeSalesHash();

  @$internal
  @override
  $FutureProviderElement<List<ActiveSale>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ActiveSale>> create(Ref ref) {
    return activeSales(ref);
  }
}

String _$activeSalesHash() => r'55595c5804fc6de461810422235da0d9e6292c15';
