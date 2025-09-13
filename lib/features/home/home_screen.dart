import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/pressable.dart';
import '../../widgets/avatar_badge.dart';
import '../../widgets/status_chip.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';
import '../../data/repos/transactions_repo.dart';
import '../../data/repos/favorites_repo.dart';
import '../../data/api/yole_api_client.dart';

/// Home Dashboard Screen
///
/// Implements PRD Section 10 Screens & States:
/// - Greeting with user name
/// - Recent transactions list with Repeat actions
/// - Favorites rail for quick sending
/// - Search functionality
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TransactionsRepository _transactionsRepo = const TransactionsRepository(
    YoleApiClient.create(),
  );
  final FavoritesRepository _favoritesRepo = const FavoritesRepository(
    YoleApiClient.create(),
  );

  List<dynamic> _recentTransactions = [];
  List<dynamic> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final transactions = await _transactionsRepo.getRecentTransactions();
      final favorites = await _favoritesRepo.getFavorites();

      setState(() {
        _recentTransactions = transactions;
        _favorites = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _repeatTransaction(Map<String, dynamic> transaction) {
    context.go(
      '/send/recipient',
      extra: {
        'recipientName': transaction['recipientName'],
        'recipientPhone': transaction['recipientPhone'],
      },
    );
  }

  void _sendToFavorite(Map<String, dynamic> favorite) {
    context.go(
      '/send/recipient',
      extra: {
        'recipientName': favorite['name'],
        'recipientPhone': favorite['phone'],
      },
    );
  }

  void _viewTransaction(String transactionId) {
    context.go('/transaction/$transactionId');
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Yole', style: textTheme.titleLarge),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          Pressable(
            onPressed: () {
              // TODO: Navigate to profile/settings
            },
            child: Padding(
              padding: SpacingTokens.lgHorizontal,
              child: Icon(Icons.person_outline, color: colorScheme.onSurface),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: SpacingTokens.lgAll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting
                      Text(
                        '${_getGreeting()}, John!',
                        style: textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ready to send money?',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Search field
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search transactions or recipients',
                          prefixIcon: Icon(
                            Icons.search,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceVariant,
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

                      // Favorites rail
                      if (_favorites.isNotEmpty) ...[
                        Text('Favorites', style: textTheme.titleLarge),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _favorites.length,
                            itemBuilder: (context, index) {
                              final favorite = _favorites[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: SpacingTokens.lg,
                                ),
                                child: Pressable(
                                  onPressed: () => _sendToFavorite(favorite),
                                  child: Container(
                                    width: 80,
                                    padding: SpacingTokens.mdAll,
                                    decoration: BoxDecoration(
                                      color: colorScheme.surface,
                                      border: Border.all(
                                        color: colorScheme.outline.withValues(
                                          alpha: 0.25,
                                        ),
                                        width: 1,
                                      ),
                                      borderRadius: RadiusTokens.lgAll,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AvatarBadge(
                                          initials:
                                              favorite['name']
                                                  ?.substring(0, 2)
                                                  .toUpperCase() ??
                                              '??',
                                          size: 32,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          favorite['name'] ?? 'Unknown',
                                          style: textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Recent transactions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Transactions',
                            style: textTheme.titleLarge,
                          ),
                          Pressable(
                            onPressed: () {
                              // TODO: Navigate to full transactions list
                            },
                            child: Text(
                              'View All',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Transactions list
                      if (_recentTransactions.isEmpty)
                        Container(
                          padding: SpacingTokens.xlAll,
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            border: Border.all(
                              color: colorScheme.outline,
                              width: 1,
                            ),
                            borderRadius: RadiusTokens.mdAll,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 48,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No transactions yet',
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start by sending money to someone',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _recentTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction = _recentTransactions[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: SpacingTokens.sm,
                              ),
                              child: Pressable(
                                onPressed: () =>
                                    _viewTransaction(transaction['id']),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: SpacingTokens.lg,
                                    vertical:
                                        SpacingTokens.md + 2, // 14 = 12 + 2
                                  ), // components.transactionItem padding
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    border: Border.all(
                                      color: colorScheme.outline,
                                      width: 1,
                                    ),
                                    borderRadius: RadiusTokens.mdAll,
                                  ),
                                  child: Row(
                                    children: [
                                      AvatarBadge(
                                        initials:
                                            transaction['recipientName']
                                                ?.substring(0, 2)
                                                .toUpperCase() ??
                                            '??',
                                        size:
                                            40, // components.transactionItem avatarSize
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ), // components.transactionItem gap
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              transaction['recipientName'] ??
                                                  'Unknown',
                                              style: textTheme.bodyLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              _formatDate(
                                                transaction['createdAt'] ?? '',
                                              ),
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color: colorScheme
                                                        .onSurfaceVariant,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            _formatCurrency(
                                              transaction['sendingAmountUSD'] ??
                                                  0.0,
                                            ),
                                            style: textTheme
                                                .titleLarge, // amount = titleLarge
                                          ),
                                          const SizedBox(height: 4),
                                          StatusChip(
                                            status: _getTransactionStatus(
                                              transaction,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 8),
                                      Pressable(
                                        onPressed: () =>
                                            _repeatTransaction(transaction),
                                        child: Icon(
                                          Icons.repeat,
                                          color: colorScheme.primary,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/send/recipient'),
        backgroundColor: colorScheme.primary,
        child: Icon(Icons.add, color: colorScheme.onPrimary),
      ),
    );
  }

  String _getTransactionStatus(Map<String, dynamic> transaction) {
    final status = transaction['status']?.toString().toLowerCase();
    switch (status) {
      case 'completed':
        return 'completed';
      case 'failed':
        return 'failed';
      case 'reversed':
        return 'reversed';
      default:
        return 'pending';
    }
  }
}

enum TransactionStatus { pending, completed, failed, reversed }
