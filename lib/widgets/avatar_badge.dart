import 'package:flutter/material.dart';
import '../core/theme/theme_extensions.dart';
import '../core/theme/tokens_radius.dart';

/// Circular avatar with gradient initials
///
/// Provides:
/// - Circular gradient background
/// - User initials in white text
/// - Configurable size
///
/// Uses theme tokens:
/// - GradientColors.primaryGradient (from theme extensions)
/// - RadiusTokens.pill (for circular shape)
class AvatarBadge extends StatelessWidget {
  const AvatarBadge({
    super.key,
    required this.initials,
    this.size = 40,
    this.onTap,
  });

  final String initials;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final gradientColors = Theme.of(context).extension<GradientColors>();

    if (gradientColors == null) {
      // Fallback if gradient colors not available
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Text(
          initials,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: Colors.white),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: gradientColors.primaryGradient,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            initials,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
