/// Send Money Review Screen
///
/// This screen shows a summary of the transaction details
/// before final submission.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../design/tokens.dart';
import '../../../design/typography.dart';
import '../../../ui/components/amount_display.dart';
import '../../../ui/components/transaction_card.dart';
import '../../../ui/layout/responsive_scaffold.dart';
import '../../../ui/layout/scroll_column.dart';
import '../../../widgets/gradient_button.dart';
import '../state/send_notifier.dart';
import '../state/send_state.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/money.dart';

/// Send money review screen
class SendReviewScreen extends ConsumerWidget {
  const SendReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sendState = ref.watch(sendNotifierProvider);

    // Track screen view
    SendFlowAnalytics.trackStepViewed('review');

    if (!sendState.canSubmit) {
      // Redirect to appropriate step if data is missing
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (sendState.recipient == null) {
          context.go('/send/recipient');
        } else if (sendState.selectedNetwork == null) {
          context.go('/send/network');
        } else if (sendState.amount == null) {
          context.go('/send/amount');
        }
      });

      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('Review Transfer'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ScrollColumn(
        children: [
          // Header
          ScrollColumn(
            children: [
              Text(
                'Review your transfer',
                style: AppTypography.h2.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                softWrap: true,
              ),
              Text(
                'Please verify all details before sending',
                style: AppTypography.bodyLarge.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                softWrap: true,
              ),
            ],
          ),

          // Transaction summary card
          _buildTransactionSummaryCard(context, sendState),

          // Amount section
          _buildAmountSection(context, sendState),

          // Recipient section
          _buildRecipientSection(context, sendState),

          // Network section
          _buildNetworkSection(context, sendState),

          // Fee breakdown
          _buildFeeBreakdown(context, sendState),

          // Terms and conditions
          _buildTermsSection(context),
        ],
      ),
      bottom: SizedBox(
        width: double.infinity,
        child: GradientButton(
          key: const Key('review_confirm'),
          onPressed: sendState.isSubmitting
              ? null
              : () {
                  ref.read(sendNotifierProvider.notifier).completeCurrentStep();
                  SendFlowAnalytics.trackSubmit(
                    fromCurrency: sendState.fromCurrency,
                    toCurrency: sendState.toCurrency,
                    amount: sendState.amount?.major ?? 0.0,
                    network: sendState.selectedNetwork?.name ?? '',
                    recipientType: 'email',
                  );
                  context.go('/send/auth');
                },
          child: sendState.isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'Continue to Authentication',
                  style: AppTypography.buttonLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  /// Build amount section
  Widget _buildAmountSection(BuildContext context, SendState sendState) {
    return _buildSection(
      context,
      'Amount',
      Icons.attach_money,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AmountDisplay(money: sendState.amount!, variant: 'primary'),
          const SizedBox(height: 8),
          Text(
            'Sending from ${sendState.fromCurrency}',
            style: AppTypography.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Build recipient section
  Widget _buildRecipientSection(BuildContext context, SendState sendState) {
    final recipient = sendState.recipient!;

    return _buildSection(
      context,
      'Recipient',
      Icons.person,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipient.name,
            style: AppTypography.h4.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            recipient.phoneNumber,
            style: AppTypography.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (recipient.email != null) ...[
            const SizedBox(height: 2),
            Text(
              recipient.email!,
              style: AppTypography.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                _getNetworkIcon(recipient.networkType),
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                recipient.networkName,
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build network section
  Widget _buildNetworkSection(BuildContext context, SendState sendState) {
    final network = sendState.selectedNetwork!;

    return _buildSection(
      context,
      'Transfer Method',
      _getNetworkIcon(network.type),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            network.name,
            style: AppTypography.h4.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${network.country} • ${network.currency}',
            style: AppTypography.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
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
                Icons.verified,
                network.isRecommended ? 'Recommended' : 'Standard',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build fee breakdown
  Widget _buildFeeBreakdown(BuildContext context, SendState sendState) {
    final feeCalc = sendState.feeCalculation!;

    return _buildSection(
      context,
      'Fee Breakdown',
      Icons.receipt,
      Column(
        children: [
          _buildFeeRow(context, 'Amount to send', sendState.amount!),
          _buildFeeRow(context, 'Network fee', feeCalc.networkFee),
          _buildFeeRow(context, 'Platform fee', feeCalc.platformFee),
          const Divider(),
          _buildFeeRow(context, 'Total fee', feeCalc.totalFee, isTotal: true),
          _buildFeeRow(
            context,
            'Total amount',
            feeCalc.totalAmount,
            isTotal: true,
          ),
          if (feeCalc.exchangeRate != 1.0) ...[
            const SizedBox(height: 12),
            Container(
              padding: DesignTokens.spacingSmAll,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: DesignTokens.radiusMdAll,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Exchange rate: 1 ${sendState.fromCurrency} = ${feeCalc.exchangeRate.toStringAsFixed(4)} ${sendState.toCurrency}',
                      style: AppTypography.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build terms section
  Widget _buildTermsSection(BuildContext context) {
    return Container(
      padding: DesignTokens.spacingMdAll,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: DesignTokens.radiusLgAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Terms & Conditions',
            style: AppTypography.h4.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'By continuing, you agree to our Terms of Service and Privacy Policy. '
            'Transfer fees are non-refundable. Processing times may vary based on the selected network.',
            style: AppTypography.bodySmall.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// Build section container
  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    Widget content,
  ) {
    return Container(
      padding: DesignTokens.spacingMdAll,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: DesignTokens.radiusLgAll,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTypography.h4.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  /// Build fee row
  Widget _buildFeeRow(
    BuildContext context,
    String label,
    Money amount, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            key: isTotal && label == 'Total amount'
                ? const Key('review_total')
                : null,
            style: AppTypography.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          AmountDisplay(money: amount, variant: 'secondary'),
        ],
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

  /// Build transaction summary card using TransactionCard
  Widget _buildTransactionSummaryCard(
    BuildContext context,
    SendState sendState,
  ) {
    final recipient = sendState.recipient!;
    final amount = sendState.amount!;
    final feeCalc = sendState.feeCalculation!;

    return TransactionCard(
      id: 'review_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Send to ${recipient.name}',
      subtitle: '${recipient.phoneNumber} • ${sendState.selectedNetwork!.name}',
      amount: amount,
      status: 'pending',
      icon: _getNetworkIcon(recipient.networkType),
    );
  }
}
