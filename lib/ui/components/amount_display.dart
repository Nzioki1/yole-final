/// Amount display component for showing monetary values
///
/// This component displays monetary values with proper formatting,
/// currency symbols, and optional exchange rate information.
library;

import 'package:flutter/material.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';
import '../../core/money.dart';

/// Variants for the amount display component
enum AmountDisplayVariant {
  /// Primary variant with larger text and emphasis
  primary,

  /// Secondary variant with smaller text
  secondary,
}

/// Amount display component for showing monetary values
///
/// This component provides consistent formatting for monetary values
/// across the application, including thousands separators, currency
/// symbols, and optional exchange rate information.
class AmountDisplay extends StatelessWidget {
  /// Creates an amount display component
  ///
  /// [money] - The monetary value to display
  /// [targetCurrency] - Optional target currency for conversion display
  /// [showApproxFx] - Whether to show approximate exchange rate info
  /// [variant] - The visual variant (primary or secondary)
  const AmountDisplay({
    super.key,
    required this.money,
    this.targetCurrency,
    this.showApproxFx = false,
    this.variant = 'primary',
  });

  /// The monetary value to display
  final Money money;

  /// Optional target currency for conversion display
  final String? targetCurrency;

  /// Whether to show approximate exchange rate information
  final bool showApproxFx;

  /// The visual variant
  final String variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main amount display
        Text(formatMoney(money), style: _getTextStyle(isDark)),

        // Optional exchange rate information
        if (showApproxFx) ...[
          const SizedBox(height: 4),
          _buildExchangeRateInfo(isDark),
        ],
      ],
    );
  }

  /// Gets the appropriate text style based on variant and theme
  TextStyle _getTextStyle(bool isDark) {
    switch (variant) {
      case 'primary':
        return AppTypography.h2.copyWith(
          color: isDark ? DesignTokens.darkOnSurface : DesignTokens.onSurface,
          fontWeight: FontWeight.w700,
        );
      case 'secondary':
        return AppTypography.bodyLarge.copyWith(
          color: isDark
              ? DesignTokens.darkOnSurfaceVariant
              : DesignTokens.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        );
      default:
        return AppTypography.h2.copyWith(
          color: isDark ? DesignTokens.darkOnSurface : DesignTokens.onSurface,
          fontWeight: FontWeight.w700,
        );
    }
  }

  /// Builds the exchange rate information widget
  Widget _buildExchangeRateInfo(bool isDark) {
    return Container(
      padding: DesignTokens.spacingXsAll,
      decoration: BoxDecoration(
        color: (isDark ? DesignTokens.darkPrimary : DesignTokens.primary)
            .withOpacity(0.1),
        borderRadius: DesignTokens.radiusSmAll,
      ),
      child: Text(
        '≈ ${_getApproximateFxText()}',
        style: AppTypography.caption.copyWith(
          color: isDark ? DesignTokens.darkPrimary : DesignTokens.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Gets the approximate exchange rate text
  String _getApproximateFxText() {
    // This would typically come from an exchange rate service
    // For now, we'll provide a placeholder
    switch (money.currency.toUpperCase()) {
      case 'USD':
        return '${(money.major * 2593).toStringAsFixed(0)} KES';
      case 'EUR':
        return '${(money.major * 1.08).toStringAsFixed(2)} USD';
      case 'KES':
        return '${(money.major / 2593).toStringAsFixed(2)} USD';
      default:
        return 'Exchange rate unavailable';
    }
  }
}
