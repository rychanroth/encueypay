// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_request_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Returnable lines for one delivered order + submission.

@ProviderFor(ReturnRequestController)
final returnRequestControllerProvider = ReturnRequestControllerFamily._();

/// Returnable lines for one delivered order + submission.
final class ReturnRequestControllerProvider
    extends
        $AsyncNotifierProvider<ReturnRequestController, List<ReturnableItem>> {
  /// Returnable lines for one delivered order + submission.
  ReturnRequestControllerProvider._({
    required ReturnRequestControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'returnRequestControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$returnRequestControllerHash();

  @override
  String toString() {
    return r'returnRequestControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ReturnRequestController create() => ReturnRequestController();

  @override
  bool operator ==(Object other) {
    return other is ReturnRequestControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$returnRequestControllerHash() =>
    r'9e2d8dc7dba660b3ae1fd580807522e13e216033';

/// Returnable lines for one delivered order + submission.

final class ReturnRequestControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ReturnRequestController,
          AsyncValue<List<ReturnableItem>>,
          List<ReturnableItem>,
          FutureOr<List<ReturnableItem>>,
          String
        > {
  ReturnRequestControllerFamily._()
    : super(
        retry: null,
        name: r'returnRequestControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Returnable lines for one delivered order + submission.

  ReturnRequestControllerProvider call(String orderId) =>
      ReturnRequestControllerProvider._(argument: orderId, from: this);

  @override
  String toString() => r'returnRequestControllerProvider';
}

/// Returnable lines for one delivered order + submission.

abstract class _$ReturnRequestController
    extends $AsyncNotifier<List<ReturnableItem>> {
  late final _$args = ref.$arg as String;
  String get orderId => _$args;

  FutureOr<List<ReturnableItem>> build(String orderId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<ReturnableItem>>, List<ReturnableItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ReturnableItem>>,
                List<ReturnableItem>
              >,
              AsyncValue<List<ReturnableItem>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
