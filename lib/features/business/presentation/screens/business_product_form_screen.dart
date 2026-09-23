import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../domain/entities/business_profile.dart';
import '../controllers/business_categories_provider.dart';
import '../controllers/business_products_controller.dart';

/// Create (product == null) or edit a product. Variants are defined at
/// creation; afterwards stock is corrected per variant (spec §7).
class BusinessProductFormScreen extends ConsumerStatefulWidget {
  const BusinessProductFormScreen({super.key, this.product});

  final BusinessProduct? product;

  @override
  ConsumerState<BusinessProductFormScreen> createState() =>
      _BusinessProductFormScreenState();
}

class _BusinessProductFormScreenState
    extends ConsumerState<BusinessProductFormScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  String? _categoryId;
  final _variantDrafts = <VariantDraft>[];

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    if (product != null) {
      _nameController.text = product.name;
      _descriptionController.text = product.description;
      _priceController.text = Money(product.basePriceMinor).format();
      _stockController.text = '${product.stock}';
      _categoryId = product.categoryId;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  int? _parseMoney(String input) {
    try {
      return Money.parse(input).minorUnits;
    } on FormatException {
      return null;
    }
  }

  Future<void> _save() async {
    final categoryId = _categoryId;
    final price = _parseMoney(_priceController.text);
    final stock = int.tryParse(_stockController.text);
    if (categoryId == null || price == null || stock == null) {
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
        stock: stock,
        variants: List.of(_variantDrafts),
      );
    } else {
      await controller.updateProduct(
        productId: product.id,
        categoryId: categoryId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        basePriceMinor: price,
      );
    }
    final hasError = ref.read(businessProductsControllerProvider).hasError;
    if (!hasError && mounted) context.pop();
  }

  Future<void> _editStock(ManagementVariant variant) async {
    final controller = TextEditingController(text: '${variant.stock}');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Stock — ${variant.name}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'New stock'),
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
    if (confirmed != true) return;
    final stock = int.tryParse(controller.text);
    if (stock == null) return;
    if (!mounted) return;
    await ref
        .read(businessProductsControllerProvider.notifier)
        .updateStock(variantId: variant.id, stock: stock);
  }

  void _addVariantDraft() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add variant'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name (e.g. M / Black)'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Price (empty = base price)',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: stockController,
              decoration: const InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
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
              final stock = int.tryParse(stockController.text) ?? 0;
              setState(() {
                _variantDrafts.add(VariantDraft(
                  name: nameController.text.trim(),
                  priceMinor: priceController.text.trim().isEmpty
                      ? null
                      : _parseMoney(priceController.text),
                  stock: stock,
                ));
              });
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
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
          const SizedBox(height: 12),
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(labelText: 'Base price'),
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
          ),
          if (widget.product == null) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _stockController,
              decoration: const InputDecoration(
                labelText: 'Stock (used when no variants are added)',
              ),
              keyboardType: TextInputType.number,
            ),
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
                subtitle: Text(
                  '${draft.priceMinor == null ? "base price" : Money(draft.priceMinor!).format()}'
                  ' · stock ${draft.stock}',
                ),
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
            Text('Stock per variant',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            for (final variant in widget.product!.variants)
              ListTile(
                dense: true,
                leading: const Icon(Icons.layers_outlined),
                title: Text(variant.name),
                subtitle: Text(
                  '${variant.priceMinor == null ? "base price" : Money(variant.priceMinor!).format()}'
                  ' · stock ${variant.stock}',
                ),
                trailing: const Icon(Icons.edit_outlined),
                onTap: () => _editStock(variant),
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
