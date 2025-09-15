/// Network tile component for network selection
///
/// Provides:
/// - Clear states: loading, selectable, disabled, error
/// - Per-network fee preview and limits
/// - Accessibility support with focus/labels
/// - Deterministic keys for testing
library;

import 'package:flutter/material.dart';
import '../../core/money.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';
import '../../features/send/state/send_state.dart';

/// Network tile state
enum NetworkTileState {
  /// Network is loading
  loading,
  
  /// Network is available and selectable
  available,
  
  /// Network is disabled (amount limits, currency mismatch, etc.)
  disabled,
  
  /// Network has an error
  error,
}

/// Network tile widget for selection
class NetworkTile extends StatelessWidget {
  /// Network information
  final NetworkInfo network;
  
  /// Current amount (for validation)
  final Money? amount;
  
  /// Current currency
  final String currentCurrency;
  
  /// Whether this network is selected
  final bool isSelected;
  
  /// Network state
  final NetworkTileState state;
  
  /// Fee preview for the current amount
  final Money? feePreview;
  
  /// Callback when network is selected
  final VoidCallback? onTap;
  
  /// Disabled reason (if any)
  final String? disabledReason;
  
  /// Error message (if any)
  final String? errorMessage;
  
  /// Whether to show fee preview
  final bool showFeePreview;

  const NetworkTile({
    super.key,
    required this.network,
    this.amount,
    this.currentCurrency = 'USD',
    this.isSelected = false,
    this.state = NetworkTileState.available,
    this.feePreview,
    this.onTap,
    this.disabledReason,
    this.errorMessage,
    this.showFeePreview = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final isEnabled = state == NetworkTileState.available && onTap != null;
    final hasError = state == NetworkTileState.error;
    final isLoading = state == NetworkTileState.loading;

    return Semantics(
      key: Key('network_item_${network.id}'),
      label: _getAccessibilityLabel(),
      hint: _getAccessibilityHint(),
      enabled: isEnabled,
      selected: isSelected,
      button: true,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getBackgroundColor(isDark),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getBorderColor(isDark),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Network logo/icon
                  _buildNetworkIcon(isDark),
                  
                  const SizedBox(width: 12),
                  
                  // Network info
                  Expanded(
                    child: _buildNetworkInfo(isDark),
                  ),
                  
                  // Status indicator
                  _buildStatusIndicator(isDark),
                ],
              ),
              
              // Fee preview (if available and enabled)
              if (showFeePreview && isEnabled && feePreview != null) ...[
                const SizedBox(height: 12),
                _buildFeePreview(feePreview!, isDark),
              ],
              
              // Limits info
              if (isEnabled) ...[
                const SizedBox(height: 8),
                _buildLimitsInfo(isDark),
              ],
              
              // Error message
              if (hasError && errorMessage != null) ...[
                const SizedBox(height: 8),
                _buildErrorMessage(errorMessage!, isDark),
              ],
              
              // Disabled reason
              if (state == NetworkTileState.disabled && disabledReason != null) ...[
                const SizedBox(height: 8),
                _buildDisabledReason(disabledReason!, isDark),
              ],
              
              // Loading indicator
              if (isLoading) ...[
                const SizedBox(height: 12),
                _buildLoadingIndicator(isDark),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Build network icon
  Widget _buildNetworkIcon(bool isDark) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _getIconBackgroundColor(isDark),
        borderRadius: BorderRadius.circular(8),
      ),
      child: network.logoUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                network.logoUrl!,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackIcon(isDark);
                },
              ),
            )
          : _buildFallbackIcon(isDark),
    );
  }

  /// Build fallback icon when logo is not available
  Widget _buildFallbackIcon(bool isDark) {
    return Icon(
      _getNetworkIcon(network.type),
      color: _getIconColor(isDark),
      size: 24,
    );
  }

  /// Build network information
  Widget _buildNetworkInfo(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                network.name,
                style: AppTypography.h4.copyWith(
                  color: _getTextColor(isDark),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (network.isRecommended)
              _buildRecommendedBadge(isDark),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${network.country} • ${network.currency}',
          style: AppTypography.bodyMedium.copyWith(
            color: _getSecondaryTextColor(isDark),
          ),
        ),
        if (network.processingTimeMinutes > 0) ...[
          const SizedBox(height: 2),
          Text(
            _formatProcessingTime(network.processingTimeMinutes),
            style: AppTypography.bodySmall.copyWith(
              color: _getSecondaryTextColor(isDark),
            ),
          ),
        ],
      ],
    );
  }

  /// Build status indicator
  Widget _buildStatusIndicator(bool isDark) {
    switch (state) {
      case NetworkTileState.loading:
        return SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getIconColor(isDark),
            ),
          ),
        );
      case NetworkTileState.available:
        if (isSelected) {
          return Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: DesignTokens.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.check,
              size: 16,
              color: Colors.white,
            ),
          );
        }
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            border: Border.all(
              color: _getBorderColor(isDark),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      case NetworkTileState.disabled:
      case NetworkTileState.error:
        return Icon(
          Icons.info_outline,
          color: _getSecondaryTextColor(isDark),
          size: 20,
        );
    }
  }

  /// Build fee preview
  Widget _buildFeePreview(Money fee, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _getFeePreviewBackgroundColor(isDark),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.attach_money,
            size: 16,
            color: _getSecondaryTextColor(isDark),
          ),
          const SizedBox(width: 8),
          Text(
            'Fee: ${fee.formatted}',
            style: AppTypography.bodyMedium.copyWith(
              color: _getSecondaryTextColor(isDark),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Build limits information
  Widget _buildLimitsInfo(bool isDark) {
    final minAmount = Money.fromMajor(network.minAmount, network.currency);
    final maxAmount = Money.fromMajor(network.maxAmount, network.currency);
    
    return Text(
      '${minAmount.formatted} - ${maxAmount.formatted}',
      style: AppTypography.bodySmall.copyWith(
        color: _getSecondaryTextColor(isDark),
      ),
    );
  }

  /// Build error message
  Widget _buildErrorMessage(String message, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: DesignTokens.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: DesignTokens.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySmall.copyWith(
                color: DesignTokens.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build disabled reason
  Widget _buildDisabledReason(String reason, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _getDisabledBackgroundColor(isDark),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: _getSecondaryTextColor(isDark),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              reason,
              style: AppTypography.bodySmall.copyWith(
                color: _getSecondaryTextColor(isDark),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build loading indicator
  Widget _buildLoadingIndicator(bool isDark) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getIconColor(isDark),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Loading...',
          style: AppTypography.bodySmall.copyWith(
            color: _getSecondaryTextColor(isDark),
          ),
        ),
      ],
    );
  }

  /// Build recommended badge
  Widget _buildRecommendedBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: DesignTokens.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Recommended',
        style: AppTypography.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Get network icon for type
  IconData _getNetworkIcon(NetworkType type) {
    switch (type) {
      case NetworkType.mobileMoney:
        return Icons.phone_android;
      case NetworkType.bankTransfer:
        return Icons.account_balance;
      case NetworkType.card:
        return Icons.credit_card;
      case NetworkType.crypto:
        return Icons.currency_bitcoin;
    }
  }

  /// Get accessibility label
  String _getAccessibilityLabel() {
    final status = isSelected ? 'Selected' : 'Not selected';
    final availability = state == NetworkTileState.available ? 'Available' : 'Not available';
    return '${network.name}, $status, $availability';
  }

  /// Get accessibility hint
  String _getAccessibilityHint() {
    if (state == NetworkTileState.disabled) {
      return 'Double tap to see why this network is disabled';
    }
    if (state == NetworkTileState.error) {
      return 'Double tap to see error details';
    }
    if (isSelected) {
      return 'Double tap to deselect';
    }
    return 'Double tap to select this network';
  }

  /// Format processing time
  String _formatProcessingTime(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) {
      return '${hours}h';
    }
    return '${hours}h ${remainingMinutes}m';
  }

  /// Get background color based on state
  Color _getBackgroundColor(bool isDark) {
    if (isSelected) {
      return isDark ? DesignTokens.darkPrimaryContainer : DesignTokens.primaryContainer;
    }
    if (state == NetworkTileState.disabled) {
      return isDark ? DesignTokens.darkSurfaceVariant : DesignTokens.surfaceVariant;
    }
    return isDark ? DesignTokens.darkSurface : DesignTokens.surface;
  }

  /// Get border color based on state
  Color _getBorderColor(bool isDark) {
    if (isSelected) {
      return DesignTokens.primary;
    }
    if (state == NetworkTileState.error) {
      return DesignTokens.error;
    }
    return isDark ? DesignTokens.darkOutline : DesignTokens.outline;
  }

  /// Get icon background color
  Color _getIconBackgroundColor(bool isDark) {
    if (state == NetworkTileState.disabled) {
      return isDark ? DesignTokens.darkSurfaceVariant : DesignTokens.surfaceVariant;
    }
    return isDark ? DesignTokens.darkPrimaryContainer : DesignTokens.primaryContainer;
  }

  /// Get icon color
  Color _getIconColor(bool isDark) {
    if (state == NetworkTileState.disabled) {
      return isDark ? DesignTokens.darkOnSurfaceVariant : DesignTokens.onSurfaceVariant;
    }
    return isDark ? DesignTokens.darkPrimary : DesignTokens.primary;
  }

  /// Get text color
  Color _getTextColor(bool isDark) {
    if (state == NetworkTileState.disabled) {
      return isDark ? DesignTokens.darkOnSurfaceVariant : DesignTokens.onSurfaceVariant;
    }
    return isDark ? DesignTokens.darkOnSurface : DesignTokens.onSurface;
  }

  /// Get secondary text color
  Color _getSecondaryTextColor(bool isDark) {
    return isDark ? DesignTokens.darkOnSurfaceVariant : DesignTokens.onSurfaceVariant;
  }

  /// Get fee preview background color
  Color _getFeePreviewBackgroundColor(bool isDark) {
    return isDark ? DesignTokens.darkSurfaceVariant : DesignTokens.surfaceVariant;
  }

  /// Get disabled background color
  Color _getDisabledBackgroundColor(bool isDark) {
    return isDark ? DesignTokens.darkSurfaceVariant : DesignTokens.surfaceVariant;
  }
}

