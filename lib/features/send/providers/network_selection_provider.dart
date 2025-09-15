/// Network selection provider for managing network state and validation
///
/// Handles:
/// - Network loading and fee calculations
/// - Validation based on amount and currency
/// - Disabled states and error handling
/// - Persistence of last-used network
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/money.dart';
import '../../../data/repos/fees_repo.dart';
import '../../../data/api/yole_api_client.dart';
import '../state/send_state.dart';

/// Network selection state
class NetworkSelectionState {
  /// Available networks with fee information
  final List<NetworkInfo> networks;
  
  /// Selected network
  final NetworkInfo? selectedNetwork;
  
  /// Current amount for validation
  final Money? amount;
  
  /// Current currency
  final String currency;
  
  /// Whether networks are loading
  final bool isLoading;
  
  /// Error message if any
  final String? error;
  
  /// Fee calculations for each network
  final Map<String, Money> feeCalculations;
  
  /// Validation errors for each network
  final Map<String, String> validationErrors;

  const NetworkSelectionState({
    this.networks = const [],
    this.selectedNetwork,
    this.amount,
    this.currency = 'USD',
    this.isLoading = false,
    this.error,
    this.feeCalculations = const {},
    this.validationErrors = const {},
  });

  /// Check if a network is available
  bool isNetworkAvailable(NetworkInfo network) {
    return network.isActive && 
           validationErrors[network.id] == null &&
           (network.requiredCurrency == null || network.requiredCurrency == currency);
  }

  /// Check if a network is disabled
  bool isNetworkDisabled(NetworkInfo network) {
    return !isNetworkAvailable(network);
  }

  /// Get disabled reason for a network
  String? getDisabledReason(NetworkInfo network) {
    if (!network.isActive) {
      return network.unavailabilityReason ?? 'Temporarily unavailable';
    }
    
    if (network.requiredCurrency != null && network.requiredCurrency != currency) {
      return 'Only supports ${network.requiredCurrency}';
    }
    
    if (amount != null) {
      if (amount!.major < network.minAmount) {
        return 'Minimum amount is \$${network.minAmount.toStringAsFixed(2)}';
      }
      if (amount!.major > network.maxAmount) {
        return 'Maximum amount is \$${network.maxAmount.toStringAsFixed(2)}';
      }
    }
    
    return validationErrors[network.id];
  }

  /// Get fee preview for a network
  Money? getFeePreview(NetworkInfo network) {
    return feeCalculations[network.id];
  }

  /// Copy with updated fields
  NetworkSelectionState copyWith({
    List<NetworkInfo>? networks,
    NetworkInfo? selectedNetwork,
    Money? amount,
    String? currency,
    bool? isLoading,
    String? error,
    Map<String, Money>? feeCalculations,
    Map<String, String>? validationErrors,
  }) {
    return NetworkSelectionState(
      networks: networks ?? this.networks,
      selectedNetwork: selectedNetwork ?? this.selectedNetwork,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      feeCalculations: feeCalculations ?? this.feeCalculations,
      validationErrors: validationErrors ?? this.validationErrors,
    );
  }
}

/// Network selection notifier
class NetworkSelectionNotifier extends StateNotifier<NetworkSelectionState> {
  NetworkSelectionNotifier(this._feesRepository) : super(const NetworkSelectionState());

  final FeesRepository _feesRepository;

  /// Load available networks
  Future<void> loadNetworks({
    String currency = 'USD',
    String recipientCountry = 'US',
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Load network fee information
      final networkFees = await _feesRepository.getNetworkFees(
        currency: currency,
        recipientCountry: recipientCountry,
      );
      
      // Convert to NetworkInfo objects
      final networks = networkFees.map((fee) => NetworkInfo(
        id: fee.networkId,
        name: fee.networkName,
        type: _getNetworkType(fee.networkId),
        country: _getNetworkCountry(fee.networkId),
        currency: fee.requiredCurrency ?? currency,
        minAmount: fee.minAmountMinor / 100.0,
        maxAmount: fee.maxAmountMinor / 100.0,
        feePercentage: fee.feePercentage,
        fixedFee: fee.feeFixedMinor / 100.0,
        processingTimeMinutes: fee.processingTimeMinutes,
        isActive: fee.isAvailable,
        logoUrl: fee.logoUrl,
        unavailabilityReason: fee.unavailabilityReason,
        requiredCurrency: fee.requiredCurrency,
      )).toList();
      
      state = state.copyWith(
        networks: networks,
        isLoading: false,
        currency: currency,
      );
      
      // Calculate fees if amount is available
      if (state.amount != null) {
        await _calculateFees();
      }
      
      // Validate networks
      await _validateNetworks();
      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load networks: ${e.toString()}',
      );
    }
  }

  /// Update amount and recalculate fees
  Future<void> updateAmount(Money? amount) async {
    state = state.copyWith(amount: amount);
    
    if (amount != null) {
      await _calculateFees();
      await _validateNetworks();
    } else {
      state = state.copyWith(
        feeCalculations: {},
        validationErrors: {},
      );
    }
  }

  /// Update currency
  Future<void> updateCurrency(String currency) async {
    state = state.copyWith(currency: currency);
    
    // Reload networks with new currency
    await loadNetworks(currency: currency);
  }

  /// Select a network
  void selectNetwork(NetworkInfo network) {
    if (isNetworkAvailable(network)) {
      state = state.copyWith(selectedNetwork: network);
    }
  }

  /// Calculate fees for all networks
  Future<void> _calculateFees() async {
    if (state.amount == null) return;
    
    final feeCalculations = <String, Money>{};
    
    for (final network in state.networks) {
      try {
        final fee = await _feesRepository.calculateNetworkFee(
          networkId: network.id,
          amount: state.amount!,
        );
        
        if (fee != null) {
          feeCalculations[network.id] = fee;
        }
      } catch (e) {
        // Fee calculation failed, skip this network
      }
    }
    
    state = state.copyWith(feeCalculations: feeCalculations);
  }

  /// Validate all networks
  Future<void> _validateNetworks() async {
    if (state.amount == null) return;
    
    final validationErrors = <String, String>{};
    
    for (final network in state.networks) {
      try {
        final error = await _feesRepository.validateAmount(
          networkId: network.id,
          amount: state.amount!,
        );
        
        if (error != null) {
          validationErrors[network.id] = error;
        }
      } catch (e) {
        validationErrors[network.id] = 'Validation failed';
      }
    }
    
    state = state.copyWith(validationErrors: validationErrors);
  }

  /// Check if network is available (helper method)
  bool isNetworkAvailable(NetworkInfo network) {
    return state.isNetworkAvailable(network);
  }

  /// Get network type from ID (helper method)
  NetworkType _getNetworkType(String networkId) {
    switch (networkId.toLowerCase()) {
      case 'mpesa':
      case 'venmo':
      case 'paypal':
        return NetworkType.mobileMoney;
      case 'chase':
      case 'wise':
      case 'western_union':
        return NetworkType.bankTransfer;
      default:
        return NetworkType.mobileMoney;
    }
  }

  /// Get network country from ID (helper method)
  String _getNetworkCountry(String networkId) {
    switch (networkId.toLowerCase()) {
      case 'mpesa':
        return 'Kenya';
      case 'chase':
      case 'venmo':
      case 'paypal':
        return 'United States';
      case 'wise':
        return 'Global';
      case 'western_union':
        return 'Global';
      default:
        return 'Global';
    }
  }
}

/// API client provider
final yoleApiClientProvider = Provider<YoleApiClient>((ref) => createYoleApiClient());

/// Network selection provider
final networkSelectionProvider = StateNotifierProvider<NetworkSelectionNotifier, NetworkSelectionState>(
    (ref) => NetworkSelectionNotifier(FeesRepository(ref.watch(yoleApiClientProvider))),
);

/// Selected network provider
final selectedNetworkProvider = Provider<NetworkInfo?>((ref) {
  return ref.watch(networkSelectionProvider).selectedNetwork;
});

/// Available networks provider
final availableNetworksProvider = Provider<List<NetworkInfo>>((ref) {
  final state = ref.watch(networkSelectionProvider);
  return state.networks.where((network) => state.isNetworkAvailable(network)).toList();
});

/// Network validation provider
final networkValidationProvider = Provider.family<String?, String>((ref, networkId) {
  final state = ref.watch(networkSelectionProvider);
  return state.getDisabledReason(
    state.networks.firstWhere((n) => n.id == networkId),
  );
});
