import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color _primaryLight = Color(0xFFFF6D00);  // Orange 500
  static const Color _primaryLightLight = Color(0xFFFF9E40);  // Orange 200
  static const Color _primaryLightDark = Color(0xFFE65100);  // Orange 900
  static const Color _secondaryLight = Color(0xFFFFA000);  // Amber 700
  static const Color _tertiaryLight = Color(0xFFFFD54F); // Amber 300
  static const Color _backgroundLight = Color(0xFFFFFFFF);
  static const Color _surfaceLight = Color(0xFFF8F9FA);
  static const Color _surfaceVariantLight = Color(0xFFF1F1F1);
  static const Color _onPrimaryLight = Color(0xFFFFFFFF);
  static const Color _onSecondaryLight = Color(0xFF000000);
  static const Color _onBackgroundLight = Color(0xFF1A1A1A);
  static const Color _onSurfaceLight = Color(0xFF2C2C2C);
  static const Color _errorLight = Color(0xFFD32F2F);
  static const Color _onErrorLight = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const Color _primaryDark = Color(0xFFFF8A65);  // Deep Orange 300
  static const Color _primaryDarkLight = Color(0xFFFFAB91);  // Deep Orange 200
  static const Color _primaryDarkDark = Color(0xFFE64A19);  // Deep Orange 700
  static const Color _secondaryDark = Color(0xFFFFB74D);  // Orange 300
  static const Color _tertiaryDark = Color(0xFFFFD54F); // Amber 300
  static const Color _backgroundDark = Color(0xFF121212);
  static const Color _surfaceDark = Color(0xFF1E1E1E);
  static const Color _surfaceVariantDark = Color(0xFF2D2D2D);
  static const Color _onPrimaryDark = Color(0xFF000000);
  static const Color _onSecondaryDark = Color(0xFF000000);
  static const Color _onBackgroundDark = Color(0xFFFFFFFF);
  static const Color _onSurfaceDark = Color(0xFFFFFFFF);
  static const Color _errorDark = Color(0xFFCF6679);
  static const Color _onErrorDark = Color(0xFF000000);

  // Text Themes
  static TextTheme _buildTextTheme(TextTheme base, Color textColor) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: textColor,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: textColor,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: textColor,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: textColor,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: textColor,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: textColor,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: textColor,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: textColor,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: textColor.withOpacity(0.8),
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: textColor,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: textColor,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: textColor.withOpacity(0.7),
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: textColor,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: textColor,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: textColor.withOpacity(0.7),
      ),
    );
  }

  // Light Theme
  static ThemeData get lightTheme {
    final baseTheme = ThemeData.light(useMaterial3: true);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryLight,
        primary: _primaryLight,
        primaryContainer: _primaryLightDark,
        secondary: _secondaryLight,
        secondaryContainer: _primaryLightLight,
        tertiary: _tertiaryLight,
        background: _backgroundLight,
        surface: _surfaceLight,
        surfaceVariant: _surfaceVariantLight,
        onPrimary: _onPrimaryLight,
        onSecondary: _onSecondaryLight,
        onBackground: _onBackgroundLight,
        onSurface: _onSurfaceLight,
        error: _errorLight,
        onError: _onErrorLight,
        brightness: Brightness.light,
      ),
      textTheme: _buildTextTheme(baseTheme.textTheme, _onBackgroundLight),
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryLight,
        foregroundColor: _onPrimaryLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _onPrimaryLight,
        ),
        iconTheme: IconThemeData(color: _onPrimaryLight),
        actionsIconTheme: IconThemeData(color: _onPrimaryLight),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        color: _surfaceLight,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceVariantLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _onSurfaceLight.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _errorLight),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _errorLight, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: _onSurfaceLight.withOpacity(0.6)),
        labelStyle: TextStyle(color: _onSurfaceLight),
        errorStyle: TextStyle(color: _errorLight, fontSize: 12),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _onBackgroundLight,
        contentTextStyle: TextStyle(color: _backgroundLight),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _surfaceLight,
        selectedItemColor: _primaryLight,
        unselectedItemColor: _onSurfaceLight.withOpacity(0.6),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 4,
      ),
      dividerTheme: DividerThemeData(
        color: _onSurfaceLight.withOpacity(0.1),
        thickness: 1,
        space: 1,
      ),
      iconTheme: IconThemeData(
        color: _onSurfaceLight,
        size: 24,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryLight,
        foregroundColor: _onPrimaryLight,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    final baseTheme = ThemeData.dark(useMaterial3: true);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryDark,
        primary: _primaryDark,
        primaryContainer: _primaryDarkDark,
        secondary: _secondaryDark,
        secondaryContainer: _primaryDarkLight,
        tertiary: _tertiaryDark,
        background: _backgroundDark,
        surface: _surfaceDark,
        surfaceVariant: _surfaceVariantDark,
        onPrimary: _onPrimaryDark,
        onSecondary: _onSecondaryDark,
        onBackground: _onBackgroundDark,
        onSurface: _onSurfaceDark,
        error: _errorDark,
        onError: _onErrorDark,
        brightness: Brightness.dark,
      ),
      textTheme: _buildTextTheme(baseTheme.textTheme, _onBackgroundDark),
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryDark,
        foregroundColor: _onPrimaryDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _onPrimaryDark,
        ),
        iconTheme: IconThemeData(color: _onPrimaryDark),
        actionsIconTheme: IconThemeData(color: _onPrimaryDark),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        color: _surfaceDark,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceVariantDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _onSurfaceDark.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _errorDark),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _errorDark, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: _onSurfaceDark.withOpacity(0.6)),
        labelStyle: TextStyle(color: _onSurfaceDark),
        errorStyle: TextStyle(color: _errorDark, fontSize: 12),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _onBackgroundDark,
        contentTextStyle: TextStyle(color: _backgroundDark),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _surfaceDark,
        selectedItemColor: _primaryDark,
        unselectedItemColor: _onSurfaceDark.withOpacity(0.6),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 4,
      ),
      dividerTheme: DividerThemeData(
        color: _onSurfaceDark.withOpacity(0.2),
        thickness: 1,
        space: 1,
      ),
      iconTheme: IconThemeData(
        color: _onSurfaceDark,
        size: 24,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryDark,
        foregroundColor: _onPrimaryDark,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
      // Input decoration theme is already defined above
    );
  }
}
