/// Send Money Start Screen
///
/// This screen introduces the send money flow and provides
/// a call-to-action to begin the process.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../design/tokens.dart';
import '../../../design/typography.dart';
import '../../../widgets/gradient_button.dart';
import '../../../ui/layout/responsive_scaffold.dart';
import '../../../ui/layout/scroll_column.dart';
import '../state/send_notifier.dart';
import '../../../core/analytics/analytics_service.dart';

/// Send money start screen
class SendStartScreen extends ConsumerWidget {
  const SendStartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sendState = ref.watch(sendNotifierProvider);

    // Track screen view
    SendFlowAnalytics.trackStepViewed('start');

    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: ScrollColumn(
        children: [
          // Header section
          ScrollColumn(
            children: [
              // Title
              Text(
                'Send Money\nAnywhere',
                style: AppTypography.h1.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.2,
                ),
                softWrap: true,
              ),

              // Subtitle
              Text(
                'Transfer money to friends, family, or businesses\ninstantly and securely.',
                style: AppTypography.bodyLarge.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                softWrap: true,
              ),

              // Features list
              _buildFeatureList(context),
            ],
          ),

          // Draft restoration banner
          if (sendState.hasDraft) _buildDraftBanner(context, ref),
        ],
      ),
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Start button
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              key: const Key('send_start_cta'),
              onPressed: () {
                ref.read(sendNotifierProvider.notifier).startFlow();
                SendFlowAnalytics.trackUserAction('start_send_flow');
                context.go('/send/recipient');
              },
              child: Text(
                'Start Sending',
                style: AppTypography.buttonLarge.copyWith(color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Secondary action
          TextButton(
            onPressed: () {
              // TODO: Navigate to recent transactions
            },
            child: Text(
              'View Recent Transfers',
              style: AppTypography.buttonMedium.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build feature list
  Widget _buildFeatureList(BuildContext context) {
    final features = [
      {
        'icon': Icons.flash_on,
        'title': 'Instant Transfer',
        'description': 'Money arrives in seconds',
      },
      {
        'icon': Icons.security,
        'title': 'Secure & Encrypted',
        'description': 'Bank-level security',
      },
      {
        'icon': Icons.public,
        'title': 'Global Network',
        'description': 'Send to 200+ countries',
      },
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: DesignTokens.radiusLgAll,
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature['title'] as String,
                      style: AppTypography.h4.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      feature['description'] as String,
                      style: AppTypography.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Build draft restoration banner
  Widget _buildDraftBanner(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: DesignTokens.spacingMdAll,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: DesignTokens.radiusLgAll,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.restore,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Draft Found',
                  style: AppTypography.labelLarge.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'You have an unfinished transfer. Continue where you left off?',
                  style: AppTypography.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: () {
              // Navigate to the last step in the draft
              final sendState = ref.read(sendNotifierProvider);
              context.go('/send/${sendState.currentStep.name}');
            },
            child: Text(
              'Continue',
              style: AppTypography.labelMedium.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
