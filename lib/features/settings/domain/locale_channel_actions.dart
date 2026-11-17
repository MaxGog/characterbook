abstract interface class LocaleChannelActions {
  Future<void> setNativeLocale(String? languageTag);

  Future<String?> getNativeLocale();

  Future<bool> openSystemLanguageSettings();
}
