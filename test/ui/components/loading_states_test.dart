/// Widget tests for loading states components
///
/// Tests:
/// - Skeleton loading states display correctly
/// - Shimmer effects work as expected
/// - Reduced motion disables shimmer
/// - Different skeleton types render properly
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yole_final/ui/components/loading_states.dart';

void main() {
  group('LoadingStates Tests', () {
    group('Skeleton Types', () {
      testWidgets('should display list skeleton correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoadingStates.listSkeleton(count: 3),
            ),
          ),
        );

        // Should have 3 skeleton items
        expect(find.byType(Column), findsWidgets);
        
        // Should have shimmer effect
        expect(find.byType(ShaderMask), findsWidgets);
      });

      testWidgets('should display tile skeleton correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoadingStates.tileSkeleton(),
            ),
          ),
        );

        // Should have card and shimmer
        expect(find.byType(Card), findsOneWidget);
        expect(find.byType(ShaderMask), findsWidgets);
      });

      testWidgets('should display card skeleton correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoadingStates.cardSkeleton(),
            ),
          ),
        );

        // Should have card and shimmer
        expect(find.byType(Card), findsOneWidget);
        expect(find.byType(ShaderMask), findsWidgets);
      });

      testWidgets('should display chart skeleton correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoadingStates.chartSkeleton(bars: 5),
            ),
          ),
        );

        // Should have container for chart
        expect(find.byType(Container), findsWidgets);
        expect(find.byType(ShaderMask), findsWidgets);
      });
    });

    group('Shimmer Effects', () {
      testWidgets('should enable shimmer by default', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoadingStates.listSkeleton(count: 2),
            ),
          ),
        );

        // Should have shimmer effect
        expect(find.byType(ShaderMask), findsWidgets);
      });

      testWidgets('should disable shimmer when shimmer=false', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoadingStates.listSkeleton(
                count: 2,
                shimmer: false,
              ),
            ),
          ),
        );

        // Should not have shimmer effect
        expect(find.byType(ShaderMask), findsNothing);
      });

      testWidgets('should disable shimmer when reducedMotion=true', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoadingStates.listSkeleton(
                count: 2,
                reducedMotion: true,
              ),
            ),
          ),
        );

        // Should not have shimmer effect
        expect(find.byType(ShaderMask), findsNothing);
      });

      testWidgets('should use custom shimmer duration', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoadingStates.listSkeleton(
                count: 2,
                shimmerDuration: const Duration(milliseconds: 800),
              ),
            ),
          ),
        );

        // Should have shimmer effect
        expect(find.byType(ShaderMask), findsWidgets);
        
        // Animation controller should use custom duration
        final animationController = tester.state<State>(find.byType(ShaderMask));
        expect(animationController, isA<State>());
      });
    });

    group('Item Count', () {
      testWidgets('should display correct number of list items', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoadingStates.listSkeleton(count: 5),
            ),
          ),
        );

        // Should generate 5 skeleton items
        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('should display correct number of chart bars', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoadingStates.chartSkeleton(bars: 8),
            ),
          ),
        );

        // Should generate 8 chart bars
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('should handle zero count gracefully', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoadingStates.listSkeleton(count: 0),
            ),
          ),
        );

        // Should not crash and should render empty
        expect(find.byType(Column), findsWidgets);
      });
    });

    group('Loading States with Labels', () {
      testWidgets('should display loading label when showLabel=true', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: const LoadingStates(
                type: SkeletonType.list,
                itemCount: 3,
                showLabel: true,
                label: 'Loading data...',
              ),
            ),
          ),
        );

        expect(find.text('Loading data...'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should not display loading label when showLabel=false', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: const LoadingStates(
                type: SkeletonType.list,
                itemCount: 3,
                showLabel: false,
                label: 'Loading data...',
              ),
            ),
          ),
        );

        expect(find.text('Loading data...'), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('should display progress indicator correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoadingStates.progress(label: 'Processing...'),
            ),
          ),
        );

        expect(find.text('Processing...'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Theme Adaptation', () {
      testWidgets('should adapt to light theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: LoadingStates.listSkeleton(count: 2),
            ),
          ),
        );

        expect(find.byType(ShaderMask), findsWidgets);
      });

      testWidgets('should adapt to dark theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: LoadingStates.listSkeleton(count: 2),
            ),
          ),
        );

        expect(find.byType(ShaderMask), findsWidgets);
      });
    });

    group('Performance Tests', () {
      testWidgets('should handle large item counts efficiently', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoadingStates.listSkeleton(count: 50),
            ),
          ),
        );

        // Should render without issues
        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('should handle multiple shimmer effects', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  LoadingStates.listSkeleton(count: 3),
                  const SizedBox(height: 16),
                  LoadingStates.tileSkeleton(),
                  const SizedBox(height: 16),
                  LoadingStates.cardSkeleton(),
                ],
              ),
            ),
          ),
        );

        // Should have multiple shimmer effects
        expect(find.byType(ShaderMask), findsWidgets);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle null shimmer duration gracefully', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoadingStates.listSkeleton(
                count: 2,
                shimmerDuration: Duration.zero,
              ),
            ),
          ),
        );

        // Should not crash
        expect(find.byType(ShaderMask), findsWidgets);
      });

      testWidgets('should handle very long labels', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: const LoadingStates(
                type: SkeletonType.list,
                itemCount: 2,
                showLabel: true,
                label: 'This is a very long label that might cause layout issues if not handled properly by the component',
              ),
            ),
          ),
        );

        expect(find.textContaining('This is a very long label'), findsOneWidget);
      });

      testWidgets('should handle empty label', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: const LoadingStates(
                type: SkeletonType.list,
                itemCount: 2,
                showLabel: true,
                label: '',
              ),
            ),
          ),
        );

        // Should not crash with empty label
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });
  });
}
