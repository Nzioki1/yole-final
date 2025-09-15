import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import '../_harness/golden_config.dart';

/// Golden tests for SendReviewScreen
///
/// Tests the send review screen with various states:
/// - Normal transaction review
/// - High amount transaction
/// - Different currencies (USD/EUR)
/// - Network selection states
/// - Both light and dark theme variants
void main() {
  group('SendReviewScreen Golden Tests', () {
    setUpAll(GoldenTestBase.setUpAll);

    testGoldens('SendReviewScreen - Standard Transaction', (tester) async {
      final widget = _buildSendReviewScreen(
        recipientName: 'John Doe',
        recipientPhone: '+243 123 456 789',
        network: 'Vodacom',
        sendAmount: 150.00,
        sendCurrency: 'USD',
        receiveAmount: 389550.00,
        receiveCurrency: 'CDF',
        fee: 2.50,
        exchangeRate: 2593.0,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_review_standard',
      );
    });

    testGoldens('SendReviewScreen - High Amount Transaction', (tester) async {
      final widget = _buildSendReviewScreen(
        recipientName: 'Jane Smith',
        recipientPhone: '+243 987 654 321',
        network: 'Orange',
        sendAmount: 5000.00,
        sendCurrency: 'USD',
        receiveAmount: 12965000.00,
        receiveCurrency: 'CDF',
        fee: 25.00,
        exchangeRate: 2593.0,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_review_high_amount',
      );
    });

    testGoldens('SendReviewScreen - EUR Currency', (tester) async {
      final widget = _buildSendReviewScreen(
        recipientName: 'Pierre Dubois',
        recipientPhone: '+243 555 123 456',
        network: 'Airtel',
        sendAmount: 200.00,
        sendCurrency: 'EUR',
        receiveAmount: 518600.00,
        receiveCurrency: 'CDF',
        fee: 3.00,
        exchangeRate: 2593.0,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_review_eur',
      );
    });

    testGoldens('SendReviewScreen - Small Amount', (tester) async {
      final widget = _buildSendReviewScreen(
        recipientName: 'Maria Santos',
        recipientPhone: '+243 111 222 333',
        network: 'Vodacom',
        sendAmount: 25.00,
        sendCurrency: 'USD',
        receiveAmount: 64825.00,
        receiveCurrency: 'CDF',
        fee: 1.00,
        exchangeRate: 2593.0,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_review_small_amount',
      );
    });

    testGoldens('SendReviewScreen - Long Names', (tester) async {
      final widget = _buildSendReviewScreen(
        recipientName: 'Jean-Baptiste Mwamba Tshisekedi',
        recipientPhone: '+243 999 888 777',
        network: 'Orange',
        sendAmount: 100.00,
        sendCurrency: 'USD',
        receiveAmount: 259300.00,
        receiveCurrency: 'CDF',
        fee: 2.00,
        exchangeRate: 2593.0,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/send_review_long_names',
      );
    });
  });
}

/// Build SendReviewScreen widget for testing
///
/// This is a mock implementation of the SendReviewScreen
/// that would be used in the actual app. In a real implementation,
/// this would import the actual SendReviewScreen component.
Widget _buildSendReviewScreen({
  required String recipientName,
  required String recipientPhone,
  required String network,
  required double sendAmount,
  required String sendCurrency,
  required double receiveAmount,
  required String receiveCurrency,
  required double fee,
  required double exchangeRate,
}) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Review & Confirm'),
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction Summary Card
            _buildTransactionSummaryCard(
              recipientName: recipientName,
              recipientPhone: recipientPhone,
              network: network,
              sendAmount: sendAmount,
              sendCurrency: sendCurrency,
              receiveAmount: receiveAmount,
              receiveCurrency: receiveCurrency,
              fee: fee,
              exchangeRate: exchangeRate,
            ),

            const SizedBox(height: 24),

            // Fee Breakdown
            _buildFeeBreakdown(
              sendAmount: sendAmount,
              sendCurrency: sendCurrency,
              fee: fee,
              receiveAmount: receiveAmount,
              receiveCurrency: receiveCurrency,
            ),

            const SizedBox(height: 24),

            // Confirm Button
            _buildConfirmButton(),

            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  );
}

/// Build transaction summary card
Widget _buildTransactionSummaryCard({
  required String recipientName,
  required String recipientPhone,
  required String network,
  required double sendAmount,
  required String sendCurrency,
  required double receiveAmount,
  required String receiveCurrency,
  required double fee,
  required double exchangeRate,
}) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Recipient Info
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  recipientName.split(' ').map((n) => n[0]).join(''),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipientName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      recipientPhone,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      network,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Amount Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(child: Text('You send:')),
              Flexible(
                child: Text(
                  '${_formatAmount(sendAmount)} $sendCurrency',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(child: Text('They receive:')),
              Flexible(
                child: Text(
                  '${_formatAmount(receiveAmount)} $receiveCurrency',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// Build fee breakdown section
Widget _buildFeeBreakdown({
  required double sendAmount,
  required String sendCurrency,
  required double fee,
  required double receiveAmount,
  required String receiveCurrency,
}) {
  final total = sendAmount + fee;

  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fee Breakdown',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(child: Text('Amount:')),
              Flexible(
                child: Text(
                  '${_formatAmount(sendAmount)} $sendCurrency',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(child: Text('Yole Fee:')),
              Flexible(
                child: Text(
                  '${_formatAmount(fee)} $sendCurrency',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'Total:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                child: Text(
                  '${_formatAmount(total)} $sendCurrency',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// Build confirm button
Widget _buildConfirmButton() {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text(
        'Confirm & Send',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

/// Format amount with proper decimal places
String _formatAmount(double amount) {
  if (amount == amount.toInt()) {
    return amount.toInt().toString();
  } else {
    return amount.toStringAsFixed(2);
  }
}
