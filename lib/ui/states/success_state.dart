/// Success state component with animation and confetti effects
///
/// Provides a comprehensive success state with:
/// - SuccessAnimation with confetti
/// - Customizable content and actions
/// - Static frame support for golden tests
/// - Accessibility support
library;

import 'package:flutter/material.dart';
import '../components/success_animation.dart';
import '../motion/motion.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';

/// Success state widget with animation and optional actions
class SuccessState extends StatelessWidget {
  /// Title text to display
  final String title;
  
  /// Subtitle text to display
  final String? subtitle;
  
  /// Optional action button
  final Widget? action;
  
  /// Duration of the success animation
  final Duration animationDuration;
  
  /// For golden tests: freeze animation at this duration
  final Duration? staticFrame;
  
  /// Callback when animation completes
  final VoidCallback? onAnimationComplete;
  
  /// Whether to show confetti animation
  final bool showConfetti;
  
  /// Custom icon to display (defaults to check mark)
  final IconData? icon;
  
  /// Custom icon color
  final Color? iconColor;
  
  /// Custom background color
  final Color? backgroundColor;

  const SuccessState({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.animationDuration = const Duration(seconds: 3),
    this.staticFrame,
    this.onAnimationComplete,
    this.showConfetti = true,
    this.icon,
    this.iconColor,
    this.backgroundColor,
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
          // Success animation with confetti
          if (showConfetti)
            SuccessAnimation(
              duration: animationDuration,
              staticFrame: staticFrame,
              onDone: onAnimationComplete,
            )
          else
            _buildStaticSuccessIcon(context, isDark),
          
          const SizedBox(height: 24),
          
          // Title
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark 
                  ? DesignTokens.onSurface 
                  : DesignTokens.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          
          // Subtitle
          if (subtitle != null) ...[
            const SizedBox(height: 8),
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
            const SizedBox(height: 32),
            action!,
          ],
        ],
      ),
    );
  }

  Widget _buildStaticSuccessIcon(BuildContext context, bool isDark) {
    final effectiveIconColor = iconColor ?? 
        (isDark ? DesignTokens.success : DesignTokens.success);
    
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: effectiveIconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon ?? Icons.check_circle_outline,
        size: 40,
        color: effectiveIconColor,
      ),
    );
  }
}

/// Predefined success states for common scenarios
class SuccessStates {
  /// Success state for completed transactions
  static Widget transactionComplete({
    required String recipientName,
    required String amount,
    String? transactionId,
    VoidCallback? onViewDetails,
    VoidCallback? onSendAgain,
    Duration? staticFrame,
  }) {
    return SuccessState(
      title: 'Money Sent Successfully!',
      subtitle: 'You sent $amount to $recipientName',
      staticFrame: staticFrame,
      action: Column(
        children: [
          if (onViewDetails != null)
            AnimatedPress(
              onTap: onViewDetails,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: DesignTokens.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'View Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: DesignTokens.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (onSendAgain != null) ...[
            const SizedBox(height: 12),
            AnimatedPress(
              onTap: onSendAgain,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: DesignTokens.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Send Again',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Success state for email verification
  static Widget emailVerified({
    required String email,
    VoidCallback? onContinue,
    Duration? staticFrame,
  }) {
    return SuccessState(
      title: 'Email Verified!',
      subtitle: 'Your email $email has been successfully verified',
      staticFrame: staticFrame,
      action: onContinue != null
          ? AnimatedPress(
              onTap: onContinue,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: DesignTokens.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Continue',
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

  /// Success state for KYC completion
  static Widget kycComplete({
    VoidCallback? onContinue,
    Duration? staticFrame,
  }) {
    return SuccessState(
      title: 'Identity Verified!',
      subtitle: 'Your identity has been successfully verified. You can now send money.',
      staticFrame: staticFrame,
      action: onContinue != null
          ? AnimatedPress(
              onTap: onContinue,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: DesignTokens.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Start Sending',
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

  /// Success state for profile updates
  static Widget profileUpdated({
    String? message,
    VoidCallback? onContinue,
    Duration? staticFrame,
  }) {
    return SuccessState(
      title: 'Profile Updated!',
      subtitle: message ?? 'Your profile has been successfully updated',
      staticFrame: staticFrame,
      action: onContinue != null
          ? AnimatedPress(
              onTap: onContinue,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: DesignTokens.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Continue',
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
