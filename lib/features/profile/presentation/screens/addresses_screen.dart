import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/address.dart';
import '../controllers/addresses_controller.dart';

class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Address address) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete address?'),
        content: Text('"${address.label}" will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(addressesControllerProvider.notifier).remove(address.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressesControllerProvider);

    ref.listen(addressesControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Addresses')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(AppRoutes.addressEdit),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: addressesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$error', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(addressesControllerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (addresses) {
          if (addresses.isEmpty) {
            return const Center(child: Text('No addresses yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return Card(
                child: ListTile(
                  leading: Icon(
                    address.isDefault
                        ? Icons.star
                        : Icons.location_on_outlined,
                    color: address.isDefault
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  title: Text(
                    '${address.label} · ${address.recipientName}'
                    '${address.isDefault ? '  (default)' : ''}',
                  ),
                  subtitle: Text(
                    [address.line1, address.line2, address.city]
                        .whereType<String>()
                        .where((part) => part.isNotEmpty)
                        .join(', '),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!address.isDefault)
                        IconButton(
                          tooltip: 'Set as default',
                          icon: const Icon(Icons.star_outline),
                          onPressed: () => ref
                              .read(addressesControllerProvider.notifier)
                              .setDefault(address.id),
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _confirmDelete(context, ref, address),
                      ),
                    ],
                  ),
                  onTap: () => context.pushNamed(
                    AppRoutes.addressEdit,
                    extra: address,
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
