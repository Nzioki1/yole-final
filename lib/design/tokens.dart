/// Design tokens for Yole app
///
/// This file contains all design tokens including colors, spacing, radius,
/// and other design system constants. These tokens are the single source
/// of truth for all design values used throughout the app.
library;

import 'package:flutter/material.dart';
import 'color_utils.dart';

/// Design tokens class containing all design system constants
class DesignTokens {
  const DesignTokens._();

  // ============================================================================
  // COLOR TOKENS
  // ============================================================================

  /// Primary color tokens
  static const Color primary = Color(0xFF3B82F6);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFDBEAFE);
  static const Color onPrimaryContainer = Color(0xFF1E3A8A);

  /// Surface color tokens
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1F2937);
  static const Color surfaceVariant = Color(0xFFF9FAFB);
  static const Color onSurfaceVariant = Color(0xFF6B7280);

  /// Background color tokens
  static const Color background = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF1F2937);

  /// Error color tokens
  static const Color error = Color(0xFFEF4444);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onErrorContainer = Color(0xFF991B1B);

  /// Success color tokens
  static const Color success = Color(0xFF10B981);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = Color(0xFFD1FAE5);
  static const Color onSuccessContainer = Color(0xFF065F46);

  /// Warning color tokens
  static const Color warning = Color(0xFFF59E0B);
  static const Color onWarning = Color(0xFFFFFFFF);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color onWarningContainer = Color(0xFF92400E);

  /// Info color tokens
  static const Color info = Color(0xFF3B82F6);
  static const Color onInfo = Color(0xFFFFFFFF);
  static const Color infoContainer = Color(0xFFDBEAFE);
  static const Color onInfoContainer = Color(0xFF1E3A8A);

  /// Outline color tokens
  static const Color outline = Color(0xFFD1D5DB);
  static const Color outlineVariant = Color(0xFFE5E7EB);

  /// Sidebar color tokens
  static const Color sidebarBg = Color(0xFF0B1220);
  static const Color sidebarActive = Color(0xFF7DD3FC);
  static const Color sidebarInactive = Color(0xFF6B7280);
  static const Color sidebarHover = Color(0xFF1F2937);

  /// Chart color palette
  static const Color chart1 = Color(0xFF2563EB);
  static const Color chart2 = Color(0xFF10B981);
  static const Color chart3 = Color(0xFFF59E0B);
  static const Color chart4 = Color(0xFFEF4444);
  static const Color chart5 = Color(0xFF8B5CF6);

  /// Interactive element colors
  static const Color ring = Color(0xFF60A5FA);
  static const Color switchThumb = Color(0xFFF8FAFC);
  static const Color switchTrack = Color(0xFF1F2937);
  static const Color switchTrackActive = Color(0xFF3B82F6);

  /// Gradient colors
  static const Color gradientStart = Color(0xFF3B82F6);
  static const Color gradientEnd = Color(0xFF8B5CF6);

  // ============================================================================
  // DARK MODE COLOR TOKENS
  // ============================================================================

  /// Dark mode primary colors
  static const Color darkPrimary = Color(0xFF60A5FA);
  static const Color darkOnPrimary = Color(0xFF1E3A8A);
  static const Color darkPrimaryContainer = Color(0xFF1E3A8A);
  static const Color darkOnPrimaryContainer = Color(0xFFDBEAFE);

  /// Dark mode surface colors
  static const Color darkSurface = Color(0xFF19173D);
  static const Color darkOnSurface = Color(0xFFF9FAFB);
  static const Color darkSurfaceVariant = Color(0xFF374151);
  static const Color darkOnSurfaceVariant = Color(0xFFD1D5DB);

  /// Dark mode background colors
  static const Color darkBackground = Color(0xFF19173D);
  static const Color darkOnBackground = Color(0xFFF9FAFB);

  /// Dark mode error colors
  static const Color darkError = Color(0xFFF87171);
  static const Color darkOnError = Color(0xFF991B1B);
  static const Color darkErrorContainer = Color(0xFF991B1B);
  static const Color darkOnErrorContainer = Color(0xFFFEE2E2);

  /// Dark mode success colors
  static const Color darkSuccess = Color(0xFF34D399);
  static const Color darkOnSuccess = Color(0xFF065F46);
  static const Color darkSuccessContainer = Color(0xFF065F46);
  static const Color darkOnSuccessContainer = Color(0xFFD1FAE5);

  /// Dark mode warning colors
  static const Color darkWarning = Color(0xFFFBBF24);
  static const Color darkOnWarning = Color(0xFF92400E);
  static const Color darkWarningContainer = Color(0xFF92400E);
  static const Color darkOnWarningContainer = Color(0xFFFEF3C7);

  /// Dark mode info colors
  static const Color darkInfo = Color(0xFF60A5FA);
  static const Color darkOnInfo = Color(0xFF1E3A8A);
  static const Color darkInfoContainer = Color(0xFF1E3A8A);
  static const Color darkOnInfoContainer = Color(0xFFDBEAFE);

  /// Dark mode outline colors
  static const Color darkOutline = Color(0xFF4B5563);
  static const Color darkOutlineVariant = Color(0xFF374151);

  /// Dark mode sidebar colors
  static const Color darkSidebarBg = Color(0xFF0F172A);
  static const Color darkSidebarActive = Color(0xFF7DD3FC);
  static const Color darkSidebarInactive = Color(0xFF94A3B8);
  static const Color darkSidebarHover = Color(0xFF1E293B);

  /// Dark mode interactive element colors
  static const Color darkRing = Color(0xFF60A5FA);
  static const Color darkSwitchThumb = Color(0xFFF8FAFC);
  static const Color darkSwitchTrack = Color(0xFF374151);
  static const Color darkSwitchTrackActive = Color(0xFF60A5FA);

  // ============================================================================
  // OKLCH COLOR TOKENS (with fallback to sRGB)
  // ============================================================================

  /// OKLCH color tokens with sRGB fallback
  static Color get oklchPrimary => ColorUtils.oklch(0.7, 0.15, 250);
  static Color get oklchSuccess => ColorUtils.oklch(0.7, 0.15, 140);
  static Color get oklchWarning => ColorUtils.oklch(0.8, 0.12, 60);
  static Color get oklchError => ColorUtils.oklch(0.7, 0.15, 20);
  static Color get oklchInfo => ColorUtils.oklch(0.7, 0.15, 250);

  // ============================================================================
  // SPACING TOKENS
  // ============================================================================

  /// Spacing scale: [4, 8, 12, 16, 20, 24, 32]
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 12.0;
  static const double spacingLg = 16.0;
  static const double spacingXl = 20.0;
  static const double spacing2xl = 24.0;
  static const double spacing3xl = 32.0;

  /// Spacing as EdgeInsets
  static const EdgeInsets spacingXsAll = EdgeInsets.all(spacingXs);
  static const EdgeInsets spacingSmAll = EdgeInsets.all(spacingSm);
  static const EdgeInsets spacingMdAll = EdgeInsets.all(spacingMd);
  static const EdgeInsets spacingLgAll = EdgeInsets.all(spacingLg);
  static const EdgeInsets spacingXlAll = EdgeInsets.all(spacingXl);
  static const EdgeInsets spacing2xlAll = EdgeInsets.all(spacing2xl);
  static const EdgeInsets spacing3xlAll = EdgeInsets.all(spacing3xl);

  /// Horizontal spacing
  static const EdgeInsets spacingXsHorizontal = EdgeInsets.symmetric(
    horizontal: spacingXs,
  );
  static const EdgeInsets spacingSmHorizontal = EdgeInsets.symmetric(
    horizontal: spacingSm,
  );
  static const EdgeInsets spacingMdHorizontal = EdgeInsets.symmetric(
    horizontal: spacingMd,
  );
  static const EdgeInsets spacingLgHorizontal = EdgeInsets.symmetric(
    horizontal: spacingLg,
  );
  static const EdgeInsets spacingXlHorizontal = EdgeInsets.symmetric(
    horizontal: spacingXl,
  );
  static const EdgeInsets spacing2xlHorizontal = EdgeInsets.symmetric(
    horizontal: spacing2xl,
  );
  static const EdgeInsets spacing3xlHorizontal = EdgeInsets.symmetric(
    horizontal: spacing3xl,
  );

  /// Vertical spacing
  static const EdgeInsets spacingXsVertical = EdgeInsets.symmetric(
    vertical: spacingXs,
  );
  static const EdgeInsets spacingSmVertical = EdgeInsets.symmetric(
    vertical: spacingSm,
  );
  static const EdgeInsets spacingMdVertical = EdgeInsets.symmetric(
    vertical: spacingMd,
  );
  static const EdgeInsets spacingLgVertical = EdgeInsets.symmetric(
    vertical: spacingLg,
  );
  static const EdgeInsets spacingXlVertical = EdgeInsets.symmetric(
    vertical: spacingXl,
  );
  static const EdgeInsets spacing2xlVertical = EdgeInsets.symmetric(
    vertical: spacing2xl,
  );
  static const EdgeInsets spacing3xlVertical = EdgeInsets.symmetric(
    vertical: spacing3xl,
  );

  // ============================================================================
  // RADIUS TOKENS
  // ============================================================================

  /// Border radius tokens: sm=8, md=12, lg=16, pill=999
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusPill = 999.0;

  /// Border radius as BorderRadius
  static const BorderRadius radiusSmAll = BorderRadius.all(
    Radius.circular(radiusSm),
  );
  static const BorderRadius radiusMdAll = BorderRadius.all(
    Radius.circular(radiusMd),
  );
  static const BorderRadius radiusLgAll = BorderRadius.all(
    Radius.circular(radiusLg),
  );
  static const BorderRadius radiusPillAll = BorderRadius.all(
    Radius.circular(radiusPill),
  );

  /// Top border radius
  static const BorderRadius radiusSmTop = BorderRadius.vertical(
    top: Radius.circular(radiusSm),
  );
  static const BorderRadius radiusMdTop = BorderRadius.vertical(
    top: Radius.circular(radiusMd),
  );
  static const BorderRadius radiusLgTop = BorderRadius.vertical(
    top: Radius.circular(radiusLg),
  );

  /// Bottom border radius
  static const BorderRadius radiusSmBottom = BorderRadius.vertical(
    bottom: Radius.circular(radiusSm),
  );
  static const BorderRadius radiusMdBottom = BorderRadius.vertical(
    bottom: Radius.circular(radiusMd),
  );
  static const BorderRadius radiusLgBottom = BorderRadius.vertical(
    bottom: Radius.circular(radiusLg),
  );

  // ============================================================================
  // ELEVATION TOKENS
  // ============================================================================

  /// Elevation levels
  static const double elevation0 = 0.0;
  static const double elevation1 = 1.0;
  static const double elevation2 = 2.0;
  static const double elevation3 = 4.0;
  static const double elevation4 = 8.0;
  static const double elevation5 = 16.0;

  // ============================================================================
  // ANIMATION TOKENS
  // ============================================================================

  /// Animation durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  /// Animation curves
  static const Curve animationEaseIn = Curves.easeIn;
  static const Curve animationEaseOut = Curves.easeOut;
  static const Curve animationEaseInOut = Curves.easeInOut;
  static const Curve animationBounceIn = Curves.bounceIn;
  static const Curve animationBounceOut = Curves.bounceOut;

  // ============================================================================
  // BREAKPOINT TOKENS
  // ============================================================================

  /// Breakpoints for responsive design
  static const double breakpointXs = 360.0;
  static const double breakpointSm = 640.0;
  static const double breakpointMd = 768.0;
  static const double breakpointLg = 1024.0;
  static const double breakpointXl = 1280.0;
  static const double breakpoint2xl = 1536.0;

  // ============================================================================
  // Z-INDEX TOKENS
  // ============================================================================

  /// Z-index levels
  static const int zIndex0 = 0;
  static const int zIndex10 = 10;
  static const int zIndex20 = 20;
  static const int zIndex30 = 30;
  static const int zIndex40 = 40;
  static const int zIndex50 = 50;
  static const int zIndexModal = 1000;
  static const int zIndexToast = 2000;
  static const int zIndexTooltip = 3000;
}

