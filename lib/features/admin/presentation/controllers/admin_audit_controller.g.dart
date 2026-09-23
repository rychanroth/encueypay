// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_audit_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminAuditController)
final adminAuditControllerProvider = AdminAuditControllerProvider._();

final class AdminAuditControllerProvider
    extends $AsyncNotifierProvider<AdminAuditController, List<AuditEntry>> {
  AdminAuditControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminAuditControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminAuditControllerHash();

  @$internal
  @override
  AdminAuditController create() => AdminAuditController();
}

String _$adminAuditControllerHash() =>
    r'bc87e449e9c09d7c808d25a2eb246b030d8a3a8a';

abstract class _$AdminAuditController extends $AsyncNotifier<List<AuditEntry>> {
  FutureOr<List<AuditEntry>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<AuditEntry>>, List<AuditEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<AuditEntry>>, List<AuditEntry>>,
              AsyncValue<List<AuditEntry>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
