import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/pressable.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/cap_limit_banner.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';
import '../../core/analytics/analytics_provider.dart';
import 'cap_limit_state.dart';

/// Review Screen
///
/// Implements PRD Section 6.3 Send Flow Screen 3:
/// - Full breakdown display
/// - Confirm & Send (disabled until KYC + email verified)
/// - Choose payment method (Card/M-Pesa)
/// - Create Yole order and open WebView
class SendReviewScreen extends ConsumerStatefulWidget {
  const SendReviewScreen({
    super.key,
    required this.recipientName,
    required this.recipientPhone,
    required this.sendingAmount,
    required this.yoleFee,
    required this.totalCharges,
    required this.receiveAmount,
  });

  final String recipientName;
  final String recipientPhone;
  final double sendingAmount;
  final double yoleFee;
  final double totalCharges;
  final double receiveAmount;

  @override
  ConsumerState<SendReviewScreen> createState() => _SendReviewScreenState();
}

class _SendReviewScreenState extends ConsumerState<SendReviewScreen> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.card;
  bool _isProcessing = false;

  // TODO: Replace with actual user state from repository/provider
  bool get _isKycComplete => true; // Mock: assume KYC is complete
  bool get _isEmailVerified => true; // Mock: assume email is verified

  bool get _canConfirmSend =>
      _isKycComplete && _isEmailVerified && !_isProcessing;

  void _selectPaymentMethod(PaymentMethod method) {
    setState(() {
      _selectedPaymentMethod = method;
    });

    // Track payment method selection
    ref
        .read(analyticsProvider)
        .paymentMethodSelected(
          method: method == PaymentMethod.card ? 'card' : 'mpesa',
        );

    // Check M-Pesa limits when M-Pesa is selected
    if (method == PaymentMethod.mpesa) {
      _checkMpesaLimits();
    } else {
      ref.read(txKesProvider.notifier).state = null;
    }
  }

  void _checkMpesaLimits() {
    // TODO: Convert USD to KES using actual exchange rate
    final amountKes =
        widget.sendingAmount * 150.0; // Placeholder conversion rate

    // Update the txKes provider with the estimated amount
    ref.read(txKesProvider.notifier).state = amountKes;
  }

  Future<void> _confirmAndSend() async {
    if (!_canConfirmSend) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // TODO: Replace with actual API calls
      // 1. Create Yole order via send-money endpoint
      // 2. Get Pesapal redirect URL
      // 3. Navigate to WebView

      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      // Mock order creation
      final orderTrackingId = 'ORDER_${DateTime.now().millisecondsSinceEpoch}';

      if (mounted) {
        context.go(
          '/send/pay',
          extra: {
            'orderTrackingId': orderTrackingId,
            'redirectUrl': 'https://cybqa.pesapal.com/pesapalv3/mock-checkout',
          },
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create order: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final capStatus = ref.watch(capStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Review & Send', style: textTheme.titleLarge),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: SpacingTokens.lgAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipient section
              Container(
                padding: SpacingTokens.lgAll,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(color: colorScheme.outline, width: 1),
                  borderRadius: RadiusTokens.mdAll,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sending to',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          child: Text(
                            widget.recipientName.isNotEmpty
                                ? widget.recipientName[0].toUpperCase()
                                : '?',
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.recipientName,
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.recipientPhone,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Amount breakdown
              Container(
                padding: SpacingTokens.lgAll,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(color: colorScheme.outline, width: 1),
                  borderRadius: RadiusTokens.mdAll,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount breakdown',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildBreakdownRow(
                      'You send',
                      _formatCurrency(widget.sendingAmount),
                      colorScheme.onSurface,
                    ),
                    const SizedBox(height: 8),
                    _buildBreakdownRow(
                      'Yole fee',
                      _formatCurrency(widget.yoleFee),
                      colorScheme.onSurfaceVariant,
                    ),
                    const Divider(height: 24),
                    _buildBreakdownRow(
                      'They receive',
                      _formatCurrency(widget.receiveAmount),
                      colorScheme.primary,
                      isHighlight: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Payment method selection
              Text('Payment method', style: textTheme.titleLarge),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Pressable(
                      onPressed: () => _selectPaymentMethod(PaymentMethod.card),
                      child: Container(
                        padding: SpacingTokens.lgAll,
                        decoration: BoxDecoration(
                          color: _selectedPaymentMethod == PaymentMethod.card
                              ? colorScheme.primary.withValues(alpha: 0.1)
                              : colorScheme.surface,
                          border: Border.all(
                            color: _selectedPaymentMethod == PaymentMethod.card
                                ? colorScheme.primary
                                : colorScheme.outline,
                            width: 1,
                          ),
                          borderRadius: RadiusTokens.mdAll,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.credit_card,
                              size: 32,
                              color:
                                  _selectedPaymentMethod == PaymentMethod.card
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Card',
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    _selectedPaymentMethod == PaymentMethod.card
                                    ? colorScheme.primary
                                    : colorScheme.onSurface,
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
                      onPressed: () =>
                          _selectPaymentMethod(PaymentMethod.mpesa),
                      child: Container(
                        padding: SpacingTokens.lgAll,
                        decoration: BoxDecoration(
                          color: _selectedPaymentMethod == PaymentMethod.mpesa
                              ? colorScheme.primary.withValues(alpha: 0.1)
                              : colorScheme.surface,
                          border: Border.all(
                            color: _selectedPaymentMethod == PaymentMethod.mpesa
                                ? colorScheme.primary
                                : colorScheme.outline,
                            width: 1,
                          ),
                          borderRadius: RadiusTokens.mdAll,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.phone_android,
                              size: 32,
                              color:
                                  _selectedPaymentMethod == PaymentMethod.mpesa
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'M-Pesa',
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    _selectedPaymentMethod ==
                                        PaymentMethod.mpesa
                                    ? colorScheme.primary
                                    : colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Verification status
              if (!_isKycComplete || !_isEmailVerified) ...[
                Container(
                  padding: SpacingTokens.lgAll,
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    border: Border.all(color: colorScheme.error, width: 1),
                    borderRadius: RadiusTokens.mdAll,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.warning_outlined,
                            color: colorScheme.error,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Verification required',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (!_isKycComplete)
                        Text(
                          '• Complete KYC verification',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      if (!_isEmailVerified)
                        Text(
                          '• Verify your email address',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              const Spacer(),

              // M-Pesa cap limit banner (appears when M-Pesa selected and limits breached)
              if (_selectedPaymentMethod == PaymentMethod.mpesa &&
                  capStatus.breach != CapBreach.none)
                CapLimitBanner(
                  title: capStatus.inlineTitle ?? '',
                  body: capStatus.inlineBody ?? '',
                  onLearnMore: () {
                    final type = (capStatus.breach == CapBreach.perTxn)
                        ? 'per_txn'
                        : 'daily';
                    context.push('/limits/mpesa?type=$type');
                  },
                ),

              // Confirm & Send button (disabled when caps are breached)
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  onPressed:
                      _canConfirmSend && capStatus.breach == CapBreach.none
                      ? _confirmAndSend
                      : null,
                  child: _isProcessing
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Processing...',
                              style: textTheme.labelLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Confirm & Send',
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

  Widget _buildBreakdownRow(
    String label,
    String amount,
    Color textColor, {
    bool isHighlight = false,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isHighlight
              ? textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                )
              : textTheme.bodyLarge?.copyWith(color: textColor),
        ),
        Text(
          amount,
          style: isHighlight
              ? textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: textColor,
                )
              : textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
        ),
      ],
    );
  }
}

enum PaymentMethod { card, mpesa }
