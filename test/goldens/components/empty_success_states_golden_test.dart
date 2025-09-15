/// Golden tests for empty and success state components
///
/// Tests the visual appearance of:
/// - EmptyState components in various scenarios
/// - SuccessState components with static frames
/// - Different themes (light/dark)
/// - Various content configurations
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:yole_final/ui/states/empty_state.dart';
import 'package:yole_final/ui/states/success_state.dart';
import 'package:yole_final/ui/motion/motion.dart';

void main() {
  group('Empty and Success States Golden Tests', () {
    group('EmptyState Tests', () {
      testGoldens('EmptyState - No Transactions', (tester) async {
        await tester.pumpWidgetBuilder(
          EmptyStates.noTransactions(
            staticFrame: const Duration(seconds: 1),
            onSendMoney: () {},
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'empty_state_no_transactions');
      });

      testGoldens('EmptyState - No Favorites', (tester) async {
        await tester.pumpWidgetBuilder(
          EmptyStates.noFavorites(
            staticFrame: const Duration(seconds: 1),
            onAddFavorite: () {},
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'empty_state_no_favorites');
      });

      testGoldens('EmptyState - No Notifications', (tester) async {
        await tester.pumpWidgetBuilder(
          EmptyStates.noNotifications(
            staticFrame: const Duration(seconds: 1),
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'empty_state_no_notifications');
      });

      testGoldens('EmptyState - Network Error', (tester) async {
        await tester.pumpWidgetBuilder(
          EmptyStates.networkError(
            staticFrame: const Duration(seconds: 1),
            onRetry: () {},
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'empty_state_network_error');
      });

      testGoldens('EmptyState - Search Results', (tester) async {
        await tester.pumpWidgetBuilder(
          EmptyStates.noSearchResults(
            searchQuery: 'John Doe',
            staticFrame: const Duration(seconds: 1),
            onClearSearch: () {},
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'empty_state_search_results');
      });

      testGoldens('EmptyState - Dark Theme', (tester) async {
        await tester.pumpWidgetBuilder(
          EmptyStates.noTransactions(
            staticFrame: const Duration(seconds: 1),
            onSendMoney: () {},
          ),
          wrapper: (child) => _darkWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'empty_state_dark_theme');
      });
    });

    group('SuccessState Tests', () {
      testGoldens('SuccessState - Transaction Complete', (tester) async {
        await tester.pumpWidgetBuilder(
          SuccessStates.transactionComplete(
            recipientName: 'John Doe',
            amount: '\$100.00',
            transactionId: 'TXN123456',
            staticFrame: const Duration(milliseconds: 1500),
            onViewDetails: () {},
            onSendAgain: () {},
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'success_state_transaction_complete');
      });

      testGoldens('SuccessState - Email Verified', (tester) async {
        await tester.pumpWidgetBuilder(
          SuccessStates.emailVerified(
            email: 'user@example.com',
            staticFrame: const Duration(milliseconds: 1500),
            onContinue: () {},
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'success_state_email_verified');
      });

      testGoldens('SuccessState - KYC Complete', (tester) async {
        await tester.pumpWidgetBuilder(
          SuccessStates.kycComplete(
            staticFrame: const Duration(milliseconds: 1500),
            onContinue: () {},
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'success_state_kyc_complete');
      });

      testGoldens('SuccessState - Profile Updated', (tester) async {
        await tester.pumpWidgetBuilder(
          SuccessStates.profileUpdated(
            message: 'Your profile information has been updated successfully.',
            staticFrame: const Duration(milliseconds: 1500),
            onContinue: () {},
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'success_state_profile_updated');
      });

      testGoldens('SuccessState - Dark Theme', (tester) async {
        await tester.pumpWidgetBuilder(
          SuccessStates.transactionComplete(
            recipientName: 'Jane Smith',
            amount: '\$250.00',
            staticFrame: const Duration(milliseconds: 1500),
            onViewDetails: () {},
            onSendAgain: () {},
          ),
          wrapper: (child) => _darkWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'success_state_dark_theme');
      });

      testGoldens('SuccessState - Without Confetti', (tester) async {
        await tester.pumpWidgetBuilder(
          SuccessState(
            title: 'Action Completed',
            subtitle: 'Your action has been completed successfully.',
            showConfetti: false,
            staticFrame: const Duration(milliseconds: 1500),
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'success_state_no_confetti');
      });

      testGoldens('SuccessState - Custom Icon', (tester) async {
        await tester.pumpWidgetBuilder(
          SuccessState(
            title: 'Custom Success',
            subtitle: 'This uses a custom icon instead of the default.',
            icon: Icons.star,
            iconColor: Colors.amber,
            showConfetti: false,
            staticFrame: const Duration(milliseconds: 1500),
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'success_state_custom_icon');
      });
    });

    group('Edge Cases', () {
      testGoldens('EmptyState - Long Text', (tester) async {
        await tester.pumpWidgetBuilder(
          EmptyState(
            icon: Icons.info_outline,
            title: 'This is a very long title that might wrap to multiple lines and test the layout',
            subtitle: 'This is also a very long subtitle that contains multiple sentences and should test how the component handles text wrapping and spacing in various scenarios.',
            staticFrame: const Duration(seconds: 1),
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'empty_state_long_text');
      });

      testGoldens('SuccessState - Long Text', (tester) async {
        await tester.pumpWidgetBuilder(
          SuccessState(
            title: 'This is a very long success title that might wrap to multiple lines',
            subtitle: 'This is also a very long success subtitle that contains multiple sentences and should test how the component handles text wrapping and spacing in various scenarios.',
            showConfetti: false,
            staticFrame: const Duration(milliseconds: 1500),
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'success_state_long_text');
      });

      testGoldens('EmptyState - Multiple Actions', (tester) async {
        await tester.pumpWidgetBuilder(
          EmptyState(
            icon: Icons.settings,
            title: 'Multiple Actions',
            subtitle: 'This empty state has multiple action buttons to test the layout.',
            action: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Primary Action',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Secondary Action',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            staticFrame: const Duration(seconds: 1),
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'empty_state_multiple_actions');
      });
    });
  });
}

/// Light theme wrapper for golden tests
Widget _lightWrapper(Widget child) {
  return MaterialApp(
    theme: ThemeData.light(),
    home: Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: child),
    ),
  );
}

/// Dark theme wrapper for golden tests
Widget _darkWrapper(Widget child) {
  return MaterialApp(
    theme: ThemeData.dark(),
    home: Scaffold(
      backgroundColor: const Color(0xFF19173d),
      body: Center(child: child),
    ),
  );
}
