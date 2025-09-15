import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';
import '../../core/analytics/analytics_service.dart';

/// KYC Error screen with error summary, retry callback, and help actions.
class KycErrorScreen extends StatefulWidget {
  /// Error message to display
  final String? errorMessage;

  /// Error code for analytics
  final String? errorCode;

  /// Callback for retry action
  final VoidCallback? onRetry;

  /// Callback for help action
  final VoidCallback? onGetHelp;

  const KycErrorScreen({
    super.key,
    this.errorMessage,
    this.errorCode,
    this.onRetry,
    this.onGetHelp,
  });

  @override
  State<KycErrorScreen> createState() => _KycErrorScreenState();
}

class _KycErrorScreenState extends State<KycErrorScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _showInlineError = false;

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

    // Track screen view and error
    final analytics = AnalyticsService();
    analytics.logScreenView('kyc_error');
    analytics.logError(widget.errorCode ?? 'kyc_verification_failed');
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onRetryPressed() {
    // Micro-interaction: scale down and opacity change
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    // Track user action
    final analytics = AnalyticsService();
    analytics.logUserAction('kyc_retry');

    // Show inline error briefly
    setState(() {
      _showInlineError = true;
    });

    // Hide inline error after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showInlineError = false;
        });
      }
    });

    // Call retry callback
    widget.onRetry?.call();
  }

  void _onGetHelpPressed() {
    // Micro-interaction: scale down and opacity change
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    // Track user action
    final analytics = AnalyticsService();
    analytics.logUserAction('kyc_get_help');

    // Call help callback
    widget.onGetHelp?.call();
  }

  void _onBackPressed() {
    final analytics = AnalyticsService();
    analytics.trackUserAction('kyc_error_back');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: DesignTokens.onBackground,
          ),
          onPressed: _onBackPressed,
        ),
      ),
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
          const Spacer(flex: 1),

          // Error Icon
          _buildErrorIcon(),

          SizedBox(height: DesignTokens.spacingLg),

          // Error Title
          _buildErrorTitle(),

          SizedBox(height: DesignTokens.spacingMd),

          // Error Message
          _buildErrorMessage(),

          SizedBox(height: DesignTokens.spacingLg),

          // Inline Error (shown briefly after retry)
          if (_showInlineError) _buildInlineError(),

          const Spacer(flex: 2),

          // Action Buttons
          _buildActionButtons(),

          SizedBox(height: DesignTokens.spacingLg),
        ],
      ),
    );
  }

  Widget _buildErrorIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: DesignTokens.error.withOpacity(0.1),
        border: Border.all(
          color: DesignTokens.error.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.error_outline_rounded,
        size: 40,
        color: DesignTokens.error,
      ),
    );
  }

  Widget _buildErrorTitle() {
    return Text(
      'Verification Failed',
      style: AppTypography.h2.copyWith(
        color: DesignTokens.onBackground,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildErrorMessage() {
    return Text(
      widget.errorMessage ??
          'We couldn\'t verify your identity. This could be due to unclear documents, network issues, or incomplete information.',
      style: AppTypography.bodyMedium.copyWith(
        color: DesignTokens.onBackground.withOpacity(0.8),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildInlineError() {
    return Container(
      padding: EdgeInsets.all(DesignTokens.spacingMd),
      margin: EdgeInsets.symmetric(vertical: DesignTokens.spacingSm),
      decoration: BoxDecoration(
        color: DesignTokens.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(
          color: DesignTokens.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: DesignTokens.error, size: 20),
          SizedBox(width: DesignTokens.spacingSm),
          Expanded(
            child: Text(
              'Please ensure your documents are clear and well-lit',
              style: AppTypography.caption.copyWith(color: DesignTokens.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Retry Button
        _buildRetryButton(),

        SizedBox(height: DesignTokens.spacingMd),

        // Get Help Button
        _buildGetHelpButton(),
      ],
    );
  }

  Widget _buildRetryButton() {
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
                onPressed: _onRetryPressed,
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
                  'Retry KYC',
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

  Widget _buildGetHelpButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: _onGetHelpPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: DesignTokens.primary,
          side: BorderSide(color: DesignTokens.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingLg,
            vertical: DesignTokens.spacingMd,
          ),
        ),
        child: Text(
          'Get Help',
          style: AppTypography.buttonLarge.copyWith(
            color: DesignTokens.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
