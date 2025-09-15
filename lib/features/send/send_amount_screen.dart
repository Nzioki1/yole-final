import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/pressable.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/cap_limit_banner.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';
import '../../core/analytics/analytics_provider.dart';
import 'cap_limit_state.dart';

/// Enter Amount Screen
///
/// Implements PRD Section 6.3 Send Flow Screen 2:
/// - Enter USD amount
/// - Call charges + yole-charges APIs
/// - Show You send / Yole fee / They receive (USD)
/// - Quote loading & error states
class SendAmountScreen extends ConsumerStatefulWidget {
  const SendAmountScreen({
    super.key,
    required this.recipientName,
    required this.recipientPhone,
  });

  final String recipientName;
  final String recipientPhone;

  @override
  ConsumerState<SendAmountScreen> createState() => _SendAmountScreenState();
}

class _SendAmountScreenState extends ConsumerState<SendAmountScreen> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();

  double? _sendingAmount;
  double? _yoleFee;
  double? _totalCharges;
  double? _receiveAmount;

  bool _isLoadingQuote = false;
  String? _quoteError;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    final text = _amountController.text;
    if (text.isNotEmpty) {
      final amount = double.tryParse(text);
      if (amount != null && amount > 0) {
        _fetchQuote(amount);
        _checkMpesaLimits(amount);
      } else {
        _clearQuote();
        ref.read(txKesProvider.notifier).state = null;
      }
    } else {
      _clearQuote();
      ref.read(txKesProvider.notifier).state = null;
    }
  }

  void _checkMpesaLimits(double amountUsd) {
    // TODO: Convert USD to KES using actual exchange rate
    final amountKes = amountUsd * 150.0; // Placeholder conversion rate

    // Update the txKes provider with the estimated amount
    ref.read(txKesProvider.notifier).state = amountKes;
  }

  void _clearQuote() {
    setState(() {
      _sendingAmount = null;
      _yoleFee = null;
      _totalCharges = null;
      _receiveAmount = null;
      _quoteError = null;
    });
  }

  Future<void> _fetchQuote(double amount) async {
    setState(() {
      _isLoadingQuote = true;
      _quoteError = null;
    });

    // Track quote request
    ref
        .read(analyticsProvider)
        .trackEvent(
          'quote_requested',
          parameters: {
            'amount_usd': amount,
            'recipient_country': 'CD', // DR Congo
          },
        );

    try {
      // TODO: Replace with actual API calls to charges and yole-charges endpoints
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      // Mock quote calculation
      final baseCharges = amount * 0.02; // 2% base charges
      final yoleFee = amount * 0.015; // 1.5% Yole fee
      final totalCharges = baseCharges + yoleFee;
      final receiveAmount = amount; // USD to USD, so same amount

      setState(() {
        _sendingAmount = amount;
        _yoleFee = yoleFee;
        _totalCharges = totalCharges;
        _receiveAmount = receiveAmount;
        _isLoadingQuote = false;
      });

      // Track successful quote
      ref
          .read(analyticsProvider)
          .trackEvent(
            'quote_received',
            parameters: {
              'amount_usd': amount,
              'fee_usd': yoleFee,
              'receive_amount_usd': receiveAmount,
            },
          );
    } catch (e) {
      setState(() {
        _quoteError = 'Failed to get quote. Please try again.';
        _isLoadingQuote = false;
      });

      // Track failed quote
      ref
          .read(analyticsProvider)
          .trackEvent(
            'quote_failed',
            parameters: {'amount_usd': amount, 'error': e.toString()},
          );
    }
  }

  void _continueToReview() {
    if (_sendingAmount != null && _receiveAmount != null) {
      context.go(
        '/send/review',
        extra: {
          'recipientName': widget.recipientName,
          'recipientPhone': widget.recipientPhone,
          'sendingAmount': _sendingAmount,
          'yoleFee': _yoleFee,
          'totalCharges': _totalCharges,
          'receiveAmount': _receiveAmount,
        },
      );
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
        title: Text('Enter Amount', style: textTheme.titleLarge),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: SpacingTokens.lgAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipient info
              Container(
                padding: SpacingTokens.lgAll,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(color: colorScheme.outline, width: 1),
                  borderRadius: RadiusTokens.mdAll,
                ),
                child: Row(
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
              ),

              const SizedBox(height: 24),

              // Amount input
              Text(
                'How much do you want to send?',
                style: textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _amountController,
                focusNode: _amountFocusNode,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  hintText: '0.00',
                  prefixText: '\$ ',
                  prefixStyle: textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: RadiusTokens.mdAll,
                    borderSide: BorderSide(
                      color: colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: RadiusTokens.mdAll,
                    borderSide: BorderSide(
                      color: colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: RadiusTokens.mdAll,
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                style: textTheme.headlineMedium,
              ),

              const SizedBox(height: 24),

              // Quote breakdown
              if (_isLoadingQuote) ...[
                Container(
                  padding: SpacingTokens.lgAll,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border.all(color: colorScheme.outline, width: 1),
                    borderRadius: RadiusTokens.mdAll,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('Getting quote...', style: textTheme.bodyLarge),
                    ],
                  ),
                ),
              ] else if (_quoteError != null) ...[
                Container(
                  padding: SpacingTokens.lgAll,
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    border: Border.all(color: colorScheme.error, width: 1),
                    borderRadius: RadiusTokens.mdAll,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: colorScheme.error,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _quoteError!,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                      Pressable(
                        onPressed: () {
                          if (_sendingAmount != null) {
                            _fetchQuote(_sendingAmount!);
                          }
                        },
                        child: Text(
                          'Retry',
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (_sendingAmount != null && _receiveAmount != null) ...[
                Container(
                  padding: SpacingTokens.lgAll,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border.all(color: colorScheme.outline, width: 1),
                    borderRadius: RadiusTokens.mdAll,
                  ),
                  child: Column(
                    children: [
                      _buildQuoteRow(
                        'You send',
                        _formatCurrency(_sendingAmount!),
                        colorScheme.onSurface,
                      ),
                      const SizedBox(height: 8),
                      _buildQuoteRow(
                        'Yole fee',
                        _formatCurrency(_yoleFee!),
                        colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      _buildQuoteRow(
                        'They receive',
                        _formatCurrency(_receiveAmount!),
                        colorScheme.primary,
                        isHighlight: true,
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(),

              // M-Pesa cap limit banner (appears when limits are breached)
              if (capStatus.breach != CapBreach.none)
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

              // Continue button (disabled when caps are breached)
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  onPressed:
                      _sendingAmount != null &&
                          _receiveAmount != null &&
                          capStatus.breach == CapBreach.none
                      ? _continueToReview
                      : null,
                  child: Text(
                    'Continue',
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

  Widget _buildQuoteRow(
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
