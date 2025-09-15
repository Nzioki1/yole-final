import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';
import '../../widgets/pressable.dart';

/// Notifications screen for managing app notifications
/// Implements PRD Section 10: Notifications management
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  // Notification settings
  bool _transactionNotifications = true;
  bool _marketingNotifications = false;
  bool _securityNotifications = true;
  bool _pushNotifications = true;
  bool _emailNotifications = true;

  // Mock notifications data
  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'Payment Successful',
      message:
          'Your payment of \$50.00 to Marie Kabongo was completed successfully.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      type: NotificationType.transaction,
      isRead: false,
    ),
    AppNotification(
      id: '2',
      title: 'KYC Approved',
      message:
          'Your identity verification has been approved. You can now send money.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.security,
      isRead: true,
    ),
    AppNotification(
      id: '3',
      title: 'New Feature Available',
      message:
          'You can now add recipients to your favorites for quick repeat sends.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.marketing,
      isRead: true,
    ),
    AppNotification(
      id: '4',
      title: 'Payment Failed',
      message:
          'Your payment to Jean Mbuyi could not be completed. Please try again.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.transaction,
      isRead: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _markAllAsRead,
            icon: Icon(Icons.done_all, color: colorScheme.onBackground),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // Tab bar
            Container(
              color: colorScheme.surface,
              child: TabBar(
                labelColor: colorScheme.primary,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                indicatorColor: colorScheme.primary,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Settings'),
                ],
              ),
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                children: [
                  _buildNotificationsList(context),
                  _buildSettingsTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_notifications.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: SpacingTokens.lgAll,
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return Padding(
          padding: EdgeInsets.only(bottom: SpacingTokens.md),
          child: _buildNotificationCard(context, notification),
        );
      },
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
                Icons.notifications_none,
                size: 48,
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            SizedBox(height: SpacingTokens.xl),

            Text(
              'No Notifications',
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: SpacingTokens.md),

            Text(
              'You\'ll see important updates about your transactions and account here',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    AppNotification notification,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Pressable(
      onPressed: () => _handleNotificationTap(notification),
      child: Container(
        padding: SpacingTokens.lgAll,
        decoration: BoxDecoration(
          color: notification.isRead
              ? colorScheme.surface
              : colorScheme.primaryContainer.withOpacity(0.1),
          borderRadius: RadiusTokens.mdAll,
          border: Border.all(color: colorScheme.outline, width: 1),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getNotificationColor(notification.type, colorScheme),
                borderRadius: RadiusTokens.smAll,
              ),
              child: Icon(
                _getNotificationIcon(notification.type),
                size: 20,
                color: Colors.white,
              ),
            ),

            SizedBox(width: SpacingTokens.md),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: SpacingTokens.xs),

                  Text(
                    notification.message,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: SpacingTokens.sm),

                  Text(
                    _formatTimestamp(notification.timestamp),
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: SpacingTokens.lgAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Push Notifications
          _buildSettingSection(
            context,
            title: 'Push Notifications',
            children: [
              _buildSwitchSetting(
                context,
                title: 'Enable Push Notifications',
                subtitle: 'Receive notifications on your device',
                value: _pushNotifications,
                onChanged: (value) =>
                    setState(() => _pushNotifications = value),
              ),
            ],
          ),

          SizedBox(height: SpacingTokens.xl),

          // Email Notifications
          _buildSettingSection(
            context,
            title: 'Email Notifications',
            children: [
              _buildSwitchSetting(
                context,
                title: 'Enable Email Notifications',
                subtitle: 'Receive notifications via email',
                value: _emailNotifications,
                onChanged: (value) =>
                    setState(() => _emailNotifications = value),
              ),
            ],
          ),

          SizedBox(height: SpacingTokens.xl),

          // Notification Types
          _buildSettingSection(
            context,
            title: 'Notification Types',
            children: [
              _buildSwitchSetting(
                context,
                title: 'Transaction Updates',
                subtitle: 'Payment confirmations and transaction status',
                value: _transactionNotifications,
                onChanged: (value) =>
                    setState(() => _transactionNotifications = value),
              ),

              SizedBox(height: SpacingTokens.md),

              _buildSwitchSetting(
                context,
                title: 'Security Alerts',
                subtitle: 'Login attempts and security updates',
                value: _securityNotifications,
                onChanged: (value) =>
                    setState(() => _securityNotifications = value),
              ),

              SizedBox(height: SpacingTokens.md),

              _buildSwitchSetting(
                context,
                title: 'Marketing & Promotions',
                subtitle: 'New features and promotional offers',
                value: _marketingNotifications,
                onChanged: (value) =>
                    setState(() => _marketingNotifications = value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: SpacingTokens.md),
        ...children,
      ],
    );
  }

  Widget _buildSwitchSetting(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: SpacingTokens.lgAll,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: RadiusTokens.mdAll,
        border: Border.all(color: colorScheme.outline, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: SpacingTokens.xs),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  void _handleNotificationTap(AppNotification notification) {
    setState(() {
      notification.isRead = true;
    });

    // TODO: Navigate to relevant screen based on notification type
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Handling notification: ${notification.title}')),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  Color _getNotificationColor(NotificationType type, ColorScheme colorScheme) {
    switch (type) {
      case NotificationType.transaction:
        return colorScheme.primary;
      case NotificationType.security:
        return Colors.orange;
      case NotificationType.marketing:
        return Colors.blue;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.transaction:
        return Icons.account_balance_wallet;
      case NotificationType.security:
        return Icons.security;
      case NotificationType.marketing:
        return Icons.campaign;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    required this.isRead,
  });
}

enum NotificationType { transaction, security, marketing }
