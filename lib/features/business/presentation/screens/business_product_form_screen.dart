import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../domain/entities/business_profile.dart';
import '../controllers/business_categories_provider.dart';
import '../controllers/business_products_controller.dart';
import '../widgets/product_image_strip.dart';

/// Create (product == null) or edit a product. Variants can be added at
/// creation or later from the edit form; each variant's image is managed
/// individually.
class BusinessProductFormScreen extends ConsumerStatefulWidget {
  const BusinessProductFormScreen({super.key, this.product});

  final BusinessProduct? product;

  @override
  ConsumerState<BusinessProductFormScreen> createState() =>
      _BusinessProductFormScreenState();
}

class _BusinessProductFormScreenState
    extends ConsumerState<BusinessProductFormScreen> {
  static const _maxImages = 10;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String? _categoryId;
  final _variantDrafts = <VariantDraft>[];
  final _initialImages = <BusinessProductImage>[];
  final _images = <BusinessProductImage>[];
  final _imageDrafts = <ImagePickDraft>[];

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    if (product != null) {
      _nameController.text = product.name;
      _descriptionController.text = product.description;
      _priceController.text = Money(product.basePriceMinor).format();
      _categoryId = product.categoryId;
      _initialImages.addAll(product.images);
      _images.addAll(product.images);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  int? _parseMoney(String input) {
    try {
      return Money.parse(input).minorUnits;
    } on FormatException {
      return null;
    }
  }

  Future<void> _pickImage() async {
    final file = await FilePicker.pickFile(type: FileType.image);
    if (!mounted) return;
    if (file == null || file.path == null) return;
    if (_images.length + _imageDrafts.length >= _maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Up to $_maxImages images per product')),
      );
      return;
    }
    setState(() {
      _imageDrafts.add(ImagePickDraft(
        filePath: file.path!,
        fileName: file.name,
      ));
    });
  }

  Future<void> _save() async {
    final categoryId = _categoryId;
    final price = _parseMoney(_priceController.text);
    if (categoryId == null || price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill in all fields correctly')),
      );
      return;
    }
    final controller = ref.read(businessProductsControllerProvider.notifier);
    final product = widget.product;
    if (product == null) {
      await controller.create(
        categoryId: categoryId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        basePriceMinor: price,
        variants: List.of(_variantDrafts),
        images: List.of(_imageDrafts),
      );
    } else {
      final removedImages =
          _initialImages.where((image) => !_images.contains(image)).toList();
      await controller.updateProduct(
        productId: product.id,
        categoryId: categoryId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        basePriceMinor: price,
        removedImages: removedImages,
        newImages: List.of(_imageDrafts),
      );
    }
    final hasError = ref.read(businessProductsControllerProvider).hasError;
    if (!hasError && mounted) context.pop();
  }

  /// Variant images upload immediately — each is a single self-contained op.
  /// On success the form pops back to the refetched list.
  Future<void> _pickVariantImage(ManagementVariant variant) async {
    final file = await FilePicker.pickFile(type: FileType.image);
    if (!mounted) return;
    if (file == null || file.path == null) return;
    await ref
        .read(businessProductsControllerProvider.notifier)
        .updateVariantImage(
          variantId: variant.id,
          filePath: file.path!,
          fileName: file.name,
          previousPath: variant.imagePath,
        );
    final hasError = ref.read(businessProductsControllerProvider).hasError;
    if (!hasError && mounted) context.pop();
  }

  Future<void> _clearVariantImage(ManagementVariant variant) async {
    await ref
        .read(businessProductsControllerProvider.notifier)
        .clearVariantImage(
          variantId: variant.id,
          previousPath: variant.imagePath!,
        );
    final hasError = ref.read(businessProductsControllerProvider).hasError;
    if (!hasError && mounted) context.pop();
  }

  /// Name + optional price prompt shared by the create and edit flows.
  Future<(String, int?)?> _promptVariant() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    return showDialog<(String, int?)>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add variant'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(labelText: 'Name (e.g. M / Black)'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Price (empty = base price)',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) return;
              Navigator.of(dialogContext).pop((
                name,
                priceController.text.trim().isEmpty
                    ? null
                    : _parseMoney(priceController.text),
              ));
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addVariantDraft() async {
    final draft = await _promptVariant();
    if (draft == null || !mounted) return;
    setState(() {
      _variantDrafts.add(VariantDraft(name: draft.$1, priceMinor: draft.$2));
    });
  }

  /// Edit flow: the variant is created server-side immediately; on success
  /// the form pops back to the refetched list (same as variant image ops).
  Future<void> _addVariantToProduct() async {
    final product = widget.product;
    if (product == null) return;
    final draft = await _promptVariant();
    if (draft == null || !mounted) return;
    await ref.read(businessProductsControllerProvider.notifier).addVariant(
          productId: product.id,
          name: draft.$1,
          priceMinor: draft.$2,
        );
    final hasError = ref.read(businessProductsControllerProvider).hasError;
    if (!hasError && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(businessCategoriesProvider);
    final isSaving = ref.watch(
      businessProductsControllerProvider.select((async) => async.isLoading),
    );
    final theme = Theme.of(context);

    ref.listen(businessProductsControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.product == null ? 'Add product' : 'Edit product'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          categoriesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text('$error'),
            data: (categories) => DropdownButtonFormField<String>(
              initialValue: _categoryId,
              decoration: const InputDecoration(labelText: 'Category'),
              items: [
                for (final category in categories)
                  DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name),
                  ),
              ],
              onChanged: (value) => setState(() => _categoryId = value),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Product name'),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Text('Images', style: theme.textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          ProductImageStrip(
            existingImages: _images,
            newDrafts: _imageDrafts,
            canAdd: _images.length + _imageDrafts.length < _maxImages,
            onAdd: _pickImage,
            onRemoveExisting: (image) =>
                setState(() => _images.remove(image)),
            onRemoveNew: (draft) => setState(() => _imageDrafts.remove(draft)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(labelText: 'Base price'),
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
          ),
          if (widget.product == null) ...[
            const SizedBox(height: 16),
            Text('Variants (optional)',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            for (final draft in _variantDrafts)
              ListTile(
                dense: true,
                leading: const Icon(Icons.layers_outlined),
                title: Text(draft.name),
                subtitle: Text(draft.priceMinor == null
                    ? 'base price'
                    : Money(draft.priceMinor!).format()),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () =>
                      setState(() => _variantDrafts.remove(draft)),
                ),
              ),
            OutlinedButton.icon(
              onPressed: _addVariantDraft,
              icon: const Icon(Icons.add),
              label: const Text('Add variant'),
            ),
          ],
          if (widget.product != null) ...[
            const SizedBox(height: 16),
            Text('Variants',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            for (final variant in widget.product!.variants)
              ListTile(
                dense: true,
                leading: variant.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          variant.imageUrl!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.image_outlined),
                        ),
                      )
                    : const Icon(Icons.image_outlined),
                title: Text(variant.name),
                subtitle: Text(variant.priceMinor == null
                    ? 'base price'
                    : Money(variant.priceMinor!).format()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Set image',
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                      onPressed: () => _pickVariantImage(variant),
                    ),
                    if (variant.imagePath != null)
                      IconButton(
                        tooltip: 'Remove image',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _clearVariantImage(variant),
                      ),
                  ],
                ),
              ),
            OutlinedButton.icon(
              onPressed: _addVariantToProduct,
              icon: const Icon(Icons.add),
              label: const Text('Add variant'),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: isSaving ? null : _save,
            child: isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
    );
  }
}
