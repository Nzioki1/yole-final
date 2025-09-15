import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/gradient_button.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';
import '../../data/repos/kyc_repo.dart';
import '../../data/api/yole_api_client.dart';
import '../../data/api/yole_api_client.dart';

/// KYC ID capture screen
///
/// Implements PRD Section 6.1 New User → First Send:
/// - KYC: phone → OTP → ID capture (front/back or passport) → selfie (if later needed)
/// - ID document capture and validation
/// - Navigation to selfie or completion
class KycIdScreen extends ConsumerStatefulWidget {
  const KycIdScreen({super.key});

  @override
  ConsumerState<KycIdScreen> createState() => _KycIdScreenState();
}

class _KycIdScreenState extends ConsumerState<KycIdScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idNumberController = TextEditingController();

  bool _isLoading = false;
  String? _selectedIdType = 'passport';
  String? _frontImagePath;
  String? _backImagePath;

  final KycRepository _kycRepo = KycRepository(createYoleApiClient());

  @override
  void dispose() {
    _idNumberController.dispose();
    super.dispose();
  }

  Future<void> _captureImage(String type) async {
    // TODO: Implement camera/image picker functionality
    setState(() {
      if (type == 'front') {
        _frontImagePath = 'captured_front_image.jpg';
      } else {
        _backImagePath = 'captured_back_image.jpg';
      }
    });
  }

  Future<void> _submitKyc() async {
    if (!_formKey.currentState!.validate()) return;
    if (_frontImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture the front of your ID')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _kycRepo.validateKyc(
        phoneNumber: '', // TODO: Get from previous screens
        otpCode: '', // TODO: Get from previous screens
        idNumber: _idNumberController.text.trim(),
        idFrontImage: _frontImagePath!,
        idBackImage: _backImagePath,
      );

      if (mounted) {
        context.go('/kyc/selfie');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('KYC validation failed: ${e.toString()}'),
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
        title: const Text('Verify Identity'),
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
                Text('Verify Your Identity', style: textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  'Please provide your ID document for verification',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 32),

                // ID type selection
                Text(
                  'ID Type',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedIdType,
                  decoration: InputDecoration(
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
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'passport',
                      child: Text('Passport'),
                    ),
                    DropdownMenuItem(
                      value: 'drivers_license',
                      child: Text('Driver\'s License'),
                    ),
                    DropdownMenuItem(
                      value: 'national_id',
                      child: Text('National ID'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedIdType = value;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // ID number field
                TextFormField(
                  controller: _idNumberController,
                  decoration: InputDecoration(
                    labelText: 'ID Number',
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
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'ID number is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Image capture section
                Text(
                  'Capture ID Document',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                // Front image
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
                        'Front of ID',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_frontImagePath == null)
                        Container(
                          height: 120,
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
                                Icons.camera_alt,
                                size: 32,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to capture',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          height: 120,
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
                                size: 32,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Front captured',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => _captureImage('front'),
                        child: Text(
                          _frontImagePath == null
                              ? 'Capture Front'
                              : 'Retake Front',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Back image (if needed)
                if (_selectedIdType != 'passport') ...[
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
                          'Back of ID',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_backImagePath == null)
                          Container(
                            height: 120,
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
                                  Icons.camera_alt,
                                  size: 32,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to capture',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            height: 120,
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
                                  size: 32,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Back captured',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => _captureImage('back'),
                          child: Text(
                            _backImagePath == null
                                ? 'Capture Back'
                                : 'Retake Back',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Submit button
                GradientButton(
                  onPressed: _isLoading ? null : _submitKyc,
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      : const Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
