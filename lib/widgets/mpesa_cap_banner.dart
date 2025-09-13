import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';
import '../../l10n/app_localizations.dart';

/// M-Pesa cap banner for inline error display
///
/// Shows when M-Pesa limits are breached:
/// - Per-transaction limit (KES 250,000)
/// - Daily limit (KES 500,000)
///
/// Design: Destructive/warning banner style, placed above CTA
class MpesaCapBanner extends StatelessWidget {
  const MpesaCapBanner({
    super.key,
    required this.capType,
    required this.resetHint,
  });

  final MpesaCapType capType;
  final String resetHint;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return Semantics(
      label: _getTitle(l10n),
      liveRegion: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: SpacingTokens.lgAll,
        decoration: BoxDecoration(
          // Use destructive/warning palette with subtle tint background
          color: colorScheme.errorContainer.withValues(alpha: 0.12),
          border: Border.all(color: colorScheme.error, width: 1),
          borderRadius: RadiusTokens.mdAll,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getTitle(l10n),
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onErrorContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _navigateToCapDetails(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Semantics(
                    label: '${l10n.learnMore} about M-Pesa limits',
                    child: Text(
                      l10n.learnMore,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _getBody(l10n),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle(AppLocalizations l10n) {
    switch (capType) {
      case MpesaCapType.perTransaction:
        return l10n.mpesaPerTxnTitle;
      case MpesaCapType.daily:
        return l10n.mpesaDailyTitle;
    }
  }

  String _getBody(AppLocalizations l10n) {
    switch (capType) {
      case MpesaCapType.perTransaction:
        return l10n.mpesaPerTxnBody;
      case MpesaCapType.daily:
        return l10n.mpesaDailyBodyWithHint(resetHint);
    }
  }

  void _navigateToCapDetails(BuildContext context) {
    final type = capType == MpesaCapType.daily ? 'daily' : 'per-transaction';
    context.push('/limits/mpesa?type=$type');
  }
}

enum MpesaCapType { perTransaction, daily }
