// Generated from docs/design-lock.json
// DO NOT EDIT MANUALLY - Use design-lock.json as single source of truth

import 'package:flutter/material.dart';
import 'tokens_color.dart';

/// Color schemes for Yole app
/// Single source of truth: docs/design-lock.json
class YoleColorSchemes {
  const YoleColorSchemes._();

  /// Light theme color scheme
  static const ColorScheme light = ColorScheme.light(
    primary: DesignTokens.lightPrimary,
    onPrimary: Colors.white, // TBD in design-lock, using white as fallback
    secondary: DesignTokens.lightPrimary, // TBD in design-lock, using primary
    onSecondary: Colors.white, // TBD in design-lock, using white as fallback
    background: DesignTokens.lightBackground,
    onBackground: DesignTokens.lightOnSurface, // Using onSurface as fallback
    surface: DesignTokens.lightSurface,
    onSurface: DesignTokens.lightOnSurface,
    surfaceVariant: DesignTokens.lightOnSurfaceVariant.withOpacity(0.1),
    onSurfaceVariant: DesignTokens.lightOnSurfaceVariant,
    outline: DesignTokens.lightOutline,
    error: DesignTokens.lightError,
    onError: Colors.white, // TBD in design-lock, using white as fallback
    brightness: Brightness.light,
  );

  /// Dark theme color scheme
  static const ColorScheme dark = ColorScheme.dark(
    primary: DesignTokens.darkPrimary,
    onPrimary: Colors.white, // TBD in design-lock, using white as fallback
    secondary: DesignTokens.darkPrimary, // TBD in design-lock, using primary
    onSecondary: Colors.white, // TBD in design-lock, using white as fallback
    background: DesignTokens.darkBackground,
    onBackground: DesignTokens.darkOnSurface, // Using onSurface as fallback
    surface: DesignTokens.darkSurface,
    onSurface: DesignTokens.darkOnSurface,
    surfaceVariant: DesignTokens.darkOnSurfaceVariant.withOpacity(0.1),
    onSurfaceVariant: DesignTokens.darkOnSurfaceVariant,
    outline: DesignTokens.darkOutline,
    error: DesignTokens.darkError,
    onError: Colors.white, // TBD in design-lock, using white as fallback
    brightness: Brightness.dark,
  );
}
