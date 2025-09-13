import '../api/yole_api_client.dart';

/// Transactions repository
///
/// Handles:
/// - Fetching user transaction history
/// - Transaction details and status
/// - Repeat transaction functionality
///
/// Uses dynamic models for MVP - TODO: Add strong typing later
class TransactionsRepository {
  const TransactionsRepository(this._apiClient);

  final YoleApiClient _apiClient;

  /// Get user's transaction history
  ///
  /// Returns: List of transaction objects
  Future<List<dynamic>> getTransactions() async {
    return await _apiClient.getTransactions();
  }

  /// Get transaction by ID (from local list or API)
  Future<Map<String, dynamic>?> getTransactionById({
    required String transactionId,
  }) async {
    final transactions = await getTransactions();

    try {
      return transactions.firstWhere(
        (transaction) => transaction['id'] == transactionId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Refresh transaction status
  Future<Map<String, dynamic>?> refreshTransactionStatus({
    required String orderTrackingId,
  }) async {
    try {
      return await _apiClient.getTransactionStatus({
        'order_tracking_id': orderTrackingId,
      });
    } catch (e) {
      return null;
    }
  }

  /// Get recent transactions (last 10)
  Future<List<dynamic>> getRecentTransactions() async {
    final transactions = await getTransactions();

    // Sort by creation date (newest first) and take first 10
    transactions.sort((a, b) {
      final dateA = DateTime.tryParse(a['createdAt'] ?? '');
      final dateB = DateTime.tryParse(b['createdAt'] ?? '');

      if (dateA == null || dateB == null) return 0;
      return dateB.compareTo(dateA);
    });

    return transactions.take(10).toList();
  }
}
