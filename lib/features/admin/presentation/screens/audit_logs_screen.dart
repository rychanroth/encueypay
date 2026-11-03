import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/async_value_widget.dart';
import '../../../../core/domain/failures.dart';

import '../controllers/admin_audit_controller.dart';

/// Admin — audit trail (spec §2.4/§46): accountability for important
/// domain state transitions.
class AuditLogsScreen extends ConsumerWidget {
  const AuditLogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(adminAuditControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Audit logs')),
      body: logsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(userMessageFor(error))),
        data: (logs) {
          if (logs.isEmpty) {
            return const EmptyStateView(
              icon: Icons.history,
              title: 'No audit entries yet',
              description: 'Admin actions will be recorded here.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: logs.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final log = logs[index];
              return ListTile(
                dense: true,
                leading: const Icon(Icons.history),
                title: Text(log.action),
                subtitle: Text(
                  '${log.targetType}'
                  '${log.targetId == null ? '' : ' · ${log.targetId!.substring(0, 8)}'}',
                ),
                trailing: Text(
                  log.createdAt.toLocal().toString().substring(0, 16),
                  style: theme.textTheme.bodySmall,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
