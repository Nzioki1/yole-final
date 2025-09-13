import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/pressable.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/dashed_box.dart';
import '../../widgets/avatar_badge.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';

/// Send Money - Recipient Selection Screen
///
/// Implements PRD Section 6.3 Send Flow Screen 1:
/// - Search field for phone numbers
/// - Favorites list (Pressable cards)
/// - Address book dashed box
/// - Disabled Continue until selection
class SendRecipientScreen extends ConsumerStatefulWidget {
  const SendRecipientScreen({super.key});

  @override
  ConsumerState<SendRecipientScreen> createState() =>
      _SendRecipientScreenState();
}

class _SendRecipientScreenState extends ConsumerState<SendRecipientScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedRecipient;
  String? _selectedRecipientName;
  String? _selectedRecipientPhone;

  // Mock favorites data - TODO: Replace with actual data from repository
  final List<Map<String, String>> _favorites = [
    {'name': 'John Doe', 'phone': '+243123456789', 'initials': 'JD'},
    {'name': 'Jane Smith', 'phone': '+243987654321', 'initials': 'JS'},
    {'name': 'Bob Wilson', 'phone': '+243555666777', 'initials': 'BW'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectRecipient(String name, String phone, String initials) {
    setState(() {
      _selectedRecipient = phone;
      _selectedRecipientName = name;
      _selectedRecipientPhone = phone;
    });
  }

  void _continueToAmount() {
    if (_selectedRecipient != null) {
      context.go(
        '/send/amount',
        extra: {
          'recipientName': _selectedRecipientName,
          'recipientPhone': _selectedRecipientPhone,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Send Money', style: textTheme.titleLarge),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: SpacingTokens.lgAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search field
              Text('Who are you sending to?', style: textTheme.headlineMedium),
              const SizedBox(height: 16),

              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Enter phone number or name',
                  prefixIcon: Icon(
                    Icons.search,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: RadiusTokens.mdAll,
                    borderSide: BorderSide(
                      color: colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: RadiusTokens.mdAll,
                    borderSide: BorderSide(
                      color: colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: RadiusTokens.mdAll,
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                style: textTheme.bodyLarge,
                onChanged: (value) {
                  // TODO: Implement search functionality
                },
              ),

              const SizedBox(height: 24),

              // Favorites section
              if (_favorites.isNotEmpty) ...[
                Text('Favorites', style: textTheme.titleLarge),
                const SizedBox(height: 12),

                Expanded(
                  child: ListView.builder(
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
                      final favorite = _favorites[index];
                      final isSelected =
                          _selectedRecipient == favorite['phone'];

                      return Padding(
                        padding: EdgeInsets.only(bottom: SpacingTokens.sm),
                        child: Pressable(
                          onPressed: () => _selectRecipient(
                            favorite['name']!,
                            favorite['phone']!,
                            favorite['initials']!,
                          ),
                          child: Container(
                            padding: SpacingTokens.lgAll,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colorScheme.primary.withValues(alpha: 0.1)
                                  : colorScheme.surface,
                              border: Border.all(
                                color: isSelected
                                    ? colorScheme.primary
                                    : colorScheme.outline,
                                width: 1,
                              ),
                              borderRadius: RadiusTokens.mdAll,
                            ),
                            child: Row(
                              children: [
                                AvatarBadge(
                                  initials: favorite['initials']!,
                                  size: 40,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        favorite['name']!,
                                        style: textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        favorite['phone']!,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: colorScheme.primary,
                                    size: 24,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],

              // Address book dashed box
              DashedBox(
                child: Column(
                  children: [
                    Icon(
                      Icons.contacts_outlined,
                      size: 32,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Import from Address Book',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Select contacts from your phone',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  onPressed: _selectedRecipient != null
                      ? _continueToAmount
                      : null,
                  child: Text(
                    'Continue',
                    style: textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
