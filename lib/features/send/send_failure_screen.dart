import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/pressable.dart';
import '../../widgets/gradient_button.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';

/// Send Failure Screen
///
/// Implements PRD Section 6.3 Send Flow Screen 4:
/// - Failure confirmation with error details
/// - Retry payment option
/// - Change payment method option
/// - Return to review screen
class SendFailureScreen extends ConsumerWidget {
  const SendFailureScreen({
    super.key,
    required this.recipientName,
    required this.recipientPhone,
    required this.sendingAmount,
    required this.receiveAmount,
    required this.orderTrackingId,
    this.errorMessage,
  });

  final String recipientName;
  final String recipientPhone;
  final double sendingAmount;
  final double receiveAmount;
  final String orderTrackingId;
  final String? errorMessage;

  void _retryPayment() {
    // TODO: Implement retry payment functionality
    // This would typically involve re-initiating the payment flow
    context.go(
      '/send/review',
      extra: {
        'recipientName': recipientName,
        'recipientPhone': recipientPhone,
        'sendingAmount': sendingAmount,
        'receiveAmount': receiveAmount,
      },
    );
  }

  void _changePaymentMethod() {
    // Navigate back to review screen to change payment method
    context.go(
      '/send/review',
      extra: {
        'recipientName': recipientName,
        'recipientPhone': recipientPhone,
        'sendingAmount': sendingAmount,
        'receiveAmount': receiveAmount,
      },
    );
  }

  void _goToDashboard() {
    context.go('/home');
  }

  String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Failed', style: textTheme.titleLarge),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: SpacingTokens.lgAll,
          child: Column(
            children: [
              const Spacer(),

              // Failure icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 48,
                  color: colorScheme.error,
                ),
              ),

              const SizedBox(height: 24),

              // Failure message
              Text(
                'Payment failed',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                errorMessage ??
                    'Your payment could not be processed. Please try again or use a different payment method.',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Transaction details
              Container(
                padding: SpacingTokens.lgAll,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(color: colorScheme.outline, width: 1),
                  borderRadius: RadiusTokens.mdAll,
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      'Recipient',
                      recipientName,
                      colorScheme.onSurface,
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'Phone',
                      recipientPhone,
                      colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'Amount',
                      _formatCurrency(sendingAmount),
                      colorScheme.onSurface,
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      'Transaction ID',
                      orderTrackingId,
                      colorScheme.onSurfaceVariant,
                      isMonospace: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: Pressable(
                      onPressed: _changePaymentMethod,
                      child: Container(
                        padding: SpacingTokens.lgAll,
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          border: Border.all(
                            color: colorScheme.outline,
                            width: 1,
                          ),
                          borderRadius: RadiusTokens.mdAll,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.payment,
                              color: colorScheme.primary,
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Change Method',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Pressable(
                      onPressed: _retryPayment,
                      child: Container(
                        padding: SpacingTokens.lgAll,
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          border: Border.all(
                            color: colorScheme.outline,
                            width: 1,
                          ),
                          borderRadius: RadiusTokens.mdAll,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.refresh,
                              color: colorScheme.primary,
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Retry',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Done button
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  onPressed: _goToDashboard,
                  child: Text(
                    'Done',
                    style: textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    Color textColor, {
    bool isMonospace = false,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: textTheme.bodyMedium?.copyWith(color: textColor)),
        Flexible(
          child: Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor,
              fontFamily: isMonospace ? 'monospace' : null,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
