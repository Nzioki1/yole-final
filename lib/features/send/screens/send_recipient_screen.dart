/// Send Money Recipient Screen
///
/// This screen allows users to search for and select recipients
/// for money transfer.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../design/tokens.dart';
import '../../../design/typography.dart';
import '../../../widgets/gradient_button.dart';
import '../../../ui/layout/responsive_scaffold.dart';
import '../../../ui/layout/scroll_column.dart';
import '../state/send_notifier.dart';
import '../../../core/analytics/analytics_service.dart';
import '../state/send_state.dart';
import '../../recipients/recipient.dart';
import '../../recipients/recipient_state.dart';
import '../../recipients/recipient_notifier.dart';

/// Send money recipient screen
class SendRecipientScreen extends ConsumerStatefulWidget {
  const SendRecipientScreen({super.key});

  @override
  ConsumerState<SendRecipientScreen> createState() =>
      _SendRecipientScreenState();
}

class _SendRecipientScreenState extends ConsumerState<SendRecipientScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Load recent recipients when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Loading recent recipients...');
      ref.read(recipientNotifierProvider.notifier).loadRecent();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    ref.read(recipientNotifierProvider.notifier).search(query);
  }

  @override
  Widget build(BuildContext context) {
    final sendState = ref.watch(sendNotifierProvider);
    final recipientState = ref.watch(recipientNotifierProvider);

    // Track screen view
    SendFlowAnalytics.trackStepViewed('recipient');

    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('Select Recipient'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      keyboardSafe: true,
      body: ScrollColumn(
        children: [
          // Search section
          ScrollColumn(
            children: [
              Text(
                'Who are you sending money to?',
                style: AppTypography.h2.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                softWrap: true,
              ),

              // Search field
              TextField(
                key: const Key('recipient_input'),
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search by name, phone, or email',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _searchFocusNode.unfocus();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: DesignTokens.radiusLgAll,
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: DesignTokens.radiusLgAll,
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withOpacity(0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: DesignTokens.radiusLgAll,
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Recipients list
          _buildRecipientsList(context, recipientState),
        ],
      ),
      bottom: sendState.recipient != null
          ? SizedBox(
              width: double.infinity,
              child: GradientButton(
                key: const Key('recipient_next'),
                onPressed: () {
                  ref.read(sendNotifierProvider.notifier).completeCurrentStep();
                  SendFlowAnalytics.trackRecipientSelected('email');
                  context.go('/send/network');
                },
                child: Text(
                  'Continue',
                  style: AppTypography.buttonLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  /// Build recipients list
  Widget _buildRecipientsList(
    BuildContext context,
    RecipientState recipientState,
  ) {
    print(
      '_buildRecipientsList: loading=${recipientState.loading}, list.length=${recipientState.list.length}',
    );

    if (recipientState.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (recipientState.list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No recipients found',
              style: AppTypography.h3.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Search for someone to send money to',
              style: AppTypography.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: recipientState.list.map((recipient) {
        print('Building recipient tile for: ${recipient.name}');
        return _buildRecipientTile(context, recipient);
      }).toList(),
    );
  }

  /// Build recipient tile
  Widget _buildRecipientTile(BuildContext context, Recipient recipient) {
    return ListTile(
      key: Key('recipient_item_${recipient.id}'),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        child: Text(
          recipient.name.isNotEmpty ? recipient.name[0].toUpperCase() : '?',
          style: AppTypography.h4.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      title: Text(
        recipient.name,
        style: AppTypography.h4.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        recipient.phone,
        style: AppTypography.bodyMedium.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: () {
        // Set recipient in send state
        ref
            .read(sendNotifierProvider.notifier)
            .setRecipientFromModel(recipient);

        // Navigate to next screen
        context.go('/send/network');
      },
    );
  }
}
