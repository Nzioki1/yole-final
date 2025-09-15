import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:yole_final/ui/components/loading_states.dart';
import '../_harness/golden_config.dart';

/// Golden tests for LoadingStates components
///
/// Tests various loading state scenarios including:
/// - List skeleton loader
/// - Tile skeleton loader
/// - Card skeleton loader
/// - Progress indicator with label
/// - Both light and dark theme variants
void main() {
  group('LoadingStates Golden Tests', () {
    setUpAll(GoldenTestBase.setUpAll);

    testGoldens('ListSkeleton - Default', (tester) async {
      final widget = _buildListSkeleton();

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/loading_states_list_skeleton',
      );
    });

    testGoldens('ListSkeleton - Custom Item Count', (tester) async {
      final widget = _buildListSkeleton(itemCount: 2);

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/loading_states_list_skeleton_2_items',
      );
    });

    testGoldens('TileSkeleton - Default', (tester) async {
      final widget = _buildTileSkeleton();

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/loading_states_tile_skeleton',
      );
    });

    testGoldens('TileSkeleton - With Subtitle', (tester) async {
      final widget = _buildTileSkeleton(showSubtitle: true);

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/loading_states_tile_skeleton_with_subtitle',
      );
    });

    testGoldens('CardSkeleton - Default', (tester) async {
      final widget = _buildCardSkeleton();

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/loading_states_card_skeleton',
      );
    });

    testGoldens('CardSkeleton - With Subtitle', (tester) async {
      final widget = _buildCardSkeleton(showSubtitle: true);

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/loading_states_card_skeleton_with_subtitle',
      );
    });

    testGoldens('ProgressIndicator - Default', (tester) async {
      final widget = _buildProgressIndicator();

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/loading_states_progress_indicator',
      );
    });

    testGoldens('ProgressIndicator - With Label', (tester) async {
      final widget = _buildProgressIndicator(label: 'Processing payment...');

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/loading_states_progress_indicator_with_label',
      );
    });

    testGoldens('All Loading States Comparison', (tester) async {
      final widget = SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'List Skeleton',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            _buildListSkeleton(itemCount: 2),
            const SizedBox(height: 16),
            const Text(
              'Tile Skeleton',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            _buildTileSkeleton(showSubtitle: true),
            const SizedBox(height: 16),
            const Text(
              'Card Skeleton',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            _buildCardSkeleton(showSubtitle: true),
            const SizedBox(height: 16),
            const Text(
              'Progress Indicator',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            _buildProgressIndicator(label: 'Loading...'),
          ],
        ),
      );

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'components/loading_states_all_comparison',
      );
    });
  });
}

/// Build ListSkeleton widget for testing
Widget _buildListSkeleton({int itemCount = 3}) {
  return Container(
    width: 300,
    padding: const EdgeInsets.all(16),
    child: LoadingStates.listSkeleton(),
  );
}

/// Build TileSkeleton widget for testing
Widget _buildTileSkeleton({bool showIcon = false, bool showSubtitle = false}) {
  return Container(
    width: 300,
    padding: const EdgeInsets.all(16),
    child: LoadingStates.tileSkeleton(),
  );
}

/// Build CardSkeleton widget for testing
Widget _buildCardSkeleton({bool showIcon = false, bool showSubtitle = false}) {
  return Container(
    width: 300,
    padding: const EdgeInsets.all(16),
    child: LoadingStates.cardSkeleton(),
  );
}

/// Build ProgressIndicator widget for testing
Widget _buildProgressIndicator({String? label}) {
  return Container(
    width: 300,
    padding: const EdgeInsets.all(16),
    child: LoadingStates.progress(label: label),
  );
}
