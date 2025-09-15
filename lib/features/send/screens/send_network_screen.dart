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
import '../state/send_notifier.dart';
import '../state/send_state.dart';
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
      _loadAvailableNetworks();
    });
  }

  void _loadAvailableNetworks() {
    // Mock loading of available networks
    final mockNetworks = [
      const NetworkInfo(
        id: 'mpesa',
        name: 'M-Pesa',
        type: NetworkType.mobileMoney,
        country: 'Kenya',
        currency: 'KES',
        minAmount: 10.0,
        maxAmount: 150000.0,
        feePercentage: 1.5,
        fixedFee: 0.0,
        processingTimeMinutes: 5,
        isActive: true,
        isRecommended: true,
      ),
      const NetworkInfo(
        id: 'chase',
        name: 'Chase Bank',
        type: NetworkType.bankTransfer,
        country: 'United States',
        currency: 'USD',
        minAmount: 25.0,
        maxAmount: 10000.0,
        feePercentage: 0.0,
        fixedFee: 25.0,
        processingTimeMinutes: 60,
        isActive: true,
        isRecommended: false,
      ),
      const NetworkInfo(
        id: 'venmo',
        name: 'Venmo',
        type: NetworkType.mobileMoney,
        country: 'United States',
        currency: 'USD',
        minAmount: 1.0,
        maxAmount: 5000.0,
        feePercentage: 3.0,
        fixedFee: 0.0,
        processingTimeMinutes: 2,
        isActive: true,
        isRecommended: true,
      ),
      const NetworkInfo(
        id: 'paypal',
        name: 'PayPal',
        type: NetworkType.mobileMoney,
        country: 'Global',
        currency: 'USD',
        minAmount: 1.0,
        maxAmount: 10000.0,
        feePercentage: 2.9,
        fixedFee: 0.3,
        processingTimeMinutes: 15,
        isActive: true,
        isRecommended: false,
      ),
    ];

    // Set available networks in state
    ref.read(sendNotifierProvider.notifier).setAvailableNetworks(mockNetworks);
  }

  @override
  Widget build(BuildContext context) {
    final sendState = ref.watch(sendNotifierProvider);

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
          _buildNetworksList(context, sendState),

          // Error message
          if (sendState.networkError != null)
            Container(
              width: double.infinity,
              padding: DesignTokens.spacingMdAll,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: DesignTokens.radiusLgAll,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      sendState.networkError!,
                      style: AppTypography.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottom: sendState.selectedNetwork != null
          ? SizedBox(
              width: double.infinity,
              child: GradientButton(
                key: const Key('network_next'),
                onPressed: () {
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
  Widget _buildNetworksList(BuildContext context, SendState sendState) {
    if (sendState.availableNetworks.isEmpty) {
      return _buildLoadingState(context);
    }

    return ListView.builder(
      padding: DesignTokens.spacingLgHorizontal,
      itemCount: sendState.availableNetworks.length,
      itemBuilder: (context, index) {
        final network = sendState.availableNetworks[index];
        final isSelected = sendState.selectedNetwork?.id == network.id;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildNetworkCard(context, network, isSelected),
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
