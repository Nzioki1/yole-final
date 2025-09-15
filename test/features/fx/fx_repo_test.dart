import 'package:flutter_test/flutter_test.dart';
import 'package:yole_final/features/fx/fx_repo.dart';
import 'package:yole_final/core/money.dart';

void main() {
  group('ExchangeRate', () {
    test('should convert amount correctly', () {
      final exchangeRate = ExchangeRate(
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        rate: 0.85,
        timestamp: DateTime.now(),
        source: 'Test',
      );

      final usdAmount = Money.fromMajor(100.0, 'USD');
      final eurAmount = exchangeRate.convertAmount(usdAmount);

      expect(eurAmount.currency, 'EUR');
      expect(eurAmount.major, 85.0);
      expect(eurAmount.minor, 8500);
    });

    test('should throw error for mismatched currency', () {
      final exchangeRate = ExchangeRate(
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        rate: 0.85,
        timestamp: DateTime.now(),
        source: 'Test',
      );

      final eurAmount = Money.fromMajor(100.0, 'EUR');

      expect(
        () => exchangeRate.convertAmount(eurAmount),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should handle zero amount', () {
      final exchangeRate = ExchangeRate(
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        rate: 0.85,
        timestamp: DateTime.now(),
        source: 'Test',
      );

      final zeroAmount = Money.fromMajor(0.0, 'USD');
      final convertedAmount = exchangeRate.convertAmount(zeroAmount);

      expect(convertedAmount.currency, 'EUR');
      expect(convertedAmount.major, 0.0);
      expect(convertedAmount.minor, 0);
    });

    test('should handle large amounts', () {
      final exchangeRate = ExchangeRate(
        fromCurrency: 'USD',
        toCurrency: 'KES',
        rate: 150.0,
        timestamp: DateTime.now(),
        source: 'Test',
      );

      final largeAmount = Money.fromMajor(1000.0, 'USD');
      final convertedAmount = exchangeRate.convertAmount(largeAmount);

      expect(convertedAmount.currency, 'KES');
      expect(convertedAmount.major, 150000.0);
      expect(convertedAmount.minor, 15000000);
    });
  });

  group('MockFxRepo', () {
    late MockFxRepo mockFxRepo;

    setUp(() {
      mockFxRepo = MockFxRepo();
    });

    test('should return exchange rate for supported currencies', () async {
      final exchangeRate = await mockFxRepo.getExchangeRate('USD', 'EUR');

      expect(exchangeRate.fromCurrency, 'USD');
      expect(exchangeRate.toCurrency, 'EUR');
      expect(exchangeRate.rate, 0.85);
      expect(exchangeRate.source, 'Mock API');
      expect(exchangeRate.timestamp, isA<DateTime>());
    });

    test('should return 1.0 rate for same currency', () async {
      final exchangeRate = await mockFxRepo.getExchangeRate('USD', 'USD');

      expect(exchangeRate.fromCurrency, 'USD');
      expect(exchangeRate.toCurrency, 'USD');
      expect(exchangeRate.rate, 1.0);
    });

    test('should throw error for unsupported currency pair', () async {
      expect(
        () => mockFxRepo.getExchangeRate('INVALID', 'USD'),
        throwsA(isA<Exception>()),
      );
    });

    test('should return simple rate', () async {
      final rate = await mockFxRepo.getRate('USD', 'EUR');
      expect(rate, 0.85);
    });

    test('should convert amount correctly', () async {
      final usdAmount = Money.fromMajor(100.0, 'USD');
      final eurAmount = await mockFxRepo.convertAmount(usdAmount, 'EUR');

      expect(eurAmount.currency, 'EUR');
      expect(eurAmount.major, 85.0);
    });

    test('should return supported currencies', () async {
      final currencies = await mockFxRepo.getSupportedCurrencies();

      expect(currencies, contains('USD'));
      expect(currencies, contains('EUR'));
      expect(currencies, contains('GBP'));
      expect(currencies, contains('KES'));
      expect(currencies, contains('NGN'));
      expect(currencies.length, 5);
    });

    test('should return exchange rate history', () async {
      final history = await mockFxRepo.getExchangeRateHistory('USD', 'EUR');

      expect(history, isNotEmpty);
      expect(history.length, 30); // Last 30 days
      expect(history.first.fromCurrency, 'USD');
      expect(history.first.toCurrency, 'EUR');
    });

    test('should handle multiple currency conversions', () async {
      final usdAmount = Money.fromMajor(100.0, 'USD');

      final eurAmount = await mockFxRepo.convertAmount(usdAmount, 'EUR');
      final gbpAmount = await mockFxRepo.convertAmount(usdAmount, 'GBP');
      final kesAmount = await mockFxRepo.convertAmount(usdAmount, 'KES');

      expect(eurAmount.major, 85.0);
      expect(gbpAmount.major, 73.0);
      expect(kesAmount.major, 15000.0);
    });

    test('should simulate network delay', () async {
      final stopwatch = Stopwatch()..start();

      await mockFxRepo.getExchangeRate('USD', 'EUR');

      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, greaterThan(400)); // 500ms delay
    });
  });
}
