import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../domain/entities/admin.dart';
import '../controllers/admin_brands_controller.dart';
import '../controllers/admin_categories_controller.dart';
import '../controllers/admin_products_controller.dart';

/// Create/edit product form (Section 2b, spec §8). Local text/dropdown state
/// lives in this StatefulWidget; mutations go through
/// [AdminProductsController] (AsyncValue.guard + invalidate, PRES-03).
///
/// Created products have no explicit variants — the server auto-creates a
/// 'Default' variant whose null price tracks the base price, keeping carts
/// strictly variant-based. Existing images can be removed; new ones are
/// uploaded on save.
class AdminProductFormScreen extends ConsumerStatefulWidget {
  const AdminProductFormScreen({super.key, this.product});

  final AdminProductSummary? product;

  @override
  ConsumerState<AdminProductFormScreen> createState() =>
      _AdminProductFormScreenState();
}

class _AdminProductFormScreenState
    extends ConsumerState<AdminProductFormScreen> {
  static const _maxImages = 8;

  late final _nameController =
      TextEditingController(text: widget.product?.name ?? '');
  late final _descriptionController =
      TextEditingController(text: widget.product?.description ?? '');
  late final _priceController = TextEditingController(
    text: widget.product == null
        ? ''
        : Money(widget.product!.basePriceMinor).format(),
  );

  String? _businessId;
  String? _categoryId;
  String? _brandId;
  // `late` so the initializer may read `widget` (initial copy of the
  // product's existing images in edit mode).
  late final List<AdminProductImageRef> _images = List.of(
    widget.product?.images ?? const <AdminProductImageRef>[],
  );
  final List<String> _imageDrafts = <String>[];

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
    setState(() => _imageDrafts.add(file.path!));
  }

  Future<void> _save() async {
    final price = _parseMoney(_priceController.text);
    final businessId = _businessId;
    final categoryId = _categoryId;
    if (businessId == null || categoryId == null || price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Store, category and a valid price are required'),
        ),
      );
      return;
    }
    final draft = AdminProductDraft(
      id: widget.product?.id,
      businessId: businessId,
      categoryId: categoryId,
      brandId: _brandId,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      basePriceMinor: price,
    );
    final controller = ref.read(adminProductsControllerProvider(null).notifier);
    if (widget.product == null) {
      await controller.createWithImages(
        draft: draft,
        imageFilePaths: List.of(_imageDrafts),
      );
    } else {
      await controller.updateWithImages(
        draft: draft,
        newImageFilePaths: List.of(_imageDrafts),
      );
    }
    final hasError =
        ref.read(adminProductsControllerProvider(null)).hasError;
    if (!hasError && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(adminCategoriesControllerProvider);
    final brandsAsync = ref.watch(adminBrandsControllerProvider);
    final businessesAsync = ref.watch(adminActiveBusinessesProvider);

    ref.listen(adminProductsControllerProvider(null), (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    // Default the store picker to the first active business once loaded.
    if (_businessId == null) {
      businessesAsync.maybeWhen(
        data: (businesses) {
          if (businesses.isNotEmpty) _businessId = businesses.first.id;
          return null;
        },
        orElse: () => null,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'New product' : 'Edit product'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: 'Base price',
              prefixText: '\$ ',
            ),
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 12),
          businessesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text('$error'),
            data: (businesses) => DropdownButtonFormField<String>(
              initialValue: _businessId,
              decoration: const InputDecoration(labelText: 'Store'),
              items: [
                for (final business in businesses)
                  DropdownMenuItem(
                    value: business.id,
                    child: Text(business.name),
                  ),
              ],
              onChanged: (value) => setState(() => _businessId = value),
            ),
          ),
          const SizedBox(height: 12),
          categoriesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text('$error'),
            data: (categories) => DropdownButtonFormField<String>(
              initialValue: _categoryId ?? widget.product?.categoryId,
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
          brandsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text('$error'),
            data: (brands) => DropdownButtonFormField<String>(
              initialValue: _brandId ?? widget.product?.brandId,
              decoration:
                  const InputDecoration(labelText: 'Brand (optional)'),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('— No brand —'),
                ),
                for (final brand in brands)
                  DropdownMenuItem(
                    value: brand.id,
                    child: Text(
                      brand.status == AdminCatalogStatus.archived
                          ? '${brand.name} (archived)'
                          : brand.name,
                    ),
                  ),
              ],
              onChanged: (value) => setState(() => _brandId = value),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Images', style: Theme.of(context).textTheme.titleSmall),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: const Text('Add'),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < _images.length; i++)
                _ImageTile(
                  url: _images[i].url,
                  onRemove: () {
                    final image = _images[i];
                    ref
                        .read(adminProductsControllerProvider(null).notifier)
                        .removeImage(
                          imageId: image.id,
                          storagePath: image.storagePath,
                        );
                    setState(() => _images.removeAt(i));
                  },
                ),
              for (var i = 0; i < _imageDrafts.length; i++)
                _ImageTile(
                  file: _imageDrafts[i],
                  onRemove: () => setState(() => _imageDrafts.removeAt(i)),
                ),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _save,
            child: Text(widget.product == null ? 'Create' : 'Save'),
          ),
        ],
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({this.url, this.file, required this.onRemove});

  final String? url;
  final String? file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 88,
            height: 88,
            child: url != null
                ? Image.network(url!, fit: BoxFit.cover)
                : file != null
                    ? Image.file(File(file!), fit: BoxFit.cover)
                    : const SizedBox.shrink(),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: InkWell(
            onTap: onRemove,
            child: CircleAvatar(
              radius: 12,
              backgroundColor:
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
              child: const Icon(Icons.close, size: 14),
            ),
          ),
        ),
      ],
    );
  }
}
