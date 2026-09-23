import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/admin_repository_impl.dart';
import '../../domain/entities/admin.dart';

part 'admin_audit_controller.g.dart';

@riverpod
class AdminAuditController extends _$AdminAuditController {
  @override
  Future<List<AuditEntry>> build() async {
    return ref.watch(adminRepositoryProvider).fetchAuditLogs();
  }
}
