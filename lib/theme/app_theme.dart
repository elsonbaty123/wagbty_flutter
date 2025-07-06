import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color _primaryLight = Color(0xFFFF6D00);  // Orange 500
  static const Color _primaryLightLight = Color(0xFFFF9E40);  // Orange 200
  static const Color _primaryLightDark = Color(0xFFE65100);  // Orange 900
  static const Color _secondaryLight = Color(0xFFFFA000);  // Amber 700
  static const Color _backgroundLight = Color(0xFFFFFFFF);
  static const Color _surfaceLight = Color(0xFFF5F5F5);
  static const Color _onPrimaryLight = Color(0xFFFFFFFF);
  static const Color _onSecondaryLight = Color(0xFF000000);
  static const Color _onBackgroundLight = Color(0xFF212121);
  static const Color _onSurfaceLight = Color(0xFF424242);
  static const Color _errorLight = Color(0xFFD32F2F);

  // Dark Theme Colors
  static const Color _primaryDark = Color(0xFFFF8A65);  // Deep Orange 300
  static const Color _primaryDarkLight = Color(0xFFFFAB91);  // Deep Orange 200
  static const Color _primaryDarkDark = Color(0xFFE64A19);  // Deep Orange 700
  static const Color _secondaryDark = Color(0xFFFFB74D);  // Orange 300
  static const Color _backgroundDark = Color(0xFF121212);
  static const Color _surfaceDark = Color(0xFF1E1E1E);
  static const Color _onPrimaryDark = Color(0xFF000000);
  static const Color _onSecondaryDark = Color(0xFF000000);
  static const Color _onBackgroundDark = Color(0xFFFFFFFF);
  static const Color _onSurfaceDark = Color(0xFFFFFFFF);
  static const Color _errorDark = Color(0xFFCF6679);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: _primaryLight,
        primaryContainer: _primaryLightDark,
        secondary: _secondaryLight,
        secondaryContainer: _primaryLightLight,
        background: _backgroundLight,
        surface: _surfaceLight,
        onPrimary: _onPrimaryLight,
        onSecondary: _onSecondaryLight,
        onBackground: _onBackgroundLight,
        onSurface: _onSurfaceLight,
        error: _errorLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _primaryLight,
        foregroundColor: _onPrimaryLight,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryLight,
          foregroundColor: _onPrimaryLight,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryLight,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryLight,
          side: const BorderSide(color: _primaryLight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: ColorScheme.light().outlineVariant,
            width: 1,
          ),
        ),
        color: ColorScheme.light().surface,
        surfaceTintColor: ColorScheme.light().surfaceTint,
        shadowColor: ColorScheme.light().shadow,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryLight,
        foregroundColor: _onPrimaryLight,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _surfaceLight,
        selectedItemColor: _primaryLight,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: _primaryDark,
        primaryContainer: _primaryDarkDark,
        secondary: _secondaryDark,
        secondaryContainer: _primaryDarkLight,
        background: _backgroundDark,
        surface: _surfaceDark,
        onPrimary: _onPrimaryDark,
        onSecondary: _onSecondaryDark,
        onBackground: _onSurfaceDark,
        onSurface: _onSurfaceDark,
        error: _errorDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _surfaceDark,
        foregroundColor: _onSurfaceDark,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryDark,
          foregroundColor: _onPrimaryDark,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryDark,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryDark,
          side: const BorderSide(color: _primaryDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: ColorScheme.dark().outlineVariant,
            width: 1,
          ),
        ),
        color: _surfaceDark,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryDark,
        foregroundColor: _onPrimaryDark,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _surfaceDark,
        selectedItemColor: _primaryDark,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
