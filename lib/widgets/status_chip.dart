import 'package:flutter/material.dart';
import '../design/tokens.dart';
import '../design/typography.dart';

/// Status chip that reads tokens from design-lock.json
///
/// Provides:
/// - Pending, completed, failed, and reversed status styling
/// - Capsule appearance with configurable height and radius
/// - Status-specific colors from design tokens
///
/// Uses design-lock tokens:
/// - tokens.components.status.<status>.fg (foreground color)
/// - tokens.components.status.<status>.bg.light/dark (background color)
/// - tokens.components.status.radius (border radius)
/// - tokens.components.status.height (chip height)
/// - tokens.components.status.paddingX (horizontal padding)
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final (backgroundColor, textColor) = _getStatusColors(isDark);

    return Container(
      height: 28, // tokens.components.status.height
      padding:
          DesignTokens.spacingMdHorizontal, // tokens.components.status.paddingX
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
            DesignTokens.radiusPillAll, // tokens.components.status.radius
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Small dot using fg color
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: textColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            _getStatusLabel(),
            style: AppTypography.labelMedium.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  (Color backgroundColor, Color textColor) _getStatusColors(bool isDark) {
    switch (status) {
      case 'pending':
        return (
          isDark
              ? DesignTokens.primary.withOpacity(0.2)
              : DesignTokens.primary.withOpacity(0.1),
          isDark ? DesignTokens.darkPrimary : DesignTokens.primary,
        );
      case 'completed':
        return (
          isDark
              ? DesignTokens.success.withOpacity(0.2)
              : DesignTokens.success.withOpacity(0.1),
          isDark ? DesignTokens.darkSuccess : DesignTokens.success,
        );
      case 'failed':
        return (
          isDark
              ? DesignTokens.error.withOpacity(0.2)
              : DesignTokens.error.withOpacity(0.1),
          isDark ? DesignTokens.darkError : DesignTokens.error,
        );
      case 'reversed':
        return (
          isDark
              ? DesignTokens.onSurfaceVariant.withOpacity(0.2)
              : DesignTokens.onSurfaceVariant.withOpacity(0.1),
          isDark
              ? DesignTokens.darkOnSurfaceVariant
              : DesignTokens.onSurfaceVariant,
        );
      default:
        return (
          isDark
              ? DesignTokens.darkSurfaceVariant
              : DesignTokens.surfaceVariant,
          isDark
              ? DesignTokens.darkOnSurfaceVariant
              : DesignTokens.onSurfaceVariant,
        );
    }
  }

  String _getStatusLabel() {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'completed':
        return 'Completed';
      case 'failed':
        return 'Failed';
      case 'reversed':
        return 'Reversed';
      default:
        return status.toUpperCase();
    }
  }
}
