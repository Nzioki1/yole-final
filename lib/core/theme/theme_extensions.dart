// Generated from docs/design-lock.json
// DO NOT EDIT MANUALLY - Use design-lock.json as single source of truth

import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'tokens_color.dart';
import 'tokens_spacing.dart';
import 'tokens_radius.dart';

/// Custom theme extensions for Yole app
/// Single source of truth: docs/design-lock.json
class YoleThemeExtensions {
  const YoleThemeExtensions._();

  /// Success colors extension
  static const SuccessColors lightSuccessColors = SuccessColors(
    success: DesignTokens.lightSuccess,
    onSuccess: Colors.white,
  );

  static const SuccessColors darkSuccessColors = SuccessColors(
    success: DesignTokens.darkSuccess,
    onSuccess: Colors.white,
  );

  /// Gradient colors extension
  static const GradientColors lightGradientColors = GradientColors(
    primaryGradientStart: DesignTokens.lightPrimaryGradientStart,
    primaryGradientEnd: DesignTokens.lightPrimaryGradientEnd,
  );

  static const GradientColors darkGradientColors = GradientColors(
    primaryGradientStart: DesignTokens.darkPrimaryGradientStart,
    primaryGradientEnd: DesignTokens.darkPrimaryGradientEnd,
  );

  /// Spacing extension
  static const SpacingExtension lightSpacing = SpacingExtension(
    xs: SpacingTokens.xs,
    sm: SpacingTokens.sm,
    md: SpacingTokens.md,
    lg: SpacingTokens.lg,
    xl: SpacingTokens.xl,
    xxl: SpacingTokens.xxl,
  );

  static const SpacingExtension darkSpacing = SpacingExtension(
    xs: SpacingTokens.xs,
    sm: SpacingTokens.sm,
    md: SpacingTokens.md,
    lg: SpacingTokens.lg,
    xl: SpacingTokens.xl,
    xxl: SpacingTokens.xxl,
  );

  /// Radius extension
  static const RadiusExtension lightRadius = RadiusExtension(
    xs: RadiusTokens.xs,
    sm: RadiusTokens.sm,
    md: RadiusTokens.md,
    lg: RadiusTokens.lg,
    pill: RadiusTokens.pill,
  );

  static const RadiusExtension darkRadius = RadiusExtension(
    xs: RadiusTokens.xs,
    sm: RadiusTokens.sm,
    md: RadiusTokens.md,
    lg: RadiusTokens.lg,
    pill: RadiusTokens.pill,
  );
}

/// Success colors theme extension
class SuccessColors extends ThemeExtension<SuccessColors> {
  const SuccessColors({required this.success, required this.onSuccess});

  final Color success;
  final Color onSuccess;

  @override
  SuccessColors copyWith({Color? success, Color? onSuccess}) {
    return SuccessColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
    );
  }

  @override
  SuccessColors lerp(ThemeExtension<SuccessColors>? other, double t) {
    if (other is! SuccessColors) return this;
    return SuccessColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
    );
  }
}

/// Gradient colors theme extension
class GradientColors extends ThemeExtension<GradientColors> {
  const GradientColors({
    required this.primaryGradientStart,
    required this.primaryGradientEnd,
  });

  final Color primaryGradientStart;
  final Color primaryGradientEnd;

  /// Get the primary gradient
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryGradientStart, primaryGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  GradientColors copyWith({
    Color? primaryGradientStart,
    Color? primaryGradientEnd,
  }) {
    return GradientColors(
      primaryGradientStart: primaryGradientStart ?? this.primaryGradientStart,
      primaryGradientEnd: primaryGradientEnd ?? this.primaryGradientEnd,
    );
  }

  @override
  GradientColors lerp(ThemeExtension<GradientColors>? other, double t) {
    if (other is! GradientColors) return this;
    return GradientColors(
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

/// Spacing theme extension
class SpacingExtension extends ThemeExtension<SpacingExtension> {
  const SpacingExtension({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  @override
  SpacingExtension copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return SpacingExtension(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  SpacingExtension lerp(ThemeExtension<SpacingExtension>? other, double t) {
    if (other is! SpacingExtension) return this;
    return SpacingExtension(
      xs: lerpDouble(xs, other.xs, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
    );
  }
}

/// Radius theme extension
class RadiusExtension extends ThemeExtension<RadiusExtension> {
  const RadiusExtension({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.pill,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double pill;

  @override
  RadiusExtension copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? pill,
  }) {
    return RadiusExtension(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      pill: pill ?? this.pill,
    );
  }

  @override
  RadiusExtension lerp(ThemeExtension<RadiusExtension>? other, double t) {
    if (other is! RadiusExtension) return this;
    return RadiusExtension(
      xs: lerpDouble(xs, other.xs, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      pill: lerpDouble(pill, other.pill, t)!,
    );
  }
}
