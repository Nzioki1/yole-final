// GENERATED FROM design-lock.json — DO NOT EDIT
// lock sha256: d6f50cb024cb2de49a7e41404e504a04d2b8b51189a8bc2e4b7d8bf33c8b49d9

import 'package:flutter/material.dart';

/// Design tokens extracted from design-lock.json
/// Single source of truth: docs/design-lock.json
class DesignTokens {
  const DesignTokens._();

  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF3B82F6);
  static const Color lightBackground = Color(0xFFffffff);
  static const Color lightSurface = Color(0xFFffffff);
  static const Color lightError = Color(0xFFEF4444);
  static const Color lightOnSurface = Color(0xFF1a1a1a);
  static const Color lightOnSurfaceVariant = Color(0xFF64748b);
  static const Color lightOutline = Color.fromARGB(77, 148, 163, 184);
  static const Color lightSuccess = Color(0xFF10B981);
  static const Color lightPrimaryGradientStart = Color(0xFF3B82F6);
  static const Color lightPrimaryGradientEnd = Color(0xFF8B5CF6);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF3B82F6);
  static const Color darkBackground = Color(0xFF19173d);
  static const Color darkSurface = Color(0xFF19173d);
  static const Color darkError = Color(0xFFEF4444);
  static const Color darkOnSurface = Color.fromARGB(222, 255, 255, 255);
  static const Color darkOnSurfaceVariant = Color(0xFF9ca3af);
  static const Color darkOutline = Color.fromARGB(128, 255, 255, 255);
  static const Color darkSuccess = Color(0xFF10B981);
  static const Color darkPrimaryGradientStart = Color(0xFF3B82F6);
  static const Color darkPrimaryGradientEnd = Color(0xFF8B5CF6);

  /// Light theme color scheme
  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: Color(0xFF3B82F6),
    background: Color(0xFFffffff),
    surface: Color(0xFFffffff),
    onSurface: Color(0xFF1a1a1a),
    onSurfaceVariant: Color(0xFF64748b),
    outline: Color.fromARGB(77, 148, 163, 184),
    error: Color(0xFFEF4444),
  );

  /// Dark theme color scheme
  static const ColorScheme darkColorScheme = ColorScheme.dark(
    primary: Color(0xFF3B82F6),
    background: Color(0xFF19173d),
    surface: Color(0xFF19173d),
    onSurface: Color.fromARGB(222, 255, 255, 255),
    onSurfaceVariant: Color(0xFF9ca3af),
    outline: Color.fromARGB(128, 255, 255, 255),
    error: Color(0xFFEF4444),
  );

  /// Custom theme extensions
  static const List<ThemeExtension<dynamic>> extensions = [
    _SuccessColors(success: DesignTokens.lightSuccess, onSuccess: Colors.white),
    _GradientColors(
      primaryGradientStart: DesignTokens.lightPrimaryGradientStart,
      primaryGradientEnd: DesignTokens.lightPrimaryGradientEnd,
    ),
  ];
}

class _SuccessColors extends ThemeExtension<_SuccessColors> {
  const _SuccessColors({required this.success, required this.onSuccess});

  final Color success;
  final Color onSuccess;

  @override
  _SuccessColors copyWith({Color? success, Color? onSuccess}) {
    return _SuccessColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
    );
  }

  @override
  _SuccessColors lerp(ThemeExtension<_SuccessColors>? other, double t) {
    if (other is! _SuccessColors) return this;
    return _SuccessColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
    );
  }
}

class _GradientColors extends ThemeExtension<_GradientColors> {
  const _GradientColors({
    required this.primaryGradientStart,
    required this.primaryGradientEnd,
  });

  final Color primaryGradientStart;
  final Color primaryGradientEnd;

  @override
  _GradientColors copyWith({
    Color? primaryGradientStart,
    Color? primaryGradientEnd,
  }) {
    return _GradientColors(
      primaryGradientStart: primaryGradientStart ?? this.primaryGradientStart,
      primaryGradientEnd: primaryGradientEnd ?? this.primaryGradientEnd,
    );
  }

  @override
  _GradientColors lerp(ThemeExtension<_GradientColors>? other, double t) {
    if (other is! _GradientColors) return this;
    return _GradientColors(
      primaryGradientStart: Color.lerp(
        primaryGradientStart,
        other.primaryGradientStart,
        t,
      )!,
      primaryGradientEnd: Color.lerp(
        primaryGradientEnd,
        other.primaryGradientEnd,
        t,
      )!,
    );
  }
}
