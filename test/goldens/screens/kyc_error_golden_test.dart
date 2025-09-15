import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:yole_final/features/kyc/kyc_error_screen.dart';
import 'package:yole_final/design/theme.dart';
import '../_harness/golden_config.dart';

void main() {
  group('KYC Error Screen Golden Tests', () {
    setUpAll(GoldenTestBase.setUpAll);

    testGoldens('KYC Error Screen - Light and Dark Modes', (tester) async {
      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => const KycErrorScreen(
          errorMessage:
              'Document verification failed. Please ensure your ID is clear and well-lit.',
          errorCode: 'document_unclear',
        ),
        name: 'screens/kyc_error_screen',
      );
    });

    testGoldens('KYC Error Screen - Default Message', (tester) async {
      await GoldenConfig.pumpGolden(
        tester,
        const KycErrorScreen(),
        name: 'screens/kyc_error_screen_default',
        brightness: Brightness.light,
      );
    });

    testGoldens('KYC Error Screen - Tablet', (tester) async {
      await GoldenConfig.pumpGolden(
        tester,
        const KycErrorScreen(
          errorMessage:
              'Identity verification could not be completed. Please contact support for assistance.',
          errorCode: 'verification_failed',
        ),
        name: 'screens/kyc_error_screen_tablet',
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
