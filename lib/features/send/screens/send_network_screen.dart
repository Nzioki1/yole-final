/// Send Money Network Screen
///
/// This screen allows users to select the network/method
/// for money transfer with validation and error handling.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../design/tokens.dart';
import '../../../design/typography.dart';
import '../../../widgets/gradient_button.dart';
import '../../../ui/layout/responsive_scaffold.dart';
import '../../../ui/layout/scroll_column.dart';
import '../../../ui/components/network_tile.dart';
import '../../../ui/errors/error_banner.dart';
import '../../../core/errors/app_error.dart';
import '../state/send_notifier.dart';
import '../state/send_state.dart';
import '../providers/network_selection_provider.dart';
import '../../../core/analytics/analytics_service.dart';

/// Send money network screen
class SendNetworkScreen extends ConsumerStatefulWidget {
  const SendNetworkScreen({super.key});

  @override
  ConsumerState<SendNetworkScreen> createState() => _SendNetworkScreenState();
}

class _SendNetworkScreenState extends ConsumerState<SendNetworkScreen> {
  @override
  void initState() {
    super.initState();
    // Load available networks when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNetworks();
    });
  }

  /// Load networks using the new provider
  Future<void> _loadNetworks() async {
    final sendState = ref.read(sendNotifierProvider);
    await ref.read(networkSelectionProvider.notifier).loadNetworks(
      currency: sendState.fromCurrency,
    );
  }

  /// Select a network
  void _selectNetwork(NetworkInfo network) {
    ref.read(networkSelectionProvider.notifier).selectNetwork(network);
    SendFlowAnalytics.trackNetworkSelected(network.name);
  }

  /// Get network tile state
  NetworkTileState _getNetworkTileState(NetworkSelectionState networkState, NetworkInfo network) {
    if (networkState.isLoading) {
      return NetworkTileState.loading;
    }
    
    if (networkState.validationErrors.containsKey(network.id)) {
      return NetworkTileState.error;
    }
    
    if (networkState.isNetworkDisabled(network)) {
      return NetworkTileState.disabled;
    }
    
    return NetworkTileState.available;
  }

  @override
  Widget build(BuildContext context) {
    final sendState = ref.watch(sendNotifierProvider);
    final networkState = ref.watch(networkSelectionProvider);

    // Track screen view
    SendFlowAnalytics.trackStepViewed('network');

    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('Select Network'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ScrollColumn(
        children: [
          // Header section
          ScrollColumn(
            children: [
              Text(
                'How would you like to send?',
                style: AppTypography.h2.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                softWrap: true,
              ),
              Text(
                'Choose the best option for your recipient',
                style: AppTypography.bodyLarge.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                softWrap: true,
              ),
            ],
          ),

          // Networks list
          _buildNetworksList(context, networkState),

          // Error message
          if (networkState.error != null)
            ErrorBanner(
              error: AppError.unknown(detail: networkState.error!),
              onRetry: () => _loadNetworks(),
            ),
        ],
      ),
      bottom: networkState.selectedNetwork != null
          ? SizedBox(
              width: double.infinity,
              child: GradientButton(
                key: const Key('network_next'),
                onPressed: () {
                  ref.read(sendNotifierProvider.notifier).setSelectedNetwork(networkState.selectedNetwork!);
                  ref.read(sendNotifierProvider.notifier).completeCurrentStep();
                  context.go('/send/amount');
                },
                child: Text(
                  'Continue',
                  style: AppTypography.buttonLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  /// Build networks list
  Widget _buildNetworksList(BuildContext context, NetworkSelectionState networkState) {
    if (networkState.isLoading) {
      return _buildLoadingState(context);
    }

    if (networkState.networks.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: networkState.networks.length,
      itemBuilder: (context, index) {
        final network = networkState.networks[index];
        final isSelected = networkState.selectedNetwork?.id == network.id;
        final isDisabled = networkState.isNetworkDisabled(network);
        final disabledReason = networkState.getDisabledReason(network);
        final feePreview = networkState.getFeePreview(network);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: NetworkTile(
            network: network,
            amount: networkState.amount,
            currentCurrency: networkState.currency,
            isSelected: isSelected,
            state: _getNetworkTileState(networkState, network),
            feePreview: feePreview,
            onTap: isDisabled ? null : () => _selectNetwork(network),
            disabledReason: disabledReason,
            showFeePreview: networkState.amount != null,
          ),
        );
      },
    );
  }

  /// Build loading state
  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading available networks...',
            style: AppTypography.bodyLarge.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No networks available',
            style: AppTypography.h3.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your connection and try again',
            style: AppTypography.bodyLarge.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build network card
  Widget _buildNetworkCard(
    BuildContext context,
    NetworkInfo network,
    bool isSelected,
  ) {
    return GestureDetector(
      key: Key('network_item_${network.id.toLowerCase()}'),
      onTap: () {
        ref.read(sendNotifierProvider.notifier).setSelectedNetwork(network);
        SendFlowAnalytics.trackNetworkSelected(network.name);
      },
      child: Container(
        padding: DesignTokens.spacingMdAll,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surface,
          borderRadius: DesignTokens.radiusLgAll,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Network icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: DesignTokens.radiusLgAll,
                  ),
                  child: Icon(
                    _getNetworkIcon(network.type),
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 16),

                // Network info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              network.name,
                              style: AppTypography.h4.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (network.isRecommended)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: DesignTokens.radiusPillAll,
                              ),
                              child: Text(
                                'Recommended',
                                style: AppTypography.labelSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${network.country} • ${network.currency}',
                        style: AppTypography.bodyMedium.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // Selection indicator
                if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: DesignTokens.radiusPillAll,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Network details
            Row(
              children: [
                _buildNetworkDetail(
                  context,
                  Icons.access_time,
                  '${network.processingTimeMinutes} min',
                ),
                const SizedBox(width: 16),
                _buildNetworkDetail(
                  context,
                  Icons.attach_money,
                  _formatFee(network),
                ),
                const SizedBox(width: 16),
                _buildNetworkDetail(
                  context,
                  Icons.trending_up,
                  '${network.minAmount.toInt()}-${network.maxAmount.toInt()} ${network.currency}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build network detail
  Widget _buildNetworkDetail(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTypography.bodySmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Format fee display
  String _formatFee(NetworkInfo network) {
    if (network.feePercentage > 0 && network.fixedFee > 0) {
      return '${network.feePercentage}% + ${network.fixedFee} ${network.currency}';
    } else if (network.feePercentage > 0) {
      return '${network.feePercentage}%';
    } else if (network.fixedFee > 0) {
      return '${network.fixedFee} ${network.currency}';
    } else {
      return 'Free';
    }
  }

  /// Get network icon
  IconData _getNetworkIcon(NetworkType networkType) {
    switch (networkType) {
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
}
