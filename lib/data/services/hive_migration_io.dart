import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

const _hiveDirectoryName = 'Characterbook data';

Future<void> migrateLegacyHiveFiles() async {
  final documentsDirectory = await getApplicationDocumentsDirectory();
  final legacyDirectory = documentsDirectory;
  final currentDirectory = Directory(
    '${documentsDirectory.path}${Platform.pathSeparator}$_hiveDirectoryName',
  );

  if (!await currentDirectory.exists()) {
    await currentDirectory.create(recursive: true);
  }

  final legacyHiveFiles = await _findLegacyHiveFiles(legacyDirectory);
  for (final legacyHiveFile in legacyHiveFiles) {
    final destination = File(
      '${currentDirectory.path}${Platform.pathSeparator}${_fileName(legacyHiveFile.path)}',
    );

    if (await destination.exists()) {
      debugPrint(
        'Skipping Hive migration for ${legacyHiveFile.path}: '
        'destination already exists.',
      );
      continue;
    }

    try {
      final legacyLockFile = File('${legacyHiveFile.path}.lock');
      await legacyHiveFile.rename(destination.path);

      if (await legacyLockFile.exists()) {
        final destinationLockFile = File('${destination.path}.lock');
        if (!await destinationLockFile.exists()) {
          await legacyLockFile.rename(destinationLockFile.path);
        }
      }
    } catch (error) {
      debugPrint(
        'Could not migrate Hive file ${legacyHiveFile.path}: $error',
      );
    }
  }
}

Future<List<File>> _findLegacyHiveFiles(Directory directory) async {
  final hiveFiles = <File>[];

  await for (final entity in directory.list(followLinks: false)) {
    if (entity is File && entity.path.toLowerCase().endsWith('.hive')) {
      hiveFiles.add(entity);
    }
  }

  return hiveFiles;
}

String _fileName(String path) {
  final separatorIndex = path.lastIndexOf(Platform.pathSeparator);
  return separatorIndex == -1 ? path : path.substring(separatorIndex + 1);
}
