import 'package:flutter/material.dart';

abstract interface class LocaleSettingsActions implements Listenable {
  Locale get locale;

  Future<void> setLocale(Locale locale);
}

enum ThemePaletteStyle {
  tonalSpot,
  vibrant,
  expressive,
  fidelity,
  monochrome,
  neutral,
  rainbow,
  fruitSalad,
  content,
}

enum ThemeColorSpec {
  spec2021,
  spec2025,
}

abstract interface class ThemeSettingsActions implements Listenable {
  ThemeMode get themeMode;
  Color get seedColor;
  bool get useDynamicColor;
  ThemePaletteStyle get paletteStyle;
  ThemeColorSpec get colorSpec;
  bool get useAmoledBlack;
  bool get supportsDynamicColor;

  void setThemeMode(ThemeMode mode);
  void setSeedColor(Color color);
  void setUseDynamicColor(bool value);
  void setPaletteStyle(ThemePaletteStyle value);
  void setColorSpec(ThemeColorSpec value);
  void setUseAmoledBlack(bool value);

  ColorScheme generateMaterialYouColorSchemeFromSeed({
    required Color seed,
    required Brightness brightness,
    ThemePaletteStyle? style,
  });
}
