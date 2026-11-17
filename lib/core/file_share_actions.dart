import 'dart:typed_data';

abstract interface class FileShareActions {
  Future<void> shareTextFile(
    String content,
    String fileName, {
    String? text,
    String? subject,
  });

  Future<void> shareFile(
    Uint8List bytes,
    String fileName, {
    String? text,
    String? subject,
  });
}
