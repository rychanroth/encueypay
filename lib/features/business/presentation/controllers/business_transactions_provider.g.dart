// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_transactions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Realized profit lines for the selected day — plain one-shot fetch
/// consumed directly by the screen (DOMAIN-03). [day] is date-only.

@ProviderFor(businessTransactions)
final businessTransactionsProvider = BusinessTransactionsFamily._();

/// Realized profit lines for the selected day — plain one-shot fetch
/// consumed directly by the screen (DOMAIN-03). [day] is date-only.

final class BusinessTransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BusinessTransactionEntry>>,
          List<BusinessTransactionEntry>,
          FutureOr<List<BusinessTransactionEntry>>
        >
    with
        $FutureModifier<List<BusinessTransactionEntry>>,
        $FutureProvider<List<BusinessTransactionEntry>> {
  /// Realized profit lines for the selected day — plain one-shot fetch
  /// consumed directly by the screen (DOMAIN-03). [day] is date-only.
  BusinessTransactionsProvider._({
    required BusinessTransactionsFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'businessTransactionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$businessTransactionsHash();

  @override
  String toString() {
    return r'businessTransactionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<BusinessTransactionEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BusinessTransactionEntry>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return businessTransactions(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BusinessTransactionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$businessTransactionsHash() =>
    r'125b12e4d034455dee83c5a633e2bb793eb2dc47';

/// Realized profit lines for the selected day — plain one-shot fetch
/// consumed directly by the screen (DOMAIN-03). [day] is date-only.

final class BusinessTransactionsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<BusinessTransactionEntry>>,
          DateTime
        > {
  BusinessTransactionsFamily._()
    : super(
        retry: null,
        name: r'businessTransactionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Realized profit lines for the selected day — plain one-shot fetch
  /// consumed directly by the screen (DOMAIN-03). [day] is date-only.

  BusinessTransactionsProvider call(DateTime day) =>
      BusinessTransactionsProvider._(argument: day, from: this);

  @override
  String toString() => r'businessTransactionsProvider';
}
