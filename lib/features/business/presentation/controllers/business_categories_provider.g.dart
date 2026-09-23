// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_categories_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Category options for the product form. Plain one-shot fetch (DOMAIN-03).

@ProviderFor(businessCategories)
final businessCategoriesProvider = BusinessCategoriesProvider._();

/// Category options for the product form. Plain one-shot fetch (DOMAIN-03).

final class BusinessCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CategoryOption>>,
          List<CategoryOption>,
          FutureOr<List<CategoryOption>>
        >
    with
        $FutureModifier<List<CategoryOption>>,
        $FutureProvider<List<CategoryOption>> {
  /// Category options for the product form. Plain one-shot fetch (DOMAIN-03).
  BusinessCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessCategoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<CategoryOption>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CategoryOption>> create(Ref ref) {
    return businessCategories(ref);
  }
}

String _$businessCategoriesHash() =>
    r'9398802e667331087e2e42b716d16bb757142652';
