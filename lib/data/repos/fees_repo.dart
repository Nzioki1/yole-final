/// Fees repository for network fee calculations
///
/// Handles:
/// - Per-network fee estimates
/// - Min/max amount validation
/// - Fee preview calculations
/// - Network availability status
library;

import '../api/yole_api_client.dart';
import '../../core/money.dart';

/// Network fee information
class NetworkFeeInfo {
  /// Network identifier
  final String networkId;
  
  /// Network name
  final String networkName;
  
  /// Network logo URL
  final String? logoUrl;
  
  /// Minimum amount in minor units
  final int minAmountMinor;
  
  /// Maximum amount in minor units
  final int maxAmountMinor;
  
  /// Fixed fee in minor units
  final int feeFixedMinor;
  
  /// Fee percentage (0.0 to 100.0)
  final double feePercentage;
  
  /// Whether the network is currently available
  final bool isAvailable;
  
  /// Reason for unavailability (if any)
  final String? unavailabilityReason;
  
  /// Required currency for this network
  final String? requiredCurrency;
  
  /// Processing time in minutes
  final int processingTimeMinutes;

  const NetworkFeeInfo({
    required this.networkId,
    required this.networkName,
    this.logoUrl,
    required this.minAmountMinor,
    required this.maxAmountMinor,
    required this.feeFixedMinor,
    required this.feePercentage,
    this.isAvailable = true,
    this.unavailabilityReason,
    this.requiredCurrency,
    this.processingTimeMinutes = 60,
  });

  /// Calculate fee for a given amount
  Money calculateFee(Money amount) {
    final fixedFee = Money.fromMinor(feeFixedMinor, amount.currency);
    final percentageFee = Money.fromMinor(
      (amount.minor * feePercentage / 100).round(),
      amount.currency,
    );
    return fixedFee + percentageFee;
  }

  /// Check if amount is within limits
  bool isAmountValid(Money amount) {
    return amount.minor >= minAmountMinor && amount.minor <= maxAmountMinor;
  }

  /// Get validation error message for amount
  String? getAmountValidationError(Money amount) {
    if (amount.minor < minAmountMinor) {
      final minAmount = Money.fromMinor(minAmountMinor, amount.currency);
      return 'Minimum amount is ${formatAmount(minAmount)}';
    }
    if (amount.minor > maxAmountMinor) {
      final maxAmount = Money.fromMinor(maxAmountMinor, amount.currency);
      return 'Maximum amount is ${formatAmount(maxAmount)}';
    }
    return null;
  }

  /// Check if network supports the given currency
  bool supportsCurrency(String currency) {
    if (requiredCurrency == null) return true;
    return requiredCurrency == currency;
  }

  /// Get currency validation error message
  String? getCurrencyValidationError(String currency) {
    if (!supportsCurrency(currency)) {
      return 'This network only supports $requiredCurrency';
    }
    return null;
  }

  /// Format amount as string
  String formatAmount(Money amount) {
    return '${amount.symbol}${amount.major.toStringAsFixed(2)}';
  }
}

/// Fees repository for network calculations
class FeesRepository {
  const FeesRepository(this._apiClient);

  final YoleApiClient _apiClient;

  /// Get fee information for all available networks
  Future<List<NetworkFeeInfo>> getNetworkFees({
    String currency = 'USD',
    String recipientCountry = 'US',
  }) async {
    try {
      // For MVP, return mock data
      // TODO: Replace with actual API call when endpoint is available
      return _getMockNetworkFees(currency, recipientCountry);
    } catch (e) {
      // Fallback to mock data on error
      return _getMockNetworkFees(currency, recipientCountry);
    }
  }

  /// Get fee estimate for a specific network and amount
  Future<NetworkFeeInfo?> getNetworkFeeEstimate({
    required String networkId,
    required Money amount,
    String recipientCountry = 'US',
  }) async {
    try {
      final networkFees = await getNetworkFees(
        currency: amount.currency,
        recipientCountry: recipientCountry,
      );
      
      return networkFees.firstWhere(
        (fee) => fee.networkId == networkId,
        orElse: () => throw Exception('Network not found'),
      );
    } catch (e) {
      return null;
    }
  }

  /// Calculate fee for a specific network and amount
  Future<Money?> calculateNetworkFee({
    required String networkId,
    required Money amount,
    String recipientCountry = 'US',
  }) async {
    final feeInfo = await getNetworkFeeEstimate(
      networkId: networkId,
      amount: amount,
      recipientCountry: recipientCountry,
    );
    
    return feeInfo?.calculateFee(amount);
  }

  /// Validate amount against network limits
  Future<String?> validateAmount({
    required String networkId,
    required Money amount,
    String recipientCountry = 'US',
  }) async {
    final feeInfo = await getNetworkFeeEstimate(
      networkId: networkId,
      amount: amount,
      recipientCountry: recipientCountry,
    );
    
    if (feeInfo == null) {
      return 'Network not available';
    }
    
    if (!feeInfo.isAvailable) {
      return feeInfo.unavailabilityReason ?? 'Network temporarily unavailable';
    }
    
    final amountError = feeInfo.getAmountValidationError(amount);
    if (amountError != null) {
      return amountError;
    }
    
    final currencyError = feeInfo.getCurrencyValidationError(amount.currency);
    if (currencyError != null) {
      return currencyError;
    }
    
    return null;
  }

  /// Get mock network fees for testing
  List<NetworkFeeInfo> _getMockNetworkFees(String currency, String recipientCountry) {
    return [
      NetworkFeeInfo(
        networkId: 'mpesa',
        networkName: 'M-Pesa',
        minAmountMinor: 1000, // $10.00
        maxAmountMinor: 15000000, // $150,000.00
        feeFixedMinor: 0,
        feePercentage: 1.5,
        isAvailable: true,
        requiredCurrency: 'KES',
        processingTimeMinutes: 5,
      ),
      NetworkFeeInfo(
        networkId: 'chase',
        networkName: 'Chase Bank',
        minAmountMinor: 2500, // $25.00
        maxAmountMinor: 10000000, // $100,000.00
        feeFixedMinor: 2500, // $25.00
        feePercentage: 0.0,
        isAvailable: true,
        requiredCurrency: 'USD',
        processingTimeMinutes: 60,
      ),
      NetworkFeeInfo(
        networkId: 'venmo',
        networkName: 'Venmo',
        minAmountMinor: 100, // $1.00
        maxAmountMinor: 5000000, // $50,000.00
        feeFixedMinor: 0,
        feePercentage: 3.0,
        isAvailable: true,
        requiredCurrency: 'USD',
        processingTimeMinutes: 2,
      ),
      NetworkFeeInfo(
        networkId: 'paypal',
        networkName: 'PayPal',
        minAmountMinor: 100, // $1.00
        maxAmountMinor: 10000000, // $100,000.00
        feeFixedMinor: 30, // $0.30
        feePercentage: 2.9,
        isAvailable: true,
        processingTimeMinutes: 15,
      ),
      NetworkFeeInfo(
        networkId: 'wise',
        networkName: 'Wise',
        minAmountMinor: 100, // $1.00
        maxAmountMinor: 10000000, // $100,000.00
        feeFixedMinor: 0,
        feePercentage: 0.65,
        isAvailable: false,
        unavailabilityReason: 'Temporarily unavailable',
        processingTimeMinutes: 30,
      ),
      NetworkFeeInfo(
        networkId: 'western_union',
        networkName: 'Western Union',
        minAmountMinor: 1000, // $10.00
        maxAmountMinor: 5000000, // $50,000.00
        feeFixedMinor: 500, // $5.00
        feePercentage: 0.0,
        isAvailable: true,
        processingTimeMinutes: 120,
      ),
    ];
  }
}
