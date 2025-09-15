import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'design/theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/routing/app_router.dart';
import 'core/analytics/analytics_provider.dart';

/// Main app widget with routing and theming
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize analytics asynchronously (don't block UI)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        ref.read(analyticsInitializerProvider);
      } catch (e) {
        print('Analytics initialization failed: $e');
      }
    });

    // Watch theme mode provider
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Yole',
      debugShowCheckedModeBanner: false,

      // Full custom theme system with theme switching
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode, // Dynamic theme switching
      // Router configuration
      routerConfig: AppRouter.router,
    );
  }
}
