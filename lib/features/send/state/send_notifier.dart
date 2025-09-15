/// Send money flow state notifier with persistence
///
/// This notifier manages the send money flow state and persists
/// draft data to allow users to resume the flow after app restart.
library;

import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'send_state.dart';
import '../repo/fees_repo.dart';
import '../../fx/fx_repo.dart';
import '../../recipients/recipient.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/money.dart';

/// Provider for the send state notifier
final sendNotifierProvider = StateNotifierProvider<SendNotifier, SendState>((
  ref,
) {
  return SendNotifier(
    ref.read(feesRepoProvider),
    ref.read(fxRepoProvider),
    ref.read(analyticsServiceProvider),
  );
});

/// Send money flow state notifier
class SendNotifier extends StateNotifier<SendState> {
  SendNotifier(this._feesRepo, this._fxRepo, this._analytics)
    : super(const SendState()) {
    _loadDraft();
  }

  final FeesRepo _feesRepo;
  final FxRepo _fxRepo;
  final AnalyticsService _analytics;

  static const String _draftKey = 'send_money_draft';
  static const int _draftExpiryHours = 24;

  /// Load draft from persistent storage
  Future<void> _loadDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftJson = prefs.getString(_draftKey);

      if (draftJson != null) {
        final draftData = jsonDecode(draftJson) as Map<String, dynamic>;
        final timestamp = draftData['timestamp'] as int? ?? 0;

        // Check if draft is still valid (within 24 hours)
        final now = DateTime.now().millisecondsSinceEpoch;
        if (now - timestamp < _draftExpiryHours * 60 * 60 * 1000) {
          final draftState = SendState.fromJson(
            draftData['state'] as Map<String, dynamic>,
          );
          state = draftState.copyWith(
            hasDraft: true,
            draftTimestamp: timestamp,
          );

          _analytics.trackEvent(
            'send_draft_restored',
            parameters: {
              'step': draftState.currentStep.name,
              'has_recipient': draftState.recipient != null,
              'has_network': draftState.selectedNetwork != null,
              'has_amount': draftState.amount != null,
            },
          );
        } else {
          // Draft expired, remove it
          await prefs.remove(_draftKey);
        }
      }
    } catch (e) {
      // If loading fails, continue with empty state
      print('Failed to load send draft: $e');
    }
  }

  /// Save current state as draft
  Future<void> _saveDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftData = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'state': state.toJson(),
      };

      await prefs.setString(_draftKey, jsonEncode(draftData));
      state = state.copyWith(
        hasDraft: true,
        draftTimestamp: DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      print('Failed to save send draft: $e');
    }
  }

  /// Clear draft data
  Future<void> _clearDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_draftKey);
      state = state.copyWith(hasDraft: false, draftTimestamp: 0);
    } catch (e) {
      print('Failed to clear send draft: $e');
    }
  }

  /// Start the send money flow
  void startFlow() {
    state = const SendState(currentStep: SendStep.start);
    _saveDraft();
    _analytics.trackEvent('send_flow_started');
  }

  /// Navigate to a specific step
  void navigateToStep(SendStep step) {
    if (!state.canNavigateToStep(step)) {
      return;
    }

    final previousStep = state.currentStep;
    state = state.copyWith(currentStep: step);
    _saveDraft();

    _analytics.trackEvent(
      'send_step_viewed',
      parameters: {
        'step': step.name,
        'previous_step': previousStep.name,
        'is_back_navigation':
            SendStep.values.indexOf(step) <
            SendStep.values.indexOf(previousStep),
      },
    );
  }

  /// Complete the current step and move to next
  void completeCurrentStep() {
    final currentStep = state.currentStep;
    final completedSteps = List<SendStep>.from(state.completedSteps);

    if (!completedSteps.contains(currentStep)) {
      completedSteps.add(currentStep);
    }

    final nextStep = state.nextStep;
    if (nextStep != null) {
      state = state.copyWith(
        currentStep: nextStep,
        completedSteps: completedSteps,
      );
      _saveDraft();

      _analytics.trackEvent(
        'send_step_completed',
        parameters: {'step': currentStep.name, 'next_step': nextStep.name},
      );
    }
  }

  /// Go back to previous step
  void goBack() {
    final previousStep = state.previousStep;
    if (previousStep != null) {
      state = state.copyWith(currentStep: previousStep);
      _saveDraft();

      _analytics.trackEvent(
        'send_step_back',
        parameters: {
          'from_step': state.currentStep.name,
          'to_step': previousStep.name,
        },
      );
    }
  }

  /// Set recipient information
  void setRecipient(RecipientInfo recipient) {
    state = state.copyWith(recipient: recipient, networkError: null);
    _saveDraft();

    _analytics.trackEvent(
      'send_recipient_selected',
      parameters: {
        'recipient_id': recipient.id,
        'network_type': recipient.networkType.name,
        'is_verified': recipient.isVerified,
      },
    );
  }

  /// Set recipient from the new Recipient model
  void setRecipientFromModel(Recipient recipient) {
    final recipientInfo = RecipientInfo(
      id: recipient.id,
      name: recipient.name,
      phoneNumber: recipient.phone,
      email: null,
      networkType: NetworkType.mobileMoney, // Default to mobile money
      networkName: 'M-Pesa', // Default network
      bankCode: null,
      accountNumber: null,
      isVerified: true, // Assume verified for now
      isFavorite: false,
    );

    setRecipient(recipientInfo);
  }

  /// Search for recipients
  void searchRecipients(String query) {
    state = state.copyWith(recipientSearchQuery: query);

    // Mock search results - in real app, this would call an API
    final mockResults = _getMockSearchResults(query);
    state = state.copyWith(searchResults: mockResults);
  }

  /// Set selected network
  void setSelectedNetwork(NetworkInfo network) {
    state = state.copyWith(selectedNetwork: network, networkError: null);
    _saveDraft();

    _analytics.trackEvent(
      'send_network_selected',
      parameters: {
        'network_id': network.id,
        'network_type': network.type.name,
        'country': network.country,
      },
    );
  }

  /// Set available networks
  void setAvailableNetworks(List<NetworkInfo> networks) {
    state = state.copyWith(availableNetworks: networks);
  }

  /// Set network error
  void setNetworkError(String error) {
    state = state.copyWith(networkError: error);

    _analytics.trackEvent(
      'send_network_error',
      parameters: {'error': error, 'step': state.currentStep.name},
    );
  }

  /// Set amount and currency
  void setAmount(Money amount, {String? fromCurrency, String? toCurrency}) {
    state = state.copyWith(
      amount: amount,
      fromCurrency: fromCurrency ?? state.fromCurrency,
      toCurrency: toCurrency ?? state.toCurrency,
    );
    _saveDraft();

    _analytics.trackEvent(
      'send_amount_set',
      parameters: {
        'amount': amount.minor,
        'currency': amount.currency,
        'from_currency': fromCurrency ?? state.fromCurrency,
        'to_currency': toCurrency ?? state.toCurrency,
      },
    );
  }

  /// Calculate fees for current amount and network
  Future<void> calculateFees() async {
    if (state.amount == null || state.selectedNetwork == null) {
      return;
    }

    state = state.copyWith(isCalculatingFees: true, feeCalculationError: null);

    try {
      final feeCalculation = await _feesRepo.calculateFees(
        amount: state.amount!,
        network: state.selectedNetwork!,
        fromCurrency: state.fromCurrency,
        toCurrency: state.toCurrency,
      );

      state = state.copyWith(
        feeCalculation: feeCalculation,
        isCalculatingFees: false,
      );
      _saveDraft();

      _analytics.trackEvent(
        'send_fees_calculated',
        parameters: {
          'amount': state.amount!.minor,
          'currency': state.amount!.currency,
          'network_fee': feeCalculation.networkFee.minor,
          'platform_fee': feeCalculation.platformFee.minor,
          'total_fee': feeCalculation.totalFee.minor,
        },
      );
    } catch (e) {
      state = state.copyWith(
        isCalculatingFees: false,
        feeCalculationError: e.toString(),
      );

      _analytics.trackEvent(
        'send_fees_error',
        parameters: {
          'error': e.toString(),
          'amount': state.amount!.minor,
          'currency': state.amount!.currency,
        },
      );
    }
  }

  /// Submit the send money transaction
  Future<void> submitTransaction() async {
    if (!state.canSubmit) {
      return;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      // Mock transaction submission
      await Future.delayed(const Duration(seconds: 2));

      final transactionId = 'txn_${DateTime.now().millisecondsSinceEpoch}';

      state = state.copyWith(
        isSubmitting: false,
        transactionId: transactionId,
        currentStep: SendStep.success,
      );

      // Clear draft after successful submission
      await _clearDraft();

      _analytics.trackEvent(
        'send_submit',
        parameters: {
          'transaction_id': transactionId,
          'amount': state.amount!.minor,
          'currency': state.amount!.currency,
          'network_id': state.selectedNetwork!.id,
          'recipient_id': state.recipient!.id,
          'total_fee': state.feeCalculation!.totalFee.minor,
        },
      );
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());

      _analytics.trackEvent(
        'send_error',
        parameters: {
          'error': e.toString(),
          'code': 'SUBMIT_FAILED',
          'step': state.currentStep.name,
        },
      );
    }
  }

  /// Reset the entire flow
  void resetFlow() {
    state = const SendState();
    _clearDraft();

    _analytics.trackEvent('send_flow_reset');
  }

  /// Toggle currency selector visibility
  void toggleCurrencySelector() {
    state = state.copyWith(showCurrencySelector: !state.showCurrencySelector);
  }

  /// Get mock search results for testing
  List<RecipientInfo> _getMockSearchResults(String query) {
    if (query.isEmpty) {
      return state.recentRecipients;
    }

    final allRecipients = [
      const RecipientInfo(
        id: '1',
        name: 'John Doe',
        phoneNumber: '+1234567890',
        email: 'john@example.com',
        networkType: NetworkType.mobileMoney,
        networkName: 'M-Pesa',
        bankCode: null,
        accountNumber: null,
        isVerified: true,
      ),
      const RecipientInfo(
        id: '2',
        name: 'Jane Smith',
        phoneNumber: '+1987654321',
        email: 'jane@example.com',
        networkType: NetworkType.bankTransfer,
        networkName: 'Chase Bank',
        bankCode: 'CHASE',
        accountNumber: '1234567890',
        isVerified: true,
      ),
      const RecipientInfo(
        id: '3',
        name: 'Bob Johnson',
        phoneNumber: '+1555123456',
        email: 'bob@example.com',
        networkType: NetworkType.mobileMoney,
        networkName: 'Venmo',
        bankCode: null,
        accountNumber: null,
        isVerified: false,
      ),
    ];

    return allRecipients
        .where(
          (recipient) =>
              recipient.name.toLowerCase().contains(query.toLowerCase()) ||
              recipient.phoneNumber.contains(query) ||
              (recipient.email?.toLowerCase().contains(query.toLowerCase()) ??
                  false),
        )
        .toList();
  }
}
