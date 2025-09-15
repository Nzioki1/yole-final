/// Fees repository interface and implementation
///
/// This repository handles fee calculations for different networks
/// and payment methods in the send money flow.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/money.dart';
import '../state/send_state.dart';
import '../../fx/fx_repo.dart';

/// Fees repository interface
abstract class FeesRepo {
  /// Calculate fees for a given amount and network
  Future<FeeCalculation> calculateFees({
    required Money amount,
    required NetworkInfo network,
    required String fromCurrency,
    required String toCurrency,
  });

  /// Estimate fee in minor units for a given amount and network
  Future<int> estimateFee(Money money, {required String network});

  /// Get fee structure for a network
  Future<Map<String, dynamic>> getFeeStructure(String networkId);

  /// Get estimated processing time for a network
  Future<Duration> getEstimatedProcessingTime(String networkId);
}

/// Mock fees repository implementation for development
class MockFeesRepo implements FeesRepo {
  MockFeesRepo(this._fxRepo);

  final FxRepo _fxRepo;

  @override
  Future<int> estimateFee(Money money, {required String network}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    // Simple tiered fee calculation
    final amount = money.major;
    int feeMinor;

    if (amount < 100) {
      feeMinor = 50; // $0.50
    } else if (amount < 500) {
      feeMinor = 100; // $1.00
    } else if (amount < 1000) {
      feeMinor = 200; // $2.00
    } else {
      feeMinor = 300; // $3.00
    }

    return feeMinor;
  }

  @override
  Future<FeeCalculation> calculateFees({
    required Money amount,
    required NetworkInfo network,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Convert amount to network currency if needed
    Money networkAmount = amount;
    double exchangeRate = 1.0;

    if (amount.currency != network.currency) {
      final convertedAmount = await _fxRepo.convertAmount(
        amount,
        network.currency,
      );
      networkAmount = convertedAmount;

      // Get exchange rate for display
      final rate = await _fxRepo.getExchangeRate(
        amount.currency,
        network.currency,
      );
      exchangeRate = rate.rate;
    }

    // Calculate network fee
    final networkFeeAmount = _calculateNetworkFee(networkAmount, network);
    final networkFee = Money.fromMajor(networkFeeAmount, network.currency);

    // Calculate platform fee (2% of amount, minimum $1, maximum $50)
    final platformFeePercentage = 0.02;
    final platformFeeAmount =
        (networkAmount.minor / 100) * platformFeePercentage;
    final minPlatformFee = 1.0;
    final maxPlatformFee = 50.0;
    final finalPlatformFeeAmount = platformFeeAmount.clamp(
      minPlatformFee,
      maxPlatformFee,
    );
    final platformFee = Money.fromMajor(
      finalPlatformFeeAmount,
      network.currency,
    );

    // Calculate total fee
    final totalFeeAmount = networkFeeAmount + finalPlatformFeeAmount;
    final totalFee = Money.fromMajor(totalFeeAmount, network.currency);

    // Calculate total amount (amount + fees)
    final totalAmount = Money.fromMajor(
      (networkAmount.minor / 100) + totalFeeAmount,
      network.currency,
    );

    // Calculate recipient amount (amount - network fee)
    final recipientAmount = Money.fromMajor(
      (networkAmount.minor / 100) - networkFeeAmount,
      network.currency,
    );

    return FeeCalculation(
      networkFee: networkFee,
      platformFee: platformFee,
      totalFee: totalFee,
      totalAmount: totalAmount,
      recipientAmount: recipientAmount,
      exchangeRate: exchangeRate,
      exchangeRateSource: 'Mock API',
      estimatedProcessingTimeMinutes: network.processingTimeMinutes,
    );
  }

  @override
  Future<Map<String, dynamic>> getFeeStructure(String networkId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Mock fee structures for different networks
    final feeStructures = {
      'mpesa': {
        'type': 'percentage',
        'rate': 0.015, // 1.5%
        'minFee': 5.0,
        'maxFee': 100.0,
        'currency': 'KES',
        'description': 'M-Pesa transfer fee',
      },
      'chase': {
        'type': 'fixed',
        'rate': 0.0,
        'fixedFee': 25.0,
        'currency': 'USD',
        'description': 'Wire transfer fee',
      },
      'venmo': {
        'type': 'percentage',
        'rate': 0.03, // 3%
        'minFee': 0.25,
        'maxFee': 10.0,
        'currency': 'USD',
        'description': 'Venmo processing fee',
      },
      'default': {
        'type': 'percentage',
        'rate': 0.02, // 2%
        'minFee': 1.0,
        'maxFee': 50.0,
        'currency': 'USD',
        'description': 'Standard transfer fee',
      },
    };

    return feeStructures[networkId] ?? feeStructures['default']!;
  }

  @override
  Future<Duration> getEstimatedProcessingTime(String networkId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    // Mock processing times for different networks
    final processingTimes = {
      'mpesa': const Duration(minutes: 5),
      'chase': const Duration(hours: 1),
      'venmo': const Duration(minutes: 2),
      'default': const Duration(minutes: 15),
    };

    return processingTimes[networkId] ?? processingTimes['default']!;
  }

  /// Calculate network-specific fee
  double _calculateNetworkFee(Money amount, NetworkInfo network) {
    final amountValue = amount.minor / 100;

    // Calculate percentage fee
    final percentageFee = amountValue * (network.feePercentage / 100);

    // Add fixed fee
    final totalFee = percentageFee + network.fixedFee;

    // Apply minimum and maximum limits
    final minFee = network.minAmount > 0 ? network.minAmount * 0.01 : 0.0;
    final maxFee = network.maxAmount > 0 ? network.maxAmount * 0.05 : totalFee;

    return totalFee.clamp(minFee, maxFee);
  }
}

/// Provider for fees repository
final feesRepoProvider = Provider<FeesRepo>((ref) {
  return MockFeesRepo(ref.read(fxRepoProvider));
});
