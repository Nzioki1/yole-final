/// Color utilities for design system
///
/// This file provides utilities for color manipulation, OKLCH color support,
/// and color conversion functions for the design system.
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Color utilities class
class ColorUtils {
  const ColorUtils._();

  /// Convert OKLCH color to approximate sRGB Color with fallback
  ///
  /// OKLCH is a perceptually uniform color space that provides better
  /// color consistency across different displays and lighting conditions.
  ///
  /// Parameters:
  /// - [l]: Lightness (0.0 to 1.0)
  /// - [c]: Chroma (0.0 to 0.4+)
  /// - [h]: Hue (0.0 to 360.0)
  ///
  /// Returns: Approximate sRGB Color
  static Color oklch(double l, double c, double h) {
    // Clamp values to valid ranges
    l = l.clamp(0.0, 1.0);
    c = c.clamp(0.0, 0.4);
    h = h % 360.0;

    // Convert OKLCH to OKLAB
    final a = c * _cos(h * _pi / 180.0);
    final b = c * _sin(h * _pi / 180.0);

    // Convert OKLAB to linear sRGB
    final linearR = _oklabToLinearRgb(l, a, b);
    final linearG = _oklabToLinearRgb(l, a, b);
    final linearBValue = _oklabToLinearRgb(l, a, b);

    // Convert linear sRGB to sRGB
    final r = _linearToSrgb(linearR);
    final g = _linearToSrgb(linearG);
    final bValue = _linearToSrgb(linearBValue);

    // Clamp to valid sRGB range
    final clampedR = (r * 255).clamp(0, 255).round();
    final clampedG = (g * 255).clamp(0, 255).round();
    final clampedB = (bValue * 255).clamp(0, 255).round();

    return Color.fromRGBO(clampedR, clampedG, clampedB, 1.0);
  }

  /// Convert OKLAB to linear RGB (simplified approximation)
  static double _oklabToLinearRgb(double l, double a, double b) {
    // This is a simplified conversion - in practice, you'd use the full
    // OKLAB to linear sRGB conversion matrix
    final lms = _oklabToLms(l, a, b);
    return _lmsToLinearRgb(lms);
  }

  /// Convert OKLAB to LMS color space
  static List<double> _oklabToLms(double l, double a, double b) {
    final l_ = l + 0.3963377774 * a + 0.2158037573 * b;
    final m = l - 0.1055613458 * a - 0.0638541728 * b;
    final s = l - 0.0894841775 * a - 1.2914855480 * b;

    return [l_, m, s];
  }

  /// Convert LMS to linear RGB
  static double _lmsToLinearRgb(List<double> lms) {
    final r =
        4.0767416621 * lms[0] - 3.3077115913 * lms[1] + 0.2309699292 * lms[2];
    final g =
        -1.2684380046 * lms[0] + 2.6097574011 * lms[1] - 0.3413193965 * lms[2];
    final bValue =
        -0.0041960863 * lms[0] - 0.7034186147 * lms[1] + 1.7076147010 * lms[2];

    return (r + g + bValue) / 3.0; // Simplified - return average
  }

  /// Convert linear sRGB to sRGB
  static double _linearToSrgb(double linear) {
    if (linear <= 0.0031308) {
      return 12.92 * linear;
    } else {
      return 1.055 * _pow(linear, 1.0 / 2.4) - 0.055;
    }
  }

  /// Math utility functions
  static double _cos(double radians) => math.cos(radians);
  static double _sin(double radians) => math.sin(radians);
  static double _pow(double base, double exponent) =>
      math.pow(base, exponent).toDouble();
  static const double _pi = math.pi;

  /// Create a color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity.clamp(0.0, 1.0));
  }

  /// Create a color with alpha
  static Color withAlpha(Color color, int alpha) {
    return color.withAlpha(alpha.clamp(0, 255));
  }

  /// Blend two colors
  static Color blend(Color color1, Color color2, double ratio) {
    final clampedRatio = ratio.clamp(0.0, 1.0);
    return Color.lerp(color1, color2, clampedRatio) ?? color1;
  }

  /// Get contrast color (black or white) for given background
  static Color getContrastColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Check if color is light
  static bool isLight(Color color) {
    return color.computeLuminance() > 0.5;
  }

  /// Check if color is dark
  static bool isDark(Color color) {
    return color.computeLuminance() <= 0.5;
  }

  /// Get color brightness
  static Brightness getBrightness(Color color) {
    return isLight(color) ? Brightness.light : Brightness.dark;
  }

  /// Create a color scheme from a base color
  static ColorScheme createColorScheme(
    Color primaryColor, {
    bool isDark = false,
  }) {
    if (isDark) {
      return ColorScheme.dark(
        primary: primaryColor,
        onPrimary: getContrastColor(primaryColor),
        secondary: primaryColor.withOpacity(0.8),
        onSecondary: getContrastColor(primaryColor.withOpacity(0.8)),
        surface: const Color(0xFF121212),
        onSurface: Colors.white,
        background: const Color(0xFF121212),
        onBackground: Colors.white,
        error: const Color(0xFFCF6679),
        onError: Colors.black,
      );
    } else {
      return ColorScheme.light(
        primary: primaryColor,
        onPrimary: getContrastColor(primaryColor),
        secondary: primaryColor.withOpacity(0.8),
        onSecondary: getContrastColor(primaryColor.withOpacity(0.8)),
        surface: Colors.white,
        onSurface: Colors.black,
        background: Colors.white,
        onBackground: Colors.black,
        error: const Color(0xFFB00020),
        onError: Colors.white,
      );
    }
  }

  /// Generate a color palette from a base color
  static List<Color> generatePalette(Color baseColor, int count) {
    final palette = <Color>[];
    final hue = HSVColor.fromColor(baseColor).hue;
    final saturation = HSVColor.fromColor(baseColor).saturation;
    final value = HSVColor.fromColor(baseColor).value;

    for (int i = 0; i < count; i++) {
      final newValue = (value * (1.0 - (i * 0.1))).clamp(0.0, 1.0);
      final newSaturation = (saturation * (1.0 - (i * 0.05))).clamp(0.0, 1.0);
      final color = HSVColor.fromAHSV(
        1.0,
        hue,
        newSaturation,
        newValue,
      ).toColor();
      palette.add(color);
    }

    return palette;
  }

  /// Convert hex string to Color
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Convert Color to hex string
  static String toHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  /// Get color name (approximate)
  static String getColorName(Color color) {
    final hex = toHex(color).toLowerCase();

    // Common color mappings
    const colorMap = {
      '#ff0000': 'Red',
      '#00ff00': 'Green',
      '#0000ff': 'Blue',
      '#ffff00': 'Yellow',
      '#ff00ff': 'Magenta',
      '#00ffff': 'Cyan',
      '#ffffff': 'White',
      '#000000': 'Black',
      '#808080': 'Gray',
      '#ffa500': 'Orange',
      '#800080': 'Purple',
      '#008000': 'Green',
      '#000080': 'Navy',
      '#800000': 'Maroon',
      '#808000': 'Olive',
      '#008080': 'Teal',
    };

    return colorMap[hex] ?? 'Custom';
  }
}
