// Generated from docs/design-lock.json
// DO NOT EDIT MANUALLY - Use design-lock.json as single source of truth

import 'package:flutter/material.dart';

/// Border radius tokens from design-lock.json
/// Single source of truth: docs/design-lock.json
class RadiusTokens {
  const RadiusTokens._();

  // Radius values from PRD specification: 8, 12, 16, 20, plus pill for CTAs
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double pill = 28.0; // For CTAs as specified in PRD

  /// All radius values as BorderRadius
  static const BorderRadius xsAll = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));

  /// Top radius values as BorderRadius
  static const BorderRadius xsTop = BorderRadius.vertical(
    top: Radius.circular(xs),
  );
  static const BorderRadius smTop = BorderRadius.vertical(
    top: Radius.circular(sm),
  );
  static const BorderRadius mdTop = BorderRadius.vertical(
    top: Radius.circular(md),
  );
  static const BorderRadius lgTop = BorderRadius.vertical(
    top: Radius.circular(lg),
  );

  /// Bottom radius values as BorderRadius
  static const BorderRadius xsBottom = BorderRadius.vertical(
    bottom: Radius.circular(xs),
  );
  static const BorderRadius smBottom = BorderRadius.vertical(
    bottom: Radius.circular(sm),
  );
  static const BorderRadius mdBottom = BorderRadius.vertical(
    bottom: Radius.circular(md),
  );
  static const BorderRadius lgBottom = BorderRadius.vertical(
    bottom: Radius.circular(lg),
  );

  /// Left radius values as BorderRadius
  static const BorderRadius xsLeft = BorderRadius.horizontal(
    left: Radius.circular(xs),
  );
  static const BorderRadius smLeft = BorderRadius.horizontal(
    left: Radius.circular(sm),
  );
  static const BorderRadius mdLeft = BorderRadius.horizontal(
    left: Radius.circular(md),
  );
  static const BorderRadius lgLeft = BorderRadius.horizontal(
    left: Radius.circular(lg),
  );

  /// Right radius values as BorderRadius
  static const BorderRadius xsRight = BorderRadius.horizontal(
    right: Radius.circular(xs),
  );
  static const BorderRadius smRight = BorderRadius.horizontal(
    right: Radius.circular(sm),
  );
  static const BorderRadius mdRight = BorderRadius.horizontal(
    right: Radius.circular(md),
  );
  static const BorderRadius lgRight = BorderRadius.horizontal(
    right: Radius.circular(lg),
  );

  /// Custom radius combinations
  static BorderRadius custom({
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
    double? all,
  }) {
    if (all != null) {
      return BorderRadius.all(Radius.circular(all));
    }
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft ?? 0),
      topRight: Radius.circular(topRight ?? 0),
      bottomLeft: Radius.circular(bottomLeft ?? 0),
      bottomRight: Radius.circular(bottomRight ?? 0),
    );
  }
}
