// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_compose_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReviewComposeController)
final reviewComposeControllerProvider = ReviewComposeControllerProvider._();

final class ReviewComposeControllerProvider
    extends $AsyncNotifierProvider<ReviewComposeController, void> {
  ReviewComposeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewComposeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewComposeControllerHash();

  @$internal
  @override
  ReviewComposeController create() => ReviewComposeController();
}

String _$reviewComposeControllerHash() =>
    r'ab74306f08f7e3d89c4a04cccb777ae6a5a8eb9f';

abstract class _$ReviewComposeController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
