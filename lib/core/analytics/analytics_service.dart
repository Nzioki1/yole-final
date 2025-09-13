import 'dart:io';
import 'package:flutter/foundation.dart';

/// Analytics service for tracking user events
///
/// Events are defined in PRD Section 14: Analytics (Client Events)
/// For now, prints to debug console unless ANALYTICS_DSN is present in .env
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  String? _dsn;
  bool _isInitialized = false;

  /// Initialize the analytics service
  /// Checks for ANALYTICS_DSN in environment variables
  Future<void> initialize() async {
    if (_isInitialized) return;

    // In a real implementation, you'd load from .env file
    // For now, we'll check if we're in debug mode
    _dsn = kDebugMode ? null : Platform.environment['ANALYTICS_DSN'];
    _isInitialized = true;

    if (_dsn != null) {
      debugPrint('Analytics initialized with DSN');
    } else {
      debugPrint('Analytics initialized in debug mode (console logging)');
    }
  }

  /// Track an analytics event
  ///
  /// [eventName] - The event name from PRD
  /// [properties] - Optional event properties
  void track(String eventName, {Map<String, dynamic>? properties}) {
    if (!_isInitialized) {
      debugPrint('Analytics not initialized, skipping event: $eventName');
      return;
    }

    final event = {
      'event': eventName,
      'timestamp': DateTime.now().toIso8601String(),
      'properties': properties ?? {},
    };

    if (_dsn != null) {
      // In a real implementation, send to analytics service
      _sendToAnalyticsService(event);
    } else {
      // Debug mode - print to console
      debugPrint('📊 Analytics Event: $eventName');
      if (properties != null && properties.isNotEmpty) {
        debugPrint('   Properties: $properties');
      }
    }
  }

  /// Send event to analytics service (placeholder)
  void _sendToAnalyticsService(Map<String, dynamic> event) {
    // TODO: Implement actual analytics service integration
    // This could be Firebase Analytics, Mixpanel, Amplitude, etc.
    debugPrint('📊 [ANALYTICS] $event');
  }

  // Auth Events
  void authRegisterSuccess({String? userId}) {
    track(
      'auth_register_success',
      properties: {if (userId != null) 'user_id': userId},
    );
  }

  void authLoginSuccess({String? userId}) {
    track(
      'auth_login_success',
      properties: {if (userId != null) 'user_id': userId},
    );
  }

  // KYC Events
  void kycSubmitted({String? step}) {
    track('kyc_submitted', properties: {if (step != null) 'step': step});
  }

  // Email Events
  void emailVerificationSent() {
    track('email_verification_sent');
  }

  void emailVerified() {
    track('email_verified');
  }

  // Quote Events
  void quoteRequested({
    required double amountUsd,
    required String recipientCountry,
  }) {
    track(
      'quote_requested',
      properties: {
        'amount_usd': amountUsd,
        'recipient_country': recipientCountry,
      },
    );
  }

  void quoteReceived({
    required double amountUsd,
    required double feeUsd,
    required double receiveAmountUsd,
  }) {
    track(
      'quote_received',
      properties: {
        'amount_usd': amountUsd,
        'fee_usd': feeUsd,
        'receive_amount_usd': receiveAmountUsd,
      },
    );
  }

  void quoteFailed({required double amountUsd, String? error}) {
    track(
      'quote_failed',
      properties: {'amount_usd': amountUsd, if (error != null) 'error': error},
    );
  }

  // Send Events
  void sendInitiated({
    required double amountUsd,
    required String recipientCountry,
  }) {
    track(
      'send_initiated',
      properties: {
        'amount_usd': amountUsd,
        'recipient_country': recipientCountry,
      },
    );
  }

  void paymentMethodSelected({required String method}) {
    track(
      'payment_method_selected',
      properties: {
        'method': method, // 'card' or 'mpesa'
      },
    );
  }

  void sendConfirmed({
    required double amountUsd,
    required String paymentMethod,
  }) {
    track(
      'send_confirmed',
      properties: {'amount_usd': amountUsd, 'payment_method': paymentMethod},
    );
  }

  void sendSuccess({required String transactionId, required double amountUsd}) {
    track(
      'send_success',
      properties: {'transaction_id': transactionId, 'amount_usd': amountUsd},
    );
  }

  void sendFailed({required double amountUsd, String? error}) {
    track(
      'send_failed',
      properties: {'amount_usd': amountUsd, if (error != null) 'error': error},
    );
  }

  // Transaction Events
  void statusRefreshClicked({required String transactionId}) {
    track(
      'status_refresh_clicked',
      properties: {'transaction_id': transactionId},
    );
  }

  void repeatSendClicked({required String transactionId}) {
    track('repeat_send_clicked', properties: {'transaction_id': transactionId});
  }

  void favoriteSendClicked({required String transactionId}) {
    track(
      'favorite_send_clicked',
      properties: {'transaction_id': transactionId},
    );
  }

  // Settings Events
  void toggleDarkMode() {
    track('toggle_dark_mode');
  }

  void toggleLightMode() {
    track('toggle_light_mode');
  }

  void toggleBiometrics({required bool enabled}) {
    track('toggle_biometrics', properties: {'enabled': enabled});
  }
}
