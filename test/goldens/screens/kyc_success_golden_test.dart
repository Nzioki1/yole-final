import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:yole_final/features/kyc/kyc_success_screen.dart';
import 'package:yole_final/design/theme.dart';
import '../_harness/golden_config.dart';

void main() {
  group('KYC Success Screen Golden Tests', () {
    setUpAll(GoldenTestBase.setUpAll);

    testGoldens('KYC Success Screen - Light and Dark Modes', (tester) async {
      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => const KycSuccessScreen(),
        name: 'screens/kyc_success_screen',
      );
    });

    testGoldens('KYC Success Screen - Tablet', (tester) async {
      await GoldenConfig.pumpGolden(
        tester,
        const KycSuccessScreen(),
        name: 'screens/kyc_success_screen_tablet',
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
