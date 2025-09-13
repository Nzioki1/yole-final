// Generated from docs/design-lock.json
// DO NOT EDIT MANUALLY - Use design-lock.json as single source of truth

import 'package:flutter/material.dart';

/// Spacing tokens from design-lock.json
/// Single source of truth: docs/design-lock.json
class SpacingTokens {
  const SpacingTokens._();

  // Spacing values from PRD specification: 4, 8, 12, 16, 24, 32 (xs…2xl)
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;

  /// All spacing values as EdgeInsets
  static const EdgeInsets xsAll = EdgeInsets.all(xs);
  static const EdgeInsets smAll = EdgeInsets.all(sm);
  static const EdgeInsets mdAll = EdgeInsets.all(md);
  static const EdgeInsets lgAll = EdgeInsets.all(lg);
  static const EdgeInsets xlAll = EdgeInsets.all(xl);
  static const EdgeInsets xxlAll = EdgeInsets.all(xxl);

  /// Horizontal spacing values as EdgeInsets
  static const EdgeInsets xsHorizontal = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets smHorizontal = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets mdHorizontal = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets lgHorizontal = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets xlHorizontal = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets xxlHorizontal = EdgeInsets.symmetric(horizontal: xxl);

  /// Vertical spacing values as EdgeInsets
  static const EdgeInsets xsVertical = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets smVertical = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets mdVertical = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets lgVertical = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets xlVertical = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets xxlVertical = EdgeInsets.symmetric(vertical: xxl);

  /// Custom spacing combinations
  static EdgeInsets custom({
    double? top,
    double? bottom,
    double? left,
    double? right,
    double? horizontal,
    double? vertical,
  }) {
    return EdgeInsets.only(
      top: top ?? vertical ?? 0,
      bottom: bottom ?? vertical ?? 0,
      left: left ?? horizontal ?? 0,
      right: right ?? horizontal ?? 0,
    );
  }
}
