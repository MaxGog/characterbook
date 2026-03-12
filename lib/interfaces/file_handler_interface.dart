import 'dart:async';

abstract class FileHandlerInterface {
  Stream<Map<String, dynamic>> get onFileOpened;
  Future<Map<String, dynamic>?> getOpenedFile();
  Future<bool> initialize();
  Future<String> readFileAsString(String path);
  void dispose();
}
