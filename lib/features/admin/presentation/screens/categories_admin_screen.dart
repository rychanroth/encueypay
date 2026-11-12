import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/async_value_widget.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/picked_file.dart';
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
    required PickedFile? pickedImage,
    required String? existingPath,
  }) async {
    if (pickedImage != null) {
      return ref
          .read(adminCategoriesControllerProvider.notifier)
          .uploadImage(image: pickedImage);
    }
    return existingPath;
  }

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    PickedFile? pickedImage;
    // 2-level taxonomy (§2c): a new category may nest under a top-level
    // parent; parent products aggregate in Discovery automatically.
    final topLevelCategories =
        (ref.read(adminCategoriesControllerProvider).value ??
                const <AdminCategory>[])
            .where((category) => category.parentId == null)
            .toList();
    String? parentId;
    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('New category'),
        // StatefulBuilder: the picker's onChanged mutates [parentId], and
        // without a dialog-scoped setState the field keeps displaying the
        // stale selection while Save still reads the updated value.
        content: StatefulBuilder(
          builder: (context, dialogSetState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 12),
                CatalogImagePickField(
                  label: 'Category image (optional)',
                  onPicked: (pick) => pickedImage = pick,
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
                  onChanged: (value) => dialogSetState(() => parentId = value),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('Enter a category name')),
                );
                return;
              }
              Navigator.of(dialogContext).pop(true);
            },
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
        pickedImage: pickedImage,
        existingPath: null,
      );
    } on Failure catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(userMessageFor(error))));
      return;
    }
    await ref
        .read(adminCategoriesControllerProvider.notifier)
        .create(
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
    PickedFile? pickedImage;
    // Parent options: top-level categories only, excluding the category
    // itself. Picking none promotes back to top-level.
    final topLevelCategories =
        (ref.read(adminCategoriesControllerProvider).value ??
                const <AdminCategory>[])
            .where(
              (candidate) =>
                  candidate.parentId == null && candidate.id != category.id,
            )
            .toList();
    String? parentId = category.parentId;
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit category'),
        // StatefulBuilder — same reason as the create dialog above.
        content: StatefulBuilder(
          builder: (context, dialogSetState) => SingleChildScrollView(
            child: Column(
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
                  onPicked: (pick) => pickedImage = pick,
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
                  onChanged: (value) => dialogSetState(() => parentId = value),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('Enter a category name')),
                );
                return;
              }
              Navigator.of(dialogContext).pop(true);
            },
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
        pickedImage: pickedImage,
        existingPath: category.imagePath,
      );
    } on Failure catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(userMessageFor(error))));
      return;
    }
    await ref
        .read(adminCategoriesControllerProvider.notifier)
        .rename(
          categoryId: category.id,
          name: nameController.text.trim(),
          imagePath: imagePath,
          parentId: parentId,
        );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    String categoryId,
  ) async {
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
          ..showSnackBar(SnackBar(content: Text(userMessageFor(error))));
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
        error: (error, _) => Center(child: Text(userMessageFor(error))),
        data: (categories) {
          if (categories.isEmpty) {
            return const EmptyStateView(
              icon: Icons.category_outlined,
              title: 'No categories yet',
              description: 'Add a top-level category to start the catalog.',
            );
          }
          final ordered = orderedAdminCategories(categories);
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ordered.length,
            itemBuilder: (context, index) {
              final category = ordered[index];
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
                      onPressed: () => _delete(context, ref, category.id),
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

/// Display order for the admin category list (mirrors the customer
/// DiscoveryScreen chip strip): top-level categories alphabetically, each
/// immediately followed by its own alphabetical children. Children whose
/// parent is missing from the list stay visible at the end so management
/// never hides a row.
List<AdminCategory> orderedAdminCategories(List<AdminCategory> categories) {
  final byName = [...categories]
    ..sort((a, b) {
      final byLabel = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      return byLabel != 0 ? byLabel : a.id.compareTo(b.id);
    });
  final parents =
      byName.where((category) => category.parentId == null).toList();
  final parentIds = {for (final parent in parents) parent.id};
  return [
    for (final parent in parents) ...[
      parent,
      ...byName.where((category) => category.parentId == parent.id),
    ],
    ...byName.where(
      (category) =>
          category.parentId != null && !parentIds.contains(category.parentId),
    ),
  ];
}
