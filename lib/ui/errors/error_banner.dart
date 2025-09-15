/// Error banner widget for displaying inline error messages
///
/// Provides a dismissible banner that shows error messages with
/// retry functionality and consistent styling.
library;

import 'package:flutter/material.dart';
import '../../core/errors/app_error.dart';
import '../../core/errors/error_mapper.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';

/// Inline error banner widget
class ErrorBanner extends StatelessWidget {
  /// The error to display
  final AppError error;
  
  /// Callback when retry is pressed
  final VoidCallback? onRetry;
  
  /// Callback when the banner is dismissed
  final VoidCallback? onDismiss;
  
  /// Whether to show the dismiss button
  final bool showDismissButton;
  
  /// Whether to show the retry button
  final bool showRetryButton;
  
  /// Custom retry button text
  final String? retryButtonText;
  
  /// Whether the banner is dismissible
  final bool isDismissible;

  const ErrorBanner({
    super.key,
    required this.error,
    this.onRetry,
    this.onDismiss,
    this.showDismissButton = true,
    this.showRetryButton = true,
    this.retryButtonText,
    this.isDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final message = ErrorMapper.uiMessage(error);
    final shouldShowRetry = showRetryButton && 
        ErrorMapper.shouldShowRetry(error) && 
        onRetry != null;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark 
            ? DesignTokens.darkErrorContainer
            : DesignTokens.errorContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark 
              ? DesignTokens.darkError
              : DesignTokens.error,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Error icon
            Icon(
              Icons.error_outline,
              color: isDark 
                  ? DesignTokens.darkOnErrorContainer
                  : DesignTokens.onErrorContainer,
              size: 20,
            ),
            
            const SizedBox(width: 12),
            
            // Error message
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark 
                      ? DesignTokens.darkOnErrorContainer
                      : DesignTokens.onErrorContainer,
                ),
              ),
            ),
            
            // Action buttons
            if (shouldShowRetry) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  foregroundColor: isDark 
                      ? DesignTokens.darkOnErrorContainer
                      : DesignTokens.onErrorContainer,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  retryButtonText ?? ErrorMapper.retryLabel(error),
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark 
                        ? DesignTokens.darkOnErrorContainer
                        : DesignTokens.onErrorContainer,
                  ),
                ),
              ),
            ],
            
            if (isDismissible && showDismissButton && onDismiss != null) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: onDismiss,
                icon: Icon(
                  Icons.close,
                  size: 18,
                  color: isDark 
                      ? DesignTokens.darkOnErrorContainer
                      : DesignTokens.onErrorContainer,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Compact error banner for tight spaces
class CompactErrorBanner extends StatelessWidget {
  /// The error to display
  final AppError error;
  
  /// Callback when retry is pressed
  final VoidCallback? onRetry;
  
  /// Callback when the banner is dismissed
  final VoidCallback? onDismiss;

  const CompactErrorBanner({
    super.key,
    required this.error,
    this.onRetry,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final message = ErrorMapper.uiMessage(error);
    final shouldShowRetry = ErrorMapper.shouldShowRetry(error) && onRetry != null;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark 
            ? DesignTokens.darkErrorContainer
            : DesignTokens.errorContainer,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark 
              ? DesignTokens.darkError
              : DesignTokens.error,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: isDark 
                ? DesignTokens.darkOnErrorContainer
                : DesignTokens.onErrorContainer,
            size: 16,
          ),
          
          const SizedBox(width: 8),
          
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySmall.copyWith(
                color: isDark 
                    ? DesignTokens.darkOnErrorContainer
                    : DesignTokens.onErrorContainer,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          if (shouldShowRetry) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: isDark 
                    ? DesignTokens.darkOnErrorContainer
                    : DesignTokens.onErrorContainer,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                ErrorMapper.retryLabel(error),
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark 
                      ? DesignTokens.darkOnErrorContainer
                      : DesignTokens.onErrorContainer,
                ),
              ),
            ),
          ],
          
          if (onDismiss != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(
                Icons.close,
                size: 16,
                color: isDark 
                    ? DesignTokens.darkOnErrorContainer
                    : DesignTokens.onErrorContainer,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Success banner for showing success messages
class SuccessBanner extends StatelessWidget {
  /// The success message to display
  final String message;
  
  /// Callback when the banner is dismissed
  final VoidCallback? onDismiss;
  
  /// Whether the banner is dismissible
  final bool isDismissible;

  const SuccessBanner({
    super.key,
    required this.message,
    this.onDismiss,
    this.isDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark 
            ? DesignTokens.darkSuccessContainer
            : DesignTokens.successContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark 
              ? DesignTokens.darkSuccess
              : DesignTokens.success,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: isDark 
                  ? DesignTokens.darkOnSuccessContainer
                  : DesignTokens.onSuccessContainer,
              size: 20,
            ),
            
            const SizedBox(width: 12),
            
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark 
                      ? DesignTokens.darkOnSuccessContainer
                      : DesignTokens.onSuccessContainer,
                ),
              ),
            ),
            
            if (isDismissible && onDismiss != null) ...[
              IconButton(
                onPressed: onDismiss,
                icon: Icon(
                  Icons.close,
                  size: 18,
                  color: isDark 
                      ? DesignTokens.darkOnSuccessContainer
                      : DesignTokens.onSuccessContainer,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
