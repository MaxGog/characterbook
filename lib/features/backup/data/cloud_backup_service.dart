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

  final BackupManager _backupManager;
  final GoogleSignIn _googleSignIn;
  drive.DriveApi? _driveApi;

  CloudBackupService({
    required BackupManager backupManager,
    GoogleSignIn? googleSignIn,
  })  : _backupManager = backupManager,
        _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: _scopes);

  @override
  Future<void> exportData() async {
    final data = await _backupManager.createBackup();
    if (!_backupManager.containsData(data)) {
      throw const EmptyBackupException();
    }

    final account = _googleSignIn.currentUser ?? await _googleSignIn.signIn();
    if (account == null) throw StateError(S.current.auth_cancelled);

    final client = await _googleSignIn.authenticatedClient();
    if (client == null) throw StateError(S.current.auth_client_error);

    final json = jsonEncode(data);
    final fileName =
        '${_backupPrefix}_${DateTime.now().toIso8601String()}.characterbook';
    final bytes = utf8.encode(json);
    await drive.DriveApi(client).files.create(
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
    final account = await _googleSignIn.signIn();
    if (account == null) throw StateError(S.current.auth_cancelled);

    final client = await _googleSignIn.authenticatedClient();
    if (client == null) throw StateError(S.current.auth_client_error);

    _driveApi = drive.DriveApi(client);
    final files = await _driveApi!.files.list(
      q: "name contains '$_backupPrefix'",
      orderBy: 'createdTime desc',
      pageSize: 1,
    );
    final driveFiles = files.files;
    if (driveFiles == null || driveFiles.isEmpty || driveFiles.first.id == null) {
      throw StateError(S.current.cloud_backup_not_found);
    }
    final file = driveFiles.first;

    final fileId = file.id!;
    final media = await _driveApi!.files.get(
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
    final account =
        _googleSignIn.currentUser ?? await _googleSignIn.signInSilently();
    if (account != null) await exportData();
  }

  Future<Uint8List> _readStream(Stream<List<int>> stream) async {
    final bytesBuilder = BytesBuilder();
    await for (final chunk in stream) {
      bytesBuilder.add(chunk);
    }
    return bytesBuilder.takeBytes();
  }
}
