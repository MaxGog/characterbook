import 'package:flutter/services.dart';

typedef MenuCallback = void Function();

class MenuChannel {
  static const MethodChannel _channel = MethodChannel('characterbook/menu');

  static MenuCallback? onOpenSettings;
  static MenuCallback? onNewCharacter;
  static MenuCallback? onOpenFile;

  static void initialize({
    required MenuCallback onOpenSettings,
    required MenuCallback onNewCharacter,
    required MenuCallback onOpenFile,
  }) {
    MenuChannel.onOpenSettings = onOpenSettings;
    MenuChannel.onNewCharacter = onNewCharacter;
    MenuChannel.onOpenFile = onOpenFile;

    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'openSettings':
        onOpenSettings?.call();
        break;
      case 'newCharacter':
        onNewCharacter?.call();
        break;
      case 'openFile':
        onOpenFile?.call();
        break;
      default:
        throw PlatformException(
          code: 'UNIMPLEMENTED',
          message: 'Method ${call.method} is not implemented',
        );
    }
  }
}
