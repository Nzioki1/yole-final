import 'package:flutter/material.dart';

class CapLimitBanner extends StatelessWidget {
  final String title;
  final String body;
  final VoidCallback? onLearnMore;

  const CapLimitBanner({
    super.key,
    required this.title,
    required this.body,
    this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final border = cs.outline.withValues(alpha: 0.25);
    final warningBg = cs.error.withValues(
      alpha: 0.08,
    ); // subtle tinted bg using error color

    return Container(
      decoration: BoxDecoration(
        color: warningBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: cs.error),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          if (onLearnMore != null)
            TextButton(onPressed: onLearnMore, child: const Text('Learn more')),
        ],
      ),
    );
  }
}
