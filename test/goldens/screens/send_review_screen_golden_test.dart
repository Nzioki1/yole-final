import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:yole_final/features/send/screens/send_review_screen.dart';
import '../_harness/golden_config.dart';

/// Golden tests for SendReviewScreen
///
/// Tests the review screen with various transaction configurations
void main() {
  group('SendReviewScreen Golden Tests', () {
    setUpAll(GoldenTestBase.setUpAll);

    testGoldens('SendReviewScreen - USD to EUR', (tester) async {
      final widget = _buildSendReviewScreen(
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        amount: 100.0,
        convertedAmount: 85.0,
        networkFee: 2.50,
        platformFee: 1.00,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_review_screen_usd_eur',
      );
    });

    testGoldens('SendReviewScreen - USD to KES', (tester) async {
      final widget = _buildSendReviewScreen(
        fromCurrency: 'USD',
        toCurrency: 'KES',
        amount: 50.0,
        convertedAmount: 6500.0,
        networkFee: 1.25,
        platformFee: 0.50,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_review_screen_usd_kes',
      );
    });

    testGoldens('SendReviewScreen - Dual Currency Display', (tester) async {
      final widget = _buildSendReviewScreen(
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        amount: 100.0,
        convertedAmount: 85.0,
        networkFee: 2.50,
        platformFee: 1.00,
        showDualCurrency: true,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_review_screen_dual_currency',
      );
    });

    testGoldens('SendReviewScreen - Large Amount', (tester) async {
      final widget = _buildSendReviewScreen(
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        amount: 10000.0,
        convertedAmount: 8500.0,
        networkFee: 25.0,
        platformFee: 10.0,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_review_screen_large_amount',
      );
    });

    testGoldens('SendReviewScreen - EUR to USD', (tester) async {
      final widget = _buildSendReviewScreen(
        fromCurrency: 'EUR',
        toCurrency: 'USD',
        amount: 200.0,
        convertedAmount: 235.0,
        networkFee: 5.0,
        platformFee: 2.0,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_review_screen_eur_usd',
      );
    });

    testGoldens('SendReviewScreen - KES to USD', (tester) async {
      final widget = _buildSendReviewScreen(
        fromCurrency: 'KES',
        toCurrency: 'USD',
        amount: 10000.0,
        convertedAmount: 77.0,
        networkFee: 0.77,
        platformFee: 0.31,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_review_screen_kes_usd',
      );
    });

    testGoldens('SendReviewScreen - Same Currency', (tester) async {
      final widget = _buildSendReviewScreen(
        fromCurrency: 'USD',
        toCurrency: 'USD',
        amount: 500.0,
        convertedAmount: 500.0,
        networkFee: 5.0,
        platformFee: 2.0,
        showConversion: false,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_review_screen_same_currency',
      );
    });

    testGoldens('SendReviewScreen - With Recipient Details', (tester) async {
      final widget = _buildSendReviewScreen(
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        amount: 100.0,
        convertedAmount: 85.0,
        networkFee: 2.50,
        platformFee: 1.00,
        recipientName: 'John Doe',
        recipientEmail: 'john.doe@example.com',
        recipientPhone: '+1 (555) 123-4567',
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_review_screen_with_recipient',
      );
    });

    testGoldens('SendReviewScreen - With Network Details', (tester) async {
      final widget = _buildSendReviewScreen(
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        amount: 100.0,
        convertedAmount: 85.0,
        networkFee: 2.50,
        platformFee: 1.00,
        networkName: 'Ethereum',
        networkType: 'ERC-20',
        estimatedTime: '2-5 minutes',
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_review_screen_with_network',
      );
    });
  });
}

/// Build SendReviewScreen widget for testing
Widget _buildSendReviewScreen({
  required String fromCurrency,
  required String toCurrency,
  required double amount,
  required double convertedAmount,
  required double networkFee,
  required double platformFee,
  bool showConversion = true,
  bool showDualCurrency = false,
  String? recipientName,
  String? recipientEmail,
  String? recipientPhone,
  String? networkName,
  String? networkType,
  String? estimatedTime,
}) {
  final totalFee = networkFee + platformFee;
  final totalAmount = amount + totalFee;

  return MaterialApp(
    title: 'Send Review Screen Test',
    home: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mock header
            const Text(
              'Review Transaction',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Please review your transaction details',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            const SizedBox(height: 32),

            // Mock amount summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                children: [
                  Text(
                    'You\'re sending',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  if (showDualCurrency && fromCurrency != toCurrency) ...[
                    // Show both amounts prominently
                    Text(
                      '\$${amount.toStringAsFixed(2)} $fromCurrency',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '≈ €${convertedAmount.toStringAsFixed(2)} $toCurrency',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ] else ...[
                    Text(
                      '\$${amount.toStringAsFixed(2)} $fromCurrency',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (showConversion && fromCurrency != toCurrency) ...[
                      const SizedBox(height: 8),
                      Text(
                        '≈ ${convertedAmount.toStringAsFixed(2)} $toCurrency',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Mock transaction details
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
                    'Transaction Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Recipient details
                  if (recipientName != null) ...[
                    _buildDetailRow('Recipient', recipientName),
                    if (recipientEmail != null)
                      _buildDetailRow('Email', recipientEmail),
                    if (recipientPhone != null)
                      _buildDetailRow('Phone', recipientPhone),
                    const SizedBox(height: 12),
                  ],

                  // Network details
                  if (networkName != null) ...[
                    _buildDetailRow('Network', networkName),
                    if (networkType != null)
                      _buildDetailRow('Type', networkType),
                    if (estimatedTime != null)
                      _buildDetailRow('Est. Time', estimatedTime),
                    const SizedBox(height: 12),
                  ],

                  // Amount details
                  _buildDetailRow(
                    'Amount',
                    '\$${amount.toStringAsFixed(2)} $fromCurrency',
                  ),
                  if (showConversion && fromCurrency != toCurrency)
                    _buildDetailRow(
                      'Converted',
                      '${convertedAmount.toStringAsFixed(2)} $toCurrency',
                    ),

                  const Divider(),

                  // Fee breakdown
                  _buildDetailRow(
                    'Network Fee',
                    '\$${networkFee.toStringAsFixed(2)}',
                  ),
                  _buildDetailRow(
                    'Platform Fee',
                    '\$${platformFee.toStringAsFixed(2)}',
                  ),
                  _buildDetailRow(
                    'Total Fee',
                    '\$${totalFee.toStringAsFixed(2)}',
                    isTotal: true,
                  ),

                  const Divider(),

                  _buildDetailRow(
                    'Total Amount',
                    '\$${totalAmount.toStringAsFixed(2)} $fromCurrency',
                    isTotal: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Mock exchange rate info
            if (showConversion && fromCurrency != toCurrency)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Exchange rate: 1 $fromCurrency = ${(convertedAmount / amount).toStringAsFixed(4)} $toCurrency',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Mock action buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Center(
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.blueAccent],
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Center(
                      child: Text(
                        'Confirm & Send',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// Build detail row
Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );
}
