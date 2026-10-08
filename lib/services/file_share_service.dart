import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Creates temporary files and shares them through the platform share sheet.
class FileShareService {
  static Future<void> shareTextFile(
    String content,
    String fileName, {
    String? text,
    String? subject,
  }) {
    return shareFile(
      Uint8List.fromList(utf8.encode(content)),
      fileName,
      text: text,
      subject: subject,
    );
  }

  static Future<void> shareFile(
    Uint8List bytes,
    String fileName, {
    String? text,
    String? subject,
  }) async {
    final dir = await getTemporaryDirectory();
    final safeFileName = fileName.replaceAll(RegExp(r'[/\\]'), '_');
    final file = File(
      '${dir.path}/${DateTime.now().microsecondsSinceEpoch}_$safeFileName',
    );

    try {
      await file.writeAsBytes(bytes);

      if (!await file.exists()) {
        throw FileSystemException('File was not created', file.path);
      }

      await SharePlus.instance
          .share(
            ShareParams(
              files: [
                XFile(
                  file.path,
                  name: safeFileName,
                  mimeType: _mimeTypeFor(fileName),
                ),
              ],
              text: text,
              subject: subject,
            ),
          )
          .timeout(
            const Duration(seconds: 60),
            onTimeout: () => throw TimeoutException('Sharing timed out'),
          );

      await Future.delayed(const Duration(seconds: 3));
    } finally {
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  static String _mimeTypeFor(String fileName) {
    switch (fileName.split('.').last.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'character':
      case 'race':
      case 'note':
      case 'chax':
      case 'characterbook':
      case 'json':
        return 'application/json';
      default:
        return 'application/octet-stream';
    }
  }
}
