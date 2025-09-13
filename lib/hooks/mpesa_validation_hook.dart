import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/mpesa_validation.dart' as validation;
import '../widgets/mpesa_cap_banner.dart';

/// Hook for M-Pesa validation with proper trigger points
///
/// Validation triggers:
/// - On amount change
/// - On quote return
/// - On Review load
///
/// Disable logic:
/// - When banner visible, disable primary CTA
/// - Still allow "Use Card instead" secondary CTA
class MpesaValidationHook extends StateNotifier<MpesaValidationState> {
  MpesaValidationHook() : super(const MpesaValidationState());

  /// Validate on amount change
  void validateOnAmountChange({
    required double amountKes,
    required double dailyTotalKes,
    required String paymentMethod,
  }) {
    if (paymentMethod != 'mpesa') {
      state = state.copyWith(
        validationResult: null,
        isPrimaryCtaDisabled: false,
      );
      return;
    }

    final result = validation.MpesaValidation.validatePayment(
      amountKes: amountKes,
      dailyTotalKes: dailyTotalKes,
    );

    // Convert validation result to use the banner's enum
    MpesaValidationResult? convertedResult;
    if (!result.isValid) {
      convertedResult = MpesaValidationResult(
        isValid: result.isValid,
        capType: result.capType == validation.MpesaCapType.perTransaction
            ? MpesaCapType.perTransaction
            : MpesaCapType.daily,
        resetHint: result.resetHint,
      );
    }

    state = state.copyWith(
      validationResult: convertedResult,
      isPrimaryCtaDisabled: !result.isValid,
    );
  }

  /// Validate on quote return
  void validateOnQuoteReturn({
    required double amountKes,
    required double dailyTotalKes,
    required String paymentMethod,
  }) {
    validateOnAmountChange(
      amountKes: amountKes,
      dailyTotalKes: dailyTotalKes,
      paymentMethod: paymentMethod,
    );
  }

  /// Validate on Review load
  void validateOnReviewLoad({
    required double amountKes,
    required double dailyTotalKes,
    required String paymentMethod,
  }) {
    validateOnAmountChange(
      amountKes: amountKes,
      dailyTotalKes: dailyTotalKes,
      paymentMethod: paymentMethod,
    );
  }

  /// Clear validation (e.g., when switching payment methods)
  void clearValidation() {
    state = state.copyWith(validationResult: null, isPrimaryCtaDisabled: false);
  }

  /// Update daily total (e.g., from transaction history)
  void updateDailyTotal(double dailyTotalKes) {
    state = state.copyWith(dailyTotalKes: dailyTotalKes);
  }
}

/// Result of M-Pesa validation for the hook
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

/// State for M-Pesa validation
class MpesaValidationState {
  const MpesaValidationState({
    this.validationResult,
    this.isPrimaryCtaDisabled = false,
    this.dailyTotalKes = 0.0,
  });

  final MpesaValidationResult? validationResult;
  final bool isPrimaryCtaDisabled;
  final double dailyTotalKes;

  MpesaValidationState copyWith({
    MpesaValidationResult? validationResult,
    bool? isPrimaryCtaDisabled,
    double? dailyTotalKes,
  }) {
    return MpesaValidationState(
      validationResult: validationResult ?? this.validationResult,
      isPrimaryCtaDisabled: isPrimaryCtaDisabled ?? this.isPrimaryCtaDisabled,
      dailyTotalKes: dailyTotalKes ?? this.dailyTotalKes,
    );
  }

  /// Whether the banner should be shown
  bool get shouldShowBanner =>
      validationResult != null && !validationResult!.isValid;

  /// Whether primary CTA should be disabled
  bool get shouldDisablePrimaryCta => isPrimaryCtaDisabled;

  /// Whether secondary CTA should be enabled (always true for "Use Card instead")
  bool get shouldEnableSecondaryCta => true;
}

/// Provider for M-Pesa validation hook
final mpesaValidationProvider =
    StateNotifierProvider<MpesaValidationHook, MpesaValidationState>((ref) {
      return MpesaValidationHook();
    });
