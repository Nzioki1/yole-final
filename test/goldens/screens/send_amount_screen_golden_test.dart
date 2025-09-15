import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:yole_final/features/send/screens/send_amount_screen.dart';
import '../_harness/golden_config.dart';

/// Golden tests for SendAmountScreen
///
/// Tests the amount input screen with various states and configurations
void main() {
  group('SendAmountScreen Golden Tests', () {
    setUpAll(GoldenTestBase.setUpAll);

    testGoldens('SendAmountScreen - Default State', (tester) async {
      final widget = _buildSendAmountScreen();

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_amount_screen_default',
      );
    });

    testGoldens('SendAmountScreen - With Amount', (tester) async {
      final widget = _buildSendAmountScreen(hasAmount: true);

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_amount_screen_with_amount',
      );
    });

    testGoldens('SendAmountScreen - With Fee Preview', (tester) async {
      final widget = _buildSendAmountScreen(
        hasAmount: true,
        hasFeeCalculation: true,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_amount_screen_with_fees',
      );
    });

    testGoldens('SendAmountScreen - Currency Selector Open', (tester) async {
      final widget = _buildSendAmountScreen(
        hasAmount: true,
        showCurrencySelector: true,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_amount_screen_currency_selector',
      );
    });

    testGoldens('SendAmountScreen - Dual Currency Display', (tester) async {
      final widget = _buildSendAmountScreen(
        hasAmount: true,
        hasFeeCalculation: true,
        currency: 'EUR',
        showDualCurrency: true,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_amount_screen_dual_currency',
      );
    });

    testGoldens('SendAmountScreen - EUR Currency', (tester) async {
      final widget = _buildSendAmountScreen(
        hasAmount: true,
        currency: 'EUR',
        hasFeeCalculation: true,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_amount_screen_eur',
      );
    });

    testGoldens('SendAmountScreen - KES Currency', (tester) async {
      final widget = _buildSendAmountScreen(
        hasAmount: true,
        currency: 'KES',
        hasFeeCalculation: true,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_amount_screen_kes',
      );
    });

    testGoldens('SendAmountScreen - Large Amount', (tester) async {
      final widget = _buildSendAmountScreen(
        hasAmount: true,
        amount: 50000.0,
        hasFeeCalculation: true,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_amount_screen_large_amount',
      );
    });

    testGoldens('SendAmountScreen - With Recipient', (tester) async {
      final widget = _buildSendAmountScreen(
        hasAmount: true,
        hasRecipient: true,
        hasFeeCalculation: true,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_amount_screen_with_recipient',
      );
    });
  });
}

/// Build SendAmountScreen widget for testing
Widget _buildSendAmountScreen({
  bool hasAmount = false,
  bool hasFeeCalculation = false,
  bool showCurrencySelector = false,
  bool hasRecipient = false,
  String currency = 'USD',
  double amount = 100.0,
  bool showDualCurrency = false,
}) {
  return MaterialApp(
    title: 'Send Amount Screen Test',
    home: Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mock header
              const Text(
                'How much would you like to send?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (hasRecipient) ...[
                const SizedBox(height: 8),
                Text(
                  'To John Doe',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],

              const SizedBox(height: 32),

              // Mock amount display
              if (hasAmount)
                Container(
                  height: showDualCurrency ? 100 : 80,
                  alignment: Alignment.center,
                  child: showDualCurrency
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '\$${amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '€${(amount * 0.85).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        )
                      : Text(
                          '\$${amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                )
              else
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: Text(
                    'Enter amount',
                    style: TextStyle(fontSize: 48, color: Colors.grey[400]),
                  ),
                ),

              const SizedBox(height: 32),

              // Mock amount input
              Container(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '0.00',
                    prefixText: '\$',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 32, letterSpacing: 4),
                ),
              ),

              const SizedBox(height: 24),

              // Mock currency selector
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currency,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      showCurrencySelector
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),

              if (showCurrencySelector) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: ['USD', 'EUR', 'GBP', 'KES', 'NGN'].map((curr) {
                      final isSelected = curr == currency;
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue[50]
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              curr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: isSelected ? Colors.blue : Colors.black,
                              ),
                            ),
                            const Spacer(),
                            if (isSelected)
                              const Icon(
                                Icons.check,
                                color: Colors.blue,
                                size: 20,
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Mock fee preview
              if (hasFeeCalculation)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fee Breakdown',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildFeeRow('Network Fee', '\$2.50'),
                      _buildFeeRow('Platform Fee', '\$1.00'),
                      const Divider(),
                      _buildFeeRow('Total Fee', '\$3.50', isTotal: true),
                      const SizedBox(height: 8),
                      _buildFeeRow('Total Amount', '\$103.50', isTotal: true),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Exchange rate: 1 USD = 0.8500 EUR',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 32),

              // Mock continue button
              if (hasAmount)
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.blueAccent],
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Build fee row
Widget _buildFeeRow(String label, String amount, {bool isTotal = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}
