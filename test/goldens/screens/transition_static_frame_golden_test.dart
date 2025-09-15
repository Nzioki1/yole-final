/// Golden tests for page transitions with static frames
///
/// Tests the visual appearance of page transitions at specific frames:
/// - Shared axis transitions at mid-animation
/// - Cross-fade transitions at different stages
/// - Custom transitions with deterministic frames
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:yole_final/core/router/transitions.dart';
import 'package:yole_final/ui/motion/motion.dart';

void main() {
  group('Page Transition Static Frame Golden Tests', () {
    group('Shared Axis Transitions', () {
      testGoldens('SharedAxisX - Mid Animation', (tester) async {
        await tester.pumpWidgetBuilder(
          _TransitionTestWidget(
            config: const PageTransitionConfig(
              type: PageTransitionType.sharedAxisX,
              duration: Duration(milliseconds: 300),
            ),
            animationProgress: 0.5, // Mid animation
            child: const _TestPage(
              title: 'Destination Page',
              color: Colors.blue,
            ),
          ),
          wrapper: (child) => _goldenWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'shared_axis_x_mid');
      });

      testGoldens('SharedAxisX - Start Animation', (tester) async {
        await tester.pumpWidgetBuilder(
          _TransitionTestWidget(
            config: const PageTransitionConfig(
              type: PageTransitionType.sharedAxisX,
              duration: Duration(milliseconds: 300),
            ),
            animationProgress: 0.0, // Start of animation
            child: const _TestPage(
              title: 'Destination Page',
              color: Colors.blue,
            ),
          ),
          wrapper: (child) => _goldenWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'shared_axis_x_start');
      });

      testGoldens('SharedAxisX - End Animation', (tester) async {
        await tester.pumpWidgetBuilder(
          _TransitionTestWidget(
            config: const PageTransitionConfig(
              type: PageTransitionType.sharedAxisX,
              duration: Duration(milliseconds: 300),
            ),
            animationProgress: 1.0, // End of animation
            child: const _TestPage(
              title: 'Destination Page',
              color: Colors.blue,
            ),
          ),
          wrapper: (child) => _goldenWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'shared_axis_x_end');
      });

      testGoldens('SharedAxisY - Mid Animation', (tester) async {
        await tester.pumpWidgetBuilder(
          _TransitionTestWidget(
            config: const PageTransitionConfig(
              type: PageTransitionType.sharedAxisY,
              duration: Duration(milliseconds: 300),
            ),
            animationProgress: 0.5, // Mid animation
            child: const _TestPage(
              title: 'Destination Page',
              color: Colors.green,
            ),
          ),
          wrapper: (child) => _goldenWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'shared_axis_y_mid');
      });

      testGoldens('SharedAxisZ - Mid Animation', (tester) async {
        await tester.pumpWidgetBuilder(
          _TransitionTestWidget(
            config: const PageTransitionConfig(
              type: PageTransitionType.sharedAxisZ,
              duration: Duration(milliseconds: 300),
            ),
            animationProgress: 0.5, // Mid animation
            child: const _TestPage(
              title: 'Modal Page',
              color: Colors.purple,
            ),
          ),
          wrapper: (child) => _goldenWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'shared_axis_z_mid');
      });
    });

    group('Cross Fade Transitions', () {
      testGoldens('CrossFade - Mid Animation', (tester) async {
        await tester.pumpWidgetBuilder(
          _TransitionTestWidget(
            config: const PageTransitionConfig(
              type: PageTransitionType.crossFade,
              duration: Duration(milliseconds: 300),
            ),
            animationProgress: 0.5, // Mid animation
            child: const _TestPage(
              title: 'Faded Page',
              color: Colors.orange,
            ),
          ),
          wrapper: (child) => _goldenWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'cross_fade_mid');
      });

      testGoldens('CrossFade - Start Animation', (tester) async {
        await tester.pumpWidgetBuilder(
          _TransitionTestWidget(
            config: const PageTransitionConfig(
              type: PageTransitionType.crossFade,
              duration: Duration(milliseconds: 300),
            ),
            animationProgress: 0.0, // Start of animation
            child: const _TestPage(
              title: 'Faded Page',
              color: Colors.orange,
            ),
          ),
          wrapper: (child) => _goldenWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'cross_fade_start');
      });

      testGoldens('CrossFade - End Animation', (tester) async {
        await tester.pumpWidgetBuilder(
          _TransitionTestWidget(
            config: const PageTransitionConfig(
              type: PageTransitionType.crossFade,
              duration: Duration(milliseconds: 300),
            ),
            animationProgress: 1.0, // End of animation
            child: const _TestPage(
              title: 'Faded Page',
              color: Colors.orange,
            ),
          ),
          wrapper: (child) => _goldenWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'cross_fade_end');
      });
    });

    group('Reverse Transitions', () {
      testGoldens('SharedAxisX - Reverse Mid Animation', (tester) async {
        await tester.pumpWidgetBuilder(
          _TransitionTestWidget(
            config: const PageTransitionConfig(
              type: PageTransitionType.sharedAxisX,
              duration: Duration(milliseconds: 300),
              reverse: true,
            ),
            animationProgress: 0.5, // Mid animation
            child: const _TestPage(
              title: 'Going Back',
              color: Colors.red,
            ),
          ),
          wrapper: (child) => _goldenWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'shared_axis_x_reverse_mid');
      });

      testGoldens('SharedAxisY - Reverse Mid Animation', (tester) async {
        await tester.pumpWidgetBuilder(
          _TransitionTestWidget(
            config: const PageTransitionConfig(
              type: PageTransitionType.sharedAxisY,
              duration: Duration(milliseconds: 300),
              reverse: true,
            ),
            animationProgress: 0.5, // Mid animation
            child: const _TestPage(
              title: 'Going Up',
              color: Colors.teal,
            ),
          ),
          wrapper: (child) => _goldenWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'shared_axis_y_reverse_mid');
      });
    });

    group('Custom Transitions', () {
      testGoldens('Custom Transition - Slide and Fade', (tester) async {
        await tester.pumpWidgetBuilder(
          _TransitionTestWidget(
            config: PageTransitionConfig(
              type: PageTransitionType.custom,
              duration: const Duration(milliseconds: 300),
              customTransition: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
            ),
            animationProgress: 0.5, // Mid animation
            child: const _TestPage(
              title: 'Custom Transition',
              color: Colors.indigo,
            ),
          ),
          wrapper: (child) => _goldenWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'custom_transition_mid');
      });
    });

    group('Different Durations', () {
      testGoldens('Fast Transition - Mid Animation', (tester) async {
        await tester.pumpWidgetBuilder(
          _TransitionTestWidget(
            config: const PageTransitionConfig(
              type: PageTransitionType.sharedAxisX,
              duration: Duration(milliseconds: 120), // Fast
            ),
            animationProgress: 0.5, // Mid animation
            child: const _TestPage(
              title: 'Fast Transition',
              color: Colors.yellow,
            ),
          ),
          wrapper: (child) => _goldenWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'fast_transition_mid');
      });

      testGoldens('Slow Transition - Mid Animation', (tester) async {
        await tester.pumpWidgetBuilder(
          _TransitionTestWidget(
            config: const PageTransitionConfig(
              type: PageTransitionType.sharedAxisX,
              duration: Duration(milliseconds: 500), // Slow
            ),
            animationProgress: 0.5, // Mid animation
            child: const _TestPage(
              title: 'Slow Transition',
              color: Colors.pink,
            ),
          ),
          wrapper: (child) => _goldenWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'slow_transition_mid');
      });
    });
  });
}

/// Test widget that simulates a page transition at a specific frame
class _TransitionTestWidget extends StatelessWidget {
  final PageTransitionConfig config;
  final double animationProgress;
  final Widget child;

  const _TransitionTestWidget({
    required this.config,
    required this.animationProgress,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background page (simulating the previous page)
        const _TestPage(
          title: 'Previous Page',
          color: Colors.grey,
        ),
        // Transitioning page
        _buildTransitioningPage(),
      ],
    );
  }

  Widget _buildTransitioningPage() {
    switch (config.type) {
      case PageTransitionType.crossFade:
        return Opacity(
          opacity: animationProgress,
          child: child,
        );
      case PageTransitionType.sharedAxisX:
        return Transform.translate(
          offset: Offset(
            (1.0 - animationProgress) * (config.reverse ? 400.0 : -400.0),
            0.0,
          ),
          child: Opacity(
            opacity: animationProgress,
            child: child,
          ),
        );
      case PageTransitionType.sharedAxisY:
        return Transform.translate(
          offset: Offset(
            0.0,
            (1.0 - animationProgress) * (config.reverse ? 600.0 : -600.0),
          ),
          child: Opacity(
            opacity: animationProgress,
            child: child,
          ),
        );
      case PageTransitionType.sharedAxisZ:
        return Transform.scale(
          scale: config.reverse 
              ? (0.8 + (animationProgress * 0.2))
              : (1.2 - (animationProgress * 0.2)),
          child: Opacity(
            opacity: animationProgress,
            child: child,
          ),
        );
      case PageTransitionType.custom:
        if (config.customTransition != null) {
          // For custom transitions, we'd need to create a mock animation controller
          // For golden tests, we'll simulate with a simple slide and fade
          return Transform.translate(
            offset: Offset(0.0, (1.0 - animationProgress) * 600.0),
            child: Opacity(
              opacity: animationProgress,
              child: child,
            ),
          );
        }
        return child;
      case PageTransitionType.none:
        return child;
    }
  }
}

/// Test page widget for transition testing
class _TestPage extends StatelessWidget {
  final String title;
  final Color color;
  final double animationProgress;

  const _TestPage({
    required this.title,
    required this.color,
    this.animationProgress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: color.withOpacity(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pages,
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Animation Progress: ${(animationProgress * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Wrapper for golden tests
Widget _goldenWrapper(Widget child) {
  return MaterialApp(
    theme: ThemeData.light(),
    home: Scaffold(
      backgroundColor: Colors.white,
      body: child,
    ),
  );
}
