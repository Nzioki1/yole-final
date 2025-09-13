import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/analytics/analytics_provider.dart';

/// Main app widget with routing and theming
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize analytics
    ref.watch(analyticsInitializerProvider);

    return MaterialApp.router(
      title: 'Yole',
      debugShowCheckedModeBanner: false,

      // Localization configuration (simplified for now)
      // TODO: Add proper localization support

      // Theme configuration
      theme: YoleTheme.light,
      darkTheme: YoleTheme.dark,
      themeMode: ThemeMode.system, // Follows system theme
      // Router configuration
      routerConfig: AppRouter.router,
    );
  }
}
