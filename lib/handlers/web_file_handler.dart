import 'dart:async';
import 'package:characterbook/interfaces/file_handler_interface.dart';
import 'package:flutter/foundation.dart';
class WebFileHandler implements FileHandlerInterface {
  final _fileOpenedController =
      StreamController<Map<String, dynamic>>.broadcast();

  @override
  Stream<Map<String, dynamic>> get onFileOpened => _fileOpenedController.stream;

  @override
  Future<bool> initialize() async {
    debugPrint('WebFileHandler initialized (no-op for web)');
    return true;
  }

  @override
  Future<Map<String, dynamic>?> getOpenedFile() async {
    return null;
  }
  
  @override
  Future<String> readFileAsString(String path) {
    throw UnimplementedError();
  }
  
  @override
  void dispose() {
    _fileOpenedController.close();
  }
}
