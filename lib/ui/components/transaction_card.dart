/// Transaction card component for displaying transaction information
///
/// This component displays transaction details in a card format with
/// proper styling, status indicators, and amount formatting.
library;

import 'package:flutter/material.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';
import '../../core/money.dart';
import '../../widgets/status_chip.dart';
import 'amount_display.dart';

/// Transaction card component for displaying transaction information
///
/// This component provides a consistent way to display transaction
/// details including title, subtitle, amount, status, and optional icon.
class TransactionCard extends StatelessWidget {
  /// Creates a transaction card component
  ///
  /// [id] - The transaction ID
  /// [title] - The transaction title
  /// [subtitle] - Optional transaction subtitle
  /// [amount] - The transaction amount
  /// [status] - The transaction status
  /// [icon] - Optional transaction icon
  const TransactionCard({
    super.key,
    required this.id,
    required this.title,
    this.subtitle,
    required this.amount,
    required this.status,
    this.icon,
  });

  /// The transaction ID
  final String id;

  /// The transaction title
  final String title;

  /// Optional transaction subtitle
  final String? subtitle;

  /// The transaction amount
  final Money amount;

  /// The transaction status
  final String status;

  /// Optional transaction icon
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: DesignTokens.spacingSmAll,
      child: InkWell(
        onTap: () {}, // No onTap callback in new API
        borderRadius: DesignTokens.radiusLgAll,
        child: Padding(
          padding: DesignTokens.spacingLgAll,
          child: Row(
            children: [
              // Left side - Icon and content
              Expanded(
                child: Row(
                  children: [
                    // Transaction icon
                    if (icon != null) ...[
                      _buildTransactionIcon(isDark),
                      const SizedBox(width: 12),
                    ],

                    // Transaction details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            title,
                            style: AppTypography.bodyMedium.copyWith(
                              color: isDark
                                  ? DesignTokens.darkOnSurface
                                  : DesignTokens.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 4),

                          // Subtitle
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark
                                    ? DesignTokens.darkOnSurfaceVariant
                                    : DesignTokens.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Right side - Amount and status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Amount
                  AmountDisplay(money: amount, variant: 'primary'),

                  const SizedBox(height: 8),

                  // Status chip
                  StatusChip(status: status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the transaction icon widget
  Widget _buildTransactionIcon(bool isDark) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: (isDark ? DesignTokens.darkPrimary : DesignTokens.primary)
            .withOpacity(0.1),
        borderRadius: DesignTokens.radiusMdAll,
      ),
      child: Icon(
        icon!,
        size: 20,
        color: isDark ? DesignTokens.darkPrimary : DesignTokens.primary,
      ),
    );
  }
}
