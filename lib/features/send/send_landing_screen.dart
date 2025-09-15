import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/pressable.dart';

/// Send landing screen - shows when Send tab is selected
/// Provides entry points to the send flow
class SendLandingScreen extends StatelessWidget {
  const SendLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Send Money', style: textTheme.titleLarge),
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
              Text(
                'Send money to the DRC',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: SpacingTokens.sm),
              Text(
                'Quick, secure, and reliable money transfers',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              SizedBox(height: SpacingTokens.xl),

              // Quick send button
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  onPressed: () {
                    context.go('/send/recipient');
                  },
                  child: const Text('Start New Transfer'),
                ),
              ),

              SizedBox(height: SpacingTokens.lg),

              // Recent recipients section
              Text(
                'Recent Recipients',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: SpacingTokens.sm),

              // Quick send cards
              Expanded(
                child: ListView(
                  children: [
                    _buildQuickSendCard(
                      context,
                      name: 'Marie Kabongo',
                      phone: '+243 123 456 789',
                      lastAmount: '\$50.00',
                    ),
                    SizedBox(height: SpacingTokens.sm),
                    _buildQuickSendCard(
                      context,
                      name: 'Jean Mbuyi',
                      phone: '+243 987 654 321',
                      lastAmount: '\$25.00',
                    ),
                    SizedBox(height: SpacingTokens.sm),
                    _buildQuickSendCard(
                      context,
                      name: 'Sarah Kimvuidi',
                      phone: '+243 555 123 456',
                      lastAmount: '\$100.00',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickSendCard(
    BuildContext context, {
    required String name,
    required String phone,
    required String lastAmount,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Pressable(
      onPressed: () {
        context.go(
          '/send/amount?name=${Uri.encodeComponent(name)}&phone=${Uri.encodeComponent(phone)}',
        );
      },
      child: Container(
        padding: SpacingTokens.mdAll,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(Icons.person, color: colorScheme.onPrimaryContainer),
            ),
            SizedBox(width: SpacingTokens.md),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    phone,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Amount and arrow
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Last: $lastAmount',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
