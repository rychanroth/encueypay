import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/picked_file.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';

/// Brand/category imagery picker (DESIGN.md imagery pipeline): previews the
/// current storage reference (resolved display URL) or a freshly picked
/// file.
///
/// The picked file is reported through [onPicked] (null on undo) — the
/// CALLER must own it in a variable declared *outside* the dialog. The
/// field's own state dies with the dialog subtree, so reading it after
/// `showDialog` returns would always yield null (the bug this callback
/// replaced).
///
/// Picks are carried as bytes ([PickedFile]) so the preview and the upload
/// work on web, where no local file path exists.
///
/// Dialog flow: pick → (on save) upload via the controller → persist the
/// returned path. No repo access from screens (PRES-04).
class CatalogImagePickField extends StatefulWidget {
  const CatalogImagePickField({
    super.key,
    required this.label,
    this.existingUrl,
    this.existingPath,
    this.onPicked,
  });

  final String label;

  /// Resolved display URL of the current imagery (may be null).
  final String? existingUrl;

  /// Raw storage path backing [existingUrl]; passed through when the user
  /// keeps the current image.
  final String? existingPath;

  /// Fired when the user picks a new file or undoes the pick (with null).
  final ValueChanged<PickedFile?>? onPicked;

  @override
  State<CatalogImagePickField> createState() => _CatalogImagePickFieldState();
}

class _CatalogImagePickFieldState extends State<CatalogImagePickField> {
  PickedFile? _pick;

  Future<void> _pickFile() async {
    final file = await FilePicker.pickFile(type: FileType.image);
    if (!mounted || file == null) return;
    final picked = PickedFile(
      bytes: await file.readAsBytes(),
      fileName: file.name,
    );
    if (!mounted) return;
    setState(() => _pick = picked);
    widget.onPicked?.call(picked);
  }

  void _clear() {
    setState(() => _pick = null);
    widget.onPicked?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pick = _pick;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: theme.textTheme.labelMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: ClipRRect(
                borderRadius: AppRadii.br12,
                child: pick != null
                    ? Image.memory(
                        pick.bytes,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const ColoredBox(color: Color(0xFFF1F5F9)),
                      )
                    : MonogramImage(
                        imageUrl: widget.existingUrl,
                        name: widget.label,
                        icon: Icons.image_outlined,
                      ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  OutlinedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.upload_outlined, size: 18),
                    label: Text(pick != null ? 'Replace pick' : 'Upload image'),
                  ),
                  if (pick != null)
                    TextButton(
                      onPressed: _clear,
                      child: const Text('Undo pick'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
