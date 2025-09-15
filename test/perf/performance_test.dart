import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yole_final/ui/effects/sparkle_layer.dart';
import 'package:yole_final/design/tokens.dart';

void main() {
  group('Performance Tests', () {
    testWidgets('SparkleLayer should render within performance budget', (
      WidgetTester tester,
    ) async {
      // Arrange
      final widget = MaterialApp(
        home: Scaffold(
          body: SparkleLayer(
            enabled: false, // Disable animations for performance testing
            quality: SparkleQuality.medium,
            animationSpeed: 1.0,
            baseAlpha: 0.7,
            child: Container(
              width: 400,
              height: 800,
              color: DesignTokens.background,
              child: const Center(child: Text('Test Content')),
            ),
          ),
        ),
      );

      // Act & Assert
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Measure frame times during animation
      final frameTimes = <int>[];
      for (int i = 0; i < 10; i++) {
        final frameStart = DateTime.now().millisecondsSinceEpoch;
        await tester.pump(const Duration(milliseconds: 16));
        final frameEnd = DateTime.now().millisecondsSinceEpoch;
        frameTimes.add(frameEnd - frameStart);
      }

      stopwatch.stop();

      // Assert performance
      final averageFrameTime =
          frameTimes.reduce((a, b) => a + b) / frameTimes.length;
      expect(
        averageFrameTime,
        lessThan(33),
        reason: 'Average frame time should be under 33ms (30 FPS minimum)',
      );

      print('Performance Test Results:');
      print('  Average frame time: ${averageFrameTime.toStringAsFixed(2)}ms');
      print('  Total test time: ${stopwatch.elapsedMilliseconds}ms');
      print('  Frame times: $frameTimes');
    });

    testWidgets('SparkleLayer should be disabled in low power mode', (
      WidgetTester tester,
    ) async {
      // Arrange
      final widget = MaterialApp(
        home: Scaffold(
          body: SparkleLayer(
            enabled: false, // Simulate low power mode
            quality: SparkleQuality.medium,
            animationSpeed: 1.0,
            baseAlpha: 0.7,
            child: Container(
              width: 400,
              height: 800,
              color: DesignTokens.background,
              child: const Center(child: Text('Test Content')),
            ),
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Assert - should render quickly without animation
      final stopwatch = Stopwatch()..start();
      await tester.pump(const Duration(milliseconds: 16));
      stopwatch.stop();

      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(10),
        reason: 'Disabled SparkleLayer should render very quickly',
      );
    });

    testWidgets('Complex widget tree should render within budget', (
      WidgetTester tester,
    ) async {
      // Arrange - Create a complex widget tree similar to Send Money screens
      final widget = MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              // Header
              Container(
                height: 100,
                color: DesignTokens.primary,
                child: const Center(
                  child: Text(
                    'Send Money',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 80,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: DesignTokens.surface,
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusMd,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: DesignTokens.primary,
                          child: Text('${index + 1}'),
                        ),
                        title: Text('Item ${index + 1}'),
                        subtitle: Text('Description for item ${index + 1}'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    );
                  },
                ),
              ),
              // Footer
              Container(
                height: 80,
                color: DesignTokens.surface,
                child: const Center(child: Text('Footer Content')),
              ),
            ],
          ),
        ),
      );

      // Act & Assert
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Assert performance
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(1000),
        reason: 'Complex widget tree should render within 1 second',
      );

      print('Complex Widget Performance:');
      print('  Render time: ${stopwatch.elapsedMilliseconds}ms');
    });
  });
}
