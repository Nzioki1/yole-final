import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/gradient_button.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';
import '../../data/repos/kyc_repo.dart';
import '../../data/api/yole_api_client.dart';
import '../../data/api/yole_api_client.dart';

/// KYC OTP verification screen
///
/// Implements PRD Section 6.1 New User → First Send:
/// - KYC: phone → OTP → ID capture → selfie (if later needed)
/// - OTP input and validation
/// - Verify OTP functionality
/// - Navigation to ID capture
class KycOtpScreen extends ConsumerStatefulWidget {
  const KycOtpScreen({super.key});

  @override
  ConsumerState<KycOtpScreen> createState() => _KycOtpScreenState();
}

class _KycOtpScreenState extends ConsumerState<KycOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  bool _isLoading = false;
  bool _isResending = false;

  final KycRepository _kycRepo = KycRepository(createYoleApiClient());

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _kycRepo.validateOtp(
        phoneNumber: '', // TODO: Get from previous screen
        otp: _otpController.text.trim(),
      );

      if (mounted) {
        context.go('/kyc/id');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid OTP: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isResending = true;
    });

    try {
      await _kycRepo.sendOtp(
        phoneNumber: '', // TODO: Get from previous screen
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification code sent!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend OTP: ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Code'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: SpacingTokens.lgAll,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Enter Verification Code',
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'We sent a 6-digit code to your phone number',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 32),

                // OTP field
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium?.copyWith(letterSpacing: 8),
                  decoration: InputDecoration(
                    labelText: 'Verification Code',
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
                    counterText: '', // Hide character counter
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Verification code is required';
                    }
                    if (value.trim().length != 6) {
                      return 'Please enter the 6-digit code';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Resend OTP
                Center(
                  child: TextButton(
                    onPressed: _isResending ? null : _resendOtp,
                    child: _isResending
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Resend Code',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 32),

                // Verify button
                GradientButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      : const Text('Verify Code'),
                ),

                const SizedBox(height: 16),

                // Back to phone link
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/kyc/phone'),
                    child: Text(
                      'Change phone number',
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
      ),
    );
  }
}
