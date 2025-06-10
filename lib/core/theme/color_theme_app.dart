import 'package:flutter/material.dart';

class ColorThemeApp {
  // colors for the app
  static Color primaryColor = const Color(0xFF183B4E);
  static Color secondaryColor = const Color(0xFFDDA853);
  static Color tertiaryColor = const Color(0xFFF5EEDC);
  static Color backgroundColor = const Color(0xFF27548A);

  // colors  collection 1
  static Color c1 = const Color(0xFF7FD6EB);
  static Color c2 = const Color(0xFF7C61E8);
  static Color c3 = const Color(0xFFD905A7);
  static Color c4 = const Color(0xFF4239C6);
  static Color c5 = const Color(0xFFFD1C3F);
  static Color c6 = const Color(0xFF1B1B1B);
  static Color c7 = const Color(0xFFBA1467);
  static Color c8 = const Color(0xFF38071B);
  static Color c9 = const Color(0xFF6C8697);
  static Color c10 = const Color(0xFF624F3F);
  static Color c11 = const Color(0xFF53DCCD);

  // السمة الرئيسية - فاتح
  static ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: secondaryColor,
    brightness: Brightness.light,
    primary: secondaryColor,
    background: tertiaryColor,
  );

  // السمة الرئيسية - داكن
  static ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.dark,
    primary: primaryColor,
    background: const Color(0xFF121212),
  );

  // السمة الخاصة بمجموعة الألوان 1
  static ColorScheme collection1ColorScheme = ColorScheme.fromSeed(
    seedColor: c4,
    brightness: Brightness.dark,
    primary: c4,
    secondary: c1,
    tertiary: c2,
    surface: c3,
    background: c6,
    error: c5,
    onPrimary: c7,
    onSecondary: c8,
    onTertiary: c9,
    onSurface: c10,
    onBackground: c11,
    onError: c5,
    primaryContainer: c4.withOpacity(0.8),
    secondaryContainer: c1.withOpacity(0.8),
    tertiaryContainer: c2.withOpacity(0.8),
    surfaceContainer: c3.withOpacity(0.8),

    errorContainer: c5.withOpacity(0.8),
    onPrimaryContainer: c7.withOpacity(0.8),
    onSecondaryContainer: c8.withOpacity(0.8),
    onTertiaryContainer: c9.withOpacity(0.8),

    onErrorContainer: c5.withOpacity(0.8),
    shadow: c4.withOpacity(0.8),
    scrim: c4.withOpacity(0.8),
    inversePrimary: c4.withOpacity(0.8),
    inverseSurface: c6.withOpacity(0.8),

    outline: c9.withOpacity(0.8),
    outlineVariant: c8.withOpacity(0.8),
    surfaceTint: c4.withOpacity(0.8),
  );
}
