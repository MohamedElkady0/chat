import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  static const String _themeKey = 'themeMode';

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    loadTheme();
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _saveTheme();
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();

    int themeIndex = 2;
    if (_themeMode == ThemeMode.light) {
      themeIndex = 0;
    } else if (_themeMode == ThemeMode.dark) {
      themeIndex = 1;
    }
    await prefs.setInt(_themeKey, themeIndex);
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 2;

    switch (themeIndex) {
      case 0:
        _themeMode = ThemeMode.light;
        break;
      case 1:
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
        break;
    }
    notifyListeners();
  }

  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return Theme.of(context).brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}
