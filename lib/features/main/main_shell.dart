import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/bottom_navigation.dart';
import '../home/home_screen.dart';
import '../send/send_landing_screen.dart';
import '../favorites/favorites_screen.dart';
import '../profile/profile_screen.dart';

/// Main shell that provides bottom navigation for main app views
/// Implements PRD Section 10: Navigation structure with tabs
class MainShell extends ConsumerStatefulWidget {
  final String initialTab;

  const MainShell({super.key, this.initialTab = 'home'});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  late String _activeTab;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab;
  }

  void _onTabChanged(String tabId) {
    setState(() {
      _activeTab = tabId;
    });

    // Navigate to the appropriate route
    switch (tabId) {
      case 'home':
        context.go('/home');
        break;
      case 'send':
        context.go('/send-tab'); // This will go to the send landing screen
        break;
      case 'favorites':
        context.go('/favorites');
        break;
      case 'profile':
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content area
          Positioned.fill(
            bottom: 80, // Space for bottom navigation
            child: _buildCurrentScreen(),
          ),

          // Bottom navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavigation(
              activeTab: _activeTab,
              onTabChanged: _onTabChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_activeTab) {
      case 'home':
        return const HomeScreen();
      case 'send':
        return const SendLandingScreen();
      case 'favorites':
        return const FavoritesScreen();
      case 'profile':
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }
}
