import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pesapal sandbox integration repository
///
/// Implements Pesapal v3 sandbox flow per PRD Section 7:
/// 1. Auth: POST /api/Auth/RequestToken (Bearer ~5min)
/// 2. Register IPN: POST /api/URLSetup/RegisterIPN (one-time; store ipn_id)
/// 3. Submit Order: POST /api/Transactions/SubmitOrderRequest
/// 4. Get Status: GET /api/Transactions/GetTransactionStatus
///
/// Uses dynamic models for MVP - TODO: Add strong typing later
class PesapalRepository {
  const PesapalRepository(this._dio);

  final Dio _dio;

  static const String _ipnIdKey = 'pesapal_ipn_id';
  static const String _tokenKey = 'pesapal_bearer_token';
  static const String _tokenExpiryKey = 'pesapal_token_expiry';

  /// Get Pesapal sandbox base URL
  String get _baseUrl =>
      dotenv.env['PESAPAL_BASE'] ?? 'https://cybqa.pesapal.com/pesapalv3';

  /// Get consumer key from environment
  String get _consumerKey => dotenv.env['PESAPAL_CONSUMER_KEY'] ?? '';

  /// Get consumer secret from environment
  String get _consumerSecret => dotenv.env['PESAPAL_CONSUMER_SECRET'] ?? '';

  /// Get callback URL from environment
  String get _callbackUrl => dotenv.env['PESAPAL_CALLBACK_URL'] ?? '';

  /// Get IPN URL from environment
  String get _ipnUrl => dotenv.env['PESAPAL_IPN_URL'] ?? '';

  /// Authenticate with Pesapal and get bearer token
  ///
  /// Returns bearer token with ~5min TTL
  Future<String> authenticate() async {
    try {
      final response = await _dio.post(
        '$_baseUrl/api/Auth/RequestToken',
        data: {
          'consumer_key': _consumerKey,
          'consumer_secret': _consumerSecret,
        },
      );

      final token = response.data['token'] as String;
      final expiresAt = DateTime.now().add(const Duration(minutes: 5));

      // Store token and expiry
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      await prefs.setString(_tokenExpiryKey, expiresAt.toIso8601String());

      return token;
    } catch (e) {
      throw Exception('Failed to authenticate with Pesapal: $e');
    }
  }

  /// Get valid bearer token (refresh if needed)
  Future<String> _getValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString(_tokenKey);
    final storedExpiry = prefs.getString(_tokenExpiryKey);

    // Check if token exists and is not expired
    if (storedToken != null && storedExpiry != null) {
      final expiry = DateTime.tryParse(storedExpiry);
      if (expiry != null && expiry.isAfter(DateTime.now())) {
        return storedToken;
      }
    }

    // Token expired or doesn't exist, get new one
    return await authenticate();
  }

  /// Register IPN URL (one-time setup)
  ///
  /// Returns IPN ID for use in order creation
  Future<String> registerIpn() async {
    try {
      // Check if IPN already registered
      final prefs = await SharedPreferences.getInstance();
      final existingIpnId = prefs.getString(_ipnIdKey);
      if (existingIpnId != null) {
        return existingIpnId;
      }

      final token = await _getValidToken();

      final response = await _dio.post(
        '$_baseUrl/api/URLSetup/RegisterIPN',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {'url': _ipnUrl, 'ipn_notification_type': 'GET'},
      );

      final ipnId = response.data['ipn_id'] as String;

      // Store IPN ID for future use
      await prefs.setString(_ipnIdKey, ipnId);

      return ipnId;
    } catch (e) {
      throw Exception('Failed to register IPN: $e');
    }
  }

  /// Submit order for payment
  ///
  /// Returns order_tracking_id and redirect_url
  Future<Map<String, dynamic>> submitOrder({
    required String merchantReference,
    required String currency,
    required double amount,
    required String description,
    required Map<String, dynamic> billingAddress,
  }) async {
    try {
      final token = await _getValidToken();
      final ipnId = await registerIpn();

      final response = await _dio.post(
        '$_baseUrl/api/Transactions/SubmitOrderRequest',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'id': merchantReference,
          'currency': currency,
          'amount': amount,
          'description': description,
          'callback_url': _callbackUrl,
          'notification_id': ipnId,
          'billing_address': billingAddress,
        },
      );

      return {
        'order_tracking_id': response.data['order_tracking_id'],
        'redirect_url': response.data['redirect_url'],
      };
    } catch (e) {
      throw Exception('Failed to submit order: $e');
    }
  }

  /// Get transaction status by order tracking ID
  ///
  /// Returns status_code (1 COMPLETED, 2 FAILED, 3 REVERSED, 0 INVALID)
  Future<Map<String, dynamic>> getTransactionStatus({
    required String orderTrackingId,
  }) async {
    try {
      final token = await _getValidToken();

      final response = await _dio.get(
        '$_baseUrl/api/Transactions/GetTransactionStatus',
        queryParameters: {'orderTrackingId': orderTrackingId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.data;
    } catch (e) {
      throw Exception('Failed to get transaction status: $e');
    }
  }

  /// Check if transaction is completed
  bool isTransactionCompleted(Map<String, dynamic> status) {
    final statusCode = status['status_code'] as int?;
    return statusCode == 1; // 1 = COMPLETED
  }

  /// Check if transaction failed
  bool isTransactionFailed(Map<String, dynamic> status) {
    final statusCode = status['status_code'] as int?;
    return statusCode == 2; // 2 = FAILED
  }

  /// Check if transaction was reversed
  bool isTransactionReversed(Map<String, dynamic> status) {
    final statusCode = status['status_code'] as int?;
    return statusCode == 3; // 3 = REVERSED
  }

  /// Check if transaction is invalid
  bool isTransactionInvalid(Map<String, dynamic> status) {
    final statusCode = status['status_code'] as int?;
    return statusCode == 0; // 0 = INVALID
  }

  /// Clear stored tokens and IPN ID (for testing or logout)
  Future<void> clearStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_tokenExpiryKey);
    await prefs.remove(_ipnIdKey);
  }
}
