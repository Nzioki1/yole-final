import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yole_final/features/send/screens/send_review_screen.dart';
import 'package:yole_final/features/send/state/send_notifier.dart';
import 'package:yole_final/features/send/state/send_state.dart';
import 'package:yole_final/features/fx/fx_repo.dart';
import 'package:yole_final/features/send/repo/fees_repo.dart';
import 'package:yole_final/core/money.dart';
import 'package:yole_final/core/analytics/analytics.dart';

void main() {
  group('SendReviewScreen Widget Tests', () {
    late MockFxRepo mockFxRepo;
    late MockFeesRepo mockFeesRepo;
    late FakeAnalytics fakeAnalytics;

    setUp(() {
      mockFxRepo = MockFxRepo();
      mockFeesRepo = MockFeesRepo(mockFxRepo);
      fakeAnalytics = FakeAnalytics();
    });

    Widget createTestWidgetWithState(SendState sendState) {
      return ProviderScope(
        overrides: [
          fxRepoProvider.overrideWithValue(mockFxRepo),
          feesRepoProvider.overrideWithValue(mockFeesRepo),
          sendNotifierProvider.overrideWith(
            (ref) => SendNotifier(mockFeesRepo, mockFxRepo, fakeAnalytics),
          ),
        ],
        child: MaterialApp(home: SendReviewScreen()),
      );
    }

    SendState createValidSendState() {
      return SendState(
        currentStep: SendStep.review,
        recipient: const RecipientInfo(
          id: '1',
          name: 'John Doe',
          phoneNumber: '+1234567890',
          email: 'john@example.com',
          networkType: NetworkType.mobileMoney,
          networkName: 'M-Pesa',
          bankCode: null,
          accountNumber: null,
          isVerified: true,
        ),
        selectedNetwork: const NetworkInfo(
          id: 'mpesa',
          name: 'M-Pesa',
          type: NetworkType.mobileMoney,
          country: 'KE',
          currency: 'KES',
          minAmount: 1.0,
          maxAmount: 100000.0,
          feePercentage: 2.5,
          fixedFee: 10.0,
          processingTimeMinutes: 5,
          isActive: true,
          isRecommended: true,
        ),
        amount: Money.fromMajor(100.0, 'USD'),
        fromCurrency: 'USD',
        toCurrency: 'KES',
        feeCalculation: FeeCalculation(
          networkFee: Money.fromMajor(2.5, 'USD'),
          platformFee: Money.fromMajor(1.0, 'USD'),
          totalFee: Money.fromMajor(3.5, 'USD'),
          totalAmount: Money.fromMajor(103.5, 'USD'),
          recipientAmount: Money.fromMajor(97.5, 'USD'),
          exchangeRate: 150.0,
          exchangeRateSource: 'Mock API',
          estimatedProcessingTimeMinutes: 5,
        ),
      );
    }

    testWidgets('should display transaction summary card', (tester) async {
      final sendState = createValidSendState();
      await tester.pumpWidget(createTestWidgetWithState(sendState));
      await tester.pumpAndSettle();

      expect(find.text('Send to John Doe'), findsOneWidget);
      expect(find.text('+1234567890 • M-Pesa'), findsOneWidget);
      expect(find.text('\$100'), findsOneWidget);
    });

    testWidgets('should show amount details section', (tester) async {
      final sendState = createValidSendState();
      await tester.pumpWidget(createTestWidgetWithState(sendState));
      await tester.pumpAndSettle();

      expect(find.text('Amount Details'), findsOneWidget);
      expect(find.text('You send:'), findsOneWidget);
      expect(find.text('They receive:'), findsOneWidget);
    });

    testWidgets('should display dual amounts when currencies differ', (
      tester,
    ) async {
      final sendState = createValidSendState();
      await tester.pumpWidget(createTestWidgetWithState(sendState));
      await tester.pumpAndSettle();

      // Should show both USD and KES amounts
      expect(find.text('\$100'), findsOneWidget);
      expect(find.text('KSh 15,000'), findsOneWidget);
    });

    testWidgets('should show fee breakdown section', (tester) async {
      final sendState = createValidSendState();
      await tester.pumpWidget(createTestWidgetWithState(sendState));
      await tester.pumpAndSettle();

      expect(find.text('Fee Breakdown'), findsOneWidget);
      expect(find.text('Amount:'), findsOneWidget);
      expect(find.text('Yole Fee:'), findsOneWidget);
      expect(find.text('Total:'), findsOneWidget);
    });

    testWidgets('should display correct fee amounts', (tester) async {
      final sendState = createValidSendState();
      await tester.pumpWidget(createTestWidgetWithState(sendState));
      await tester.pumpAndSettle();

      expect(find.text('\$100'), findsOneWidget); // Original amount
      expect(find.text('\$3.50'), findsOneWidget); // Total fee
      expect(find.text('\$103.50'), findsOneWidget); // Total amount
    });

    testWidgets('should show exchange rate information', (tester) async {
      final sendState = createValidSendState();
      await tester.pumpWidget(createTestWidgetWithState(sendState));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Exchange rate: 1 USD = 150.0000 KES'),
        findsOneWidget,
      );
    });

    testWidgets('should display recipient information', (tester) async {
      final sendState = createValidSendState();
      await tester.pumpWidget(createTestWidgetWithState(sendState));
      await tester.pumpAndSettle();

      expect(find.text('Recipient'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('+1234567890'), findsOneWidget);
    });

    testWidgets('should display network information', (tester) async {
      final sendState = createValidSendState();
      await tester.pumpWidget(createTestWidgetWithState(sendState));
      await tester.pumpAndSettle();

      expect(find.text('Network'), findsOneWidget);
      expect(find.text('M-Pesa'), findsOneWidget);
      expect(find.text('5 minutes'), findsOneWidget);
    });

    testWidgets('should show confirm button', (tester) async {
      final sendState = createValidSendState();
      await tester.pumpWidget(createTestWidgetWithState(sendState));
      await tester.pumpAndSettle();

      expect(find.text('Confirm & Send'), findsOneWidget);
    });

    testWidgets('should handle same currency conversion', (tester) async {
      final sendState = createValidSendState().copyWith(
        toCurrency: 'USD',
        feeCalculation: FeeCalculation(
          networkFee: Money.fromMajor(2.5, 'USD'),
          platformFee: Money.fromMajor(1.0, 'USD'),
          totalFee: Money.fromMajor(3.5, 'USD'),
          totalAmount: Money.fromMajor(103.5, 'USD'),
          recipientAmount: Money.fromMajor(97.5, 'USD'),
          exchangeRate: 1.0,
          exchangeRateSource: 'Mock API',
          estimatedProcessingTimeMinutes: 5,
        ),
      );

      await tester.pumpWidget(createTestWidgetWithState(sendState));
      await tester.pumpAndSettle();

      // Should only show USD amounts
      expect(find.text('\$100'), findsOneWidget);
      expect(find.text('KSh'), findsNothing);
    });

    testWidgets('should handle large amounts with abbreviations', (
      tester,
    ) async {
      final sendState = createValidSendState().copyWith(
        amount: Money.fromMajor(1000000.0, 'USD'),
        feeCalculation: FeeCalculation(
          networkFee: Money.fromMajor(25000.0, 'USD'),
          platformFee: Money.fromMajor(10000.0, 'USD'),
          totalFee: Money.fromMajor(35000.0, 'USD'),
          totalAmount: Money.fromMajor(1035000.0, 'USD'),
          recipientAmount: Money.fromMajor(975000.0, 'USD'),
          exchangeRate: 150.0,
          exchangeRateSource: 'Mock API',
          estimatedProcessingTimeMinutes: 5,
        ),
      );

      await tester.pumpWidget(createTestWidgetWithState(sendState));
      await tester.pumpAndSettle();

      // Should show abbreviated amounts
      expect(find.text('\$1.0M'), findsOneWidget);
      expect(find.text('\$35.0K'), findsOneWidget);
      expect(find.text('\$1.0M'), findsOneWidget);
    });

    testWidgets('should show processing time', (tester) async {
      final sendState = createValidSendState();
      await tester.pumpWidget(createTestWidgetWithState(sendState));
      await tester.pumpAndSettle();

      expect(find.text('Processing Time'), findsOneWidget);
      expect(find.text('5 minutes'), findsOneWidget);
    });

    testWidgets('should display terms and conditions', (tester) async {
      final sendState = createValidSendState();
      await tester.pumpWidget(createTestWidgetWithState(sendState));
      await tester.pumpAndSettle();

      expect(find.text('Terms & Conditions'), findsOneWidget);
      expect(
        find.textContaining('By confirming this transaction'),
        findsOneWidget,
      );
    });

    testWidgets('should handle missing fee calculation gracefully', (
      tester,
    ) async {
      final sendState = createValidSendState().copyWith(feeCalculation: null);

      await tester.pumpWidget(createTestWidgetWithState(sendState));
      await tester.pumpAndSettle();

      // Should still show basic information
      expect(find.text('Send to John Doe'), findsOneWidget);
      expect(find.text('\$100'), findsOneWidget);
    });

    testWidgets('should show loading state when submitting', (tester) async {
      final sendState = createValidSendState().copyWith(isSubmitting: true);

      await tester.pumpWidget(createTestWidgetWithState(sendState));
      await tester.pumpAndSettle();

      // Should show loading indicator or disabled state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
