/// Immutable state for the Send Money flow
///
/// This class represents the complete state of the send money flow,
/// including recipient information, network selection, amount details,
/// and flow progress tracking.
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/money.dart';
import '../../../core/converters/money_converter.dart';

part 'send_state.freezed.dart';
part 'send_state.g.dart';

/// Current step in the send money flow
enum SendStep { start, recipient, network, amount, review, auth, success }

/// Network type for money transfer
enum NetworkType { mobileMoney, bankTransfer, card, crypto }

/// Recipient information
@freezed
abstract class RecipientInfo with _$RecipientInfo {
  const factory RecipientInfo({
    required String id,
    required String name,
    required String phoneNumber,
    required String? email,
    required NetworkType networkType,
    required String networkName,
    required String? bankCode,
    required String? accountNumber,
    @Default(false) bool isVerified,
    @Default(false) bool isFavorite,
  }) = _RecipientInfo;

  factory RecipientInfo.fromJson(Map<String, dynamic> json) =>
      _$RecipientInfoFromJson(json);
}

/// Network information
@freezed
abstract class NetworkInfo with _$NetworkInfo {
  const factory NetworkInfo({
    required String id,
    required String name,
    required NetworkType type,
    required String country,
    required String currency,
    @Default(0) double minAmount,
    @Default(0) double maxAmount,
    @Default(0) double feePercentage,
    @Default(0) double fixedFee,
    @Default(0) int processingTimeMinutes,
    @Default(true) bool isActive,
    @Default(false) bool isRecommended,
  }) = _NetworkInfo;

  factory NetworkInfo.fromJson(Map<String, dynamic> json) =>
      _$NetworkInfoFromJson(json);
}

/// Fee calculation result
@freezed
abstract class FeeCalculation with _$FeeCalculation {
  const factory FeeCalculation({
    @MoneyConverter() required Money networkFee,
    @MoneyConverter() required Money platformFee,
    @MoneyConverter() required Money totalFee,
    @MoneyConverter() required Money totalAmount,
    @MoneyConverter() required Money recipientAmount,
    @Default(0.0) double exchangeRate,
    @Default('') String exchangeRateSource,
    @Default(0) int estimatedProcessingTimeMinutes,
  }) = _FeeCalculation;

  factory FeeCalculation.fromJson(Map<String, dynamic> json) =>
      _$FeeCalculationFromJson(json);
}

/// Send money flow state
@freezed
abstract class SendState with _$SendState {
  const factory SendState({
    @Default(SendStep.start) SendStep currentStep,
    @Default([]) List<SendStep> completedSteps,

    // Recipient information
    RecipientInfo? recipient,
    @Default([]) List<RecipientInfo> recentRecipients,
    @Default([]) List<RecipientInfo> favoriteRecipients,
    @Default('') String recipientSearchQuery,
    @Default([]) List<RecipientInfo> searchResults,

    // Network selection
    NetworkInfo? selectedNetwork,
    @Default([]) List<NetworkInfo> availableNetworks,
    String? networkError,

    // Amount and currency
    @MoneyConverter() Money? amount,
    @Default('USD') String fromCurrency,
    @Default('USD') String toCurrency,
    @Default(false) bool showCurrencySelector,

    // Fee calculation
    FeeCalculation? feeCalculation,
    @Default(false) bool isCalculatingFees,
    String? feeCalculationError,

    // Flow state
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    String? error,
    String? transactionId,

    // Draft persistence
    @Default(false) bool hasDraft,
    @Default(0) int draftTimestamp,

    // Analytics
    @Default(0) int stepViewCount,
    @Default({}) Map<String, dynamic> analyticsData,
  }) = _SendState;

  factory SendState.fromJson(Map<String, dynamic> json) =>
      _$SendStateFromJson(json);
}

/// Extension methods for SendState
extension SendStateExtension on SendState {
  /// Check if a step is completed
  bool isStepCompleted(SendStep step) => completedSteps.contains(step);

  /// Check if we can navigate to a step
  bool canNavigateToStep(SendStep step) {
    final stepIndex = SendStep.values.indexOf(step);
    final currentIndex = SendStep.values.indexOf(currentStep);

    // Can always go back
    if (stepIndex <= currentIndex) return true;

    // Can only go forward if all previous steps are completed
    for (int i = 0; i < stepIndex; i++) {
      if (!isStepCompleted(SendStep.values[i])) {
        return false;
      }
    }

    return true;
  }

  /// Get the next step in the flow
  SendStep? get nextStep {
    final currentIndex = SendStep.values.indexOf(currentStep);
    if (currentIndex < SendStep.values.length - 1) {
      return SendStep.values[currentIndex + 1];
    }
    return null;
  }

  /// Get the previous step in the flow
  SendStep? get previousStep {
    final currentIndex = SendStep.values.indexOf(currentStep);
    if (currentIndex > 0) {
      return SendStep.values[currentIndex - 1];
    }
    return null;
  }

  /// Check if the flow is complete
  bool get isComplete => currentStep == SendStep.success;

  /// Check if we have all required data for submission
  bool get canSubmit {
    return recipient != null &&
        selectedNetwork != null &&
        amount != null &&
        feeCalculation != null &&
        currentStep == SendStep.review;
  }

  /// Get progress percentage (0.0 to 1.0)
  double get progress {
    return SendStep.values.indexOf(currentStep) / (SendStep.values.length - 1);
  }
}
