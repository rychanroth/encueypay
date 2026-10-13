import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';
import '../../domain/entities/admin.dart';
import '../controllers/admin_categories_controller.dart';
import '../widgets/catalog_image_pick_field.dart';
import '../widgets/searchable_picker_field.dart';

/// Category management (spec §2.4): global parent/child catalog structure,
/// now with the DESIGN.md imagery pipeline (upload → catalog_assets →
/// image_path).
class CategoriesAdminScreen extends ConsumerWidget {
  const CategoriesAdminScreen({super.key});

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
          .read(adminCategoriesControllerProvider.notifier)
          .uploadImage(filePath: pickedLocalPath);
    }
    return existingPath;
  }

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    String? pickedLocalPath;
    // 2-level taxonomy (§2c): a new category may nest under a top-level
    // parent; parent products aggregate in Discovery automatically.
    final topLevelCategories = (ref.read(adminCategoriesControllerProvider).value ?? const <AdminCategory>[])
        .where((category) => category.parentId == null)
        .toList();
    String? parentId;
    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('New category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            CatalogImagePickField(
              label: 'Category image (optional)',
              onPicked: (path) => pickedLocalPath = path,
            ),
            const SizedBox(height: 12),
            SearchablePickerField(
              label: 'Parent category (optional)',
              allowEmpty: true,
              options: [
                for (final category in topLevelCategories)
                  SearchableOption(id: category.id, label: category.name),
              ],
              valueId: parentId,
              onChanged: (value) => parentId = value,
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
    await ref.read(adminCategoriesControllerProvider.notifier).create(
          name: nameController.text.trim(),
          parentId: parentId,
          imagePath: imagePath,
        );
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    AdminCategory category,
  ) async {
    final nameController = TextEditingController(text: category.name);
    String? pickedLocalPath;
    // Parent options: top-level categories only, excluding the category
    // itself. Picking none promotes back to top-level.
    final topLevelCategories = (ref.read(adminCategoriesControllerProvider).value ?? const <AdminCategory>[])
        .where((candidate) =>
            candidate.parentId == null && candidate.id != category.id)
        .toList();
    String? parentId = category.parentId;
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            CatalogImagePickField(
              label: 'Category image (optional)',
              existingUrl: category.imageUrl,
              existingPath: category.imagePath,
              onPicked: (path) => pickedLocalPath = path,
            ),
            const SizedBox(height: 12),
            SearchablePickerField(
              label: 'Parent category (optional)',
              allowEmpty: true,
              options: [
                for (final candidate in topLevelCategories)
                  SearchableOption(id: candidate.id, label: candidate.name),
              ],
              valueId: parentId,
              onChanged: (value) => parentId = value,
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
        existingPath: category.imagePath,
      );
    } on Failure catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error.message)));
      return;
    }
    await ref.read(adminCategoriesControllerProvider.notifier).rename(
          categoryId: category.id,
          name: nameController.text.trim(),
          imagePath: imagePath,
          parentId: parentId,
        );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, String categoryId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete category?'),
        content: const Text(
          'Categories in use by products or with subcategories cannot be '
          'deleted.',
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
        .read(adminCategoriesControllerProvider.notifier)
        .delete(categoryId: categoryId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(adminCategoriesControllerProvider);

    ref.listen(adminCategoriesControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _create(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No categories yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                leading: SizedBox(
                  width: 44,
                  height: 44,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: MonogramImage(
                      imageUrl: category.imageUrl,
                      name: category.name,
                      icon: Icons.category_outlined,
                    ),
                  ),
                ),
                title: Text(
                  category.parentId == null
                      ? category.name
                      : '   ↳ ${category.name}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _edit(context, ref, category),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () =>
                          _delete(context, ref, category.id),
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
