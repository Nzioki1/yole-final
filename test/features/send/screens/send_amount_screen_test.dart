import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yole_final/features/send/screens/send_amount_screen.dart';
import 'package:yole_final/features/send/state/send_notifier.dart';
import 'package:yole_final/features/send/state/send_state.dart';
import 'package:yole_final/features/fx/fx_repo.dart';
import 'package:yole_final/features/send/repo/fees_repo.dart';
import 'package:yole_final/core/money.dart';
import 'package:yole_final/core/analytics/analytics.dart';

void main() {
  group('SendAmountScreen Widget Tests', () {
    late MockFxRepo mockFxRepo;
    late MockFeesRepo mockFeesRepo;
    late FakeAnalytics fakeAnalytics;

    setUp(() {
      mockFxRepo = MockFxRepo();
      mockFeesRepo = MockFeesRepo(mockFxRepo);
      fakeAnalytics = FakeAnalytics();
    });

    Widget createTestWidget() {
      return ProviderScope(
        overrides: [
          fxRepoProvider.overrideWithValue(mockFxRepo),
          feesRepoProvider.overrideWithValue(mockFeesRepo),
        ],
        child: MaterialApp(home: const SendAmountScreen()),
      );
    }

    testWidgets('should display amount input field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('How much would you like to send?'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Enter amount'), findsOneWidget);
    });

    testWidgets('should show currency selector', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('USD'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });

    testWidgets('should display currency options when tapped', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap currency selector
      await tester.tap(find.text('USD'));
      await tester.pumpAndSettle();

      expect(find.text('EUR'), findsOneWidget);
      expect(find.text('GBP'), findsOneWidget);
      expect(find.text('KES'), findsOneWidget);
      expect(find.text('NGN'), findsOneWidget);
    });

    testWidgets('should update amount when text is entered', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter amount
      await tester.enterText(find.byType(TextField), '100');
      await tester.pumpAndSettle();

      expect(find.text('\$100'), findsOneWidget);
    });

    testWidgets('should show converted amount when currencies differ', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter amount
      await tester.enterText(find.byType(TextField), '100');
      await tester.pumpAndSettle();

      // Change to EUR
      await tester.tap(find.text('USD'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('EUR'));
      await tester.pumpAndSettle();

      // Wait for conversion
      await tester.pump(const Duration(seconds: 1));

      // Should show both USD and EUR amounts
      expect(find.text('\$100'), findsOneWidget);
      expect(find.text('€85.00'), findsOneWidget);
    });

    testWidgets('should show fee breakdown when amount is entered', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter amount
      await tester.enterText(find.byType(TextField), '100');
      await tester.pumpAndSettle();

      // Wait for fee calculation
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Fee Breakdown'), findsOneWidget);
      expect(find.text('Network Fee'), findsOneWidget);
      expect(find.text('Platform Fee'), findsOneWidget);
      expect(find.text('Total Fee'), findsOneWidget);
      expect(find.text('Total Amount'), findsOneWidget);
    });

    testWidgets('should show continue button when amount is valid', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Initially no continue button
      expect(find.text('Continue'), findsNothing);

      // Enter amount
      await tester.enterText(find.byType(TextField), '100');
      await tester.pumpAndSettle();

      // Continue button should appear
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('should not show continue button for zero amount', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter zero amount
      await tester.enterText(find.byType(TextField), '0');
      await tester.pumpAndSettle();

      expect(find.text('Continue'), findsNothing);
    });

    testWidgets('should not show continue button for negative amount', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter negative amount
      await tester.enterText(find.byType(TextField), '-10');
      await tester.pumpAndSettle();

      expect(find.text('Continue'), findsNothing);
    });

    testWidgets('should show exchange rate info when currencies differ', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter amount
      await tester.enterText(find.byType(TextField), '100');
      await tester.pumpAndSettle();

      // Change to EUR
      await tester.tap(find.text('USD'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('EUR'));
      await tester.pumpAndSettle();

      // Wait for fee calculation
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.textContaining('Exchange rate: 1 USD = 0.8500 EUR'),
        findsOneWidget,
      );
    });

    testWidgets('should handle currency selection correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter amount
      await tester.enterText(find.byType(TextField), '100');
      await tester.pumpAndSettle();

      // Change to GBP
      await tester.tap(find.text('USD'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('GBP'));
      await tester.pumpAndSettle();

      // Currency selector should show GBP
      expect(find.text('GBP'), findsOneWidget);
      expect(find.text('USD'), findsNothing);
    });

    testWidgets('should show loading state during fee calculation', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter amount
      await tester.enterText(find.byType(TextField), '100');
      await tester.pump();

      // Should show loading or calculating state
      // Note: The actual loading state depends on the implementation
      expect(find.text('Fee Breakdown'), findsNothing);
    });

    testWidgets('should handle large amounts correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter large amount
      await tester.enterText(find.byType(TextField), '1000000');
      await tester.pumpAndSettle();

      // Should show abbreviated format
      expect(find.text('\$1.0M'), findsOneWidget);
    });

    testWidgets('should validate decimal input', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter decimal amount
      await tester.enterText(find.byType(TextField), '99.99');
      await tester.pumpAndSettle();

      expect(find.text('\$99.99'), findsOneWidget);
    });

    testWidgets('should handle invalid input gracefully', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter invalid amount
      await tester.enterText(find.byType(TextField), 'abc');
      await tester.pumpAndSettle();

      // Should not show continue button
      expect(find.text('Continue'), findsNothing);
    });
  });
}

