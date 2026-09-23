import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../controllers/role_application_controller.dart';

/// Submit a Business/Driver role application (spec §3) and view its status.
/// A new submission replaces a pending one.
class RoleApplicationScreen extends ConsumerStatefulWidget {
  const RoleApplicationScreen({super.key});

  @override
  ConsumerState<RoleApplicationScreen> createState() =>
      _RoleApplicationScreenState();
}

class _RoleApplicationScreenState extends ConsumerState<RoleApplicationScreen> {
  String _selectedRole = 'business';

  Future<void> _submit() async {
    await ref
        .read(roleApplicationControllerProvider.notifier)
        .submit(requestedRole: _selectedRole);
    final hasError = ref.read(roleApplicationControllerProvider).hasError;
    if (!hasError && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final applicationAsync = ref.watch(roleApplicationControllerProvider);
    final submitting = ref.watch(
      roleApplicationControllerProvider.select((async) => async.isLoading),
    );

    ref.listen(roleApplicationControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Role application')),
      body: applicationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (application) {
          final pending = application?.status.name == 'pending';
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (application != null) ...[
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.badge_outlined),
                    title: Text(
                        'Latest application: ${application.requestedRole}'),
                    subtitle: Text(
                      '${application.status.name}'
                      '${application.decisionReason == null ? '' : ' — ${application.decisionReason}'}',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (!pending) ...[
                const Text(
                  'Apply to become a business or a driver. '
                  'An admin reviews your application.',
                ),
                const SizedBox(height: 12),
                RadioGroup<String>(
                  groupValue: _selectedRole,
                  onChanged: (value) =>
                      setState(() => _selectedRole = value!),
                  child: Column(
                    children: const [
                      RadioListTile<String>(
                        value: 'business',
                        title: Text('Business'),
                        subtitle: Text('Sell products on EncueYPay'),
                      ),
                      RadioListTile<String>(
                        value: 'driver',
                        title: Text('Driver'),
                        subtitle: Text('Deliver orders'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: submitting ? null : _submit,
                  child: const Text('Submit application'),
                ),
              ] else
                const Text(
                  'Your application is pending admin review. '
                  'Submitting a new one would replace it.',
                ),
            ],
          );
        },
      ),
    );
  }
}
