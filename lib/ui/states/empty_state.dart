/// Empty state component with icon, message, and optional CTA
///
/// Provides a comprehensive empty state with:
/// - Customizable icon and messaging
/// - Optional call-to-action button
/// - Static frame support for golden tests
/// - Accessibility support
/// - Consistent styling with design system
library;

import 'package:flutter/material.dart';
import '../motion/motion.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';

/// Empty state widget with icon, message, and optional actions
class EmptyState extends StatelessWidget {
  /// Icon to display
  final IconData icon;
  
  /// Title text to display
  final String title;
  
  /// Subtitle text to display
  final String? subtitle;
  
  /// Optional action button
  final Widget? action;
  
  /// Custom icon color
  final Color? iconColor;
  
  /// Custom background color
  final Color? backgroundColor;
  
  /// Icon size
  final double iconSize;
  
  /// Spacing between elements
  final double spacing;
  
  /// For golden tests: freeze any animations at this duration
  final Duration? staticFrame;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.iconColor,
    this.backgroundColor,
    this.iconSize = 64.0,
    this.spacing = 16.0,
    this.staticFrame,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: backgroundColor ?? theme.colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Icon(
            icon,
            size: iconSize,
            color: iconColor ?? 
                (isDark ? DesignTokens.onSurfaceVariant : DesignTokens.onSurfaceVariant),
          ),
          
          SizedBox(height: spacing),
          
          // Title
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark 
                  ? DesignTokens.onSurface 
                  : DesignTokens.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          
          // Subtitle
          if (subtitle != null) ...[
            SizedBox(height: spacing / 2),
            Text(
              subtitle!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark 
                    ? DesignTokens.onSurfaceVariant 
                    : DesignTokens.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          
          // Action button
          if (action != null) ...[
            SizedBox(height: spacing * 2),
            action!,
          ],
        ],
      ),
    );
  }
}

/// Predefined empty states for common scenarios
class EmptyStates {
  /// Empty state for no transactions
  static Widget noTransactions({
    VoidCallback? onSendMoney,
    Duration? staticFrame,
  }) {
    return EmptyState(
      icon: Icons.receipt_long_outlined,
      title: 'No Transactions Yet',
      subtitle: 'Start sending money to see your transaction history here',
      staticFrame: staticFrame,
      action: onSendMoney != null
          ? AnimatedPress(
              onTap: onSendMoney,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: DesignTokens.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Send Money',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  /// Empty state for no favorites
  static Widget noFavorites({
    VoidCallback? onAddFavorite,
    Duration? staticFrame,
  }) {
    return EmptyState(
      icon: Icons.favorite_border,
      title: 'No Favorites Yet',
      subtitle: 'Add recipients to your favorites for quick and easy sending',
      staticFrame: staticFrame,
      action: onAddFavorite != null
          ? AnimatedPress(
              onTap: onAddFavorite,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: DesignTokens.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Add Favorite',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  /// Empty state for no notifications
  static Widget noNotifications({
    Duration? staticFrame,
  }) {
    return EmptyState(
      icon: Icons.notifications_none,
      title: 'No Notifications',
      subtitle: 'You\'re all caught up! We\'ll notify you about important updates.',
      staticFrame: staticFrame,
    );
  }

  /// Empty state for search results
  static Widget noSearchResults({
    required String searchQuery,
    VoidCallback? onClearSearch,
    Duration? staticFrame,
  }) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'No Results Found',
      subtitle: 'No results found for "$searchQuery". Try a different search term.',
      staticFrame: staticFrame,
      action: onClearSearch != null
          ? AnimatedPress(
              onTap: onClearSearch,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: DesignTokens.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Clear Search',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: DesignTokens.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  /// Empty state for network errors
  static Widget networkError({
    VoidCallback? onRetry,
    Duration? staticFrame,
  }) {
    return EmptyState(
      icon: Icons.wifi_off,
      title: 'Connection Problem',
      subtitle: 'Please check your internet connection and try again.',
      staticFrame: staticFrame,
      action: onRetry != null
          ? AnimatedPress(
              onTap: onRetry,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: DesignTokens.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Try Again',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  /// Empty state for server errors
  static Widget serverError({
    VoidCallback? onRetry,
    Duration? staticFrame,
  }) {
    return EmptyState(
      icon: Icons.error_outline,
      title: 'Something Went Wrong',
      subtitle: 'We\'re experiencing technical difficulties. Please try again later.',
      staticFrame: staticFrame,
      action: onRetry != null
          ? AnimatedPress(
              onTap: onRetry,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: DesignTokens.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Try Again',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  /// Empty state for maintenance mode
  static Widget maintenance({
    Duration? staticFrame,
  }) {
    return EmptyState(
      icon: Icons.build_outlined,
      title: 'Under Maintenance',
      subtitle: 'We\'re currently performing maintenance. Please check back later.',
      staticFrame: staticFrame,
    );
  }

  /// Empty state for feature coming soon
  static Widget comingSoon({
    required String featureName,
    Duration? staticFrame,
  }) {
    return EmptyState(
      icon: Icons.construction,
      title: 'Coming Soon',
      subtitle: '$featureName is currently in development. Stay tuned!',
      staticFrame: staticFrame,
    );
  }

  /// Empty state for empty form
  static Widget emptyForm({
    required String formName,
    VoidCallback? onStart,
    Duration? staticFrame,
  }) {
    return EmptyState(
      icon: Icons.edit_outlined,
      title: 'Start $formName',
      subtitle: 'Fill out the form below to get started.',
      staticFrame: staticFrame,
      action: onStart != null
          ? AnimatedPress(
              onTap: onStart,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: DesignTokens.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Get Started',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
