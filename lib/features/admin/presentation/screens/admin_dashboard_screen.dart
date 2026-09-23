import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../controllers/admin_audit_controller.dart';

/// Admin tab 1 — Dashboard: links to audit logs and platform settings.
/// Reports arrive in Phase 12.
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auditCount = ref.watch(adminAuditControllerProvider.select(
      (async) => async.value?.length ?? 0,
    ));

    return Scaffold(
      appBar: AppBar(title: const Text('Admin dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Audit logs'),
              subtitle: Text('$auditCount entries'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed(AppRoutes.adminAudit),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Platform settings'),
              subtitle: const Text('Fees, commissions, payment account'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed(AppRoutes.adminSettings),
            ),
          ),
          const Text('Reports arrive in Phase 12.'),
        ],
      ),
    );
  }
}
