/// Full-screen error widget for displaying critical errors
///
/// Provides a full-screen error display with icon, message, and action buttons
/// for errors that require user attention or intervention.
library;

import 'package:flutter/material.dart';
import '../../core/errors/app_error.dart';
import '../../core/errors/error_mapper.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';
import '../../widgets/gradient_button.dart';

/// Full-screen error display widget
class ErrorFullScreen extends StatelessWidget {
  /// The error to display
  final AppError error;
  
  /// Callback when retry is pressed
  final VoidCallback? onRetry;
  
  /// Callback when help is requested
  final VoidCallback? onHelp;
  
  /// Callback when going back
  final VoidCallback? onBack;
  
  /// Custom title for the error
  final String? title;
  
  /// Custom message for the error
  final String? message;
  
  /// Custom retry button text
  final String? retryButtonText;
  
  /// Custom help button text
  final String? helpButtonText;
  
  /// Whether to show the back button
  final bool showBackButton;
  
  /// Whether to show the retry button
  final bool showRetryButton;
  
  /// Whether to show the help button
  final bool showHelpButton;

  const ErrorFullScreen({
    super.key,
    required this.error,
    this.onRetry,
    this.onHelp,
    this.onBack,
    this.title,
    this.message,
    this.retryButtonText,
    this.helpButtonText,
    this.showBackButton = true,
    this.showRetryButton = true,
    this.showHelpButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final errorTitle = title ?? ErrorMapper.uiTitle(error);
    final errorMessage = message ?? ErrorMapper.uiMessage(error);
    final suggestion = ErrorMapper.suggestedAction(error);
    final iconName = ErrorMapper.iconName(error);
    
    final shouldShowRetry = showRetryButton && 
        ErrorMapper.shouldShowRetry(error) && 
        onRetry != null;
    
    final shouldShowHelp = showHelpButton && 
        ErrorMapper.shouldShowHelp(error) && 
        onHelp != null;

    return Scaffold(
      backgroundColor: isDark ? DesignTokens.darkBackground : DesignTokens.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Back button
              if (showBackButton && onBack != null) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: onBack,
                    icon: Icon(
                      Icons.arrow_back,
                      color: isDark 
                          ? DesignTokens.darkOnBackground
                          : DesignTokens.onBackground,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              // Spacer to center content
              const Spacer(),
              
              // Error icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: isDark 
                      ? DesignTokens.darkErrorContainer
                      : DesignTokens.errorContainer,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark 
                        ? DesignTokens.darkError
                        : DesignTokens.error,
                    width: 2,
                  ),
                ),
                child: Icon(
                  _getIconData(iconName),
                  size: 60,
                  color: isDark 
                      ? DesignTokens.darkError
                      : DesignTokens.error,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Error title
              Text(
                errorTitle,
                style: AppTypography.h2.copyWith(
                  color: isDark 
                      ? DesignTokens.darkOnBackground
                      : DesignTokens.onBackground,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Error message
              Text(
                errorMessage,
                style: AppTypography.bodyLarge.copyWith(
                  color: isDark 
                      ? DesignTokens.darkOnBackground
                      : DesignTokens.onBackground,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Suggestion
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark 
                      ? DesignTokens.darkSurfaceVariant
                      : DesignTokens.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: isDark 
                          ? DesignTokens.darkOnSurfaceVariant
                          : DesignTokens.onSurfaceVariant,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        suggestion,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark 
                              ? DesignTokens.darkOnSurfaceVariant
                              : DesignTokens.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Action buttons
              Column(
                children: [
                  if (shouldShowRetry) ...[
                    SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        onPressed: onRetry,
                        child: Text(
                          retryButtonText ?? ErrorMapper.retryLabel(error),
                          style: AppTypography.buttonLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  if (shouldShowHelp) ...[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onHelp,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isDark 
                                ? DesignTokens.darkPrimary
                                : DesignTokens.primary,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          helpButtonText ?? ErrorMapper.helpLabel(error),
                          style: AppTypography.buttonLarge.copyWith(
                            color: isDark 
                                ? DesignTokens.darkPrimary
                                : DesignTokens.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// Gets the appropriate icon data for the error type
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'wifi_off':
        return Icons.wifi_off;
      case 'schedule':
        return Icons.schedule;
      case 'error_outline':
        return Icons.error_outline;
      case 'warning':
        return Icons.warning;
      case 'lock':
        return Icons.lock;
      case 'help_outline':
        return Icons.help_outline;
      default:
        return Icons.error_outline;
    }
  }
}

/// Compact full-screen error for mobile screens
class CompactErrorFullScreen extends StatelessWidget {
  /// The error to display
  final AppError error;
  
  /// Callback when retry is pressed
  final VoidCallback? onRetry;
  
  /// Callback when help is requested
  final VoidCallback? onHelp;
  
  /// Callback when going back
  final VoidCallback? onBack;

  const CompactErrorFullScreen({
    super.key,
    required this.error,
    this.onRetry,
    this.onHelp,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final errorTitle = ErrorMapper.uiTitle(error);
    final errorMessage = ErrorMapper.uiMessage(error);
    final iconName = ErrorMapper.iconName(error);
    
    final shouldShowRetry = ErrorMapper.shouldShowRetry(error) && onRetry != null;
    final shouldShowHelp = ErrorMapper.shouldShowHelp(error) && onHelp != null;

    return Scaffold(
      backgroundColor: isDark ? DesignTokens.darkBackground : DesignTokens.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: onBack != null
            ? IconButton(
                onPressed: onBack,
                icon: Icon(
                  Icons.arrow_back,
                  color: isDark 
                      ? DesignTokens.darkOnBackground
                      : DesignTokens.onBackground,
                ),
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Error icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isDark 
                      ? DesignTokens.darkErrorContainer
                      : DesignTokens.errorContainer,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark 
                        ? DesignTokens.darkError
                        : DesignTokens.error,
                    width: 2,
                  ),
                ),
                child: Icon(
                  _getIconData(iconName),
                  size: 40,
                  color: isDark 
                      ? DesignTokens.darkError
                      : DesignTokens.error,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Error title
              Text(
                errorTitle,
                style: AppTypography.h3.copyWith(
                  color: isDark 
                      ? DesignTokens.darkOnBackground
                      : DesignTokens.onBackground,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              // Error message
              Text(
                errorMessage,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark 
                      ? DesignTokens.darkOnBackground
                      : DesignTokens.onBackground,
                ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),
              
              // Action buttons
              Column(
                children: [
                  if (shouldShowRetry) ...[
                    SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        onPressed: onRetry,
                        child: Text(
                          ErrorMapper.retryLabel(error),
                          style: AppTypography.buttonMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  if (shouldShowHelp) ...[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onHelp,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isDark 
                                ? DesignTokens.darkPrimary
                                : DesignTokens.primary,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          ErrorMapper.helpLabel(error),
                          style: AppTypography.buttonMedium.copyWith(
                            color: isDark 
                                ? DesignTokens.darkPrimary
                                : DesignTokens.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Gets the appropriate icon data for the error type
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'wifi_off':
        return Icons.wifi_off;
      case 'schedule':
        return Icons.schedule;
      case 'error_outline':
        return Icons.error_outline;
      case 'warning':
        return Icons.warning;
      case 'lock':
        return Icons.lock;
      case 'help_outline':
        return Icons.help_outline;
      default:
        return Icons.error_outline;
    }
  }
}
