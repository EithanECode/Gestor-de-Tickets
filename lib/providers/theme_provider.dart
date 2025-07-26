import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  AppThemeMode _currentThemeMode = AppThemeMode.automatic;
  bool _isDarkMode = false;

  AppThemeMode get currentThemeMode => _currentThemeMode;
  bool get isDarkMode => _isDarkMode;

  void setThemeMode(AppThemeMode mode) {
    _currentThemeMode = mode;
    _updateTheme();
    notifyListeners();
  }

  void _updateTheme() {
    switch (_currentThemeMode) {
      case AppThemeMode.automatic:
        // En modo automático, usar la configuración del sistema
        _isDarkMode =
            WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
        break;
      case AppThemeMode.light:
        _isDarkMode = false;
        break;
      case AppThemeMode.dark:
        _isDarkMode = true;
        break;
    }
  }

  ThemeData get currentTheme {
    return _isDarkMode ? AppTheme.getDarkTheme() : AppTheme.getLightTheme();
  }

  String get currentThemeName {
    return AppTheme.getThemeModeName(_currentThemeMode);
  }
}
