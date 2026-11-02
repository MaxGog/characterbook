import 'package:characterbook/features/settings/data/locale_channel_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/features/settings/domain/settings_actions.dart';

class LocaleProvider with ChangeNotifier implements LocaleSettingsActions {
  Locale? _locale;

  LocaleProvider() {
    _loadPreferences();
    _syncFromNative();
  }

  @override
  Locale get locale => _locale ?? S.delegate.supportedLocales.first;

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('selectedLocale');

    if (localeCode != null && localeCode.isNotEmpty) {
      _locale = Locale(localeCode);
      notifyListeners();
    }
  }

  Future<void> _syncFromNative() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

    final tag = await LocaleChannelService.getNativeLocale();
    if (tag == null || tag.isEmpty) return;
    final lang = tag.split('-').first;
    if (_locale?.languageCode == lang) return;
    if (!S.delegate.supportedLocales.any((l) => l.languageCode == lang)) return;
    _locale = Locale(lang);
    notifyListeners();
  }

  @override
  Future<void> setLocale(Locale newLocale) async {
    if (!S.delegate.supportedLocales.contains(newLocale)) return;

    _locale = newLocale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLocale', newLocale.languageCode);

    await LocaleChannelService.setNativeLocale(newLocale.languageCode);
  }
}
