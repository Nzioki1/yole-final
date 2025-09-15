/// Golden tests for skeleton loading components
///
/// Tests the visual appearance of:
/// - List skeleton with different counts and heights
/// - Tile skeleton with various configurations
/// - Card skeleton layouts
/// - Chart skeleton with different bar counts
/// - Shimmer effects (enabled/disabled)
/// - Light and dark themes
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:yole_final/ui/components/loading_states.dart';

void main() {
  group('Skeleton Loading Golden Tests', () {
    group('List Skeleton Tests', () {
      testGoldens('ListSkeleton - Default (6 items)', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.listSkeleton(
            count: 6,
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        // Use finite pumps instead of pumpAndSettle for deterministic tests
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'list_skeleton_default');
      });

      testGoldens('ListSkeleton - 3 items', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.listSkeleton(
            count: 3,
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 400),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'list_skeleton_3_items');
      });

      testGoldens('ListSkeleton - 10 items', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.listSkeleton(
            count: 10,
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 800),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'list_skeleton_10_items');
      });

      testGoldens('ListSkeleton - Dark Theme', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.listSkeleton(
            count: 6,
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _darkWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'list_skeleton_dark');
      });

      testGoldens('ListSkeleton - No Shimmer', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.listSkeleton(
            count: 6,
            shimmer: false,
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'list_skeleton_no_shimmer');
      });

      testGoldens('ListSkeleton - Reduced Motion', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.listSkeleton(
            count: 6,
            reducedMotion: true,
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'list_skeleton_reduced_motion');
      });
    });

    group('Tile Skeleton Tests', () {
      testGoldens('TileSkeleton - Default', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.tileSkeleton(
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 200),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'tile_skeleton_default');
      });

      testGoldens('TileSkeleton - Dark Theme', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.tileSkeleton(
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _darkWrapper(child),
          surfaceSize: const Size(400, 200),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'tile_skeleton_dark');
      });

      testGoldens('TileSkeleton - No Shimmer', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.tileSkeleton(
            shimmer: false,
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 200),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'tile_skeleton_no_shimmer');
      });
    });

    group('Card Skeleton Tests', () {
      testGoldens('CardSkeleton - Default', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.cardSkeleton(
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 300),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'card_skeleton_default');
      });

      testGoldens('CardSkeleton - Dark Theme', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.cardSkeleton(
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _darkWrapper(child),
          surfaceSize: const Size(400, 300),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'card_skeleton_dark');
      });

      testGoldens('CardSkeleton - No Shimmer', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.cardSkeleton(
            shimmer: false,
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 300),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'card_skeleton_no_shimmer');
      });
    });

    group('Chart Skeleton Tests', () {
      testGoldens('ChartSkeleton - 5 bars', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.chartSkeleton(
            bars: 5,
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 300),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'chart_skeleton_5_bars');
      });

      testGoldens('ChartSkeleton - 8 bars', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.chartSkeleton(
            bars: 8,
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 300),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'chart_skeleton_8_bars');
      });

      testGoldens('ChartSkeleton - Dark Theme', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.chartSkeleton(
            bars: 5,
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _darkWrapper(child),
          surfaceSize: const Size(400, 300),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'chart_skeleton_dark');
      });

      testGoldens('ChartSkeleton - No Shimmer', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.chartSkeleton(
            bars: 5,
            shimmer: false,
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 300),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'chart_skeleton_no_shimmer');
      });
    });

    group('Shimmer Effect Tests', () {
      testGoldens('Shimmer - Fast Duration', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.listSkeleton(
            count: 3,
            shimmerDuration: const Duration(milliseconds: 600),
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 300),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'shimmer_fast_duration');
      });

      testGoldens('Shimmer - Slow Duration', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.listSkeleton(
            count: 3,
            shimmerDuration: const Duration(milliseconds: 2000),
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 300),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'shimmer_slow_duration');
      });

      testGoldens('Shimmer - Different Types', (tester) async {
        await tester.pumpWidgetBuilder(
          Column(
            children: [
              LoadingStates.listSkeleton(
                count: 2,
                animate: false, // Static for golden test
              ),
              const SizedBox(height: 16),
              LoadingStates.tileSkeleton(
                animate: false, // Static for golden test
              ),
              const SizedBox(height: 16),
              LoadingStates.cardSkeleton(
                animate: false, // Static for golden test
              ),
            ],
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 600),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'shimmer_different_types');
      });
    });

    group('Loading States Tests', () {
      testGoldens('LoadingStates - With Label', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates(
            type: SkeletonType.list,
            itemCount: 3,
            showLabel: true,
            label: 'Loading transactions...',
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 400),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'loading_states_with_label');
      });

      testGoldens('LoadingStates - Progress Indicator', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.progress(
            label: 'Processing...',
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 200),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'loading_states_progress');
      });
    });

    group('Edge Cases', () {
      testGoldens('Skeleton - Empty Count', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.listSkeleton(
            count: 0,
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 200),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'skeleton_empty_count');
      });

      testGoldens('Skeleton - Large Count', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.listSkeleton(
            count: 20,
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 1000),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'skeleton_large_count');
      });

      testGoldens('Skeleton - Custom Shimmer Duration', (tester) async {
        await tester.pumpWidgetBuilder(
          LoadingStates.listSkeleton(
            count: 4,
            shimmerDuration: const Duration(milliseconds: 1500),
            animate: false, // Static for golden test
          ),
          wrapper: (child) => _lightWrapper(child),
          surfaceSize: const Size(400, 400),
        );

        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        await screenMatchesGolden(tester, 'skeleton_custom_shimmer_duration');
      });
    });
  });
}

/// Light theme wrapper for golden tests
Widget _lightWrapper(Widget child) {
  return MaterialApp(
    theme: ThemeData.light(),
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

/// Dark theme wrapper for golden tests
Widget _darkWrapper(Widget child) {
  return MaterialApp(
    theme: ThemeData.dark(),
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}