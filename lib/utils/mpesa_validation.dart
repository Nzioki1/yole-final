import 'mpesa_countdown.dart';

/// M-Pesa validation utility for cap checking
///
/// Validates against:
/// - Per-transaction limit: KES 250,000
/// - Daily limit: KES 500,000 (aggregate across all sends)
class MpesaValidation {
  static const double perTransactionLimitKes = 250000.0;
  static const double dailyLimitKes = 500000.0;

  /// Check if amount exceeds per-transaction limit
  static bool exceedsPerTransactionLimit(double amountKes) {
    return amountKes > perTransactionLimitKes;
  }

  /// Check if daily total would exceed daily limit
  /// Note: This requires tracking daily total from previous transactions
  static bool exceedsDailyLimit(double amountKes, double dailyTotalKes) {
    return (dailyTotalKes + amountKes) > dailyLimitKes;
  }

  /// Get validation result for M-Pesa payment
  static MpesaValidationResult validatePayment({
    required double amountKes,
    required double dailyTotalKes,
  }) {
    // Check per-transaction limit first
    if (exceedsPerTransactionLimit(amountKes)) {
      return MpesaValidationResult(
        isValid: false,
        capType: MpesaCapType.perTransaction,
        resetHint: '', // No reset hint for per-transaction
      );
    }

    // Check daily limit
    if (exceedsDailyLimit(amountKes, dailyTotalKes)) {
      return MpesaValidationResult(
        isValid: false,
        capType: MpesaCapType.daily,
        resetHint: MpesaCountdown.getShortCountdown(),
      );
    }

    return MpesaValidationResult(isValid: true, capType: null, resetHint: '');
  }

  /// Get remaining daily limit
  static double getRemainingDailyLimit(double dailyTotalKes) {
    return dailyLimitKes - dailyTotalKes;
  }

  /// Get remaining per-transaction limit
  static double getRemainingPerTransactionLimit(double amountKes) {
    return perTransactionLimitKes - amountKes;
  }
}

/// Result of M-Pesa validation
class MpesaValidationResult {
  const MpesaValidationResult({
    required this.isValid,
    required this.capType,
    required this.resetHint,
  });

  final bool isValid;
  final MpesaCapType? capType;
  final String resetHint;
}

/// M-Pesa cap types
enum MpesaCapType { perTransaction, daily }
