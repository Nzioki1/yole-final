/// Foreign exchange repository interface and implementation
///
/// This repository handles currency conversion and exchange rate
/// calculations for the send money flow.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/money.dart';

/// Exchange rate information
class ExchangeRate {
  const ExchangeRate({
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.timestamp,
    required this.source,
  });

  final String fromCurrency;
  final String toCurrency;
  final double rate;
  final DateTime timestamp;
  final String source;

  /// Convert amount using this exchange rate
  Money convertAmount(Money amount) {
    if (amount.currency != fromCurrency) {
      throw ArgumentError(
        'Amount currency ${amount.currency} does not match fromCurrency $fromCurrency',
      );
    }

    final convertedValue = (amount.minor / 100) * rate;
    return Money.fromMajor(convertedValue, toCurrency);
  }
}

/// FX repository interface
abstract class FxRepo {
  /// Get current exchange rate between two currencies
  Future<ExchangeRate> getExchangeRate(String fromCurrency, String toCurrency);

  /// Get simple exchange rate as double
  Future<double> getRate(String base, String quote);

  /// Convert amount from one currency to another
  Future<Money> convertAmount(Money amount, String toCurrency);

  /// Get supported currencies
  Future<List<String>> getSupportedCurrencies();

  /// Get exchange rate history (for charts)
  Future<List<ExchangeRate>> getExchangeRateHistory(
    String fromCurrency,
    String toCurrency, {
    DateTime? from,
    DateTime? to,
  });
}

/// Mock FX repository implementation for development
class MockFxRepo implements FxRepo {
  // Mock exchange rates
  static const Map<String, double> _mockRates = {
    'USD_EUR': 0.85,
    'USD_GBP': 0.73,
    'USD_KES': 150.0,
    'USD_NGN': 750.0,
    'EUR_USD': 1.18,
    'EUR_GBP': 0.86,
    'EUR_KES': 176.5,
    'GBP_USD': 1.37,
    'GBP_EUR': 1.16,
    'GBP_KES': 205.5,
    'KES_USD': 0.0067,
    'KES_EUR': 0.0057,
    'KES_GBP': 0.0049,
    'NGN_USD': 0.0013,
    'NGN_EUR': 0.0011,
    'NGN_GBP': 0.00095,
  };

  static const List<String> _supportedCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'KES',
    'NGN',
  ];

  @override
  Future<ExchangeRate> getExchangeRate(
    String fromCurrency,
    String toCurrency,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (fromCurrency == toCurrency) {
      return ExchangeRate(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        rate: 1.0,
        timestamp: DateTime.now(),
        source: 'Mock',
      );
    }

    final rateKey = '${fromCurrency}_$toCurrency';
    final rate = _mockRates[rateKey];

    if (rate == null) {
      throw Exception(
        'Exchange rate not available for $fromCurrency to $toCurrency',
      );
    }

    return ExchangeRate(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      rate: rate,
      timestamp: DateTime.now(),
      source: 'Mock API',
    );
  }

  @override
  Future<double> getRate(String base, String quote) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    if (base == quote) return 1.0;

    final rateKey = '${base}_$quote';
    final rate = _mockRates[rateKey];

    if (rate == null) {
      throw Exception('Exchange rate not available for $base to $quote');
    }

    return rate;
  }

  @override
  Future<Money> convertAmount(Money amount, String toCurrency) async {
    final exchangeRate = await getExchangeRate(amount.currency, toCurrency);
    return exchangeRate.convertAmount(amount);
  }

  @override
  Future<List<String>> getSupportedCurrencies() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_supportedCurrencies);
  }

  @override
  Future<List<ExchangeRate>> getExchangeRateHistory(
    String fromCurrency,
    String toCurrency, {
    DateTime? from,
    DateTime? to,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final baseRate = await getExchangeRate(fromCurrency, toCurrency);
    final history = <ExchangeRate>[];

    // Generate mock historical data (last 30 days)
    final endDate = to ?? DateTime.now();
    final startDate = from ?? endDate.subtract(const Duration(days: 30));

    for (int i = 0; i < 30; i++) {
      final date = startDate.add(Duration(days: i));
      if (date.isAfter(endDate)) break;

      // Add some random variation to the rate
      final variation = (i % 7 - 3) * 0.01; // Weekly pattern
      final randomVariation = (i % 3 - 1) * 0.005; // Random variation
      final adjustedRate = baseRate.rate + variation + randomVariation;

      history.add(
        ExchangeRate(
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
          rate: adjustedRate,
          timestamp: date,
          source: 'Mock Historical',
        ),
      );
    }

    return history;
  }
}

/// Provider for FX repository
final fxRepoProvider = Provider<FxRepo>((ref) {
  return MockFxRepo();
});
