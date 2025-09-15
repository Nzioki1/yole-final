import 'package:flutter/material.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import 'pressable.dart';

/// Gradient button with primary CTA styling
///
/// Provides:
/// - 56dp height (from PRD specification)
/// - 20dp radius (pill radius from tokens)
/// - Gradient from primary-gradient-start → primary-gradient-end
/// - Wraps Pressable for iOS-style press animation
///
/// Uses theme tokens:
/// - GradientColors.primaryGradient (from theme extensions)
/// - RadiusTokens.pill (20dp radius)
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.enabled = true,
    this.minWidth,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool enabled;
  final double? minWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final gradient = LinearGradient(
      colors: [
        isDark ? DesignTokens.darkPrimary : DesignTokens.primary,
        isDark
            ? DesignTokens.darkPrimary.withOpacity(0.8)
            : DesignTokens.primary.withOpacity(0.8),
      ],
    );

    return Pressable(
      onPressed: enabled ? onPressed : null,
      enabled: enabled,
      child: Container(
        height: 56, // PRD: 56dp height
        constraints: BoxConstraints(minWidth: minWidth ?? 0),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: DesignTokens.radiusPillAll, // PRD: pill radius
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            borderRadius: DesignTokens.radiusPillAll,
            child: Center(
              child: DefaultTextStyle(
                style: AppTypography.buttonLarge.copyWith(
                  color: isDark
                      ? DesignTokens.darkOnPrimary
                      : DesignTokens.onPrimary,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
