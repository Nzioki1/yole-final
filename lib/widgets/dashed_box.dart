import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../core/theme/tokens_radius.dart';
import '../core/theme/tokens_spacing.dart';

/// Dashed border container with dotted_border
///
/// Provides:
/// - Dotted border styling
/// - Rounded corners
/// - Configurable padding and child
///
/// Uses theme tokens:
/// - ColorScheme.outline (for border color)
/// - RadiusTokens.md (16dp radius)
/// - SpacingTokens.lg (16dp padding)
class DashedBox extends StatelessWidget {
  const DashedBox({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.borderColor,
    this.borderWidth = 1.0,
    this.dashPattern = const [5, 5],
  });

  final Widget child;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final List<double> dashPattern;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DottedBorder(
      color: borderColor ?? colorScheme.outline,
      strokeWidth: borderWidth,
      dashPattern: dashPattern,
      borderType: BorderType.RRect,
      radius: borderRadius?.topLeft ?? Radius.circular(RadiusTokens.md),
      child: Container(padding: padding ?? SpacingTokens.lgAll, child: child),
    );
  }
}
