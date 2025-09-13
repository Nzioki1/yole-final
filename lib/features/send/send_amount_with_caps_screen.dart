import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/mpesa_cap_banner.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';
import '../../hooks/mpesa_validation_hook.dart';

/// Example integration of M-Pesa cap validation in amount screen
///
/// This shows how to integrate the MpesaCapBanner into existing screens
/// The banner appears when M-Pesa limits are breached and disables the CTA
class SendAmountWithCapsScreen extends ConsumerStatefulWidget {
  const SendAmountWithCapsScreen({super.key});

  @override
  ConsumerState<SendAmountWithCapsScreen> createState() =>
      _SendAmountWithCapsScreenState();
}

class _SendAmountWithCapsScreenState
    extends ConsumerState<SendAmountWithCapsScreen> {
  final _amountController = TextEditingController();
  String _selectedPaymentMethod = 'mpesa';
  double _dailyTotalKes = 0.0; // TODO: Get from actual daily transaction total

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _validateAmount() {
    final amountText = _amountController.text;
    if (amountText.isEmpty) {
      ref.read(mpesaValidationProvider.notifier).clearValidation();
      return;
    }

    final amountUsd = double.tryParse(amountText) ?? 0.0;
    // TODO: Convert USD to KES using actual exchange rate
    final amountKes = amountUsd * 150.0; // Placeholder conversion rate

    // Trigger validation on amount change
    ref
        .read(mpesaValidationProvider.notifier)
        .validateOnAmountChange(
          amountKes: amountKes,
          dailyTotalKes: _dailyTotalKes,
          paymentMethod: _selectedPaymentMethod,
        );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final validationState = ref.watch(mpesaValidationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Amount'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: SpacingTokens.lgAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount input
              Text(
                'How much do you want to send?',
                style: textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount (USD)',
                  prefixText: '\$ ',
                  filled: true,
                  fillColor: colorScheme.surfaceVariant,
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
                onChanged: (_) => _validateAmount(),
              ),

              const SizedBox(height: 24),

              // Payment method selection
              Text(
                'Payment Method',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('M-Pesa'),
                      value: 'mpesa',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                        _validateAmount();
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Card'),
                      value: 'card',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                        _validateAmount();
                      },
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // M-Pesa cap banner (appears when limits are breached)
              if (validationState.shouldShowBanner)
                MpesaCapBanner(
                  capType: validationState.validationResult!.capType!,
                  resetHint: validationState.validationResult!.resetHint,
                ),

              // Continue button (disabled when caps are breached)
              GradientButton(
                onPressed: !validationState.shouldDisablePrimaryCta
                    ? () {
                        // TODO: Navigate to review screen
                      }
                    : null,
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
