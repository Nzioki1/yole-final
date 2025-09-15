import 'recipient.dart';

/// State for recipient management
class RecipientState {
  final List<Recipient> list;
  final bool loading;
  final String query;

  const RecipientState({
    this.list = const [],
    this.loading = false,
    this.query = '',
  });

  RecipientState copy({List<Recipient>? list, bool? loading, String? query}) =>
      RecipientState(
        list: list ?? this.list,
        loading: loading ?? this.loading,
        query: query ?? this.query,
      );
}
