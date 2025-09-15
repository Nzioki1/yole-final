/// Send Money Authentication Screen
///
/// This screen handles PIN/biometric authentication
/// before final transaction submission.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../design/tokens.dart';
import '../../../design/typography.dart';
import '../../../ui/components/amount_display.dart';
import '../../../ui/layout/responsive_scaffold.dart';
import '../../../ui/layout/scroll_column.dart';
import '../../../widgets/gradient_button.dart';
import '../state/send_notifier.dart';
import '../state/send_state.dart';
import '../../../core/analytics/analytics_service.dart';

/// Send money authentication screen
class SendAuthScreen extends ConsumerStatefulWidget {
  const SendAuthScreen({super.key});

  @override
  ConsumerState<SendAuthScreen> createState() => _SendAuthScreenState();
}

class _SendAuthScreenState extends ConsumerState<SendAuthScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  bool _isBiometricAvailable = false;
  bool _isAuthenticating = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _pinController.addListener(_onPinChanged);
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  void _checkBiometricAvailability() {
    // Mock biometric availability check
    // In real app, this would check device capabilities
    setState(() {
      _isBiometricAvailable = true;
    });
  }

  void _onPinChanged() {
    if (_pinController.text.length == 6) {
      _authenticateWithPin();
    }
  }

  Future<void> _authenticateWithPin() async {
    setState(() {
      _isAuthenticating = true;
      _errorMessage = '';
    });

    try {
      // Mock PIN authentication
      await Future.delayed(const Duration(seconds: 1));

      // Simulate PIN validation (in real app, this would validate against stored PIN)
      if (_pinController.text == '123456') {
        // Authentication successful
        await _submitTransaction();
      } else {
        setState(() {
          _errorMessage = 'Invalid PIN. Please try again.';
          _pinController.clear();
        });
        SendFlowAnalytics.trackError('invalid_pin', step: 'auth');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Authentication failed. Please try again.';
      });
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  Future<void> _authenticateWithBiometric() async {
    setState(() {
      _isAuthenticating = true;
      _errorMessage = '';
    });

    try {
      // Mock biometric authentication
      await Future.delayed(const Duration(seconds: 2));

      // Simulate biometric success (in real app, this would use local_auth package)
      await _submitTransaction();
    } catch (e) {
      setState(() {
        _errorMessage = 'Biometric authentication failed. Please try PIN.';
      });
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  Future<void> _submitTransaction() async {
    try {
      await ref.read(sendNotifierProvider.notifier).submitTransaction();
      if (mounted) {
        final sendState = ref.read(sendNotifierProvider);
        SendFlowAnalytics.trackSuccess(
          fromCurrency: sendState.fromCurrency,
          toCurrency: sendState.toCurrency,
          amount: sendState.amount?.major ?? 0.0,
          network: sendState.selectedNetwork?.name ?? '',
          recipientType: 'email',
          transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
        );
        context.go('/send/success');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Transaction failed. Please try again.';
      });
      SendFlowAnalytics.trackError('transaction_failed', step: 'auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    final sendState = ref.watch(sendNotifierProvider);

    // Track screen view
    SendFlowAnalytics.trackStepViewed('auth');

    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      keyboardSafe: true,
      body: ScrollColumn(
        children: [
          // Header section
          ScrollColumn(
            children: [
              Text(
                'Confirm your transfer',
                style: AppTypography.h2.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                softWrap: true,
              ),
              Text(
                'Enter your PIN or use biometric authentication',
                style: AppTypography.bodyLarge.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                softWrap: true,
              ),

              // Transaction summary
              _buildTransactionSummary(context, sendState),
            ],
          ),

          // Authentication section
          ScrollColumn(
            children: [
              // Biometric authentication
              if (_isBiometricAvailable) ...[
                _buildBiometricAuth(context),
                _buildDivider(context),
              ],

              // PIN authentication
              _buildPinAuth(context),

              // Error message
              if (_errorMessage.isNotEmpty) _buildErrorMessage(context),
            ],
          ),
        ],
      ),
    );
  }

  /// Build transaction summary
  Widget _buildTransactionSummary(BuildContext context, SendState sendState) {
    return Container(
      padding: DesignTokens.spacingMdAll,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: DesignTokens.radiusLgAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transfer Summary',
            style: AppTypography.h4.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amount',
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              AmountDisplay(money: sendState.amount!, variant: 'primary'),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'To',
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                sendState.recipient!.name,
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Via',
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                sendState.selectedNetwork!.name,
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build biometric authentication
  Widget _buildBiometricAuth(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _isAuthenticating ? null : _authenticateWithBiometric,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: DesignTokens.radiusPillAll,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: _isAuthenticating
                ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 2,
                  )
                : Icon(
                    Icons.fingerprint,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Use Biometric',
          style: AppTypography.h4.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Touch the fingerprint sensor',
          style: AppTypography.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Build divider
  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: AppTypography.bodySmall.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  /// Build PIN authentication
  Widget _buildPinAuth(BuildContext context) {
    return Column(
      children: [
        Text(
          'Enter PIN',
          style: AppTypography.h4.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // PIN input field
        Container(
          width: 200,
          child: TextField(
            key: const Key('pin_input'),
            controller: _pinController,
            focusNode: _pinFocusNode,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            obscureText: true,
            textAlign: TextAlign.center,
            style: AppTypography.h2.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: 8,
            ),
            decoration: InputDecoration(
              hintText: '••••••',
              hintStyle: AppTypography.h2.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: DesignTokens.radiusLgAll,
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: DesignTokens.radiusLgAll,
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: DesignTokens.radiusLgAll,
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // PIN dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (index) {
            final isFilled = index < _pinController.text.length;
            return Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isFilled
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                borderRadius: DesignTokens.radiusPillAll,
              ),
            );
          }),
        ),
      ],
    );
  }

  /// Build error message
  Widget _buildErrorMessage(BuildContext context) {
    return Container(
      padding: DesignTokens.spacingMdAll,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: DesignTokens.radiusLgAll,
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
