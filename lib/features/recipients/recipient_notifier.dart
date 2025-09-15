import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'recipient_repo.dart';
import 'recipient_state.dart';
import 'dev_mock_recipient_repo.dart';

/// Notifier for managing recipient state
class RecipientNotifier extends StateNotifier<RecipientState> {
  RecipientNotifier(this._repo) : super(const RecipientState());

  final RecipientRepo _repo;

  Future<void> loadRecent() async {
    print('RecipientNotifier.loadRecent() called');
    state = state.copy(loading: true);
    final list = await _repo.recent();
    print(
      'Loaded ${list.length} recipients: ${list.map((r) => r.name).join(', ')}',
    );
    state = state.copy(loading: false, list: list);
  }

  Future<void> search(String q) async {
    print('RecipientNotifier.search() called with query: "$q"');
    state = state.copy(loading: true, query: q);
    final list = await _repo.search(q);
    print(
      'Search returned ${list.length} recipients: ${list.map((r) => r.name).join(', ')}',
    );
    state = state.copy(loading: false, list: list);
  }
}

/// Provider for recipient repository
final recipientRepoProvider = Provider<RecipientRepo>(
  (ref) => DevMockRecipientRepo(),
);

/// Provider for recipient notifier
final recipientNotifierProvider =
    StateNotifierProvider<RecipientNotifier, RecipientState>(
      (ref) => RecipientNotifier(ref.watch(recipientRepoProvider)),
    );
