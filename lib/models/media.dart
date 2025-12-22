import 'dart:typed_data';

class MediaUpload {
  final String fileName;
  final Uint8List bytes;
  final String mimeType;

  MediaUpload({
    required this.fileName,
    required this.bytes,
    required this.mimeType,
  });
}
