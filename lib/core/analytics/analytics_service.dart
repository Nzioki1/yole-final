import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'analytics.dart';

/// Analytics service implementation using the Analytics interface
///
/// This service provides a centralized way to track user interactions
/// and app events. It uses the Analytics interface to allow easy swapping
/// between fake (for tests) and real (Firebase) implementations.
class AnalyticsService implements Analytics {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  /// The underlying analytics implementation
  Analytics _analytics = FakeAnalytics();

  /// Initialize the analytics service with a specific implementation
  void initialize(Analytics analytics) {
    _analytics = analytics;
  }

  /// Get the current analytics implementation (for testing)
  Analytics get implementation => _analytics;

  @override
  Future<void> logEvent(String name, [Map<String, dynamic>? params]) async {
    await _analytics.logEvent(name, params);
  }

  @override
  Future<void> logScreenView(
    String screenName, [
    Map<String, dynamic>? params,
  ]) async {
    await _analytics.logScreenView(screenName, params);
  }

  @override
  Future<void> logUserAction(
    String action, [
    Map<String, dynamic>? params,
  ]) async {
    await _analytics.logUserAction(action, params);
  }

  @override
  Future<void> logError(String error, [Map<String, dynamic>? params]) async {
    await _analytics.logError(error, params);
  }

  @override
  Future<void> setUserProperties(Map<String, dynamic> properties) async {
    await _analytics.setUserProperties(properties);
  }

  @override
  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(userId);
  }

  // Legacy methods for backward compatibility
  /// Track a custom event (legacy method)
  void trackEvent(String eventName, {Map<String, dynamic>? parameters}) {
    logEvent(eventName, parameters);
  }

  /// Track screen view (legacy method)
  void trackScreenView(String screenName, {Map<String, dynamic>? parameters}) {
    logScreenView(screenName, parameters);
  }

  /// Track user action (legacy method)
  void trackUserAction(String action, {Map<String, dynamic>? parameters}) {
    logUserAction(action, parameters);
  }

  /// Track error (legacy method)
  void trackError(String error, {Map<String, dynamic>? parameters}) {
    logError(error, parameters);
  }

  /// Track auth login success (legacy method)
  void authLoginSuccess() {
    logUserAction('auth_login_success');
  }

  /// Track auth register success (legacy method)
  void authRegisterSuccess() {
    logUserAction('auth_register_success');
  }
}

/// Analytics events for the Send Money flow
class SendFlowAnalytics {
  static const String _prefix = 'send_';

  /// Track when a user views a step in the send flow
  static void trackStepViewed(String step) {
    AnalyticsService().trackEvent(
      '${_prefix}step_viewed',
      parameters: {'step': step},
    );
  }

  /// Track when a user submits the send flow
  static void trackSubmit({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
    required String network,
    required String recipientType,
  }) {
    AnalyticsService().trackEvent(
      '${_prefix}submit',
      parameters: {
        'from_currency': fromCurrency,
        'to_currency': toCurrency,
        'amount': amount,
        'network': network,
        'recipient_type': recipientType,
      },
    );
  }

  /// Track when an error occurs in the send flow
  static void trackError(String code, {String? step, String? message}) {
    AnalyticsService().trackEvent(
      '${_prefix}error',
      parameters: {
        'error_code': code,
        if (step != null) 'step': step,
        if (message != null) 'message': message,
      },
    );
  }

  /// Track when a user cancels the send flow
  static void trackCancel({String? step}) {
    AnalyticsService().trackEvent(
      '${_prefix}cancel',
      parameters: {if (step != null) 'step': step},
    );
  }

  /// Track when a user completes the send flow successfully
  static void trackSuccess({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
    required String network,
    required String recipientType,
    required String transactionId,
  }) {
    AnalyticsService().trackEvent(
      '${_prefix}success',
      parameters: {
        'from_currency': fromCurrency,
        'to_currency': toCurrency,
        'amount': amount,
        'network': network,
        'recipient_type': recipientType,
        'transaction_id': transactionId,
      },
    );
  }

  /// Track when a user selects a network
  static void trackNetworkSelected(String network) {
    AnalyticsService().trackEvent(
      '${_prefix}network_selected',
      parameters: {'network': network},
    );
  }

  /// Track when a user selects a currency
  static void trackCurrencySelected(String currency) {
    AnalyticsService().trackEvent(
      '${_prefix}currency_selected',
      parameters: {'currency': currency},
    );
  }

  /// Track when a user enters an amount
  static void trackAmountEntered(double amount, String currency) {
    AnalyticsService().trackEvent(
      '${_prefix}amount_entered',
      parameters: {'amount': amount, 'currency': currency},
    );
  }

  /// Track when a user selects a recipient
  static void trackRecipientSelected(String recipientType) {
    AnalyticsService().trackEvent(
      '${_prefix}recipient_selected',
      parameters: {'recipient_type': recipientType},
    );
  }

  /// Track user action (legacy method)
  static void trackUserAction(String action) {
    AnalyticsService().logUserAction(action);
  }
}

/// Provider for analytics service
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});
