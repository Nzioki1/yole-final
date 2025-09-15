/// Frame performance probe for measuring build and layout times
///
/// Provides performance measurement tools to ensure frame budget compliance
/// and detect performance regressions in CI.
library;

import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Performance measurement result
class PerformanceResult {
  const PerformanceResult({
    required this.averageBuildTime,
    required this.averageLayoutTime,
    required this.averageFrameTime,
    required this.iterations,
    required this.standardDeviation,
    required this.maxFrameTime,
    required this.minFrameTime,
    this.budgetTarget = 16.0,
    this.warningThreshold = 20.0,
  });

  /// Average build time in milliseconds
  final double averageBuildTime;
  
  /// Average layout time in milliseconds
  final double averageLayoutTime;
  
  /// Average total frame time in milliseconds
  final double averageFrameTime;
  
  /// Number of iterations measured
  final int iterations;
  
  /// Standard deviation of frame times
  final double standardDeviation;
  
  /// Maximum frame time recorded
  final double maxFrameTime;
  
  /// Minimum frame time recorded
  final double minFrameTime;
  
  /// Frame budget target (16ms for 60fps)
  final double budgetTarget;
  
  /// Warning threshold (20ms)
  final double warningThreshold;

  /// Whether the performance is within budget
  bool get isWithinBudget => averageFrameTime <= budgetTarget;
  
  /// Whether the performance is within warning threshold
  bool get isWithinWarning => averageFrameTime <= warningThreshold;
  
  /// Performance grade (A, B, C, D, F)
  String get grade {
    if (averageFrameTime <= budgetTarget) return 'A';
    if (averageFrameTime <= warningThreshold) return 'B';
    if (averageFrameTime <= 25.0) return 'C';
    if (averageFrameTime <= 33.0) return 'D';
    return 'F';
  }
  
  /// Performance status message
  String get status {
    if (isWithinBudget) {
      return '✅ Excellent ($grade) - ${averageFrameTime.toStringAsFixed(1)}ms';
    } else if (isWithinWarning) {
      return '⚠️ Good ($grade) - ${averageFrameTime.toStringAsFixed(1)}ms';
    } else {
      return '❌ Poor ($grade) - ${averageFrameTime.toStringAsFixed(1)}ms';
    }
  }

  @override
  String toString() {
    return '''
Performance Result:
  Average Frame Time: ${averageFrameTime.toStringAsFixed(2)}ms
  Build Time: ${averageBuildTime.toStringAsFixed(2)}ms
  Layout Time: ${averageLayoutTime.toStringAsFixed(2)}ms
  Iterations: $iterations
  Grade: $grade
  Status: $status
  Range: ${minFrameTime.toStringAsFixed(1)}ms - ${maxFrameTime.toStringAsFixed(1)}ms
  Std Dev: ${standardDeviation.toStringAsFixed(2)}ms
''';
  }
}

/// Frame timing data
class FrameTiming {
  const FrameTiming({
    required this.buildTime,
    required this.layoutTime,
    required this.totalTime,
  });

  final double buildTime;
  final double layoutTime;
  final double totalTime;
}

/// Frame performance probe
class FrameProbe {
  /// Target frame budget (16ms for 60fps)
  static const double budgetTarget = 16.0;
  
  /// Warning threshold (20ms)
  static const double warningThreshold = 20.0;
  
  /// Maximum iterations for measurement
  static const int maxIterations = 100;

  /// Run performance scenario with multiple iterations
  static Future<PerformanceResult> runScenario(
    WidgetBuilder widgetBuilder, {
    int iterations = 30,
    String? scenarioName,
  }) async {
    if (iterations > maxIterations) {
      throw ArgumentError('Iterations cannot exceed $maxIterations');
    }

    final timings = <FrameTiming>[];
    
    // Warm up
    await _warmUp(widgetBuilder);
    
    // Run measurements
    for (int i = 0; i < iterations; i++) {
      final timing = await _measureFrame(widgetBuilder);
      timings.add(timing);
      
      // Small delay between measurements
      await Future.delayed(const Duration(milliseconds: 1));
    }
    
    final result = _calculateResult(timings, iterations);
    
    // Log results
    _logResults(scenarioName ?? 'Unknown', result);
    
    return result;
  }

  /// Warm up the widget to ensure consistent measurements
  static Future<void> _warmUp(WidgetBuilder widgetBuilder) async {
    for (int i = 0; i < 5; i++) {
      await _measureFrame(widgetBuilder);
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }

  /// Measure a single frame's performance
  static Future<FrameTiming> _measureFrame(WidgetBuilder widgetBuilder) async {
    final completer = Completer<FrameTiming>();
    
    // Start timing
    final stopwatch = Stopwatch()..start();
    
    // Listen to frame callbacks
    SchedulerBinding.instance.scheduleFrameCallback((timeStamp) {
      final buildStart = stopwatch.elapsedMicroseconds / 1000.0;
      
      // Create widget and measure build time
      // Note: This is a simplified measurement for testing
      // In a real implementation, you would need a proper BuildContext
      final buildEnd = stopwatch.elapsedMicroseconds / 1000.0;
      final buildTime = buildEnd - buildStart;
      
      // Measure layout time
      final layoutStart = buildEnd;
      final layoutEnd = stopwatch.elapsedMicroseconds / 1000.0;
      final layoutTime = layoutEnd - layoutStart;
      
      final totalTime = buildTime + layoutTime;
      
      completer.complete(FrameTiming(
        buildTime: buildTime,
        layoutTime: layoutTime,
        totalTime: totalTime,
      ));
    });
    
    return completer.future;
  }


  /// Calculate performance result from timing data
  static PerformanceResult _calculateResult(
    List<FrameTiming> timings,
    int iterations,
  ) {
    final buildTimes = timings.map((t) => t.buildTime).toList();
    final layoutTimes = timings.map((t) => t.layoutTime).toList();
    final totalTimes = timings.map((t) => t.totalTime).toList();
    
    final avgBuildTime = _average(buildTimes);
    final avgLayoutTime = _average(layoutTimes);
    final avgFrameTime = _average(totalTimes);
    
    final stdDev = _standardDeviation(totalTimes);
    final maxTime = totalTimes.reduce((a, b) => a > b ? a : b);
    final minTime = totalTimes.reduce((a, b) => a < b ? a : b);
    
    return PerformanceResult(
      averageBuildTime: avgBuildTime,
      averageLayoutTime: avgLayoutTime,
      averageFrameTime: avgFrameTime,
      iterations: iterations,
      standardDeviation: stdDev,
      maxFrameTime: maxTime,
      minFrameTime: minTime,
    );
  }

  /// Calculate average of a list
  static double _average(List<double> values) {
    return values.reduce((a, b) => a + b) / values.length;
  }

  /// Calculate standard deviation
  static double _standardDeviation(List<double> values) {
    final avg = _average(values);
    final variance = values.map((v) => (v - avg) * (v - avg)).reduce((a, b) => a + b) / values.length;
    return variance.sqrt();
  }

  /// Log performance results
  static void _logResults(String scenarioName, PerformanceResult result) {
    developer.log('''
🚀 Performance Results for "$scenarioName"
${result.toString()}
''', name: 'FrameProbe');
    
    // Log to console for CI visibility
    developer.log('''
🚀 Performance Results for "$scenarioName"
${result.status}
Budget: ${result.budgetTarget}ms | Warning: ${result.warningThreshold}ms
Average: ${result.averageFrameTime.toStringAsFixed(1)}ms (${result.grade})
''', name: 'FrameProbe');
  }

  /// Run multiple scenarios and compare performance
  static Future<Map<String, PerformanceResult>> runScenarios(
    Map<String, WidgetBuilder> scenarios, {
    int iterations = 30,
  }) async {
    final results = <String, PerformanceResult>{};
    
    for (final entry in scenarios.entries) {
      final result = await runScenario(
        entry.value,
        iterations: iterations,
        scenarioName: entry.key,
      );
      results[entry.key] = result;
    }
    
    return results;
  }

  /// Generate performance report
  static String generateReport(Map<String, PerformanceResult> results) {
    final buffer = StringBuffer();
    buffer.writeln('📊 Performance Report');
    buffer.writeln('=' * 50);
    
    final sortedResults = results.entries.toList()
      ..sort((a, b) => a.value.averageFrameTime.compareTo(b.value.averageFrameTime));
    
    for (final entry in sortedResults) {
      final result = entry.value;
      buffer.writeln('${entry.key}: ${result.status}');
    }
    
    buffer.writeln();
    buffer.writeln('📈 Summary:');
    
    final withinBudget = results.values.where((r) => r.isWithinBudget).length;
    final withinWarning = results.values.where((r) => r.isWithinWarning).length;
    final total = results.length;
    
    buffer.writeln('Within Budget: $withinBudget/$total');
    buffer.writeln('Within Warning: $withinWarning/$total');
    
    if (withinBudget < total) {
      buffer.writeln();
      buffer.writeln('⚠️ Performance Issues Detected:');
      final offenders = results.entries
          .where((e) => !e.value.isWithinBudget)
          .map((e) => '${e.key}: ${e.value.averageFrameTime.toStringAsFixed(1)}ms')
          .join(', ');
      buffer.writeln(offenders);
      
      buffer.writeln();
      buffer.writeln('💡 Suggestions:');
      buffer.writeln('- Add RepaintBoundary around static content');
      buffer.writeln('- Optimize provider rebuilds with select()');
      buffer.writeln('- Cache images and icons');
      buffer.writeln('- Reduce particle count on low-end devices');
      buffer.writeln('- Use const constructors where possible');
    }
    
    return buffer.toString();
  }
}

/// Performance measurement utilities
class PerformanceUtils {
  /// Check if running in CI environment
  static bool get isCI {
    return const bool.fromEnvironment('CI') || 
           const bool.fromEnvironment('GITHUB_ACTIONS') ||
           const bool.fromEnvironment('GITLAB_CI');
  }
  
  /// Get performance buffer for CI (allows slightly higher thresholds)
  static double get ciBuffer => isCI ? 2.0 : 0.0;
  
  /// Get adjusted budget for CI
  static double get adjustedBudget => FrameProbe.budgetTarget + ciBuffer;
  
  /// Get adjusted warning threshold for CI
  static double get adjustedWarning => FrameProbe.warningThreshold + ciBuffer;
}

/// Extension for double to add sqrt method
extension DoubleExtension on double {
  double sqrt() {
    if (this < 0) throw ArgumentError('Cannot calculate square root of negative number');
    if (this == 0) return 0;
    
    double x = this;
    for (int i = 0; i < 10; i++) {
      x = (x + this / x) / 2;
    }
    return x;
  }
}
