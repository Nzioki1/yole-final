import 'package:flutter/material.dart';
import '../../core/theme/tokens_spacing.dart';
import '../../core/theme/tokens_radius.dart';
import 'pressable.dart';

/// Bottom navigation bar matching the Figma design
/// Implements PRD Section 10: Navigation with Home, Send, Favorites, Profile tabs
class BottomNavigation extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabChanged;

  const BottomNavigation({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final tabs = [
      {'id': 'home', 'icon': Icons.home_outlined, 'label': 'Home'},
      {'id': 'send', 'icon': Icons.send_outlined, 'label': 'Send'},
      {'id': 'favorites', 'icon': Icons.favorite_outline, 'label': 'Favorites'},
      {'id': 'profile', 'icon': Icons.person_outline, 'label': 'Profile'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.95),
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withOpacity(0.5),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          padding: SpacingTokens.mdAll,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: tabs.map((tab) => _buildTab(context, tab)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, Map<String, dynamic> tab) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isActive = activeTab == tab['id'];

    return Expanded(
      child: Pressable(
        onPressed: () => onTabChanged(tab['id']),
        child: Container(
          padding: SpacingTokens.smAll,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                tab['icon'] as IconData,
                size: 24,
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              SizedBox(height: SpacingTokens.xs),
              Text(
                tab['label'] as String,
                style: textTheme.labelSmall?.copyWith(
                  color: isActive
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
