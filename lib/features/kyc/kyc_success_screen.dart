import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';
import '../../ui/components/success_animation.dart';
import '../../core/analytics/analytics_service.dart';

/// KYC Success screen with success animation and continue CTA.
class KycSuccessScreen extends StatefulWidget {
  const KycSuccessScreen({super.key});

  @override
  State<KycSuccessScreen> createState() => _KycSuccessScreenState();
}

class _KycSuccessScreenState extends State<KycSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _showSuccessAnimation = true;
  Timer? _hideAnimationTimer;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // Start fade animation
    _fadeController.forward();

    // Track screen view
    final analytics = AnalyticsService();
    analytics.logScreenView('kyc_success');
    analytics.logUserAction('kyc_verification_success');

    // Hide success animation after 3 seconds
    _hideAnimationTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showSuccessAnimation = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _hideAnimationTimer?.cancel();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onContinuePressed() {
    // Micro-interaction: scale down and opacity change
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    // Track user action
    final analytics = AnalyticsService();
    analytics.logUserAction('kyc_success_continue');

    // Navigate to main app
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: _buildContent(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(DesignTokens.spacingLg),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // Success Animation
          if (_showSuccessAnimation) _buildSuccessAnimation(),

          SizedBox(height: DesignTokens.spacingXl),

          // Success Icon
          _buildSuccessIcon(),

          SizedBox(height: DesignTokens.spacingLg),

          // Success Title
          _buildSuccessTitle(),

          SizedBox(height: DesignTokens.spacingMd),

          // Success Message
          _buildSuccessMessage(),

          const Spacer(flex: 3),

          // Continue Button
          _buildContinueButton(),

          SizedBox(height: DesignTokens.spacingLg),
        ],
      ),
    );
  }

  Widget _buildSuccessAnimation() {
    return Container(
      width: 120,
      height: 120,
      child: SuccessAnimation(duration: const Duration(seconds: 3)),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: DesignTokens.success.withOpacity(0.1),
        border: Border.all(
          color: DesignTokens.success.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.verified_user_rounded,
        size: 40,
        color: DesignTokens.success,
      ),
    );
  }

  Widget _buildSuccessTitle() {
    return Text(
      'Verification Complete!',
      style: AppTypography.h2.copyWith(
        color: DesignTokens.onBackground,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSuccessMessage() {
    return Text(
      'Your identity has been successfully verified. You can now access all features of Yole.',
      style: AppTypography.bodyMedium.copyWith(
        color: DesignTokens.onBackground.withOpacity(0.8),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildContinueButton() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _scaleController.isAnimating ? 0.95 : 1.0,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _onContinuePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.primary,
                  foregroundColor: DesignTokens.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingLg,
                    vertical: DesignTokens.spacingMd,
                  ),
                ),
                child: Text(
                  'Continue to App',
                  style: AppTypography.buttonLarge.copyWith(
                    color: DesignTokens.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
