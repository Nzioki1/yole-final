/// Typography system for Yole app
///
/// This file defines the typography system including font families,
/// text styles, and typography tokens used throughout the app.
library;

import 'package:flutter/material.dart';
import 'tokens.dart';

/// Typography system class
class AppTypography {
  const AppTypography._();

  /// Font family
  static const String fontFamily = 'Inter';

  /// Font weights
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;

  /// Font sizes
  static const double sizeXs = 12.0;
  static const double sizeSm = 13.0;
  static const double sizeBase = 16.0;
  static const double sizeLg = 18.0;
  static const double sizeXl = 20.0;
  static const double size2xl = 22.0;
  static const double size3xl = 28.0;
  static const double size4xl = 32.0;
  static const double size5xl = 36.0;

  /// Line heights
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.4;
  static const double lineHeightRelaxed = 1.6;
  static const double lineHeightLoose = 1.8;

  /// Letter spacing
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.5;

  /// Helper to create TextStyle with font family and fallbacks
  static TextStyle _createTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
    FontStyle? fontStyle,
    String? fontFamilyOverride,
  }) {
    return TextStyle(
      fontFamily: fontFamilyOverride ?? fontFamily,
      fontFamilyFallback: const ['Roboto', 'Arial', 'sans-serif'],
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      fontStyle: fontStyle,
    );
  }

  /// Base text theme using Inter font with fallbacks
  static TextTheme get baseTextTheme {
    return TextTheme(
      displayLarge: _createTextStyle(),
      displayMedium: _createTextStyle(),
      displaySmall: _createTextStyle(),
      headlineLarge: _createTextStyle(),
      headlineMedium: _createTextStyle(),
      headlineSmall: _createTextStyle(),
      titleLarge: _createTextStyle(),
      titleMedium: _createTextStyle(),
      titleSmall: _createTextStyle(),
      bodyLarge: _createTextStyle(),
      bodyMedium: _createTextStyle(),
      bodySmall: _createTextStyle(),
      labelLarge: _createTextStyle(),
      labelMedium: _createTextStyle(),
      labelSmall: _createTextStyle(),
    );
  }

  /// Headline text styles
  static TextStyle get h1 => _createTextStyle(
    fontSize: size3xl, // 28px
    fontWeight: weightBold, // 700
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
  );

  static TextStyle get h2 => _createTextStyle(
    fontSize: size2xl, // 22px
    fontWeight: weightBold, // 700
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
  );

  static TextStyle get h3 => _createTextStyle(
    fontSize: sizeXl, // 20px
    fontWeight: weightSemiBold, // 600
    height: lineHeightTight,
    letterSpacing: letterSpacingNormal,
  );

  static TextStyle get h4 => _createTextStyle(
    fontSize: sizeLg, // 18px
    fontWeight: weightSemiBold, // 600
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  static TextStyle get h5 => _createTextStyle(
    fontSize: sizeBase, // 16px
    fontWeight: weightMedium, // 500
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  static TextStyle get h6 => _createTextStyle(
    fontSize: sizeSm, // 13px
    fontWeight: weightMedium, // 500
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  /// Body text styles
  static TextStyle get bodyLarge => _createTextStyle(
    fontSize: sizeLg, // 18px
    fontWeight: weightRegular, // 400
    height: lineHeightRelaxed,
    letterSpacing: letterSpacingNormal,
  );

  static TextStyle get bodyMedium => _createTextStyle(
    fontSize: sizeBase, // 16px
    fontWeight: weightRegular, // 400
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  static TextStyle get bodySmall => _createTextStyle(
    fontSize: sizeSm, // 13px
    fontWeight: weightRegular, // 400
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  /// Label text styles
  static TextStyle get labelLarge => _createTextStyle(
    fontSize: sizeBase, // 16px
    fontWeight: weightMedium, // 500
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  static TextStyle get labelMedium => _createTextStyle(
    fontSize: sizeSm, // 13px
    fontWeight: weightMedium, // 500
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  static TextStyle get labelSmall => _createTextStyle(
    fontSize: sizeXs, // 12px
    fontWeight: weightMedium, // 500
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  /// Caption text styles
  static TextStyle get caption => _createTextStyle(
    fontSize: sizeSm, // 13px
    fontWeight: weightRegular, // 400
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  static TextStyle get overline => _createTextStyle(
    fontSize: sizeXs, // 12px
    fontWeight: weightMedium, // 500
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
  );

  /// Button text styles
  static TextStyle get buttonLarge => _createTextStyle(
    fontSize: sizeBase, // 16px
    fontWeight: weightSemiBold, // 600
    height: lineHeightTight,
    letterSpacing: letterSpacingNormal,
  );

  static TextStyle get buttonMedium => _createTextStyle(
    fontSize: sizeSm, // 13px
    fontWeight: weightSemiBold, // 600
    height: lineHeightTight,
    letterSpacing: letterSpacingNormal,
  );

  static TextStyle get buttonSmall => _createTextStyle(
    fontSize: sizeXs, // 12px
    fontWeight: weightSemiBold, // 600
    height: lineHeightTight,
    letterSpacing: letterSpacingNormal,
  );

  /// Specialized text styles
  static TextStyle get displayLarge => _createTextStyle(
    fontSize: size5xl, // 36px
    fontWeight: weightBold, // 700
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
  );

  static TextStyle get displayMedium => _createTextStyle(
    fontSize: size4xl, // 32px
    fontWeight: weightBold, // 700
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
  );

  static TextStyle get displaySmall => _createTextStyle(
    fontSize: size3xl, // 28px
    fontWeight: weightBold, // 700
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
  );

  /// Code text styles
  static TextStyle get code => _createTextStyle(
    fontSize: sizeSm, // 13px
    fontWeight: weightRegular, // 400
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    fontFamilyOverride: 'monospace',
  );

  /// Quote text styles
  static TextStyle get quote => _createTextStyle(
    fontSize: sizeLg, // 18px
    fontWeight: weightRegular, // 400
    height: lineHeightRelaxed,
    letterSpacing: letterSpacingNormal,
    fontStyle: FontStyle.italic,
  );

  /// Create text theme for light mode
  static TextTheme createLightTextTheme() {
    return baseTextTheme.copyWith(
      displayLarge: displayLarge.copyWith(color: DesignTokens.onBackground),
      displayMedium: displayMedium.copyWith(color: DesignTokens.onBackground),
      displaySmall: displaySmall.copyWith(color: DesignTokens.onBackground),
      headlineLarge: h1.copyWith(color: DesignTokens.onBackground),
      headlineMedium: h2.copyWith(color: DesignTokens.onBackground),
      headlineSmall: h3.copyWith(color: DesignTokens.onBackground),
      titleLarge: h4.copyWith(color: DesignTokens.onBackground),
      titleMedium: h5.copyWith(color: DesignTokens.onBackground),
      titleSmall: h6.copyWith(color: DesignTokens.onBackground),
      bodyLarge: bodyLarge.copyWith(color: DesignTokens.onBackground),
      bodyMedium: bodyMedium.copyWith(color: DesignTokens.onBackground),
      bodySmall: bodySmall.copyWith(color: DesignTokens.onBackground),
      labelLarge: labelLarge.copyWith(color: DesignTokens.onBackground),
      labelMedium: labelMedium.copyWith(color: DesignTokens.onBackground),
      labelSmall: labelSmall.copyWith(color: DesignTokens.onBackground),
    );
  }

  /// Create text theme for dark mode
  static TextTheme createDarkTextTheme() {
    return baseTextTheme.copyWith(
      displayLarge: displayLarge.copyWith(color: DesignTokens.darkOnBackground),
      displayMedium: displayMedium.copyWith(
        color: DesignTokens.darkOnBackground,
      ),
      displaySmall: displaySmall.copyWith(color: DesignTokens.darkOnBackground),
      headlineLarge: h1.copyWith(color: DesignTokens.darkOnBackground),
      headlineMedium: h2.copyWith(color: DesignTokens.darkOnBackground),
      headlineSmall: h3.copyWith(color: DesignTokens.darkOnBackground),
      titleLarge: h4.copyWith(color: DesignTokens.darkOnBackground),
      titleMedium: h5.copyWith(color: DesignTokens.darkOnBackground),
      titleSmall: h6.copyWith(color: DesignTokens.darkOnBackground),
      bodyLarge: bodyLarge.copyWith(color: DesignTokens.darkOnBackground),
      bodyMedium: bodyMedium.copyWith(color: DesignTokens.darkOnBackground),
      bodySmall: bodySmall.copyWith(color: DesignTokens.darkOnBackground),
      labelLarge: labelLarge.copyWith(color: DesignTokens.darkOnBackground),
      labelMedium: labelMedium.copyWith(color: DesignTokens.darkOnBackground),
      labelSmall: labelSmall.copyWith(color: DesignTokens.darkOnBackground),
    );
  }

  /// Get text style by name
  static TextStyle? getTextStyle(String name) {
    switch (name.toLowerCase()) {
      case 'h1':
      case 'headline1':
        return h1;
      case 'h2':
      case 'headline2':
        return h2;
      case 'h3':
      case 'headline3':
        return h3;
      case 'h4':
      case 'headline4':
        return h4;
      case 'h5':
      case 'headline5':
        return h5;
      case 'h6':
      case 'headline6':
        return h6;
      case 'body1':
      case 'bodylarge':
        return bodyLarge;
      case 'body2':
      case 'bodymedium':
        return bodyMedium;
      case 'body3':
      case 'bodysmall':
        return bodySmall;
      case 'caption':
        return caption;
      case 'button':
      case 'buttonlarge':
        return buttonLarge;
      case 'buttonmedium':
        return buttonMedium;
      case 'buttonsmall':
        return buttonSmall;
      case 'overline':
        return overline;
      case 'code':
        return code;
      case 'quote':
        return quote;
      default:
        return null;
    }
  }

  /// Create responsive text style
  static TextStyle responsive({
    required double baseSize,
    required double scaleFactor,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: baseSize * scaleFactor,
      fontWeight: fontWeight ?? weightRegular,
      height: height ?? lineHeightNormal,
      letterSpacing: letterSpacing ?? letterSpacingNormal,
    );
  }
}
