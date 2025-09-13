import 'package:flutter/material.dart';
import 'core/theme/theme_extensions.dart';
import 'core/theme/tokens_radius.dart';
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
    final gradientColors = Theme.of(context).extension<GradientColors>();

    if (gradientColors == null) {
      // Fallback if gradient colors not available
      return FilledButton(onPressed: enabled ? onPressed : null, child: child);
    }

    return Pressable(
      onPressed: enabled ? onPressed : null,
      enabled: enabled,
      child: Container(
        height: 56, // PRD: 56dp height
        constraints: BoxConstraints(minWidth: minWidth ?? 0),
        decoration: BoxDecoration(
          gradient: gradientColors.primaryGradient,
          borderRadius: RadiusTokens.pillAll, // PRD: 20dp radius (pill)
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            borderRadius: RadiusTokens.pillAll,
            child: Center(
              child: DefaultTextStyle(
                style:
                    Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: Colors.white) ??
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
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
