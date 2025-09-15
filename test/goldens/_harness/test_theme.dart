import 'package:flutter/material.dart';
import 'package:yole_final/design/tokens.dart';

/// Test-specific theme that doesn't use Google Fonts
/// to avoid network requests during golden tests
class TestTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: DesignTokens.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: DesignTokens.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.primary,
          foregroundColor: DesignTokens.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: DesignTokens.onBackground,
          fontFamily: 'Inter',
          fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: DesignTokens.onBackground,
          fontFamily: 'Inter',
          fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: DesignTokens.onBackground,
          fontFamily: 'Inter',
          fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: DesignTokens.onBackground,
          fontFamily: 'Inter',
          fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: DesignTokens.onPrimary,
          fontFamily: 'Inter',
          fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
        ),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: DesignTokens.primary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: DesignTokens.darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.primary,
          foregroundColor: DesignTokens.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: DesignTokens.darkOnBackground,
          fontFamily: 'Inter',
          fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: DesignTokens.darkOnBackground,
          fontFamily: 'Inter',
          fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: DesignTokens.darkOnBackground,
          fontFamily: 'Inter',
          fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: DesignTokens.darkOnBackground,
          fontFamily: 'Inter',
          fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: DesignTokens.onPrimary,
          fontFamily: 'Inter',
          fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
        ),
      ),
    );
  }
}
