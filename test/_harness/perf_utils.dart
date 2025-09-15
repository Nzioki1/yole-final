/// Performance testing utilities for Flutter widgets
///
/// Provides utilities for measuring widget build times and performance
/// characteristics in a controlled test environment.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Measures the average build time for a widget over multiple iterations
///
/// This function pumps a widget multiple times and measures the build time
/// to get an accurate average performance measurement.
///
/// Parameters:
/// - [tester]: The WidgetTester instance for pumping widgets
/// - [builder]: The widget builder function to test
/// - [iterations]: Number of iterations to run (default: 30)
///
/// Returns:
/// - Average build time in milliseconds
Future<double> measureAvgBuildTime(
  WidgetTester tester,
  WidgetBuilder builder, {
  int iterations = 30,
}) async {
  final stopwatch = Stopwatch();
  double totalTime = 0.0;

  for (int i = 0; i < iterations; i++) {
    // Start timing
    stopwatch.start();
    
    // Pump the widget
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Builder(builder: builder),
        ),
      ),
    );
    
    // Settle one frame
    await tester.pump();
    
    // Stop timing
    stopwatch.stop();
    
    // Accumulate time in milliseconds
    totalTime += stopwatch.elapsedMicroseconds / 1000.0;
    
    // Reset for next iteration
    stopwatch.reset();
  }

  // Return average time in milliseconds
  return totalTime / iterations;
}

/// Measures frame timing for a widget over multiple iterations
///
/// This function provides more detailed frame timing information
/// including build, layout, and paint phases.
///
/// Parameters:
/// - [tester]: The WidgetTester instance for pumping widgets
/// - [builder]: The widget builder function to test
/// - [iterations]: Number of iterations to run (default: 30)
///
/// Returns:
/// - Map containing timing breakdown in milliseconds
Future<Map<String, double>> measureFrameTiming(
  WidgetTester tester,
  WidgetBuilder builder, {
  int iterations = 30,
}) async {
  final stopwatch = Stopwatch();
  double totalBuildTime = 0.0;
  double totalLayoutTime = 0.0;
  double totalPaintTime = 0.0;

  for (int i = 0; i < iterations; i++) {
    // Measure build time
    stopwatch.start();
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Builder(builder: builder),
        ),
      ),
    );
    stopwatch.stop();
    totalBuildTime += stopwatch.elapsedMicroseconds / 1000.0;
    stopwatch.reset();

    // Measure layout and paint time
    stopwatch.start();
    await tester.pump();
    stopwatch.stop();
    totalLayoutTime += stopwatch.elapsedMicroseconds / 1000.0;
    stopwatch.reset();
  }

  return {
    'build': totalBuildTime / iterations,
    'layout': totalLayoutTime / iterations,
    'total': (totalBuildTime + totalLayoutTime) / iterations,
  };
}

/// Measures memory usage for a widget
///
/// This function provides basic memory usage estimation
/// by measuring the widget tree size and complexity.
///
/// Parameters:
/// - [tester]: The WidgetTester instance for pumping widgets
/// - [builder]: The widget builder function to test
///
/// Returns:
/// - Estimated memory usage metrics
Future<Map<String, int>> measureMemoryUsage(
  WidgetTester tester,
  WidgetBuilder builder,
) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Builder(builder: builder),
      ),
    ),
  );

  // Get the widget tree
  final element = tester.element(find.byType(MaterialApp));
  
  // Count widgets recursively
  int widgetCount = 0;
  int renderObjectCount = 0;
  
  void countElements(Element element) {
    widgetCount++;
    if (element.renderObject != null) {
      renderObjectCount++;
    }
    element.visitChildren(countElements);
  }
  
  countElements(element);

  return {
    'widgets': widgetCount,
    'renderObjects': renderObjectCount,
    'estimatedMemoryKB': widgetCount * 2, // Rough estimate: 2KB per widget
  };
}

/// Performance measurement result
class PerformanceResult {
  final double avgBuildTime;
  final Map<String, double>? frameTiming;
  final Map<String, int>? memoryUsage;
  final int iterations;
  final DateTime timestamp;

  const PerformanceResult({
    required this.avgBuildTime,
    this.frameTiming,
    this.memoryUsage,
    required this.iterations,
    required this.timestamp,
  });

  /// Whether the performance meets the budget
  bool meetsBudget(double budgetMs) => avgBuildTime <= budgetMs;

  /// Performance grade based on budget
  String getPerformanceGrade(double budgetMs) {
    if (avgBuildTime <= budgetMs * 0.8) return 'A+';
    if (avgBuildTime <= budgetMs * 0.9) return 'A';
    if (avgBuildTime <= budgetMs) return 'B';
    if (avgBuildTime <= budgetMs * 1.2) return 'C';
    return 'D';
  }

  /// Generate performance report
  String generateReport(double budgetMs) {
    final grade = getPerformanceGrade(budgetMs);
    final meets = meetsBudget(budgetMs) ? 'PASS' : 'FAIL';
    
    final buffer = StringBuffer();
    buffer.writeln('Performance Report:');
    buffer.writeln('==================');
    buffer.writeln('Status: $meets');
    buffer.writeln('Grade: $grade');
    buffer.writeln('Build Time: ${avgBuildTime.toStringAsFixed(2)}ms');
    buffer.writeln('Budget: ${budgetMs}ms');
    buffer.writeln('Iterations: $iterations');
    buffer.writeln('Timestamp: $timestamp');
    
    if (frameTiming != null) {
      buffer.writeln('\nFrame Timing:');
      frameTiming!.forEach((phase, time) {
        buffer.writeln('  $phase: ${time.toStringAsFixed(2)}ms');
      });
    }
    
    if (memoryUsage != null) {
      buffer.writeln('\nMemory Usage:');
      memoryUsage!.forEach((metric, value) {
        buffer.writeln('  $metric: $value');
      });
    }
    
    if (!meetsBudget(budgetMs)) {
      buffer.writeln('\nOptimization Suggestions:');
      buffer.writeln('- Reduce SparkleLayer quality (low/medium)');
      buffer.writeln('- Add RepaintBoundary around heavy widgets');
      buffer.writeln('- Cache images with precacheImage()');
      buffer.writeln('- Use const constructors where possible');
      buffer.writeln('- Minimize setState calls');
    }
    
    return buffer.toString();
  }
}

/// Comprehensive performance measurement
///
/// Measures build time, frame timing, and memory usage for a widget
/// and returns a detailed performance result.
///
/// Parameters:
/// - [tester]: The WidgetTester instance for pumping widgets
/// - [builder]: The widget builder function to test
/// - [iterations]: Number of iterations to run (default: 30)
/// - [includeFrameTiming]: Whether to include detailed frame timing
/// - [includeMemoryUsage]: Whether to include memory usage metrics
///
/// Returns:
/// - Comprehensive performance result
Future<PerformanceResult> measurePerformance(
  WidgetTester tester,
  WidgetBuilder builder, {
  int iterations = 30,
  bool includeFrameTiming = false,
  bool includeMemoryUsage = false,
}) async {
  final timestamp = DateTime.now();
  
  // Measure average build time
  final avgBuildTime = await measureAvgBuildTime(tester, builder, iterations: iterations);
  
  // Optional detailed measurements
  Map<String, double>? frameTiming;
  if (includeFrameTiming) {
    frameTiming = await measureFrameTiming(tester, builder, iterations: iterations);
  }
  
  Map<String, int>? memoryUsage;
  if (includeMemoryUsage) {
    memoryUsage = await measureMemoryUsage(tester, builder);
  }
  
  return PerformanceResult(
    avgBuildTime: avgBuildTime,
    frameTiming: frameTiming,
    memoryUsage: memoryUsage,
    iterations: iterations,
    timestamp: timestamp,
  );
}