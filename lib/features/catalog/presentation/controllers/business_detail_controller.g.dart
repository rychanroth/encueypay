// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BusinessDetailController)
final businessDetailControllerProvider = BusinessDetailControllerFamily._();

final class BusinessDetailControllerProvider
    extends $AsyncNotifierProvider<BusinessDetailController, BusinessDetail> {
  BusinessDetailControllerProvider._({
    required BusinessDetailControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'businessDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$businessDetailControllerHash();

  @override
  String toString() {
    return r'businessDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BusinessDetailController create() => BusinessDetailController();

  @override
  bool operator ==(Object other) {
    return other is BusinessDetailControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$businessDetailControllerHash() =>
    r'f699f04b0a4a0391a43cb63d2f28b3d7adadff9b';

final class BusinessDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          BusinessDetailController,
          AsyncValue<BusinessDetail>,
          BusinessDetail,
          FutureOr<BusinessDetail>,
          String
        > {
  BusinessDetailControllerFamily._()
    : super(
        retry: null,
        name: r'businessDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BusinessDetailControllerProvider call(String businessId) =>
      BusinessDetailControllerProvider._(argument: businessId, from: this);

  @override
  String toString() => r'businessDetailControllerProvider';
}

abstract class _$BusinessDetailController
    extends $AsyncNotifier<BusinessDetail> {
  late final _$args = ref.$arg as String;
  String get businessId => _$args;

  FutureOr<BusinessDetail> build(String businessId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<BusinessDetail>, BusinessDetail>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BusinessDetail>, BusinessDetail>,
              AsyncValue<BusinessDetail>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
