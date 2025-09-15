import 'package:flutter/material.dart';
import '../core/theme/tokens_spacing.dart';

/// 4-step progress indicator with dots
///
/// Provides:
/// - 4-step progress visualization
/// - Active, completed, and pending states
/// - Horizontal layout with connecting lines
///
/// Uses theme tokens:
/// - ColorScheme.primary (for active/completed steps)
/// - ColorScheme.onSurfaceVariant (for pending steps)
/// - ColorScheme.outline (for connecting lines)
/// - SpacingTokens (for spacing between dots)
class StepDots extends StatelessWidget {
  const StepDots({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
    this.showConnectingLines = true,
  });

  final int currentStep;
  final int totalSteps;
  final bool showConnectingLines;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        final isCompleted = index < currentStep;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(
              context,
              colorScheme,
              isActive: isActive,
              isCompleted: isCompleted,
            ),
            if (showConnectingLines && index < totalSteps - 1)
              _buildConnectingLine(context, colorScheme, isCompleted),
          ],
        );
      }),
    );
  }

  Widget _buildDot(
    BuildContext context,
    ColorScheme colorScheme, {
    required bool isActive,
    required bool isCompleted,
  }) {
    Color dotColor;
    double dotSize = 8;

    if (isCompleted) {
      dotColor = colorScheme.primary;
      dotSize = 10;
    } else if (isActive) {
      dotColor = colorScheme.primary;
      dotSize = 12;
    } else {
      dotColor = colorScheme.onSurfaceVariant.withOpacity(0.3);
    }

    return Container(
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
    );
  }

  Widget _buildConnectingLine(
    BuildContext context,
    ColorScheme colorScheme,
    bool isCompleted,
  ) {
    return Container(
      width: 20,
      height: 2,
      margin: SpacingTokens.smHorizontal,
      decoration: BoxDecoration(
        color: isCompleted ? colorScheme.primary : colorScheme.outline,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
