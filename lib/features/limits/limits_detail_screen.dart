import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../send/cap_limit_state.dart';
import '../../core/theme/tokens_spacing.dart';

class LimitsDetailScreen extends ConsumerWidget {
  final CapBreach type; // CapBreach.perTxn or CapBreach.daily
  const LimitsDetailScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final status = ref.read(capStatusProvider); // for countdown texts on daily

    final isDaily = type == CapBreach.daily;

    return Scaffold(
      appBar: AppBar(title: const Text('M-Pesa limits')),
      body: ListView(
        padding: SpacingTokens.lgAll,
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: cs.outline.withValues(alpha: 0.25)),
            ),
            child: Padding(
              padding: SpacingTokens.lgAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isDaily
                        ? 'Daily M-Pesa limit'
                        : 'M-Pesa per-transaction limit',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isDaily
                        ? 'You\'ve reached your daily M-Pesa limit.'
                        : 'You\'ve reached the maximum amount allowed for a single M-Pesa transaction.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  if (isDaily) ...[
                    _Bullet(text: 'Daily total allowed: KES 500,000'),
                    if (status.resetLongRel != null)
                      _Bullet(text: status.resetLongRel!),
                    if (status.resetLongAbs != null)
                      _Bullet(text: status.resetLongAbs!),
                    const SizedBox(height: 16),
                    _PrimaryButton(
                      label: 'Use Card instead',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: 8),
                    _GhostButton(
                      label: 'Back to amount',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ] else ...[
                    _Bullet(text: 'Maximum per transaction: KES 250,000'),
                    _Bullet(
                      text:
                          'To continue: reduce the amount below the limit or choose Card',
                    ),
                    const SizedBox(height: 16),
                    _PrimaryButton(
                      label: 'Adjust amount',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: 8),
                    _GhostButton(
                      label: 'Use Card instead',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SpacingTokens.xs + 2,
      ), // 6.0 = 4 + 2
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  '),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: cs.onSurface.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _PrimaryButton({required this.label, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge!.copyWith(color: cs.onPrimary),
        ),
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _GhostButton({required this.label, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: cs.onSurface,
          side: BorderSide(color: cs.outline.withValues(alpha: 0.25)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed,
        child: Text(label, style: Theme.of(context).textTheme.labelLarge),
      ),
    );
  }
}
