import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/pressable.dart';
import '../../widgets/gradient_button.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';

/// Send Success Screen
///
/// Implements PRD Section 6.3 Send Flow Screen 4:
/// - Success confirmation with transaction details
/// - Share functionality
/// - Repeat send option
/// - Return to dashboard
class SendSuccessScreen extends ConsumerWidget {
  const SendSuccessScreen({
    super.key,
    required this.recipientName,
    required this.recipientPhone,
    required this.sendingAmount,
    required this.receiveAmount,
    required this.orderTrackingId,
  });

  final String recipientName;
  final String recipientPhone;
  final double sendingAmount;
  final double receiveAmount;
  final String orderTrackingId;

  void _shareTransaction() {
    // TODO: Implement share functionality
    // Share transaction details via system share sheet
  }

  void _repeatSend() {
    context.go('/send/recipient');
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
        title: Text('Payment Successful', style: textTheme.titleLarge),
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

              // Success icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 48,
                  color: colorScheme.primary,
                ),
              ),

              const SizedBox(height: 24),

              // Success message
              Text(
                'Money sent successfully!',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'Your payment has been processed and the recipient will receive the funds shortly.',
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
                      'Sent to',
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
                      'Amount sent',
                      _formatCurrency(sendingAmount),
                      colorScheme.onSurface,
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'Amount received',
                      _formatCurrency(receiveAmount),
                      colorScheme.primary,
                      isHighlight: true,
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
                      onPressed: _shareTransaction,
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
                              Icons.share,
                              color: colorScheme.primary,
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Share',
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
                      onPressed: _repeatSend,
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
                              Icons.repeat,
                              color: colorScheme.primary,
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Repeat',
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
    bool isHighlight = false,
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
            style: isHighlight
                ? textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  )
                : textTheme.bodyMedium?.copyWith(
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
