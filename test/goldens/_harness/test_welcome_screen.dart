import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yole_final/design/tokens.dart';
import 'package:yole_final/ui/effects/sparkle_layer.dart';
import 'package:yole_final/core/analytics/analytics_service.dart';
import 'test_typography.dart';

/// Test version of Welcome screen that uses test typography
/// to avoid Google Fonts network requests during golden tests
class TestWelcomeScreen extends StatefulWidget {
  /// Whether to enable sparkle animations (disabled for testing)
  final bool enableSparkles;

  const TestWelcomeScreen({super.key, this.enableSparkles = true});

  @override
  State<TestWelcomeScreen> createState() => _TestWelcomeScreenState();
}

class _TestWelcomeScreenState extends State<TestWelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isLowPowerMode = false;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
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

    // Check for low power mode
    _checkLowPowerMode();

    // Track screen view
    final analytics = AnalyticsService();
    analytics.logScreenView('welcome');
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _checkLowPowerMode() {
    // In a real app, this would check actual low power mode status
    // For now, we'll simulate it based on some condition
    _isLowPowerMode = false; // Placeholder
  }

  void _onGetStartedPressed() {
    // Micro-interaction: scale down and opacity change
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    // Track user action
    final analytics = AnalyticsService();
    analytics.logUserAction('welcome_get_started');

    // Navigate to next screen (onboarding or main app)
    context.go('/onboarding/kyc');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.background,
      body: SparkleLayer(
        enabled: widget.enableSparkles && !_isLowPowerMode,
        particleCount: 25,
        animationSpeed: 1.2,
        baseAlpha: 0.7,
        child: SafeArea(
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
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(DesignTokens.spacingLg),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // Hero Image
          _buildHeroImage(),

          SizedBox(height: DesignTokens.spacingXl),

          // Headline
          _buildHeadline(),

          SizedBox(height: DesignTokens.spacingMd),

          // Subhead
          _buildSubhead(),

          const Spacer(flex: 3),

          // CTA Button
          _buildGetStartedButton(),

          SizedBox(height: DesignTokens.spacingLg),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DesignTokens.primary,
            DesignTokens.primary.withOpacity(0.7),
            DesignTokens.primary.withOpacity(0.5),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: DesignTokens.primary.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Icon(
        Icons.account_balance_wallet_rounded,
        size: 80,
        color: DesignTokens.onPrimary,
      ),
    );
  }

  Widget _buildHeadline() {
    return Text(
      'Welcome to Yole',
      style: TestTypography.h1.copyWith(
        color: DesignTokens.onBackground,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubhead() {
    return Text(
      'Send money anywhere, anytime with the most secure and fastest payment platform in Africa.',
      style: TestTypography.bodyMedium.copyWith(
        color: DesignTokens.onBackground.withOpacity(0.8),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildGetStartedButton() {
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
                onPressed: _onGetStartedPressed,
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
                  'Get Started',
                  style: TestTypography.buttonLarge.copyWith(
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
