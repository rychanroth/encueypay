import 'dart:io';

import 'package:flutter/material.dart';

import '../../domain/entities/business_profile.dart';

/// Editable strip of a product's images (PRES-06): already-uploaded images
/// plus freshly picked drafts, each removable, with an add tile. The strip is
/// purely presentational — picking and persistence live in the form/controller.
class ProductImageStrip extends StatelessWidget {
  const ProductImageStrip({
    super.key,
    required this.existingImages,
    required this.newDrafts,
    required this.canAdd,
    required this.onAdd,
    required this.onRemoveExisting,
    required this.onRemoveNew,
  });

  final List<BusinessProductImage> existingImages;
  final List<ImagePickDraft> newDrafts;
  final bool canAdd;
  final VoidCallback onAdd;
  final ValueChanged<BusinessProductImage> onRemoveExisting;
  final ValueChanged<ImagePickDraft> onRemoveNew;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 96,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final image in existingImages)
            _ImageTile(
              key: ValueKey('existing-${image.id}'),
              image: Image.network(
                image.url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => ColoredBox(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(Icons.image_outlined, color: theme.colorScheme.outline),
                ),
              ),
              onRemove: () => onRemoveExisting(image),
            ),
          for (final draft in newDrafts)
            _ImageTile(
              key: ValueKey('draft-${draft.filePath}'),
              image: Image.file(
                File(draft.filePath),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => ColoredBox(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(Icons.broken_image_outlined,
                      color: theme.colorScheme.outline),
                ),
              ),
              onRemove: () => onRemoveNew(draft),
            ),
          if (canAdd)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: onAdd,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 88,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                  child: Icon(Icons.add_a_photo_outlined,
                      color: theme.colorScheme.outline),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({super.key, required this.image, required this.onRemove});

  final Widget image;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(width: 88, height: 88, child: image),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _RemoveButton(onRemove: onRemove),
          ),
        ],
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.onRemove});

  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        shape: const CircleBorder(),
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.85),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onRemove,
          child: const Padding(
            padding: EdgeInsets.all(2),
            child: Icon(Icons.close, size: 16),
          ),
        ),
      ),
    );
  }
}
