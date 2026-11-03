import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/content_width.dart';

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
/// Variants are authored explicitly — there is no implicit "Default". Every
/// product needs at least one named, priced variant; a business that wants a
/// Default option creates and manages that row itself. Editing syncs the
/// full list: id rows update in place, new rows insert, and removed rows
/// archive server-side (never delete — historical orders reference them).
/// The server derives the cached from-price from the cheapest active row.
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
  final List<AdminProductImageRef> _removedImages = <AdminProductImageRef>[];
  bool _saving = false;
  final _nameFocus = FocusNode();
  final _stockFocus = FocusNode();
  String? _nameError;
  String? _stockError;
  String? _categoryError;
  String? _variantError;

  /// Desired variant rows. Seeded from the product's active variants in edit
  /// mode (carrying their existing image paths for the preview and the save);
  /// a new product starts with one blank row. Rows without an id insert
  /// server-side, id rows update in place.
  late final List<_VariantRow> _variantRows = <_VariantRow>[
    for (final variant
        in widget.product?.variants ?? const <AdminProductVariantRef>[])
      _VariantRow(
        id: variant.id,
        imagePath: variant.imagePath,
        existingUrl: variant.imageUrl,
      )
        ..name.text = variant.name
        ..price.text =
            variant.priceMinor == null ? '' : Money(variant.priceMinor!).format(),
  ];

  void _addVariantRow() => setState(() => _variantRows.add(_VariantRow()));

  void _removeVariantRow(_VariantRow row) {
    setState(() {
      _variantRows.remove(row);
      row.dispose();
    });
  }

  @override
  void initState() {
    super.initState();
    // A blank row is a UI affordance, not a database default — saving still
    // requires the business to name and price at least one variant.
    if (widget.product == null) _variantRows.add(_VariantRow());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    _nameFocus.dispose();
    _stockFocus.dispose();
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
    if (_saving) return;
    setState(() {
      _nameError = null;
      _stockError = null;
      _categoryError = null;
      _variantError = null;
    });
    final name = _nameController.text.trim();
    final stock = _parseStock(_stockController.text);
    final categoryId = _categoryId;
    // Variant rows: an untouched new row is ignored; every kept row is a
    // real priced variant (name + price + image for new rows). Rows marked
    // archived are EXCLUDED from the payload — the server's full-list sync
    // archives them (never deletes; historical orders keep their refs).
    final variants = <AdminProductVariantDraft>[];
    for (final row in _variantRows) {
      if (row.archived) continue;
      final variantName = row.name.text.trim();
      final priceText = row.price.text.trim();
      final hasImage = row.localPath != null || row.imagePath != null;
      final isNew = row.id == null;
      if (isNew && variantName.isEmpty && priceText.isEmpty && !hasImage) {
        continue;
      }
      if (variantName.isEmpty) {
        setState(() => _variantError = 'Every variant needs a name');
        return;
      }
      final variantPrice = _parseMoney(priceText);
      if (variantPrice == null) {
        setState(
          () => _variantError = '"$variantName" needs a valid price',
        );
        return;
      }
      variants.add(AdminProductVariantDraft(
        id: row.id,
        name: variantName,
        priceMinor: variantPrice,
        imagePath: row.imagePath,
        imageLocalPath: row.localPath,
      ));
    }
    var invalid = false;
    if (name.isEmpty) {
      _nameError = 'Enter a product name';
      invalid = true;
    }
    if (categoryId == null) {
      _categoryError = 'Select a category';
      invalid = true;
    }
    if (stock == null) {
      _stockError = 'Enter a valid stock quantity';
      invalid = true;
    }
    if (variants.isEmpty) {
      _variantError = 'Add at least one variant';
      invalid = true;
    }
    if (invalid) {
      setState(() {});
      if (_nameError != null) {
        _nameFocus.requestFocus();
      } else if (_stockError != null) {
        _stockFocus.requestFocus();
      }
      return;
    }
    final draft = AdminProductDraft(
      id: widget.product?.id,
      // 2-role prototype (DESIGN.md §1.1): no store picker. Create passes
      // null — the server resolves/provisions the prototype business; edits
      // carry the product's existing business.
      categoryId: categoryId!,
      brandId: _brandId,
      name: name,
      description: _descriptionController.text.trim(),
      stock: stock!,
      variants: variants,
    );
    setState(() => _saving = true);
    try {
      final controller =
          ref.read(adminProductsControllerProvider(null).notifier);
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
      if (hasError) return;

      // Staged removals only hit the server after the product save succeeds
      // — cancelling the form never deletes an existing image.
      for (final image in List.of(_removedImages)) {
        final error = await controller.removeImage(
          imageId: image.id,
          storagePath: image.storagePath,
        );
        if (error != null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(userMessageFor(error))),
            );
          return;
        }
        _removedImages.remove(image);
      }
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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
          ..showSnackBar(SnackBar(content: Text(userMessageFor(error))));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'New product' : 'Edit product'),
      ),
      body: ContentWidth(
        child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameController,
            focusNode: _nameFocus,
            decoration: InputDecoration(
              labelText: 'Name',
              errorText: _nameError,
            ),
            onChanged: (_) {
              if (_nameError != null) setState(() => _nameError = null);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          Text(
            'Every product needs at least one variant. The cheapest active '
            'variant becomes the catalog "from" price.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _stockController,
            focusNode: _stockFocus,
            decoration: InputDecoration(
              labelText: 'Stock quantity (product-wide)',
              helperText:
                  'Purchasing any variant deducts from this counter',
              errorText: _stockError,
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) {
              if (_stockError != null) setState(() => _stockError = null);
            },
          ),
          const SizedBox(height: 12),
          // Explicit variant authoring: the business manages every row,
          // including one it chooses to call "Default". Full-list sync:
          // new rows insert, existing rows update, removed rows archive.
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
            'At least one variant is required. New variants need a name and '
            'price (image optional). Archiving keeps the variant for order '
            'history; archiving the last one is blocked.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (_variantError != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _variantError!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          for (final row in _variantRows)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Opacity(
                // Pending-archive rows stay visible until save — nothing is
                // deleted, the sync flips their status server-side.
                opacity: row.archived ? 0.5 : 1,
                child: Row(
                  children: [
                    _VariantImageTile(
                      localPath: row.localPath,
                      existingUrl: row.existingUrl,
                      enabled: !row.archived,
                      onPicked: (path) => setState(() {
                        row.localPath = path;
                        _variantError = null;
                      }),
                      onCleared: () => setState(() {
                        row.localPath = null;
                        row.imagePath = null;
                        _variantError = null;
                      }),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: row.name,
                        enabled: !row.archived,
                        onChanged: (_) => setState(() => _variantError = null),
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: row.price,
                        enabled: !row.archived,
                        onChanged: (_) => setState(() => _variantError = null),
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          prefixText: '\$ ',
                          isDense: true,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ),
                    IconButton(
                      tooltip: row.id == null
                          ? 'Remove variant'
                          : row.archived
                              ? 'Restore variant'
                              : 'Archive variant (applies on save)',
                      onPressed: () async {
                        if (row.id == null) {
                          _removeVariantRow(row);
                          return;
                        }
                        if (!row.archived &&
                            _variantRows
                                    .where((candidate) => !candidate.archived)
                                    .length ==
                                1) {
                          await showDialog<void>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Keep at least one variant'),
                              content: const Text(
                                'Every product needs at least one active '
                                'variant. Add another variant before '
                                'archiving this one.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                          return;
                        }
                        setState(() => row.archived = !row.archived);
                      },
                      icon: Icon(
                        row.id == null
                            ? Icons.remove_circle_outline
                            : row.archived
                                ? Icons.unarchive_outlined
                                : Icons.archive_outlined,
                      ),
                    ),
                  ],
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
            error: (error, _) => Text(userMessageFor(error)),
            data: (categories) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchablePickerField(
                  label: 'Category',
                  options: [
                    for (final category in categories)
                      SearchableOption(id: category.id, label: category.name),
                  ],
                  valueId: _categoryId,
                  onChanged: (value) => setState(() {
                    _categoryId = value;
                    _categoryError = null;
                  }),
                ),
                if (_categoryError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 12),
                    child: Text(
                      _categoryError!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          brandsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text(userMessageFor(error)),
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
                    setState(() {
                      _removedImages.add(image);
                      _images.removeAt(i);
                    });
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
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.product == null ? 'Create' : 'Save'),
          ),
        ],
      ),
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
/// dispose them deterministically. [id] is null for rows that insert
/// server-side; non-null rows update the existing variant in place, and
/// [archived] marks them for the server's archive-on-sync (never deletion —
/// historical orders reference their rows). [imagePath] is the existing
/// storage path (sent back on save), and [localPath] a fresh pick that
/// replaces it on save.
class _VariantRow {
  _VariantRow({this.id, this.imagePath, this.existingUrl});

  final String? id;
  bool archived = false;

  /// Resolved URL of the existing image — preview only.
  final String? existingUrl;

  String? imagePath;
  String? localPath;

  final TextEditingController name = TextEditingController();
  final TextEditingController price = TextEditingController();

  void dispose() {
    name.dispose();
    price.dispose();
  }
}

/// One variant row's image tile: a 52×52 preview (fresh pick over the
/// existing URL over a placeholder) — tap to pick, badge to clear.
class _VariantImageTile extends StatelessWidget {
  const _VariantImageTile({
    required this.localPath,
    required this.existingUrl,
    required this.enabled,
    required this.onPicked,
    required this.onCleared,
  });

  final String? localPath;
  final String? existingUrl;
  final bool enabled;
  final ValueChanged<String> onPicked;
  final VoidCallback onCleared;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = localPath != null || existingUrl != null;
    return Stack(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: enabled
              ? () async {
                  final file = await FilePicker.pickFile(type: FileType.image);
                  if (file?.path != null) onPicked(file!.path!);
                }
              : null,
          child: Container(
            width: 52,
            height: 52,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.outlineVariant),
              color: theme.colorScheme.surfaceContainerLowest,
            ),
            child: localPath != null
                ? Image.file(File(localPath!), fit: BoxFit.cover)
                : existingUrl != null
                    ? Image.network(existingUrl!, fit: BoxFit.cover)
                    : Icon(Icons.add_photo_alternate_outlined,
                        size: 20, color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
        if (hasImage && enabled)
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: onCleared,
              child: CircleAvatar(
                radius: 9,
                backgroundColor:
                    theme.colorScheme.surface.withValues(alpha: 0.9),
                child: const Icon(Icons.close, size: 12),
              ),
            ),
          ),
      ],
    );
  }
}
