import 'dart:async';
import 'dart:io';
import 'package:characterbook/interfaces/file_handler_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DesktopFileHandler implements FileHandlerInterface {
  static const MethodChannel _channel = MethodChannel('file_handler');
  final _fileOpenedController =
      StreamController<Map<String, dynamic>>.broadcast();

  @override
  Stream<Map<String, dynamic>> get onFileOpened => _fileOpenedController.stream;

  @override
  Future<bool> initialize() async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onFileOpened') {
        _fileOpenedController
            .add((call.arguments as Map).cast<String, dynamic>());
      }
      return null;
    });
    return true;
  }

  @override
  Future<Map<String, dynamic>?> getOpenedFile() async {
    try {
      final result =
          await _channel.invokeMethod<Map<dynamic, dynamic>>('getOpenedFile');
      return result?.cast<String, dynamic>();
    } on PlatformException catch (e) {
      debugPrint("Error getting opened file: ${e.message}");
      return null;
    }
  }

  @override
  Future<String> readFileAsString(String path) async {
    final file = File(path);
    return await file.readAsString();
  }

  @override
  void dispose() {
    _fileOpenedController.close();
  }
}
