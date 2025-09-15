import 'recipient.dart';

/// Repository interface for managing recipients
abstract class RecipientRepo {
  /// Search for recipients by query
  Future<List<Recipient>> search(String query);

  /// Get recent recipients
  Future<List<Recipient>> recent();
}
