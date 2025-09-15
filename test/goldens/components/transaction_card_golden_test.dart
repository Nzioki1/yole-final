import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:yole_final/ui/components/transaction_card.dart';
import 'package:yole_final/core/money.dart';
import '../_harness/golden_config.dart';

/// Golden tests for TransactionCard component
///
/// Tests various transaction card scenarios including:
/// - Pending transactions
/// - Successful transactions
/// - Failed transactions
/// - Different transaction types
/// - Both light and dark theme variants
void main() {
  group('TransactionCard Golden Tests', () {
    setUpAll(GoldenTestBase.setUpAll);

    testGoldens('TransactionCard - Pending Transaction', (tester) async {
      final widget = _buildTransactionCard(
        id: '1',
        title: 'Send Money',
        subtitle: 'To John Doe',
        amount: Money.fromMajor(150.75, 'USD'),
        status: 'pending',
        icon: Icons.send,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/transaction_card_pending',
      );
    });

    testGoldens('TransactionCard - Successful Transaction', (tester) async {
      final widget = _buildTransactionCard(
        id: '2',
        title: 'Payment Received',
        subtitle: 'From Jane Smith',
        amount: Money.fromMajor(2500.00, 'USD'),
        status: 'success',
        icon: Icons.call_received,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/transaction_card_success',
      );
    });

    testGoldens('TransactionCard - Failed Transaction', (tester) async {
      final widget = _buildTransactionCard(
        id: '3',
        title: 'Transfer Failed',
        subtitle: 'To Bank Account',
        amount: Money.fromMajor(500.00, 'USD'),
        status: 'failed',
        icon: Icons.swap_horiz,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/transaction_card_failed',
      );
    });

    testGoldens('TransactionCard - Reversed Transaction', (tester) async {
      final widget = _buildTransactionCard(
        id: '4',
        title: 'Refund Processed',
        subtitle: 'Original Payment',
        amount: Money.fromMajor(75.50, 'USD'),
        status: 'reversed',
        icon: Icons.keyboard_return,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/transaction_card_reversed',
      );
    });

    testGoldens('TransactionCard - EUR Currency', (tester) async {
      final widget = _buildTransactionCard(
        id: '5',
        title: 'International Transfer',
        subtitle: 'To European Bank',
        amount: Money.fromMajor(1000.00, 'EUR'),
        status: 'success',
        icon: Icons.swap_horiz,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/transaction_card_eur',
      );
    });

    testGoldens('TransactionCard - KES Currency', (tester) async {
      final widget = _buildTransactionCard(
        id: '6',
        title: 'M-Pesa Payment',
        subtitle: 'To Mobile Number',
        amount: Money.fromMajor(5000.00, 'KES'),
        status: 'success',
        icon: Icons.payment,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/transaction_card_kes',
      );
    });

    testGoldens('TransactionCard - Large Amount', (tester) async {
      final widget = _buildTransactionCard(
        id: '7',
        title: 'Business Payment',
        subtitle: 'Invoice #12345',
        amount: Money.fromMajor(50000.00, 'USD'),
        status: 'success',
        icon: Icons.payment,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/transaction_card_large_amount',
      );
    });

    testGoldens('TransactionCard - Without Icon', (tester) async {
      final widget = _buildTransactionCard(
        id: '8',
        title: 'Deposit',
        subtitle: 'Bank Transfer',
        amount: Money.fromMajor(1000.00, 'USD'),
        status: 'success',
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/transaction_card_no_icon',
      );
    });

    testGoldens('TransactionCard - Fee Charge', (tester) async {
      final widget = _buildTransactionCard(
        id: '9',
        title: 'Fee Charge',
        subtitle: 'Service Fee',
        amount: Money.fromMajor(2.50, 'USD'),
        status: 'success',
        icon: Icons.account_balance_wallet,
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/transaction_card_fee',
      );
    });

    testGoldens('TransactionCard - All Statuses Comparison', (tester) async {
      final widget = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTransactionCard(
            id: '1',
            title: 'Pending Transaction',
            subtitle: 'Processing...',
            amount: Money.fromMajor(100.00, 'USD'),
            status: 'pending',
            icon: Icons.send,
          ),
          const SizedBox(height: 8),
          _buildTransactionCard(
            id: '2',
            title: 'Successful Transaction',
            subtitle: 'Completed',
            amount: Money.fromMajor(100.00, 'USD'),
            status: 'success',
            icon: Icons.call_received,
          ),
          const SizedBox(height: 8),
          _buildTransactionCard(
            id: '3',
            title: 'Failed Transaction',
            subtitle: 'Error occurred',
            amount: Money.fromMajor(100.00, 'USD'),
            status: 'failed',
            icon: Icons.swap_horiz,
          ),
          const SizedBox(height: 8),
          _buildTransactionCard(
            id: '4',
            title: 'Reversed Transaction',
            subtitle: 'Refunded',
            amount: Money.fromMajor(100.00, 'USD'),
            status: 'reversed',
            icon: Icons.keyboard_return,
          ),
        ],
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/transaction_card_all_statuses',
      );
    });
  });
}

/// Build TransactionCard widget for testing
Widget _buildTransactionCard({
  required String id,
  required String title,
  String? subtitle,
  required Money amount,
  required String status,
  IconData? icon,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: TransactionCard(
      id: id,
      title: title,
      subtitle: subtitle,
      amount: amount,
      status: status,
      icon: icon,
    ),
  );
}
