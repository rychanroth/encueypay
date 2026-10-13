import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';

/// Brand/category imagery picker (DESIGN.md imagery pipeline): previews the
/// current storage reference (resolved display URL) or a freshly picked
/// local file, and exposes which state it is in via [hasNewPick]/[pickedPath].
///
/// The dialog flow is: pick → (on save) upload via the controller → persist
/// the returned path. No repo access from screens (PRES-04).
class CatalogImagePickField extends StatefulWidget {
  const CatalogImagePickField({
    super.key,
    required this.label,
    this.existingUrl,
    this.existingPath,
  });

  final String label;

  /// Resolved display URL of the current imagery (may be null).
  final String? existingUrl;

  /// Raw storage path backing [existingUrl]; passed through when the user
  /// keeps the current image.
  final String? existingPath;

  @override
  State<CatalogImagePickField> createState() => CatalogImagePickFieldState();
}

class CatalogImagePickFieldState extends State<CatalogImagePickField> {
  String? _pickedLocalPath;

  /// True when the user picked a new local file that still needs uploading.
  bool get hasNewPick => _pickedLocalPath != null;

  /// The picked local file path (only when [hasNewPick]).
  String? get pickedPath => _pickedLocalPath;

  /// The value to persist when nothing new was picked: the existing raw
  /// path (or null to clear).
  String? get existingPathOrClear => widget.existingPath;

  Future<void> _pick() async {
    final file = await FilePicker.pickFile(type: FileType.image);
    if (!mounted || file == null || file.path == null) return;
    setState(() => _pickedLocalPath = file.path);
  }

  void _clear() => setState(() => _pickedLocalPath = null);

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
