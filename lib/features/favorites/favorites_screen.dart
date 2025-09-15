import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/pressable.dart';

/// Favorites screen for managing saved recipients
/// Implements PRD Section 10: Server-synced Favorites with CRUD operations
class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  // Mock data - in real app this would come from a provider
  final List<FavoriteRecipient> _favorites = [
    FavoriteRecipient(
      id: '1',
      name: 'Marie Kabongo',
      phone: '+243 123 456 789',
      countryCode: 'CD',
      lastUsed: DateTime.now().subtract(const Duration(days: 2)),
    ),
    FavoriteRecipient(
      id: '2',
      name: 'Jean Mbuyi',
      phone: '+243 987 654 321',
      countryCode: 'CD',
      lastUsed: DateTime.now().subtract(const Duration(days: 5)),
    ),
    FavoriteRecipient(
      id: '3',
      name: 'Grace Mukendi',
      phone: '+243 555 123 456',
      countryCode: 'CD',
      lastUsed: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showAddFavoriteDialog(context),
            icon: Icon(Icons.add, color: colorScheme.onBackground),
          ),
        ],
      ),
      body: _favorites.isEmpty
          ? _buildEmptyState(context)
          : _buildFavoritesList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFavoriteDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: SpacingTokens.xlAll,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: RadiusTokens.lgAll,
              ),
              child: Icon(
                Icons.favorite_outline,
                size: 48,
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            SizedBox(height: SpacingTokens.xl),

            Text(
              'No Favorites Yet',
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: SpacingTokens.md),

            Text(
              'Add recipients to your favorites for quick repeat sends',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: SpacingTokens.xl),

            SizedBox(
              width: double.infinity,
              child: GradientButton(
                onPressed: () => _showAddFavoriteDialog(context),
                child: Text(
                  'Add First Favorite',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView.builder(
      padding: SpacingTokens.lgAll,
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        final favorite = _favorites[index];
        return Padding(
          padding: EdgeInsets.only(bottom: SpacingTokens.md),
          child: _buildFavoriteCard(context, favorite),
        );
      },
    );
  }

  Widget _buildFavoriteCard(BuildContext context, FavoriteRecipient favorite) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: SpacingTokens.lgAll,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: RadiusTokens.mdAll,
        border: Border.all(color: colorScheme.outline, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.person,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),

              SizedBox(width: SpacingTokens.md),

              // Name and phone
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      favorite.name,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: SpacingTokens.xs),
                    Text(
                      favorite.phone,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Menu button
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(value, favorite),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'send',
                    child: Row(
                      children: [
                        Icon(Icons.send),
                        SizedBox(width: 8),
                        Text('Send Money'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                child: Icon(
                  Icons.more_vert,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          SizedBox(height: SpacingTokens.md),

          // Last used info
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: SpacingTokens.xs),
              Text(
                'Last used ${_formatLastUsed(favorite.lastUsed)}',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              // Quick send button
              Pressable(
                onPressed: () => _sendToFavorite(favorite),
                child: Container(
                  padding: SpacingTokens.smAll,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: RadiusTokens.smAll,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.send,
                        size: 16,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      SizedBox(width: SpacingTokens.xs),
                      Text(
                        'Send',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddFavoriteDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Favorite',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter recipient name',
              ),
            ),
            SizedBox(height: SpacingTokens.md),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '+243 123 456 789',
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  phoneController.text.isNotEmpty) {
                _addFavorite(nameController.text, phoneController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addFavorite(String name, String phone) {
    setState(() {
      _favorites.add(
        FavoriteRecipient(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          phone: phone,
          countryCode: 'CD',
          lastUsed: null,
        ),
      );
    });
  }

  void _handleMenuAction(String action, FavoriteRecipient favorite) {
    switch (action) {
      case 'send':
        _sendToFavorite(favorite);
        break;
      case 'edit':
        _editFavorite(favorite);
        break;
      case 'delete':
        _deleteFavorite(favorite);
        break;
    }
  }

  void _sendToFavorite(FavoriteRecipient favorite) {
    context.go(
      '/send/amount?name=${Uri.encodeComponent(favorite.name)}&phone=${Uri.encodeComponent(favorite.phone)}',
    );
  }

  void _editFavorite(FavoriteRecipient favorite) {
    // TODO: Implement edit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${favorite.name} - Coming soon!')),
    );
  }

  void _deleteFavorite(FavoriteRecipient favorite) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Favorite'),
        content: Text('Are you sure you want to delete ${favorite.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _favorites.removeWhere((f) => f.id == favorite.id);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatLastUsed(DateTime? lastUsed) {
    if (lastUsed == null) return 'Never';

    final now = DateTime.now();
    final difference = now.difference(lastUsed);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}

class FavoriteRecipient {
  final String id;
  final String name;
  final String phone;
  final String countryCode;
  final DateTime? lastUsed;

  FavoriteRecipient({
    required this.id,
    required this.name,
    required this.phone,
    required this.countryCode,
    this.lastUsed,
  });
}
