import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';

/// Brand/category imagery picker (DESIGN.md imagery pipeline): previews the
/// current storage reference (resolved display URL) or a freshly picked
/// local file.
///
/// The picked local path is reported through [onPicked] (null on undo) — the
/// CALLER must own it in a variable declared *outside* the dialog. The
/// field's own state dies with the dialog subtree, so reading it after
/// `showDialog` returns would always yield null (the bug this callback
/// replaced).
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

  /// Fired when the user picks a new local file (with its path) or undoes
  /// the pick (with null).
  final ValueChanged<String?>? onPicked;

  @override
  State<CatalogImagePickField> createState() => _CatalogImagePickFieldState();
}

class _CatalogImagePickFieldState extends State<CatalogImagePickField> {
  String? _pickedLocalPath;

  Future<void> _pick() async {
    final file = await FilePicker.pickFile(type: FileType.image);
    if (!mounted || file == null || file.path == null) return;
    setState(() => _pickedLocalPath = file.path);
    widget.onPicked?.call(file.path);
  }

  void _clear() {
    setState(() => _pickedLocalPath = null);
    widget.onPicked?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                child: _pickedLocalPath != null
                    ? Image.file(
                        File(_pickedLocalPath!),
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
                    onPressed: _pick,
                    icon: const Icon(Icons.upload_outlined, size: 18),
                    label: Text(_pickedLocalPath != null
                        ? 'Replace pick'
                        : 'Upload image'),
                  ),
                  if (_pickedLocalPath != null)
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
