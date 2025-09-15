import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import '../_harness/golden_config.dart';
import '../_harness/test_welcome_screen.dart';

void main() {
  group('Welcome Screen Golden Tests', () {
    setUpAll(GoldenTestBase.setUpAll);

    testGoldens('Welcome Screen - Light and Dark Modes', (tester) async {
      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => const TestWelcomeScreen(enableSparkles: false),
        name: 'screens/welcome_screen',
      );
    });

    testGoldens('Welcome Screen - Tablet', (tester) async {
      await GoldenConfig.pumpGolden(
        tester,
        const TestWelcomeScreen(enableSparkles: false),
        name: 'screens/welcome_screen_tablet',
        brightness: Brightness.light,
        device: const Device(
          name: 'tablet',
          size: Size(768, 1024),
          devicePixelRatio: 2.0,
        ),
      );
    });
  });
}
