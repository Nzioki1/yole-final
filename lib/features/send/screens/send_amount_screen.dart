/// Send Money Amount Screen
///
/// This screen allows users to enter the amount to send with
/// currency selection, exchange rate preview, and fee estimates.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../design/tokens.dart';
import '../../../design/typography.dart';
import '../../../core/money.dart';
import '../../../ui/components/amount_display.dart';
import '../../../ui/layout/responsive_scaffold.dart';
import '../../../ui/layout/scroll_column.dart';
import '../../../widgets/gradient_button.dart';
import '../state/send_notifier.dart';
import '../state/send_state.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../fx/fx_repo.dart';

/// Send money amount screen
class SendAmountScreen extends ConsumerStatefulWidget {
  const SendAmountScreen({super.key});

  @override
  ConsumerState<SendAmountScreen> createState() => _SendAmountScreenState();
}

class _SendAmountScreenState extends ConsumerState<SendAmountScreen> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  bool _showCurrencySelector = false;

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
      try {
        final amount = double.parse(text);
        final sendState = ref.read(sendNotifierProvider);
        final money = Money.fromMajor(amount, sendState.fromCurrency);
        ref.read(sendNotifierProvider.notifier).setAmount(money);

        // Track amount entered
        SendFlowAnalytics.trackAmountEntered(amount, sendState.fromCurrency);

        // Calculate fees when amount changes
        ref.read(sendNotifierProvider.notifier).calculateFees();
      } catch (e) {
        // Invalid amount, ignore
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sendState = ref.watch(sendNotifierProvider);

    // Track screen view
    SendFlowAnalytics.trackStepViewed('amount');

    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('Enter Amount'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      keyboardSafe: true,
      body: ScrollColumn(
        children: [
          // Header section
          ScrollColumn(
            children: [
              Text(
                'How much would you like to send?',
                style: AppTypography.h2.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                softWrap: true,
              ),
              if (sendState.recipient != null)
                Text(
                  'To ${sendState.recipient!.name}',
                  style: AppTypography.bodyLarge.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  softWrap: true,
                ),
            ],
          ),

          // Amount display
          _buildAmountDisplay(context, sendState),

          // Amount input
          _buildAmountInput(context, sendState),

          // Currency selector
          _buildCurrencySelector(context, sendState),

          // Fee preview
          if (sendState.feeCalculation != null)
            _buildFeePreview(context, sendState),
        ],
      ),
      bottom: sendState.amount != null && sendState.amount!.minor > 0
          ? SizedBox(
              width: double.infinity,
              child: GradientButton(
                key: const Key('amount_next'),
                onPressed: () {
                  ref.read(sendNotifierProvider.notifier).completeCurrentStep();
                  context.go('/send/review');
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

  /// Build amount display
  Widget _buildAmountDisplay(BuildContext context, SendState sendState) {
    if (sendState.amount == null) {
      return Container(
        height: 80,
        alignment: Alignment.center,
        child: Text(
          'Enter amount',
          style: AppTypography.h1.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Column(
      children: [
        AmountDisplay(money: sendState.amount!, variant: 'primary'),
        if (sendState.fromCurrency != sendState.toCurrency) ...[
          const SizedBox(height: 8),
          FutureBuilder<Money>(
            future: _getConvertedAmount(
              sendState.amount!,
              sendState.toCurrency,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return AmountDisplay(
                  money: snapshot.data!,
                  variant: 'secondary',
                  showApproxFx: true,
                );
              } else if (snapshot.hasError) {
                return Text(
                  'Rate unavailable',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                );
              } else {
                return Text(
                  'Loading rate...',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                );
              }
            },
          ),
        ],
      ],
    );
  }

  /// Get converted amount using FX repo
  Future<Money> _getConvertedAmount(Money amount, String toCurrency) async {
    final fxRepo = ref.read(fxRepoProvider);
    return await fxRepo.convertAmount(amount, toCurrency);
  }

  /// Build amount input
  Widget _buildAmountInput(BuildContext context, SendState sendState) {
    return Padding(
      padding: DesignTokens.spacingLgHorizontal,
      child: TextField(
        key: const Key('amount_input'),
        controller: _amountController,
        focusNode: _amountFocusNode,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        style: AppTypography.h2.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: '0.00',
          hintStyle: AppTypography.h2.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          prefixText: '\$',
          prefixStyle: AppTypography.h2.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  /// Build currency selector
  Widget _buildCurrencySelector(BuildContext context, SendState sendState) {
    return Padding(
      padding: DesignTokens.spacingLgHorizontal,
      child: Column(
        children: [
          // Currency toggle button
          GestureDetector(
            key: const Key('currency_selector'),
            onTap: () {
              setState(() {
                _showCurrencySelector = !_showCurrencySelector;
              });
            },
            child: Container(
              padding: DesignTokens.spacingMdAll,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: DesignTokens.radiusLgAll,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    sendState.fromCurrency,
                    style: AppTypography.h4.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _showCurrencySelector
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),

          // Currency options
          if (_showCurrencySelector) ...[
            const SizedBox(height: 12),
            _buildCurrencyOptions(context, sendState),
          ],
        ],
      ),
    );
  }

  /// Build currency options
  Widget _buildCurrencyOptions(BuildContext context, SendState sendState) {
    final currencies = ['USD', 'EUR', 'GBP', 'KES', 'NGN'];

    return Container(
      padding: DesignTokens.spacingSmAll,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: DesignTokens.radiusLgAll,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: currencies.map((currency) {
          final isSelected = sendState.fromCurrency == currency;

          return GestureDetector(
            onTap: () {
              setState(() {
                _showCurrencySelector = false;
              });

              if (sendState.amount != null) {
                final newAmount = Money.fromMajor(
                  sendState.amount!.minor / 100,
                  currency,
                );
                ref
                    .read(sendNotifierProvider.notifier)
                    .setAmount(newAmount, fromCurrency: currency);
              }
            },
            child: Container(
              width: double.infinity,
              padding: DesignTokens.spacingMdAll,
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Colors.transparent,
                borderRadius: DesignTokens.radiusMdAll,
              ),
              child: Row(
                children: [
                  Text(
                    currency,
                    style: AppTypography.bodyLarge.copyWith(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  const Spacer(),
                  if (isSelected)
                    Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Build fee preview
  Widget _buildFeePreview(BuildContext context, SendState sendState) {
    final feeCalc = sendState.feeCalculation!;

    return Padding(
      padding: DesignTokens.spacingLgHorizontal,
      child: Container(
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
            const SizedBox(height: 8),
            _buildFeeRow(
              context,
              'Total Amount',
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
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
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
}
