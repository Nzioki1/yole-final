import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/gradient_button.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../utils/mpesa_countdown.dart';
import '../../l10n/app_localizations.dart';

/// M-Pesa cap details screen
///
/// Shows detailed information about M-Pesa limits when user taps "Learn more"
/// Route: /limits/mpesa
///
/// Two variants:
/// - Per-transaction limit (KES 250,000)
/// - Daily limit (KES 500,000)
class MpesaCapDetailsScreen extends ConsumerWidget {
  const MpesaCapDetailsScreen({super.key, required this.capType});

  final MpesaCapType capType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('M-Pesa Limits'),
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
              Text(_getHeader(l10n), style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                _getLead(l10n),
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 32),

              // Details card - using standard card tokens
              Container(
                padding: SpacingTokens.lgAll, // Standard card padding
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.25),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(
                    16,
                  ), // Standard card radius
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Limit Details',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._buildBulletPoints(context, l10n),
                  ],
                ),
              ),

              const Spacer(),

              // Action buttons
              Column(
                children: [
                  GradientButton(
                    onPressed: () => _handlePrimaryAction(context),
                    child: Semantics(
                      label: _getPrimaryCtaText(l10n),
                      child: Text(_getPrimaryCtaText(l10n)),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () => _handleSecondaryAction(context),
                    child: Semantics(
                      label: _getSecondaryCtaText(l10n),
                      child: Text(
                        _getSecondaryCtaText(l10n),
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getHeader(AppLocalizations l10n) {
    switch (capType) {
      case MpesaCapType.perTransaction:
        return l10n.mpesaPerTxnHeader;
      case MpesaCapType.daily:
        return l10n.mpesaDailyHeader;
    }
  }

  String _getLead(AppLocalizations l10n) {
    switch (capType) {
      case MpesaCapType.perTransaction:
        return l10n.mpesaPerTxnLead;
      case MpesaCapType.daily:
        return l10n.mpesaDailyLead;
    }
  }

  List<Widget> _buildBulletPoints(BuildContext context, AppLocalizations l10n) {
    switch (capType) {
      case MpesaCapType.perTransaction:
        return [
          _buildBulletPoint(context, l10n.mpesaPerTxnPoint1),
          const SizedBox(height: 8),
          _buildBulletPoint(context, l10n.mpesaPerTxnPoint2),
        ];
      case MpesaCapType.daily:
        final countdownInfo = MpesaCountdown.getLongCountdown();
        return [
          _buildBulletPoint(context, l10n.mpesaDailyPoint1),
          const SizedBox(height: 8),
          _buildBulletPoint(
            context,
            l10n.limitsResetRelativeWithTime(countdownInfo.relative),
          ),
          const SizedBox(height: 4),
          _buildBulletPoint(
            context,
            l10n.limitsResetAbsoluteWithTime(countdownInfo.absolute),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, l10n.mpesaDailyPoint3),
        ];
    }
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // TODO: Audit script flags EdgeInsets.only() constructor, but this uses design tokens correctly
          // Consider if this should be left as-is since it's using SpacingTokens
          margin: EdgeInsets.only(
            top: SpacingTokens.xs + 2,
            right: SpacingTokens.sm,
          ), // top: 6, right: 8
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: colorScheme.onSurfaceVariant,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  String _getPrimaryCtaText(AppLocalizations l10n) {
    switch (capType) {
      case MpesaCapType.perTransaction:
        return l10n.mpesaPerTxnCtaPrimary;
      case MpesaCapType.daily:
        return l10n.mpesaDailyCtaPrimary;
    }
  }

  String _getSecondaryCtaText(AppLocalizations l10n) {
    switch (capType) {
      case MpesaCapType.perTransaction:
        return l10n.mpesaPerTxnCtaSecondary;
      case MpesaCapType.daily:
        return l10n.mpesaDailyCtaSecondary;
    }
  }

  void _handlePrimaryAction(BuildContext context) {
    switch (capType) {
      case MpesaCapType.perTransaction:
        // Go back to amount screen to adjust
        context.pop();
        break;
      case MpesaCapType.daily:
        // Navigate to card payment or change payment method
        // TODO: Implement card payment flow
        context.pop();
        break;
    }
  }

  void _handleSecondaryAction(BuildContext context) {
    switch (capType) {
      case MpesaCapType.perTransaction:
        // Navigate to card payment
        // TODO: Implement card payment flow
        context.pop();
        break;
      case MpesaCapType.daily:
        // Go back to amount screen
        context.pop();
        break;
    }
  }
}

enum MpesaCapType { perTransaction, daily }
