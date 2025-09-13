import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/gradient_button.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';
import '../../data/repos/auth_repo.dart';
import '../../data/api/yole_api_client.dart';

/// Email verification screen
///
/// Implements PRD Section 6.1 New User → First Send:
/// - Email verification required (gate sending; "Resend" available)
/// - Shows verification status and instructions
/// - Resend functionality
/// - Navigation to login after verification
class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _isResending = false;
  bool _isVerified = false;

  final AuthRepository _authRepo = const AuthRepository(YoleApiClient.create());

  Future<void> _resendVerification() async {
    setState(() {
      _isResending = true;
    });

    try {
      await _authRepo.resendEmailVerification();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent! Check your inbox.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend verification: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  Future<void> _checkVerificationStatus() async {
    try {
      final user = await _authRepo.getCurrentUser();
      if (user != null && user['emailVerified'] == true) {
        setState(() {
          _isVerified = true;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email verified successfully!')),
          );

          // Navigate to login after a short delay
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              context.go('/login');
            }
          });
        }
      }
    } catch (e) {
      // Verification check failed, but don't show error to user
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
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
                'We\'ve sent a verification link to your email address',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 32),

              // Verification status card
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
                      _isVerified ? Icons.check_circle : Icons.email_outlined,
                      size: 64,
                      color: _isVerified
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isVerified ? 'Email Verified!' : 'Verification Pending',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isVerified
                          ? 'Your email has been successfully verified. You can now sign in.'
                          : 'Click the verification link in your email to activate your account.',
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
                      '2. Click the verification link\n'
                      '3. Return to the app and sign in',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Action buttons
              if (!_isVerified) ...[
                GradientButton(
                  onPressed: _isResending ? null : _resendVerification,
                  child: _isResending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      : const Text('Resend Verification Email'),
                ),

                const SizedBox(height: 12),

                Center(
                  child: TextButton(
                    onPressed: _checkVerificationStatus,
                    child: Text(
                      'I\'ve verified my email',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                GradientButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Continue to Sign In'),
                ),
              ],

              const SizedBox(height: 16),

              // Back to login link
              Center(
                child: TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    'Back to Sign In',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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
