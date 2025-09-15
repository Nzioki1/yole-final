// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecipientInfo _$RecipientInfoFromJson(Map<String, dynamic> json) =>
    _RecipientInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      networkType: $enumDecode(_$NetworkTypeEnumMap, json['networkType']),
      networkName: json['networkName'] as String,
      bankCode: json['bankCode'] as String?,
      accountNumber: json['accountNumber'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );

Map<String, dynamic> _$RecipientInfoToJson(_RecipientInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'networkType': _$NetworkTypeEnumMap[instance.networkType]!,
      'networkName': instance.networkName,
      'bankCode': instance.bankCode,
      'accountNumber': instance.accountNumber,
      'isVerified': instance.isVerified,
      'isFavorite': instance.isFavorite,
    };

const _$NetworkTypeEnumMap = {
  NetworkType.mobileMoney: 'mobileMoney',
  NetworkType.bankTransfer: 'bankTransfer',
  NetworkType.card: 'card',
  NetworkType.crypto: 'crypto',
};

_NetworkInfo _$NetworkInfoFromJson(Map<String, dynamic> json) => _NetworkInfo(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$NetworkTypeEnumMap, json['type']),
  country: json['country'] as String,
  currency: json['currency'] as String,
  minAmount: (json['minAmount'] as num?)?.toDouble() ?? 0,
  maxAmount: (json['maxAmount'] as num?)?.toDouble() ?? 0,
  feePercentage: (json['feePercentage'] as num?)?.toDouble() ?? 0,
  fixedFee: (json['fixedFee'] as num?)?.toDouble() ?? 0,
  processingTimeMinutes: (json['processingTimeMinutes'] as num?)?.toInt() ?? 0,
  isActive: json['isActive'] as bool? ?? true,
  isRecommended: json['isRecommended'] as bool? ?? false,
);

Map<String, dynamic> _$NetworkInfoToJson(_NetworkInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$NetworkTypeEnumMap[instance.type]!,
      'country': instance.country,
      'currency': instance.currency,
      'minAmount': instance.minAmount,
      'maxAmount': instance.maxAmount,
      'feePercentage': instance.feePercentage,
      'fixedFee': instance.fixedFee,
      'processingTimeMinutes': instance.processingTimeMinutes,
      'isActive': instance.isActive,
      'isRecommended': instance.isRecommended,
    };

_FeeCalculation _$FeeCalculationFromJson(Map<String, dynamic> json) =>
    _FeeCalculation(
      networkFee: Money.fromJson(json['networkFee'] as Map<String, dynamic>),
      platformFee: Money.fromJson(json['platformFee'] as Map<String, dynamic>),
      totalFee: Money.fromJson(json['totalFee'] as Map<String, dynamic>),
      totalAmount: Money.fromJson(json['totalAmount'] as Map<String, dynamic>),
      recipientAmount: Money.fromJson(
        json['recipientAmount'] as Map<String, dynamic>,
      ),
      exchangeRate: (json['exchangeRate'] as num?)?.toDouble() ?? 0.0,
      exchangeRateSource: json['exchangeRateSource'] as String? ?? '',
      estimatedProcessingTimeMinutes:
          (json['estimatedProcessingTimeMinutes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FeeCalculationToJson(_FeeCalculation instance) =>
    <String, dynamic>{
      'networkFee': instance.networkFee,
      'platformFee': instance.platformFee,
      'totalFee': instance.totalFee,
      'totalAmount': instance.totalAmount,
      'recipientAmount': instance.recipientAmount,
      'exchangeRate': instance.exchangeRate,
      'exchangeRateSource': instance.exchangeRateSource,
      'estimatedProcessingTimeMinutes': instance.estimatedProcessingTimeMinutes,
    };

_SendState _$SendStateFromJson(Map<String, dynamic> json) => _SendState(
  currentStep:
      $enumDecodeNullable(_$SendStepEnumMap, json['currentStep']) ??
      SendStep.start,
  completedSteps:
      (json['completedSteps'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$SendStepEnumMap, e))
          .toList() ??
      const [],
  recipient: json['recipient'] == null
      ? null
      : RecipientInfo.fromJson(json['recipient'] as Map<String, dynamic>),
  recentRecipients:
      (json['recentRecipients'] as List<dynamic>?)
          ?.map((e) => RecipientInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  favoriteRecipients:
      (json['favoriteRecipients'] as List<dynamic>?)
          ?.map((e) => RecipientInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  recipientSearchQuery: json['recipientSearchQuery'] as String? ?? '',
  searchResults:
      (json['searchResults'] as List<dynamic>?)
          ?.map((e) => RecipientInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  selectedNetwork: json['selectedNetwork'] == null
      ? null
      : NetworkInfo.fromJson(json['selectedNetwork'] as Map<String, dynamic>),
  availableNetworks:
      (json['availableNetworks'] as List<dynamic>?)
          ?.map((e) => NetworkInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  networkError: json['networkError'] as String?,
  amount: json['amount'] == null
      ? null
      : Money.fromJson(json['amount'] as Map<String, dynamic>),
  fromCurrency: json['fromCurrency'] as String? ?? 'USD',
  toCurrency: json['toCurrency'] as String? ?? 'USD',
  showCurrencySelector: json['showCurrencySelector'] as bool? ?? false,
  feeCalculation: json['feeCalculation'] == null
      ? null
      : FeeCalculation.fromJson(json['feeCalculation'] as Map<String, dynamic>),
  isCalculatingFees: json['isCalculatingFees'] as bool? ?? false,
  feeCalculationError: json['feeCalculationError'] as String?,
  isLoading: json['isLoading'] as bool? ?? false,
  isSubmitting: json['isSubmitting'] as bool? ?? false,
  error: json['error'] as String?,
  transactionId: json['transactionId'] as String?,
  hasDraft: json['hasDraft'] as bool? ?? false,
  draftTimestamp: (json['draftTimestamp'] as num?)?.toInt() ?? 0,
  stepViewCount: (json['stepViewCount'] as num?)?.toInt() ?? 0,
  analyticsData: json['analyticsData'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$SendStateToJson(_SendState instance) =>
    <String, dynamic>{
      'currentStep': _$SendStepEnumMap[instance.currentStep]!,
      'completedSteps': instance.completedSteps
          .map((e) => _$SendStepEnumMap[e]!)
          .toList(),
      'recipient': instance.recipient,
      'recentRecipients': instance.recentRecipients,
      'favoriteRecipients': instance.favoriteRecipients,
      'recipientSearchQuery': instance.recipientSearchQuery,
      'searchResults': instance.searchResults,
      'selectedNetwork': instance.selectedNetwork,
      'availableNetworks': instance.availableNetworks,
      'networkError': instance.networkError,
      'amount': instance.amount,
      'fromCurrency': instance.fromCurrency,
      'toCurrency': instance.toCurrency,
      'showCurrencySelector': instance.showCurrencySelector,
      'feeCalculation': instance.feeCalculation,
      'isCalculatingFees': instance.isCalculatingFees,
      'feeCalculationError': instance.feeCalculationError,
      'isLoading': instance.isLoading,
      'isSubmitting': instance.isSubmitting,
      'error': instance.error,
      'transactionId': instance.transactionId,
      'hasDraft': instance.hasDraft,
      'draftTimestamp': instance.draftTimestamp,
      'stepViewCount': instance.stepViewCount,
      'analyticsData': instance.analyticsData,
    };

const _$SendStepEnumMap = {
  SendStep.start: 'start',
  SendStep.recipient: 'recipient',
  SendStep.network: 'network',
  SendStep.amount: 'amount',
  SendStep.review: 'review',
  SendStep.auth: 'auth',
  SendStep.success: 'success',
};
