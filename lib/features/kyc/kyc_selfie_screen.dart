import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/gradient_button.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';

/// KYC selfie screen (optional placeholder)
///
/// Implements PRD Section 6.1 New User → First Send:
/// - KYC: phone → OTP → ID capture → selfie (if later needed)
/// - Selfie capture placeholder
/// - Navigation to completion
class KycSelfieScreen extends ConsumerStatefulWidget {
  const KycSelfieScreen({super.key});

  @override
  ConsumerState<KycSelfieScreen> createState() => _KycSelfieScreenState();
}

class _KycSelfieScreenState extends ConsumerState<KycSelfieScreen> {
  bool _isLoading = false;
  String? _selfieImagePath;

  Future<void> _captureSelfie() async {
    // TODO: Implement camera functionality for selfie capture
    setState(() {
      _selfieImagePath = 'captured_selfie.jpg';
    });
  }

  Future<void> _completeKyc() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Submit selfie and complete KYC process
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Selfie'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: SpacingTokens.lgAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text('Take a Selfie', style: textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'This helps us verify your identity (optional)',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 32),

              // Selfie capture section
              Container(
                padding: SpacingTokens.lgAll,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(color: colorScheme.outline, width: 1),
                  borderRadius: RadiusTokens.mdAll,
                ),
                child: Column(
                  children: [
                    Text(
                      'Selfie Photo',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_selfieImagePath == null)
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant,
                          borderRadius: RadiusTokens.mdAll,
                          border: Border.all(
                            color: colorScheme.outline,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_front,
                              size: 48,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Tap to take selfie',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant,
                          borderRadius: RadiusTokens.mdAll,
                          border: Border.all(
                            color: colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 48,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Selfie captured',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _captureSelfie,
                      child: Text(
                        _selfieImagePath == null
                            ? 'Take Selfie'
                            : 'Retake Selfie',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Info card
              Container(
                padding: SpacingTokens.lgAll,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withValues(alpha: 0.5),
                  borderRadius: RadiusTokens.mdAll,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This step is optional. You can skip it and complete it later if needed.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Complete button
              GradientButton(
                onPressed: _isLoading ? null : _completeKyc,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    : const Text('Complete Verification'),
              ),

              const SizedBox(height: 16),

              // Skip link
              Center(
                child: TextButton(
                  onPressed: _isLoading ? null : _completeKyc,
                  child: Text(
                    'Skip for now',
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
