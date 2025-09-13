import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/pressable.dart';
import '../../widgets/avatar_badge.dart';
import '../../widgets/status_chip.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';
import '../../data/repos/transactions_repo.dart';
import '../../data/repos/pesapal_repo.dart';
import '../../data/api/yole_api_client.dart';

/// Transaction Detail Screen
///
/// Implements PRD Section 10 Screens & States:
/// - Status timeline with current status
/// - Full amount breakdown (You send / Yole fee / They receive)
/// - Recipient details with avatar
/// - Order tracking ID
/// - Refresh status functionality
/// - Repeat transaction action
class TransactionDetailScreen extends ConsumerStatefulWidget {
  const TransactionDetailScreen({super.key, required this.transactionId});

  final String transactionId;

  @override
  ConsumerState<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState
    extends ConsumerState<TransactionDetailScreen> {
  final TransactionsRepository _transactionsRepo = const TransactionsRepository(
    YoleApiClient.create(),
  );
  final PesapalRepository _pesapalRepo = PesapalRepository(
    YoleApiClient.create().dio,
  );

  Map<String, dynamic>? _transaction;
  Map<String, dynamic>? _statusDetails;
  bool _isLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadTransaction();
  }

  Future<void> _loadTransaction() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final transaction = await _transactionsRepo.getTransactionById(
        transactionId: widget.transactionId,
      );

      if (transaction != null) {
        setState(() {
          _transaction = transaction;
          _isLoading = false;
        });

        // Load status details if we have a tracking ID
        if (transaction['orderTrackingId'] != null) {
          _loadStatusDetails(transaction['orderTrackingId']);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadStatusDetails(String orderTrackingId) async {
    try {
      final status = await _pesapalRepo.getTransactionStatus(
        orderTrackingId: orderTrackingId,
      );

      setState(() {
        _statusDetails = status;
      });
    } catch (e) {
      // Status loading failed, but don't show error to user
    }
  }

  Future<void> _refreshStatus() async {
    if (_transaction?['orderTrackingId'] == null) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      await _loadStatusDetails(_transaction!['orderTrackingId']);
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  void _repeatTransaction() {
    if (_transaction == null) return;

    context.go(
      '/send/recipient',
      extra: {
        'recipientName': _transaction!['recipientName'],
        'recipientPhone': _transaction!['recipientPhone'],
      },
    );
  }

  String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Unknown date';
    }
  }

  TransactionStatus _getTransactionStatus() {
    if (_statusDetails != null) {
      if (_pesapalRepo.isTransactionCompleted(_statusDetails!)) {
        return TransactionStatus.completed;
      } else if (_pesapalRepo.isTransactionFailed(_statusDetails!)) {
        return TransactionStatus.failed;
      } else if (_pesapalRepo.isTransactionReversed(_statusDetails!)) {
        return TransactionStatus.reversed;
      }
    }

    final status = _transaction?['status']?.toString().toLowerCase();
    switch (status) {
      case 'completed':
        return TransactionStatus.completed;
      case 'failed':
        return TransactionStatus.failed;
      case 'reversed':
        return TransactionStatus.reversed;
      default:
        return TransactionStatus.pending;
    }
  }

  String _getStatusText() {
    final transactionStatus = _getTransactionStatus();
    switch (transactionStatus) {
      case TransactionStatus.completed:
        return 'completed';
      case TransactionStatus.failed:
        return 'failed';
      case TransactionStatus.reversed:
        return 'reversed';
      case TransactionStatus.pending:
        return 'pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Transaction Details'),
          backgroundColor: colorScheme.surface,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_transaction == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Transaction Details'),
          backgroundColor: colorScheme.surface,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colorScheme.error),
              const SizedBox(height: 16),
              Text('Transaction not found', style: textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'This transaction may have been deleted or the ID is invalid.',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          Pressable(
            onPressed: _isRefreshing ? null : _refreshStatus,
            child: Padding(
              padding: SpacingTokens.lgHorizontal,
              child: _isRefreshing
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.primary,
                      ),
                    )
                  : Icon(Icons.refresh, color: colorScheme.primary),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: SpacingTokens.lgAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status section
              Container(
                padding: SpacingTokens.lgAll,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(color: colorScheme.outline, width: 1),
                  borderRadius: RadiusTokens.mdAll,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getStatusIcon(),
                          color: _getStatusColor(),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getStatusText(),
                                style: textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(_transaction!['createdAt'] ?? ''),
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        StatusChip(status: _getStatusText()),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Recipient section
              Container(
                padding: SpacingTokens.lgAll,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(color: colorScheme.outline, width: 1),
                  borderRadius: RadiusTokens.mdAll,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recipient',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        AvatarBadge(
                          initials:
                              _transaction!['recipientName']
                                  ?.substring(0, 2)
                                  .toUpperCase() ??
                              '??',
                          size: 48,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _transaction!['recipientName'] ?? 'Unknown',
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _transaction!['recipientPhone'] ?? 'Unknown',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Amount breakdown
              Container(
                padding: SpacingTokens.lgAll,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(color: colorScheme.outline, width: 1),
                  borderRadius: RadiusTokens.mdAll,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount breakdown',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildAmountRow(
                      'You sent',
                      _formatCurrency(_transaction!['sendingAmountUSD'] ?? 0.0),
                      colorScheme.onSurface,
                    ),
                    const SizedBox(height: 8),
                    _buildAmountRow(
                      'Yole fee',
                      _formatCurrency(_transaction!['feeUSD'] ?? 0.0),
                      colorScheme.onSurfaceVariant,
                    ),
                    const Divider(height: 24),
                    _buildAmountRow(
                      'They received',
                      _formatCurrency(_transaction!['receiveAmountUSD'] ?? 0.0),
                      colorScheme.primary,
                      isHighlight: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Transaction details
              Container(
                padding: SpacingTokens.lgAll,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(color: colorScheme.outline, width: 1),
                  borderRadius: RadiusTokens.mdAll,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction details',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      'Transaction ID',
                      _transaction!['id'] ?? 'Unknown',
                      colorScheme.onSurface,
                    ),
                    if (_transaction!['orderTrackingId'] != null) ...[
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Order Tracking ID',
                        _transaction!['orderTrackingId'],
                        colorScheme.onSurfaceVariant,
                        isMonospace: true,
                      ),
                    ],
                    if (_statusDetails?['confirmation_code'] != null) ...[
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Confirmation Code',
                        _statusDetails!['confirmation_code'],
                        colorScheme.onSurfaceVariant,
                        isMonospace: true,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: Pressable(
                      onPressed: _repeatTransaction,
                      child: Container(
                        padding: SpacingTokens.lgAll,
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
                              Icons.repeat,
                              color: colorScheme.primary,
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Repeat',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Pressable(
                      onPressed: () {
                        // TODO: Implement share functionality
                      },
                      child: Container(
                        padding: SpacingTokens.lgAll,
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
                              Icons.share,
                              color: colorScheme.primary,
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Share',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountRow(
    String label,
    String amount,
    Color textColor, {
    bool isHighlight = false,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isHighlight
              ? textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                )
              : textTheme.bodyLarge?.copyWith(color: textColor),
        ),
        Text(
          amount,
          style: isHighlight
              ? textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: textColor,
                )
              : textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    Color textColor, {
    bool isMonospace = false,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: textTheme.bodyMedium?.copyWith(color: textColor)),
        Flexible(
          child: Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor,
              fontFamily: isMonospace ? 'monospace' : null,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  IconData _getStatusIcon() {
    final status = _getTransactionStatus();
    switch (status) {
      case TransactionStatus.completed:
        return Icons.check_circle;
      case TransactionStatus.failed:
        return Icons.error;
      case TransactionStatus.reversed:
        return Icons.undo;
      case TransactionStatus.pending:
        return Icons.schedule;
    }
  }

  Color _getStatusColor() {
    final colorScheme = Theme.of(context).colorScheme;
    final status = _getTransactionStatus();
    switch (status) {
      case TransactionStatus.completed:
        return colorScheme.primary;
      case TransactionStatus.failed:
        return colorScheme.error;
      case TransactionStatus.reversed:
        return colorScheme.onSurfaceVariant;
      case TransactionStatus.pending:
        // Use design token for pending status color
        return const Color(0xFFF59E0B); // tokens.components.status.pending.fg
    }
  }
}

enum TransactionStatus { pending, completed, failed, reversed }
