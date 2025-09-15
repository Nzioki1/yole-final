/// Golden tests for AnimatedPress component
///
/// Tests the visual appearance of AnimatedPress in different states:
/// - Normal state
/// - Pressed state
/// - Disabled state
/// - Different scales and opacities
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:yole_final/ui/motion/motion.dart';

void main() {
  group('AnimatedPress Golden Tests', () {
    testGoldens('AnimatedPress - Normal State', (tester) async {
      await tester.pumpWidgetBuilder(
        const AnimatedPress(
          child: _TestButton(
            text: 'Press Me',
            backgroundColor: Colors.blue,
          ),
        ),
        wrapper: _goldenWrapper,
        surfaceSize: const Size(200, 60),
      );

      await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'animated_press_normal');
    });

    testGoldens('AnimatedPress - Pressed State', (tester) async {
      await tester.pumpWidgetBuilder(
        const AnimatedPress(
          child: _TestButton(
            text: 'Press Me',
            backgroundColor: Colors.blue,
          ),
        ),
        wrapper: _goldenWrapper,
        surfaceSize: const Size(200, 60),
      );

      // Simulate press
      await tester.startGesture(tester.getCenter(find.byType(AnimatedPress)));
      await tester.pump(const Duration(milliseconds: 60)); // Half of fast duration

      await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'animated_press_pressed');
    });

    testGoldens('AnimatedPress - Disabled State', (tester) async {
      await tester.pumpWidgetBuilder(
        const AnimatedPress(
          child: _TestButton(
            text: 'Disabled',
            backgroundColor: Colors.grey,
          ),
        ),
        wrapper: _goldenWrapper,
        surfaceSize: const Size(200, 60),
      );

      await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'animated_press_disabled');
    });

    testGoldens('AnimatedPress - Custom Scale', (tester) async {
      await tester.pumpWidgetBuilder(
        const AnimatedPress(
          pressedScale: 0.9,
          child: _TestButton(
            text: 'Custom Scale',
            backgroundColor: Colors.green,
          ),
        ),
        wrapper: _goldenWrapper,
        surfaceSize: const Size(200, 60),
      );

      await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'animated_press_custom_scale');
    });

    testGoldens('AnimatedPress - Custom Opacity', (tester) async {
      await tester.pumpWidgetBuilder(
        const AnimatedPress(
          pressedOpacity: 0.8,
          child: _TestButton(
            text: 'Custom Opacity',
            backgroundColor: Colors.orange,
          ),
        ),
        wrapper: _goldenWrapper,
        surfaceSize: const Size(200, 60),
      );

      await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'animated_press_custom_opacity');
    });

    testGoldens('AnimatedPress - Different Sizes', (tester) async {
      await tester.pumpWidgetBuilder(
        const Column(
          children: [
            AnimatedPress(
              child: _TestButton(
                text: 'Small',
                backgroundColor: Colors.red,
                height: 40,
              ),
            ),
            SizedBox(height: 16),
            AnimatedPress(
              child: _TestButton(
                text: 'Medium',
                backgroundColor: Colors.blue,
                height: 56,
              ),
            ),
            SizedBox(height: 16),
            AnimatedPress(
              child: _TestButton(
                text: 'Large',
                backgroundColor: Colors.green,
                height: 72,
              ),
            ),
          ],
        ),
        wrapper: _goldenWrapper,
        surfaceSize: const Size(200, 280),
      );

      await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'animated_press_sizes');
    });
  });
}

/// Test button widget for golden tests
class _TestButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final double height;

  const _TestButton({
    required this.text,
    required this.backgroundColor,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

/// Wrapper for golden tests
Widget _goldenWrapper(Widget child) {
  return MaterialApp(
    theme: ThemeData.light(),
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}
