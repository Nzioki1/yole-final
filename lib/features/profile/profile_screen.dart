import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/auth/auth_provider.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/pressable.dart';

/// Profile & Settings screen
/// Implements PRD Section 10: Profile & Settings
/// - Profile summary; Theme (Dark/Light/System); Biometric toggle;
/// - Change password; Terms; Privacy; Support; Logout
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _biometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile & Settings',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: SpacingTokens.lgAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Summary
            Container(
              width: double.infinity,
              padding: SpacingTokens.xlAll,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: RadiusTokens.lgAll,
                border: Border.all(color: colorScheme.outline, width: 1),
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: colorScheme.primary, width: 2),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: colorScheme.primary,
                    ),
                  ),

                  SizedBox(height: SpacingTokens.md),

                  // Name
                  Text(
                    'John Doe', // TODO: Get from user data
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: SpacingTokens.xs),

                  // Email
                  Text(
                    'john.doe@example.com', // TODO: Get from user data
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),

                  SizedBox(height: SpacingTokens.sm),

                  // Verification status
                  Container(
                    padding: SpacingTokens.smAll,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: RadiusTokens.smAll,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          size: 16,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        SizedBox(width: SpacingTokens.xs),
                        Text(
                          'Verified',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: SpacingTokens.xl),

            // Settings Sections
            Text(
              'Preferences',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: SpacingTokens.md),

            // Theme Settings
            _buildSettingCard(
              context,
              icon: Icons.palette_outlined,
              title: 'Theme',
              subtitle: 'Dark • Light • System',
              onTap: () => _showThemeDialog(context, ref),
            ),

            SizedBox(height: SpacingTokens.sm),

            // Biometric Settings
            _buildSettingCard(
              context,
              icon: Icons.fingerprint,
              title: 'Biometric Authentication',
              subtitle: _biometricEnabled ? 'Enabled' : 'Disabled',
              trailing: Switch(
                value: _biometricEnabled,
                onChanged: (value) {
                  setState(() {
                    _biometricEnabled = value;
                  });
                },
              ),
            ),

            SizedBox(height: SpacingTokens.lg),

            // Account Settings
            Text(
              'Account',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: SpacingTokens.md),

            _buildSettingCard(
              context,
              icon: Icons.lock_outline,
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: () => context.go('/forgot-password'),
            ),

            SizedBox(height: SpacingTokens.sm),

            _buildSettingCard(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Manage your notifications',
              onTap: () {
                // TODO: Navigate to notifications settings
              },
            ),

            SizedBox(height: SpacingTokens.lg),

            // Support & Legal
            Text(
              'Support & Legal',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: SpacingTokens.md),

            _buildSettingCard(
              context,
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help or contact us',
              onTap: () {
                // TODO: Navigate to support
              },
            ),

            SizedBox(height: SpacingTokens.sm),

            _buildSettingCard(
              context,
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: 'Read our terms',
              onTap: () {
                // TODO: Navigate to terms
              },
            ),

            SizedBox(height: SpacingTokens.sm),

            _buildSettingCard(
              context,
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              onTap: () {
                // TODO: Navigate to privacy policy
              },
            ),

            SizedBox(height: SpacingTokens.xl),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                onPressed: () => _showLogoutDialog(context, ref),
                child: Text(
                  'Logout',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Pressable(
      onPressed: onTap,
      child: Container(
        padding: SpacingTokens.lgAll,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: RadiusTokens.mdAll,
          border: Border.all(color: colorScheme.outline, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: SpacingTokens.smAll,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: RadiusTokens.smAll,
              ),
              child: Icon(
                icon,
                size: 20,
                color: colorScheme.onPrimaryContainer,
              ),
            ),

            SizedBox(width: SpacingTokens.md),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: SpacingTokens.xs),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            if (trailing != null) trailing,
            if (onTap != null && trailing == null)
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.read(themeModeProvider.notifier);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Light'),
              onTap: () {
                themeNotifier.setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Dark'),
              onTap: () {
                themeNotifier.setThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('System'),
              onTap: () {
                themeNotifier.setThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Logout user
              final authNotifier = ref.read(authProvider.notifier);
              await authNotifier.logout();
              // Navigate to login
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
