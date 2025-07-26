import 'package:flutter/material.dart';

enum AppThemeMode { automatic, light, dark }

class AppTheme {
  static ThemeData getLightTheme() {
    return ThemeData(
      primaryColor: const Color(0xFF1976D2),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xFF1976D2),
        secondary: const Color(0xFF2196F3),
        background: const Color(0xFFF4F8FB),
        error: const Color(0xFFE53935),
      ),
      scaffoldBackgroundColor: const Color(0xFFF4F8FB),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      primaryColor: const Color(0xFF1976D2),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xFF1976D2),
        secondary: const Color(0xFF2196F3),
        background: const Color(0xFF2C2C2C),
        error: const Color(0xFFE53935),
      ),
      scaffoldBackgroundColor: const Color(0xFF2C2C2C),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static String getThemeModeName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.automatic:
        return 'Automático';
      case AppThemeMode.light:
        return 'Claro';
      case AppThemeMode.dark:
        return 'Oscuro';
    }
  }
}
