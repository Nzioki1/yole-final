import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:yole_final/ui/components/success_animation.dart';
import '../_harness/golden_config.dart';

/// Golden tests for SuccessAnimation component
///
/// Tests various success animation scenarios including:
/// - Static frame capture of animation states
/// - Both light and dark theme variants
/// - Animation size variations
void main() {
  group('SuccessAnimation Golden Tests', () {
    setUpAll(GoldenTestBase.setUpAll);

    testGoldens('SuccessAnimation - Default Size', (tester) async {
      final widget = _buildSuccessAnimation();

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/success_animation_default',
      );
    });

    testGoldens('SuccessAnimation - Small Size', (tester) async {
      final widget = _buildSuccessAnimation(size: 80);

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/success_animation_small',
      );
    });

    testGoldens('SuccessAnimation - Large Size', (tester) async {
      final widget = _buildSuccessAnimation(size: 200);

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/success_animation_large',
      );
    });

    testGoldens('SuccessAnimation - Size Comparison', (tester) async {
      final widget = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Small (80px)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          _buildSuccessAnimation(size: 80),
          const SizedBox(height: 16),
          const Text(
            'Medium (120px)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          _buildSuccessAnimation(size: 120),
          const SizedBox(height: 16),
          const Text(
            'Large (200px)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          _buildSuccessAnimation(size: 200),
        ],
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/success_animation_size_comparison',
      );
    });

    testGoldens('SuccessAnimation - In Context', (tester) async {
      final widget = Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSuccessAnimation(size: 120),
            const SizedBox(height: 16),
            const Text(
              'Your money has been sent successfully',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/success_animation_in_context',
      );
    });
  });
}

/// Build SuccessAnimation widget for testing
Widget _buildSuccessAnimation({double size = 120}) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: SizedBox(
      width: size,
      height: size,
      child: SuccessAnimation(
        staticFrame: const Duration(
          milliseconds: 300,
        ), // Freeze for golden tests
        onDone: () {}, // No-op for tests
      ),
    ),
  );
}
