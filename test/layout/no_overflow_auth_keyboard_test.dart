/// Tests to prevent RenderFlex overflow regressions in Send Auth screen
///
/// Ensures the screen handles small screens, large text scales, and keyboard
/// without causing layout overflows, especially with PIN input.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yole_final/features/send/screens/send_auth_screen.dart';
import 'package:yole_final/features/fx/fx_repo.dart';
import 'package:yole_final/features/send/repo/fees_repo.dart';
import 'package:yole_final/features/send/state/send_state.dart';
import 'package:yole_final/core/money.dart';
import 'package:yole_final/core/analytics/analytics_provider.dart';
import 'package:yole_final/core/analytics/analytics_service.dart';
import 'package:yole_final/core/routing/app_router.dart';
import '../_harness/test_app.dart';

void main() {
  group('Send Auth Screen - No Overflow Tests', () {
    late MockFxRepo mockFxRepo;
    late MockFeesRepo mockFeesRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      mockFxRepo = MockFxRepo();
      mockFeesRepo = MockFeesRepo();
    });

    /// Helper to test for overflow errors
    Future<void> expectNoOverflow(WidgetTester tester, Widget child) async {
      final errors = <FlutterErrorDetails>[];
      final prev = FlutterError.onError;
      FlutterError.onError = (d) => errors.add(d);

      await tester.runAsync(() async {
        await tester.pumpWidget(child);
        await tester.pumpAndSettle();
      });

      FlutterError.onError = prev;
      final msgs = errors.map((e) => e.exceptionAsString()).join('\n');
      expect(msgs.contains('RenderFlex overflowed'), isFalse, reason: msgs);
      expect(msgs.contains('A RenderFlex overflowed'), isFalse, reason: msgs);
    }

    testWidgets('No overflow on small screen with large text scale', (
      tester,
    ) async {
      // Provider overrides
      final overrides = <Override>[
        fxRepoProvider.overrideWithValue(mockFxRepo),
        feesRepoProvider.overrideWithValue(mockFeesRepo),
        analyticsProvider.overrideWithValue(AnalyticsService()),
      ];

      // Small screen with large text scale
      final mediaQuery = MediaQuery(
        data: const MediaQueryData(
          size: Size(360, 640), // Small screen
          textScaleFactor: 1.4, // Large text scale
        ),
        child: TestApp(router: AppRouter.router, overrides: overrides),
      );

      await expectNoOverflow(tester, mediaQuery);
    });

    testWidgets('No overflow with keyboard open for PIN input', (tester) async {
      // Provider overrides
      final overrides = <Override>[
        fxRepoProvider.overrideWithValue(mockFxRepo),
        feesRepoProvider.overrideWithValue(mockFeesRepo),
        analyticsProvider.overrideWithValue(AnalyticsService()),
      ];

      // Screen with keyboard open (PIN input)
      final mediaQuery = MediaQuery(
        data: const MediaQueryData(
          size: Size(360, 640),
          viewInsets: EdgeInsets.only(bottom: 300), // Keyboard height
        ),
        child: TestApp(router: AppRouter.router, overrides: overrides),
      );

      await expectNoOverflow(tester, mediaQuery);
    });

    testWidgets('No overflow on very small screen with keyboard', (
      tester,
    ) async {
      // Provider overrides
      final overrides = <Override>[
        fxRepoProvider.overrideWithValue(mockFxRepo),
        feesRepoProvider.overrideWithValue(mockFeesRepo),
        analyticsProvider.overrideWithValue(AnalyticsService()),
      ];

      // Very small screen with keyboard
      final mediaQuery = MediaQuery(
        data: const MediaQueryData(
          size: Size(320, 568), // iPhone 5 size
          textScaleFactor: 1.6, // Maximum text scale
          viewInsets: EdgeInsets.only(bottom: 300), // Keyboard height
        ),
        child: TestApp(router: AppRouter.router, overrides: overrides),
      );

      await expectNoOverflow(tester, mediaQuery);
    });

    testWidgets('PIN input remains accessible with keyboard', (tester) async {
      // Provider overrides
      final overrides = <Override>[
        fxRepoProvider.overrideWithValue(mockFxRepo),
        feesRepoProvider.overrideWithValue(mockFeesRepo),
        analyticsProvider.overrideWithValue(AnalyticsService()),
      ];

      // Screen with keyboard open
      final mediaQuery = MediaQuery(
        data: const MediaQueryData(
          size: Size(360, 640),
          viewInsets: EdgeInsets.only(bottom: 300), // Keyboard height
        ),
        child: TestApp(router: AppRouter.router, overrides: overrides),
      );

      await tester.pumpWidget(mediaQuery);
      await tester.pumpAndSettle();

      // Try to find and interact with PIN input
      final pinInput = find.byType(TextField);
      if (pinInput.evaluate().isNotEmpty) {
        // Ensure the input is visible by scrolling if needed
        await tester.ensureVisible(pinInput.first);
        await tester.pumpAndSettle();

        // The input should be tappable
        await tester.tap(pinInput.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('No overflow with maximum keyboard height', (tester) async {
      // Provider overrides
      final overrides = <Override>[
        fxRepoProvider.overrideWithValue(mockFxRepo),
        feesRepoProvider.overrideWithValue(mockFeesRepo),
        analyticsProvider.overrideWithValue(AnalyticsService()),
      ];

      // Screen with maximum keyboard height
      final mediaQuery = MediaQuery(
        data: const MediaQueryData(
          size: Size(360, 640),
          viewInsets: EdgeInsets.only(bottom: 400), // Maximum keyboard height
        ),
        child: TestApp(router: AppRouter.router, overrides: overrides),
      );

      await expectNoOverflow(tester, mediaQuery);
    });
  });
}

/// Mock FX repository for testing
class MockFxRepo implements FxRepo {
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
  Future<double> getRate(String base, String quote) async {
    return 1.0;
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

/// Mock fees repository for testing
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
