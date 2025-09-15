import 'package:flutter_test/flutter_test.dart';
import 'package:yole_final/features/send/repo/fees_repo.dart';
import 'package:yole_final/features/send/state/send_state.dart';
import 'package:yole_final/features/fx/fx_repo.dart';
import 'package:yole_final/core/money.dart';

void main() {
  group('MockFeesRepo', () {
    late MockFeesRepo mockFeesRepo;
    late MockFxRepo mockFxRepo;

    setUp(() {
      mockFxRepo = MockFxRepo();
      mockFeesRepo = MockFeesRepo(mockFxRepo);
    });

    test('should calculate fees for small amount', () async {
      final amount = Money.fromMajor(50.0, 'USD');
      final network = const NetworkInfo(
        id: 'test_network',
        name: 'Test Network',
        type: NetworkType.mobileMoney,
        country: 'US',
        currency: 'USD',
        minAmount: 1.0,
        maxAmount: 10000.0,
        feePercentage: 2.5,
        fixedFee: 1.0,
        processingTimeMinutes: 5,
        isActive: true,
        isRecommended: true,
      );

      final feeCalculation = await mockFeesRepo.calculateFees(
        amount: amount,
        network: network,
        fromCurrency: 'USD',
        toCurrency: 'USD',
      );

      expect(feeCalculation.networkFee.currency, 'USD');
      expect(feeCalculation.platformFee.currency, 'USD');
      expect(feeCalculation.totalFee.currency, 'USD');
      expect(feeCalculation.totalAmount.currency, 'USD');
      expect(feeCalculation.recipientAmount.currency, 'USD');

      // Verify fee structure
      expect(feeCalculation.networkFee.major, greaterThan(0));
      expect(feeCalculation.platformFee.major, greaterThan(0));
      expect(
        feeCalculation.totalFee.major,
        feeCalculation.networkFee.major + feeCalculation.platformFee.major,
      );
      expect(
        feeCalculation.totalAmount.major,
        amount.major + feeCalculation.totalFee.major,
      );
    });

    test('should calculate fees for large amount', () async {
      final amount = Money.fromMajor(1000.0, 'USD');
      final network = const NetworkInfo(
        id: 'test_network',
        name: 'Test Network',
        type: NetworkType.bankTransfer,
        country: 'US',
        currency: 'USD',
        minAmount: 1.0,
        maxAmount: 100000.0,
        feePercentage: 1.5,
        fixedFee: 5.0,
        processingTimeMinutes: 10,
        isActive: true,
        isRecommended: false,
      );

      final feeCalculation = await mockFeesRepo.calculateFees(
        amount: amount,
        network: network,
        fromCurrency: 'USD',
        toCurrency: 'USD',
      );

      expect(feeCalculation.totalAmount.major, greaterThan(amount.major));
      expect(feeCalculation.recipientAmount.major, lessThan(amount.major));
    });

    test('should handle currency conversion in fee calculation', () async {
      final amount = Money.fromMajor(100.0, 'USD');
      final network = const NetworkInfo(
        id: 'test_network',
        name: 'Test Network',
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
      );

      final feeCalculation = await mockFeesRepo.calculateFees(
        amount: amount,
        network: network,
        fromCurrency: 'USD',
        toCurrency: 'KES',
      );

      expect(feeCalculation.exchangeRate, greaterThan(0));
      expect(feeCalculation.exchangeRateSource, 'Mock API');
      expect(feeCalculation.estimatedProcessingTimeMinutes, 5);
    });

    test('should estimate fee correctly', () async {
      final amount = Money.fromMajor(100.0, 'USD');
      final feeMinor = await mockFeesRepo.estimateFee(amount, network: 'test');

      expect(feeMinor, greaterThan(0));
      expect(feeMinor, lessThan(amount.minor));
    });

    test('should return fee structure', () async {
      final feeStructure = await mockFeesRepo.getFeeStructure('test_network');

      expect(feeStructure, isA<Map<String, dynamic>>());
      expect(feeStructure['type'], 'percentage');
      expect(feeStructure['rate'], isA<double>());
      expect(feeStructure['minFee'], isA<double>());
      expect(feeStructure['maxFee'], isA<double>());
    });

    test('should return estimated processing time', () async {
      final processingTime = await mockFeesRepo.getEstimatedProcessingTime(
        'test_network',
      );

      expect(processingTime, isA<Duration>());
      expect(processingTime.inMinutes, greaterThan(0));
    });

    test('should handle zero amount', () async {
      final amount = Money.fromMajor(0.0, 'USD');
      final network = const NetworkInfo(
        id: 'test_network',
        name: 'Test Network',
        type: NetworkType.mobileMoney,
        country: 'US',
        currency: 'USD',
        minAmount: 0.0,
        maxAmount: 10000.0,
        feePercentage: 2.5,
        fixedFee: 1.0,
        processingTimeMinutes: 5,
        isActive: true,
        isRecommended: true,
      );

      final feeCalculation = await mockFeesRepo.calculateFees(
        amount: amount,
        network: network,
        fromCurrency: 'USD',
        toCurrency: 'USD',
      );

      expect(
        feeCalculation.totalAmount.major,
        greaterThan(0),
      ); // Should include fees
      expect(
        feeCalculation.recipientAmount.major,
        lessThan(0),
      ); // Negative due to fees
    });

    test('should handle different network types', () async {
      final amount = Money.fromMajor(100.0, 'USD');

      final mobileMoneyNetwork = const NetworkInfo(
        id: 'mobile_money',
        name: 'Mobile Money',
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
      );

      final bankTransferNetwork = const NetworkInfo(
        id: 'bank_transfer',
        name: 'Bank Transfer',
        type: NetworkType.bankTransfer,
        country: 'US',
        currency: 'USD',
        minAmount: 10.0,
        maxAmount: 100000.0,
        feePercentage: 1.0,
        fixedFee: 5.0,
        processingTimeMinutes: 30,
        isActive: true,
        isRecommended: false,
      );

      final mobileMoneyFees = await mockFeesRepo.calculateFees(
        amount: amount,
        network: mobileMoneyNetwork,
        fromCurrency: 'USD',
        toCurrency: 'KES',
      );

      final bankTransferFees = await mockFeesRepo.calculateFees(
        amount: amount,
        network: bankTransferNetwork,
        fromCurrency: 'USD',
        toCurrency: 'USD',
      );

      expect(mobileMoneyFees.estimatedProcessingTimeMinutes, 5);
      expect(bankTransferFees.estimatedProcessingTimeMinutes, 30);
    });

    test('should simulate network delay', () async {
      final amount = Money.fromMajor(100.0, 'USD');
      final network = const NetworkInfo(
        id: 'test_network',
        name: 'Test Network',
        type: NetworkType.mobileMoney,
        country: 'US',
        currency: 'USD',
        minAmount: 1.0,
        maxAmount: 10000.0,
        feePercentage: 2.5,
        fixedFee: 1.0,
        processingTimeMinutes: 5,
        isActive: true,
        isRecommended: true,
      );

      final stopwatch = Stopwatch()..start();

      await mockFeesRepo.calculateFees(
        amount: amount,
        network: network,
        fromCurrency: 'USD',
        toCurrency: 'USD',
      );

      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, greaterThan(100)); // 200ms delay
    });
  });
}
