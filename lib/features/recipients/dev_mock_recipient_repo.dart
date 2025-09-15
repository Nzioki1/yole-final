import 'recipient.dart';
import 'recipient_repo.dart';

/// Development mock repository for recipients
class DevMockRecipientRepo implements RecipientRepo {
  static const _data = [
    Recipient(id: 'r1', name: 'John Doe', phone: '+254700000001'),
    Recipient(id: 'r2', name: 'Mary W.', phone: '+254700000002'),
    Recipient(id: 'r3', name: 'Acme Traders', phone: '+254700000003'),
  ];

  @override
  Future<List<Recipient>> recent() async => _data;

  @override
  Future<List<Recipient>> search(String q) async {
    if (q.trim().isEmpty) return _data;
    final s = q.toLowerCase();
    return _data
        .where((r) => r.name.toLowerCase().contains(s) || r.phone.contains(q))
        .toList();
  }
}
