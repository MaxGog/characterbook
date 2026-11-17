import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:characterbook/features/settings/domain/locale_channel_actions.dart';

class LocaleChannelService implements LocaleChannelActions {
  static const _channel = MethodChannel('app_locale');

  static bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  @override
  Future<void> setNativeLocale(String? languageTag) async {
    if (!_isAndroid) return;
    try {
      await _channel.invokeMethod('setLocale', {'tag': languageTag ?? ''});
    } on PlatformException catch (e) {
      debugPrint('setNativeLocale failed: ${e.message}');
    } on MissingPluginException catch (e) {
      debugPrint('setNativeLocale: channel not available: ${e.message}');
    }
  }

  @override
  Future<String?> getNativeLocale() async {
    if (!_isAndroid) return null;
    try {
      return await _channel.invokeMethod<String>('getLocale');
    } on PlatformException catch (e) {
      debugPrint('getNativeLocale failed: ${e.message}');
      return null;
    } on MissingPluginException catch (e) {
      debugPrint('getNativeLocale: channel not available: ${e.message}');
      return null;
    }
  }

  @override
  Future<bool> openSystemLanguageSettings() async {
    if (!_isAndroid) return false;
    try {
      final result =
          await _channel.invokeMethod<bool>('openSystemLanguageSettings');
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('openSystemLanguageSettings failed: ${e.message}');
      return false;
    } on MissingPluginException catch (e) {
      debugPrint(
          'openSystemLanguageSettings: channel not available: ${e.message}');
      return false;
    }
  }
}
