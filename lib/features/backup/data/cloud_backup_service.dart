import 'dart:convert';
import 'dart:typed_data';

import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/features/backup/domain/backup_actions.dart';
import 'package:characterbook/features/backup/domain/backup_manager.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class CloudBackupService implements CloudBackupActions {
  static const _scopes = [drive.DriveApi.driveFileScope];
  static const _backupPrefix = 'characterbook_backup';
  static const _backupMimeType = 'application/characterbook';
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static final Future<void> _googleSignInInitialization =
      _googleSignIn.initialize();

  final BackupManager _backupManager;

  CloudBackupService({required BackupManager backupManager})
      : _backupManager = backupManager;

  @override
  Future<void> exportData() async {
    final data = await _createBackup();
    final driveApi = await _authenticatedDriveApi(allowInteractive: true);
    if (driveApi == null) throw StateError(S.current.auth_cancelled);
    await _uploadBackup(driveApi, data);
  }

  Future<Map<String, dynamic>> _createBackup() async {
    final data = await _backupManager.createBackup();
    if (!_backupManager.containsData(data)) {
      throw const EmptyBackupException();
    }
    return data;
  }

  Future<void> _uploadBackup(
    drive.DriveApi driveApi,
    Map<String, dynamic> data,
  ) async {
    final json = jsonEncode(data);
    final fileName =
        '${_backupPrefix}_${DateTime.now().toIso8601String()}.characterbook';
    final bytes = utf8.encode(json);
    await driveApi.files.create(
      drive.File()
        ..name = fileName
        ..mimeType = _backupMimeType,
      uploadMedia: drive.Media(
        Stream<Uint8List>.value(Uint8List.fromList(bytes)),
        bytes.length,
        contentType: _backupMimeType,
      ),
    );
  }

  @override
  Future<void> importData() async {
    final driveApi = await _authenticatedDriveApi(allowInteractive: true);
    if (driveApi == null) throw StateError(S.current.auth_cancelled);
    final files = await driveApi.files.list(
      q: "name contains '$_backupPrefix'",
      orderBy: 'createdTime desc',
      pageSize: 1,
    );
    final driveFiles = files.files;
    if (driveFiles == null ||
        driveFiles.isEmpty ||
        driveFiles.first.id == null) {
      throw StateError(S.current.cloud_backup_not_found);
    }
    final file = driveFiles.first;

    final fileId = file.id!;
    final media = await driveApi.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;
    final data = jsonDecode(utf8.decode(await _readStream(media.stream)));
    if (data is! Map<String, dynamic>) {
      throw FormatException(S.current.cloud_restore_error);
    }
    await _backupManager.restoreBackup(data);
  }

  @override
  Future<void> autoExportIfSignedIn() async {
    final driveApi = await _authenticatedDriveApi(allowInteractive: false);
    if (driveApi != null) {
      await _uploadBackup(driveApi, await _createBackup());
    }
  }

  Future<drive.DriveApi?> _authenticatedDriveApi({
    required bool allowInteractive,
  }) async {
    await _googleSignInInitialization;
    final account = await _googleSignIn.attemptLightweightAuthentication();
    if (account == null && !allowInteractive) return null;

    final authorizationClient =
        account?.authorizationClient ?? _googleSignIn.authorizationClient;
    final authorization =
        await authorizationClient.authorizationForScopes(_scopes);
    if (authorization != null) {
      return drive.DriveApi(authorization.authClient(scopes: _scopes));
    }
    if (!allowInteractive) return null;

    try {
      final interactiveAuthorization =
          await authorizationClient.authorizeScopes(_scopes);
      return drive.DriveApi(
        interactiveAuthorization.authClient(scopes: _scopes),
      );
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw StateError(S.current.auth_cancelled);
      }
      rethrow;
    }
  }

  Future<Uint8List> _readStream(Stream<List<int>> stream) async {
    final bytesBuilder = BytesBuilder();
    await for (final chunk in stream) {
      bytesBuilder.add(chunk);
    }
    return bytesBuilder.takeBytes();
  }
}
