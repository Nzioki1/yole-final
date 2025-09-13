import '../api/yole_api_client.dart';

/// Quotes and fees repository
///
/// Handles:
/// - Base charges calculation
/// - Yole service fees
/// - Quote expiration and refresh
///
/// Uses dynamic models for MVP - TODO: Add strong typing later
class QuotesRepository {
  const QuotesRepository(this._apiClient);

  final YoleApiClient _apiClient;

  /// Get base charges for amount and recipient country
  ///
  /// Expected payload: {
  ///   amount,
  ///   currency: "USD",
  ///   recipient_country: "CD"
  /// }
  Future<Map<String, dynamic>> getCharges({
    required double amount,
    String currency = 'USD',
    String recipientCountry = 'CD',
  }) async {
    return await _apiClient.getCharges({
      'amount': amount,
      'currency': currency,
      'recipient_country': recipientCountry,
    });
  }

  /// Get Yole service fees
  ///
  /// Expected payload: {
  ///   amount,
  ///   currency: "USD",
  ///   recipient_country: "CD"
  /// }
  Future<Map<String, dynamic>> getYoleCharges({
    required double amount,
    String currency = 'USD',
    String recipientCountry = 'CD',
  }) async {
    return await _apiClient.getYoleCharges({
      'amount': amount,
      'currency': currency,
      'recipient_country': recipientCountry,
    });
  }

  /// Get complete quote (base charges + Yole fees)
  ///
  /// Combines getCharges and getYoleCharges for full breakdown
  Future<Map<String, dynamic>> getCompleteQuote({
    required double amount,
    String currency = 'USD',
    String recipientCountry = 'CD',
  }) async {
    final baseCharges = await getCharges(
      amount: amount,
      currency: currency,
      recipientCountry: recipientCountry,
    );

    final yoleCharges = await getYoleCharges(
      amount: amount,
      currency: currency,
      recipientCountry: recipientCountry,
    );

    return {
      'base_charges': baseCharges,
      'yole_charges': yoleCharges,
      'total_amount': amount,
      'currency': currency,
      'recipient_country': recipientCountry,
      'expires_at': DateTime.now()
          .add(const Duration(minutes: 10))
          .toIso8601String(),
    };
  }
}
