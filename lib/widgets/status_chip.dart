import 'package:flutter/material.dart';
import '../core/theme/theme_extensions.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final successColors = Theme.of(context).extension<SuccessColors>();
    final textTheme = Theme.of(context).textTheme;

    final (backgroundColor, textColor) = _getStatusColors(
      context,
      colorScheme,
      successColors,
    );

    return Container(
      height: 28, // tokens.components.status.height
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ), // tokens.components.status.paddingX
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          999,
        ), // tokens.components.status.radius
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
            style: textTheme.labelLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  (Color backgroundColor, Color textColor) _getStatusColors(
    BuildContext context,
    ColorScheme colorScheme,
    SuccessColors? successColors,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (status) {
      case 'pending':
        return (
          isDark
              ? const Color(0x333B82F6)
              : const Color(0x1F3B82F6), // bg.dark/bg.light
          colorScheme.primary, // fg = var(--primary)
        );
      case 'completed':
        return (
          isDark
              ? const Color(0x3310B981)
              : const Color(0x1F10B981), // bg.dark/bg.light
          successColors?.success ?? colorScheme.primary, // fg = var(--success)
        );
      case 'failed':
        return (
          isDark
              ? const Color(0x33EF4444)
              : const Color(0x1FEF4444), // bg.dark/bg.light
          colorScheme.error, // fg = var(--destructive)
        );
      case 'reversed':
        return (
          isDark
              ? const Color(0x3394A3B8)
              : const Color(0x1F94A3B8), // bg.dark/bg.light
          colorScheme.onSurfaceVariant, // fg = var(--muted-foreground)
        );
      default:
        return (colorScheme.surfaceVariant, colorScheme.onSurfaceVariant);
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
