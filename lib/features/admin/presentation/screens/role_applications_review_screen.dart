import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/failures.dart';
import '../controllers/admin_applications_controller.dart';

/// Admin tab 2 — Role application review (spec §3): approval is the only
/// path that changes a user's active_role.
class RoleApplicationsReviewScreen extends ConsumerWidget {
  const RoleApplicationsReviewScreen({super.key});

  Future<void> _review(
    BuildContext context,
    WidgetRef ref,
    String applicationId, {
    required bool approve,
  }) async {
    String? reason;
    if (!approve) {
      final controller = TextEditingController();
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Reject application?'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Reason'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                reason = controller.text.trim();
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Reject'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    await ref.read(adminApplicationsControllerProvider.notifier).review(
          applicationId: applicationId,
          approve: approve,
          reason: reason,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(adminApplicationsControllerProvider);
    final theme = Theme.of(context);

    ref.listen(adminApplicationsControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Role applications')),
      body: applicationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (applications) {
          if (applications.isEmpty) {
            return const Center(child: Text('No pending applications.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: applications.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final application = applications[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: Text(application.applicantName),
                  subtitle: Text(
                    'wants to become a ${application.requestedRole} · '
                    '${application.createdAt.toLocal().toString().substring(0, 10)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Reject',
                        icon:
                            Icon(Icons.close, color: theme.colorScheme.error),
                        onPressed: () => _review(
                          context,
                          ref,
                          application.id,
                          approve: false,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Approve',
                        icon: Icon(Icons.check,
                            color: theme.colorScheme.primary),
                        onPressed: () => _review(
                          context,
                          ref,
                          application.id,
                          approve: true,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
