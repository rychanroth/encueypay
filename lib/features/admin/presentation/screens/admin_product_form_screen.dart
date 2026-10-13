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
import '../widgets/searchable_picker_field.dart';

/// Create/edit product form (Section 2b, spec §8). Local text/dropdown state
/// lives in this StatefulWidget; mutations go through
/// [AdminProductsController] (AsyncValue.guard + invalidate, PRES-03).
///
/// Created products may author variants inline (name + optional price);
/// leaving the list empty lets the server auto-create a 'Default' variant
/// whose null price tracks the base price, keeping carts strictly
/// variant-based (map §10.3). Existing images can be removed; new ones are
/// uploaded on save. Variant authoring is create-time only — the update
/// RPC does not touch variants.
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
  late final _stockController = TextEditingController(
    text: widget.product == null ? '0' : '${widget.product!.stock}',
  );

  // Initialized from the product in edit mode (`late` so the initializer may
  // read `widget`); the pickers then own the values outright — clearing a
  // field really clears it.
  late String? _categoryId = widget.product?.categoryId;
  late String? _brandId = widget.product?.brandId;
  // `late` so the initializer may read `widget` (initial copy of the
  // product's existing images in edit mode).
  late final List<AdminProductImageRef> _images = List.of(
    widget.product?.images ?? const <AdminProductImageRef>[],
  );
  final List<String> _imageDrafts = <String>[];

  /// Create-time variant rows (name + optional price). Edit mode never
  /// populates this — the update RPC does not touch variants.
  final List<_VariantRow> _variantRows = <_VariantRow>[];

  void _addVariantRow() => setState(() => _variantRows.add(_VariantRow()));

  void _removeVariantRow(_VariantRow row) {
    setState(() {
      _variantRows.remove(row);
      row.dispose();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    for (final row in _variantRows) {
      row.dispose();
    }
    super.dispose();
  }

  int? _parseMoney(String input) {
    try {
      return Money.parse(input).minorUnits;
    } on FormatException {
      return null;
    }
  }

  int? _parseStock(String input) {
    final value = int.tryParse(input.trim());
    if (value == null || value < 0) return null;
    return value;
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
    final stock = _parseStock(_stockController.text);
    final categoryId = _categoryId;
    if (categoryId == null || price == null || stock == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category, a valid price and stock are required'),
        ),
      );
      return;
    }
    final draft = AdminProductDraft(
      id: widget.product?.id,
      // 2-role prototype (DESIGN.md §1.1): no store picker. Create passes
      // null — the server resolves/provisions the prototype business; edits
      // carry the product's existing business.
      categoryId: categoryId,
      brandId: _brandId,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      basePriceMinor: price,
      stock: stock,
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
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(adminCategoriesControllerProvider);
    final brandsAsync = ref.watch(adminBrandsControllerProvider);

    ref.listen(adminProductsControllerProvider(null), (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

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
          TextField(
            controller: _stockController,
            decoration: const InputDecoration(
              labelText: 'Stock quantity (product-wide)',
              helperText:
                  'Purchasing any variant deducts from this counter',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          // Variant authoring (map §10.3, create-time only).
          if (widget.product == null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Variants', style: theme.textTheme.titleSmall),
                TextButton.icon(
                  onPressed: _addVariantRow,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add variant'),
                ),
              ],
            ),
            Text(
              'Leave empty to auto-create a single Default variant. '
              'A variant without a price tracks the base price.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            for (final row in _variantRows)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: row.name,
                        decoration: const InputDecoration(
                          labelText: 'Variant name',
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: row.price,
                        decoration: const InputDecoration(
                          labelText: 'Price (+ base optional)',
                          prefixText: '\$ ',
                          isDense: true,
                          hintText: 'Base price',
                        ),
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Remove variant',
                      onPressed: () => _removeVariantRow(row),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                  ],
                ),
              ),
          ] else
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Variants are authored at creation; editing existing '
                'variants is not supported yet.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          const SizedBox(height: 12),
          // Searchable pickers (Section 2d): FK references scale better with
          // search than with plain dropdowns. The store is intentionally
          // absent — products belong to the auto-provisioned prototype
          // business (§1.1).
          categoriesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text('$error'),
            data: (categories) => SearchablePickerField(
              label: 'Category',
              options: [
                for (final category in categories)
                  SearchableOption(id: category.id, label: category.name),
              ],
              valueId: _categoryId,
              onChanged: (value) => setState(() => _categoryId = value),
            ),
          ),
          const SizedBox(height: 12),
          brandsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text('$error'),
            data: (brands) => SearchablePickerField(
              label: 'Brand (optional)',
              allowEmpty: true,
              options: [
                for (final brand in brands)
                  SearchableOption(
                    id: brand.id,
                    label: brand.status == AdminCatalogStatus.archived
                        ? '${brand.name} (archived)'
                        : brand.name,
                  ),
              ],
              valueId: _brandId,
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

/// One editable variant row — owns its text controllers so removal can
/// dispose them deterministically.
class _VariantRow {
  _VariantRow();

  final TextEditingController name = TextEditingController();
  final TextEditingController price = TextEditingController();

  void dispose() {
    name.dispose();
    price.dispose();
  }
}
