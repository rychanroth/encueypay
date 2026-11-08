import 'dart:typed_data';

/// A file the user picked in the UI, carried as bytes instead of a path.
///
/// Browsers never expose a local file path, so anything that uploads a pick
/// must hand the data layer the content itself. Platform pickers supply it
/// on every platform (`PlatformFile.readAsBytes()` from `file_picker`), and
/// previews render `bytes` with `Image.memory` — one code path for mobile,
/// desktop and web.
class PickedFile {
  const PickedFile({required this.bytes, required this.fileName});

  final Uint8List bytes;

  /// Original file name, extension included. Storage object keys derive from
  /// it, so the extension survives the upload.
  final String fileName;
}
