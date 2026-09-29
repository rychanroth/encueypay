// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_transactions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Realized earning lines for the selected day — plain one-shot fetch
/// consumed directly by the screen (DOMAIN-03). [day] is date-only.

@ProviderFor(driverTransactions)
final driverTransactionsProvider = DriverTransactionsFamily._();

/// Realized earning lines for the selected day — plain one-shot fetch
/// consumed directly by the screen (DOMAIN-03). [day] is date-only.

final class DriverTransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DriverTransactionEntry>>,
          List<DriverTransactionEntry>,
          FutureOr<List<DriverTransactionEntry>>
        >
    with
        $FutureModifier<List<DriverTransactionEntry>>,
        $FutureProvider<List<DriverTransactionEntry>> {
  /// Realized earning lines for the selected day — plain one-shot fetch
  /// consumed directly by the screen (DOMAIN-03). [day] is date-only.
  DriverTransactionsProvider._({
    required DriverTransactionsFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'driverTransactionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$driverTransactionsHash();

  @override
  String toString() {
    return r'driverTransactionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<DriverTransactionEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DriverTransactionEntry>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return driverTransactions(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DriverTransactionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$driverTransactionsHash() =>
    r'15f28e18dbd0540ee7ff67015e5d7aa143c5edfd';

/// Realized earning lines for the selected day — plain one-shot fetch
/// consumed directly by the screen (DOMAIN-03). [day] is date-only.

final class DriverTransactionsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<DriverTransactionEntry>>,
          DateTime
        > {
  DriverTransactionsFamily._()
    : super(
        retry: null,
        name: r'driverTransactionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Realized earning lines for the selected day — plain one-shot fetch
  /// consumed directly by the screen (DOMAIN-03). [day] is date-only.

  DriverTransactionsProvider call(DateTime day) =>
      DriverTransactionsProvider._(argument: day, from: this);

  @override
  String toString() => r'driverTransactionsProvider';
}
