import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yole_final/features/fx/fx_repo.dart';
import 'package:yole_final/features/send/repo/fees_repo.dart';
import 'package:yole_final/features/recipients/dev_mock_recipient_repo.dart';
import 'package:yole_final/features/recipients/recipient_notifier.dart';
import 'package:yole_final/features/send/state/send_state.dart';
import 'package:yole_final/core/analytics/analytics_provider.dart';
import 'package:yole_final/core/analytics/analytics_service.dart';
import 'package:yole_final/core/money.dart';
import '../_harness/test_app.dart';
import '../_harness/test_router.dart';

void main() {
  group('Simple Send Flow Integration Tests', () {
    late MockFxRepo mockFxRepo;
    late MockFeesRepo mockFeesRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      mockFxRepo = MockFxRepo();
      mockFeesRepo = MockFeesRepo();
    });

    testWidgets('Can navigate through send flow screens', (tester) async {
      // Provider overrides
      final overrides = <Override>[
        fxRepoProvider.overrideWithValue(mockFxRepo),
        feesRepoProvider.overrideWithValue(mockFeesRepo),
        analyticsProvider.overrideWithValue(AnalyticsService()),
        recipientRepoProvider.overrideWithValue(DevMockRecipientRepo()),
      ];

      // Start at the send start screen using test router
      await tester.pumpWidget(
        TestApp(router: testRouter, overrides: overrides),
      );
      await tester.pump();

      // Verify we're on the start screen
      expect(find.text('Send Money\nAnywhere'), findsOneWidget);

      // Tap start sending to go to recipient screen
      await tester.tap(find.byKey(const Key('send_start_cta')));
      await tester.pump();

      // Verify we're on the recipient screen
      expect(find.text('Who are you sending money to?'), findsOneWidget);

      // Select the first recipient from the list
      await tester.tap(find.byKey(const Key('recipient_item_r1')));
      await tester.pump();

      // Verify we're on the network screen
      expect(find.text('How would you like to send?'), findsOneWidget);

      // Select a network
      await tester.tap(find.byKey(const Key('network_item_m-pesa')));
      await tester.pump();

      // Tap continue to go to amount screen
      await tester.tap(find.byKey(const Key('network_next')));
      await tester.pump();

      // Verify we're on the amount screen
      expect(find.text('How much would you like to send?'), findsOneWidget);

      // Enter amount
      await tester.enterText(find.byKey(const Key('amount_input')), '100');
      await tester.pump();

      // Tap continue to go to review screen
      await tester.tap(find.byKey(const Key('amount_next')));
      await tester.pump();

      // Verify we're on the review screen
      expect(find.text('Review your transfer'), findsOneWidget);

      // Tap continue to go to auth screen
      await tester.tap(find.byKey(const Key('review_confirm')));
      await tester.pump();

      // Verify we're on the auth screen
      expect(find.text('Confirm your transfer'), findsOneWidget);

      // Enter PIN (6 digits for automatic submission)
      await tester.enterText(find.byKey(const Key('pin_input')), '123456');
      await tester.pump();

      // Verify we're on the success screen
      expect(find.byKey(const Key('send_success_screen')), findsOneWidget);
    });
  });
}

class MockFxRepo implements FxRepo {
  @override
  Future<double> getRate(String base, String quote) async {
    if (base == 'USD' && quote == 'EUR') return 0.9;
    if (base == 'EUR' && quote == 'USD') return 1.11;
    return 1.0;
  }

  @override
  Future<ExchangeRate> getExchangeRate(
    String fromCurrency,
    String toCurrency,
  ) async {
    return ExchangeRate(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      rate: 1.0,
      timestamp: DateTime.now(),
      source: 'Mock',
    );
  }

  @override
  Future<Money> convertAmount(Money amount, String toCurrency) async {
    return Money.fromMajor(amount.major, toCurrency);
  }

  @override
  Future<List<String>> getSupportedCurrencies() async {
    return ['USD', 'EUR', 'KES'];
  }

  @override
  Future<List<ExchangeRate>> getExchangeRateHistory(
    String fromCurrency,
    String toCurrency, {
    DateTime? from,
    DateTime? to,
  }) async {
    return [await getExchangeRate(fromCurrency, toCurrency)];
  }
}

class MockFeesRepo implements FeesRepo {
  @override
  Future<FeeCalculation> calculateFees({
    required Money amount,
    required NetworkInfo network,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    final networkFee = Money.fromMajor(amount.major * 0.025, amount.currency);
    final platformFee = Money.fromMajor(amount.major * 0.01, amount.currency);
    final totalFee = Money.fromMajor(
      networkFee.major + platformFee.major,
      amount.currency,
    );
    final totalAmount = Money.fromMajor(
      amount.major + totalFee.major,
      amount.currency,
    );
    final recipientAmount = Money.fromMajor(
      amount.major - networkFee.major,
      amount.currency,
    );

    return FeeCalculation(
      networkFee: networkFee,
      platformFee: platformFee,
      totalFee: totalFee,
      totalAmount: totalAmount,
      recipientAmount: recipientAmount,
      exchangeRate: 1.0,
      exchangeRateSource: 'Mock',
      estimatedProcessingTimeMinutes: 5,
    );
  }

  @override
  Future<int> estimateFee(Money money, {required String network}) async {
    return (money.major * 0.025 * 100).round();
  }

  @override
  Future<Duration> getEstimatedProcessingTime(String networkId) async {
    return const Duration(minutes: 5);
  }

  @override
  Future<Map<String, dynamic>> getFeeStructure(String networkId) async {
    return {'type': 'percentage', 'rate': 0.025, 'minFee': 1.0, 'maxFee': 50.0};
  }
}
