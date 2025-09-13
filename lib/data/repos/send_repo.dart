import '../api/yole_api_client.dart';

/// Send money repository
///
/// Handles:
/// - Creating send money requests
/// - Transaction status checking
/// - Idempotency key management
///
/// Uses dynamic models for MVP - TODO: Add strong typing later
class SendRepository {
  const SendRepository(this._apiClient);

  final YoleApiClient _apiClient;

  /// Send money to recipient
  ///
  /// Expected payload: {
  ///   sending_amount,
  ///   recipient_country,
  ///   phone_number,
  ///   idempotency_key (optional)
  /// }
  ///
  /// Returns: { order_tracking_id, ... }
  Future<Map<String, dynamic>> sendMoney({
    required double sendingAmount,
    required String recipientCountry,
    required String phoneNumber,
    String? idempotencyKey,
  }) async {
    final payload = {
      'sending_amount': sendingAmount,
      'recipient_country': recipientCountry,
      'phone_number': phoneNumber,
    };

    // Add idempotency key if provided
    if (idempotencyKey != null) {
      payload['idempotency_key'] = idempotencyKey;
    }

    return await _apiClient.sendMoney(payload);
  }

  /// Check transaction status by order tracking ID
  ///
  /// Expected payload: { order_tracking_id }
  Future<Map<String, dynamic>> getTransactionStatus({
    required String orderTrackingId,
  }) async {
    return await _apiClient.getTransactionStatus({
      'order_tracking_id': orderTrackingId,
    });
  }

  /// Generate unique idempotency key
  String generateIdempotencyKey() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 1000 + (timestamp % 1000)).toString();
    return 'send_${timestamp}_$random';
  }
}
