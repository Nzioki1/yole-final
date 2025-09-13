import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/gradient_button.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';

/// Forgot password success screen
///
/// Implements PRD Section 10 Screens & States:
/// - Forgot password success state
/// - Confirmation message and next steps
/// - Navigation back to login
class ForgotPasswordSuccessScreen extends ConsumerWidget {
  const ForgotPasswordSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Link Sent'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: SpacingTokens.lgAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text('Check Your Email', style: textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'We\'ve sent a password reset link to your email address',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 32),

              // Success card
              Container(
                padding: SpacingTokens.lgAll,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(color: colorScheme.outline, width: 1),
                  borderRadius: RadiusTokens.mdAll,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 64,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Reset Link Sent!',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check your email inbox and click the reset link to create a new password.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Instructions
              Container(
                padding: SpacingTokens.lgAll,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withValues(alpha: 0.5),
                  borderRadius: RadiusTokens.mdAll,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What to do next:',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1. Check your email inbox (and spam folder)\n'
                      '2. Click the password reset link\n'
                      '3. Create a new password\n'
                      '4. Sign in with your new password',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Action buttons
              GradientButton(
                onPressed: () => context.go('/login'),
                child: const Text('Back to Sign In'),
              ),

              const SizedBox(height: 16),

              // Resend link
              Center(
                child: TextButton(
                  onPressed: () => context.go('/forgot-password'),
                  child: Text(
                    'Didn\'t receive the email? Try again',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
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
