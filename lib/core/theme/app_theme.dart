// Generated from docs/design-lock.json
// DO NOT EDIT MANUALLY - Use design-lock.json as single source of truth

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_schemes.dart';
import 'theme_extensions.dart';
import 'tokens_spacing.dart';
import 'tokens_radius.dart';

/// App theme configuration for Yole
/// Single source of truth: docs/design-lock.json
class YoleTheme {
  const YoleTheme._();

  /// Light theme configuration
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: YoleColorSchemes.light,
      textTheme: _buildTextTheme(Brightness.light),
      extensions: [
        YoleThemeExtensions.lightSuccessColors,
        YoleThemeExtensions.lightGradientColors,
        YoleThemeExtensions.lightSpacing,
        YoleThemeExtensions.lightRadius,
      ],
      // Component themes
      elevatedButtonTheme: _buildElevatedButtonTheme(YoleColorSchemes.light),
      filledButtonTheme: _buildFilledButtonTheme(YoleColorSchemes.light),
      outlinedButtonTheme: _buildOutlinedButtonTheme(YoleColorSchemes.light),
      textButtonTheme: _buildTextButtonTheme(YoleColorSchemes.light),
      cardTheme: _buildCardTheme(YoleColorSchemes.light),
      inputDecorationTheme: _buildInputDecorationTheme(YoleColorSchemes.light),
      appBarTheme: _buildAppBarTheme(YoleColorSchemes.light),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(
        YoleColorSchemes.light,
      ),
      // Material 3 specific
      dividerTheme: _buildDividerTheme(YoleColorSchemes.light),
      listTileTheme: _buildListTileTheme(YoleColorSchemes.light),
    );
  }

  /// Dark theme configuration
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      colorScheme: YoleColorSchemes.dark,
      textTheme: _buildTextTheme(Brightness.dark),
      extensions: [
        YoleThemeExtensions.darkSuccessColors,
        YoleThemeExtensions.darkGradientColors,
        YoleThemeExtensions.darkSpacing,
        YoleThemeExtensions.darkRadius,
      ],
      // Component themes
      elevatedButtonTheme: _buildElevatedButtonTheme(YoleColorSchemes.dark),
      filledButtonTheme: _buildFilledButtonTheme(YoleColorSchemes.dark),
      outlinedButtonTheme: _buildOutlinedButtonTheme(YoleColorSchemes.dark),
      textButtonTheme: _buildTextButtonTheme(YoleColorSchemes.dark),
      cardTheme: _buildCardTheme(YoleColorSchemes.dark),
      inputDecorationTheme: _buildInputDecorationTheme(YoleColorSchemes.dark),
      appBarTheme: _buildAppBarTheme(YoleColorSchemes.dark),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(
        YoleColorSchemes.dark,
      ),
      // Material 3 specific
      dividerTheme: _buildDividerTheme(YoleColorSchemes.dark),
      listTileTheme: _buildListTileTheme(YoleColorSchemes.dark),
    );
  }

  /// Build text theme based on PRD specifications
  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseTextTheme = GoogleFonts.interTextTheme();

    return baseTextTheme.copyWith(
      // PRD: headlineMedium ~ 24/700
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      // PRD: titleLarge ~ 20/700
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
      // PRD: bodyLarge ~ 16/500
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      // PRD: bodyMedium ~ 14/500
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      // PRD: labelLarge ~ 16/700
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
    );
  }

  /// Build elevated button theme
  static ElevatedButtonThemeData _buildElevatedButtonTheme(
    ColorScheme colorScheme,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 56), // PRD: 56dp height
        shape: RoundedRectangleBorder(
          borderRadius: RadiusTokens.pillAll, // PRD: 20dp radius (using pill)
        ),
        padding: SpacingTokens.lgHorizontal,
      ),
    );
  }

  /// Build filled button theme (primary CTA with gradient)
  static FilledButtonThemeData _buildFilledButtonTheme(
    ColorScheme colorScheme,
  ) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 56), // PRD: 56dp height
        shape: RoundedRectangleBorder(
          borderRadius: RadiusTokens.pillAll, // PRD: 20dp radius (using pill)
        ),
        padding: SpacingTokens.lgHorizontal,
      ),
    );
  }

  /// Build outlined button theme
  static OutlinedButtonThemeData _buildOutlinedButtonTheme(
    ColorScheme colorScheme,
  ) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 56), // PRD: 56dp height
        shape: RoundedRectangleBorder(
          borderRadius: RadiusTokens.pillAll, // PRD: 20dp radius (using pill)
        ),
        padding: SpacingTokens.lgHorizontal,
        side: BorderSide(color: colorScheme.outline, width: 1),
      ),
    );
  }

  /// Build text button theme
  static TextButtonThemeData _buildTextButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(0, 56), // PRD: 56dp height
        shape: RoundedRectangleBorder(
          borderRadius: RadiusTokens.pillAll, // PRD: 20dp radius (using pill)
        ),
        padding: SpacingTokens.lgHorizontal,
      ),
    );
  }

  /// Build card theme
  static CardTheme _buildCardTheme(ColorScheme colorScheme) {
    return CardTheme(
      color: colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: RadiusTokens.mdAll, // PRD: 16dp radius
        side: BorderSide(color: colorScheme.outline, width: 1),
      ),
      margin: SpacingTokens.mdAll,
    );
  }

  /// Build input decoration theme
  static InputDecorationTheme _buildInputDecorationTheme(
    ColorScheme colorScheme,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: RadiusTokens.mdAll, // PRD: 16dp radius
        borderSide: BorderSide(color: colorScheme.outline, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: RadiusTokens.mdAll,
        borderSide: BorderSide(color: colorScheme.outline, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: RadiusTokens.mdAll,
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: RadiusTokens.mdAll,
        borderSide: BorderSide(color: colorScheme.error, width: 1),
      ),
      contentPadding: SpacingTokens.lgAll,
    );
  }

  /// Build app bar theme
  static AppBarTheme _buildAppBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
    );
  }

  /// Build bottom navigation bar theme
  static BottomNavigationBarThemeData _buildBottomNavigationBarTheme(
    ColorScheme colorScheme,
  ) {
    return BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    );
  }

  /// Build divider theme
  static DividerThemeData _buildDividerTheme(ColorScheme colorScheme) {
    return DividerThemeData(color: colorScheme.outline, thickness: 1, space: 1);
  }

  /// Build list tile theme
  static ListTileThemeData _buildListTileTheme(ColorScheme colorScheme) {
    return ListTileThemeData(
      contentPadding: SpacingTokens.lgHorizontal,
      shape: RoundedRectangleBorder(borderRadius: RadiusTokens.mdAll),
    );
  }
}
