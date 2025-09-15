/// Send Money Success Screen
///
/// This screen shows the successful completion of the money transfer
/// with animation and transaction details.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../design/tokens.dart';
import '../../../design/typography.dart';
import '../../../ui/components/amount_display.dart';
import '../../../ui/components/transaction_card.dart';
import '../../../ui/components/success_animation.dart';
import '../../../ui/layout/responsive_scaffold.dart';
import '../../../ui/layout/scroll_column.dart';
import '../../../widgets/gradient_button.dart';
import '../state/send_notifier.dart';
import '../state/send_state.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/money.dart';

/// Send money success screen
class SendSuccessScreen extends ConsumerStatefulWidget {
  const SendSuccessScreen({super.key});

  @override
  ConsumerState<SendSuccessScreen> createState() => _SendSuccessScreenState();
}

class _SendSuccessScreenState extends ConsumerState<SendSuccessScreen> {
  bool _showDetails = false;

  @override
  void initState() {
    super.initState();
    // Mark the success step as completed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sendNotifierProvider.notifier).completeCurrentStep();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sendState = ref.watch(sendNotifierProvider);

    // Track screen view
    SendFlowAnalytics.trackStepViewed('success');

    if (sendState.transactionId == null) {
      // Redirect if no transaction ID
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/send/start');
      });

      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ResponsiveScaffold(
      key: const Key('send_success_screen'),
      body: ScrollColumn(
        children: [
          // Success animation
          ScrollColumn(
            children: [
              SuccessAnimation(duration: const Duration(seconds: 3)),

              Text(
                'Money sent successfully',
                style: AppTypography.h2.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),

              Text(
                'Your transfer has been processed and the recipient will receive the money shortly.',
                style: AppTypography.bodyLarge.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ],
          ),

          // Transaction card
          _buildTransactionCard(context, sendState),

          // Action buttons
          _buildActionButtons(context, sendState),
        ],
      ),
    );
  }

  /// Build transaction card
  Widget _buildTransactionCard(BuildContext context, SendState sendState) {
    return Container(
      width: double.infinity,
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
          // Transaction header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: DesignTokens.radiusLgAll,
                ),
                child: Icon(
                  Icons.send,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transfer to ${sendState.recipient!.name}',
                      style: AppTypography.h4.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Transaction ID: ${sendState.transactionId}',
                      style: AppTypography.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Amount
              AmountDisplay(money: sendState.amount!, variant: 'primary'),
            ],
          ),

          const SizedBox(height: 16),

          // Transaction details
          _buildTransactionDetails(context, sendState),

          const SizedBox(height: 16),

          // Toggle details button
          GestureDetector(
            onTap: () {
              setState(() {
                _showDetails = !_showDetails;
              });
            },
            child: Row(
              children: [
                Text(
                  _showDetails ? 'Hide Details' : 'Show Details',
                  style: AppTypography.labelMedium.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _showDetails
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
              ],
            ),
          ),

          // Detailed information
          if (_showDetails) ...[
            const SizedBox(height: 16),
            _buildDetailedInfo(context, sendState),
          ],
        ],
      ),
    );
  }

  /// Build transaction details
  Widget _buildTransactionDetails(BuildContext context, SendState sendState) {
    return Column(
      children: [
        _buildDetailRow(context, 'Recipient', sendState.recipient!.name),
        _buildDetailRow(context, 'Network', sendState.selectedNetwork!.name),
        _buildDetailRow(
          context,
          'Processing Time',
          '${sendState.selectedNetwork!.processingTimeMinutes} minutes',
        ),
        _buildDetailRow(context, 'Status', 'Completed', isStatus: true),
      ],
    );
  }

  /// Build detailed information
  Widget _buildDetailedInfo(BuildContext context, SendState sendState) {
    final feeCalc = sendState.feeCalculation!;

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
            'Fee Breakdown',
            style: AppTypography.h4.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          _buildFeeRow(context, 'Network Fee', feeCalc.networkFee),
          _buildFeeRow(context, 'Platform Fee', feeCalc.platformFee),
          const Divider(),
          _buildFeeRow(context, 'Total Fee', feeCalc.totalFee, isTotal: true),

          const SizedBox(height: 16),

          Text(
            'Transaction Info',
            style: AppTypography.h4.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          _buildDetailRow(
            context,
            'Transaction ID',
            sendState.transactionId!,
            isMonospace: true,
          ),
          _buildDetailRow(
            context,
            'Date & Time',
            _formatDateTime(DateTime.now()),
          ),
          _buildDetailRow(
            context,
            'Exchange Rate',
            feeCalc.exchangeRate != 1.0
                ? '1 ${sendState.fromCurrency} = ${feeCalc.exchangeRate.toStringAsFixed(4)} ${sendState.toCurrency}'
                : 'N/A',
          ),
        ],
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons(BuildContext context, SendState sendState) {
    return Column(
      children: [
        // Send more money button
        SizedBox(
          width: double.infinity,
          child: GradientButton(
            onPressed: () {
              ref.read(sendNotifierProvider.notifier).resetFlow();
              context.go('/send/start');
            },
            child: Text(
              'Send More Money',
              style: AppTypography.buttonLarge.copyWith(color: Colors.white),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // View transaction history button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // TODO: Navigate to transaction history
              context.go('/transactions');
            },
            style: OutlinedButton.styleFrom(
              padding: DesignTokens.spacingMdVertical,
              shape: RoundedRectangleBorder(
                borderRadius: DesignTokens.radiusLgAll,
              ),
              side: BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
            child: Text(
              'View Transaction History',
              style: AppTypography.buttonLarge.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Done button
        TextButton(
          onPressed: () {
            context.go('/home');
          },
          child: Text(
            'Done',
            style: AppTypography.buttonMedium.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  /// Build detail row
  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isStatus = false,
    bool isMonospace = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: isStatus
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: isStatus ? FontWeight.w600 : FontWeight.normal,
              fontFamily: isMonospace ? 'monospace' : null,
            ),
          ),
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

  /// Format date and time
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
