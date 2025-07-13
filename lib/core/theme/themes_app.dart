import 'package:flutter/material.dart';
import 'package:my_chat/core/theme/color_theme_app.dart';
import 'package:my_chat/core/theme/text_style_theme_app.dart';

class ThemesApp {
  static ThemeData dark = ThemeData.dark().copyWith(
    useMaterial3: true,
    colorScheme: ColorThemeApp.darkColorScheme,
    scaffoldBackgroundColor: ColorThemeApp.darkColorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorThemeApp.darkColorScheme.primary,
      foregroundColor: ColorThemeApp.darkColorScheme.onPrimary,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: ColorThemeApp.darkColorScheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorThemeApp.darkColorScheme.primary,
        foregroundColor: ColorThemeApp.darkColorScheme.onPrimary,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
    ),

    textTheme: ThemeText.getTextTheme(ColorThemeApp.darkColorScheme),
  );

  static ThemeData light = ThemeData.light().copyWith(
    useMaterial3: true,
    colorScheme: ColorThemeApp.lightColorScheme,
    scaffoldBackgroundColor: ColorThemeApp.lightColorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorThemeApp.lightColorScheme.primary,
      foregroundColor: ColorThemeApp.lightColorScheme.onPrimary,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: ColorThemeApp.lightColorScheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorThemeApp.lightColorScheme.secondary,
        side: BorderSide(
          color: ColorThemeApp.lightColorScheme.primary,
          width: 2,
        ),
        foregroundColor: ColorThemeApp.lightColorScheme.onSecondary,
        elevation: 4,

        padding: EdgeInsets.all(10),
        iconColor: ColorThemeApp.tertiaryColor,
      ),
    ),
    iconTheme: IconThemeData(color: ColorThemeApp.secondaryColor, size: 30),

    textTheme: ThemeText.getTextTheme(ColorThemeApp.lightColorScheme),
  );
}
