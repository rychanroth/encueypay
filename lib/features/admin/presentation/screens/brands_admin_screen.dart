import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';
import '../../domain/entities/admin.dart';
import '../controllers/admin_brands_controller.dart';
import '../widgets/catalog_image_pick_field.dart';

/// Brand management (Section 2b, assignment §2/§3): admin-owned catalog
/// brands. Nested under the Products tab (`/admin/products/brands`).
class BrandsAdminScreen extends ConsumerWidget {
  const BrandsAdminScreen({super.key});

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String? pickedLocalPath;
    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('New brand'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration:
                  const InputDecoration(labelText: 'Description (optional)'),
            ),
            const SizedBox(height: 12),
            CatalogImagePickField(
              label: 'Logo image (optional)',
              onPicked: (path) => pickedLocalPath = path,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (created != true) return;
    String? imagePath;
    try {
      imagePath = await _resolveImagePath(
        ref,
        pickedLocalPath: pickedLocalPath,
        existingPath: null,
      );
    } on Failure catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error.message)));
      return;
    }
    await ref.read(adminBrandsControllerProvider.notifier).create(
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
          imagePath: imagePath,
        );
  }

  /// Uploads a freshly picked image (catalog_assets) or passes the kept
  /// existing path through. Null when no imagery is set. Takes plain values
  /// — the dialog's widget state dies with its subtree, so the picked path
  /// must be captured via [CatalogImagePickField.onPicked] into a variable
  /// declared outside the dialog.
  Future<String?> _resolveImagePath(
    WidgetRef ref, {
    required String? pickedLocalPath,
    required String? existingPath,
  }) async {
    if (pickedLocalPath != null) {
      return ref
          .read(adminBrandsControllerProvider.notifier)
          .uploadImage(filePath: pickedLocalPath);
    }
    return existingPath;
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    AdminBrand brand,
  ) async {
    final nameController = TextEditingController(text: brand.name);
    final descriptionController =
        TextEditingController(text: brand.description);
    String? pickedLocalPath;
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit brand'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration:
                  const InputDecoration(labelText: 'Description (optional)'),
            ),
            CatalogImagePickField(
              label: 'Logo image (optional)',
              existingUrl: brand.imageUrl,
              existingPath: brand.imagePath,
              onPicked: (path) => pickedLocalPath = path,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (saved != true) return;
    String? imagePath;
    try {
      imagePath = await _resolveImagePath(
        ref,
        pickedLocalPath: pickedLocalPath,
        existingPath: brand.imagePath,
      );
    } on Failure catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error.message)));
      return;
    }
    await ref.read(adminBrandsControllerProvider.notifier).edit(
          brandId: brand.id,
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
          imagePath: imagePath,
        );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    AdminBrand brand,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete brand?'),
        content: Text(
          'Products assigned to "${brand.name}" keep existing but lose their '
          'brand.',
        ),
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
    if (confirmed != true) return;
    await ref
        .read(adminBrandsControllerProvider.notifier)
        .delete(brandId: brand.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandsAsync = ref.watch(adminBrandsControllerProvider);

    ref.listen(adminBrandsControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Brands')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _create(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: brandsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (brands) {
          if (brands.isEmpty) {
            return const Center(child: Text('No brands yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              final isArchived = brand.status == AdminCatalogStatus.archived;
              return ListTile(
                leading: SizedBox(
                  width: 44,
                  height: 44,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: MonogramImage(
                      imageUrl: brand.imageUrl,
                      name: brand.name,
                      icon: Icons.sell_outlined,
                    ),
                  ),
                ),
                title: Text(
                  brand.name,
                  style: isArchived
                      ? TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        )
                      : null,
                ),
                subtitle: brand.description.isEmpty
                    ? null
                    : Text(brand.description, maxLines: 1),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: isArchived ? 'Activate' : 'Archive',
                      icon: Icon(isArchived
                          ? Icons.unarchive_outlined
                          : Icons.archive_outlined),
                      onPressed: () => ref
                          .read(adminBrandsControllerProvider.notifier)
                          .setArchived(
                            brandId: brand.id,
                            archived: !isArchived,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _edit(context, ref, brand),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _delete(context, ref, brand),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
