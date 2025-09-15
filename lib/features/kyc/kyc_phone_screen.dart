import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/gradient_button.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';
import '../../data/repos/kyc_repo.dart';
import '../../data/api/yole_api_client.dart';
import '../../data/api/yole_api_client.dart';

/// KYC phone verification screen
///
/// Implements PRD Section 6.1 New User → First Send:
/// - KYC: phone → OTP → ID capture → selfie (if later needed)
/// - Phone number input and validation
/// - Send SMS OTP functionality
/// - Navigation to OTP verification
class KycPhoneScreen extends ConsumerStatefulWidget {
  const KycPhoneScreen({super.key});

  @override
  ConsumerState<KycPhoneScreen> createState() => _KycPhoneScreenState();
}

class _KycPhoneScreenState extends ConsumerState<KycPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  bool _isLoading = false;

  final KycRepository _kycRepo = KycRepository(createYoleApiClient());

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _kycRepo.sendOtp(phoneNumber: _phoneController.text.trim());

      if (mounted) {
        context.go('/kyc/otp');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send OTP: ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone'),
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
                Text('Verify Your Phone', style: textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  'We\'ll send a verification code to your phone number',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 32),

                // Phone field
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '+1 (555) 123-4567',
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
                    prefixIcon: Icon(
                      Icons.phone,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number is required';
                    }
                    // Basic phone validation - can be enhanced
                    if (value.trim().length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

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
                          'Standard SMS rates may apply. We\'ll send a 6-digit verification code.',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Send OTP button
                GradientButton(
                  onPressed: _isLoading ? null : _sendOtp,
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      : const Text('Send Verification Code'),
                ),

                const SizedBox(height: 16),

                // Skip link (if applicable)
                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement skip functionality if needed
                    },
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
      ),
    );
  }
}
