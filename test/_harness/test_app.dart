import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestApp extends StatelessWidget {
  final Widget? home;
  final RouterConfig<Object>? router;
  final List<Override> overrides;

  const TestApp({super.key, this.home, this.router, this.overrides = const []})
    : assert(home != null || router != null, 'Provide either home or router');

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: router != null
          ? MaterialApp.router(routerConfig: router)
          : MaterialApp(home: home!),
    );
  }
}

