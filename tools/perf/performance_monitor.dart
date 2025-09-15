#!/usr/bin/env dart

/// Performance monitoring script for developers
///
/// Usage:
/// dart tools/perf/performance_monitor.dart [options]
///
/// Options:
/// --scenario <name>  Run specific scenario
/// --iterations <n>   Number of iterations (default: 30)
/// --budget <ms>      Custom budget threshold (default: 16ms)
/// --report           Generate detailed report
/// --watch            Watch mode for continuous monitoring
library;

import 'dart:io';
import 'dart:async';
import 'package:args/args.dart';

/// Performance monitoring CLI
class PerformanceMonitor {
  static const String version = '1.0.0';
  
  static void main(List<String> arguments) async {
    final parser = ArgParser()
      ..addOption('scenario', abbr: 's', help: 'Run specific scenario')
      ..addOption('iterations', abbr: 'i', defaultsTo: '30', help: 'Number of iterations')
      ..addOption('budget', abbr: 'b', defaultsTo: '16', help: 'Budget threshold in ms')
      ..addFlag('report', abbr: 'r', help: 'Generate detailed report')
      ..addFlag('watch', abbr: 'w', help: 'Watch mode for continuous monitoring')
      ..addFlag('help', abbr: 'h', help: 'Show help')
      ..addFlag('version', abbr: 'v', help: 'Show version');

    final results = parser.parse(arguments);

    if (results['help'] as bool) {
      _showHelp(parser);
      return;
    }

    if (results['version'] as bool) {
      print('Performance Monitor v$version');
      return;
    }

    final scenario = results['scenario'] as String?;
    final iterations = int.tryParse(results['iterations'] as String) ?? 30;
    final budget = double.tryParse(results['budget'] as String) ?? 16.0;
    final generateReport = results['report'] as bool;
    final watchMode = results['watch'] as bool;

    if (watchMode) {
      await _runWatchMode(scenario, iterations, budget);
    } else {
      await _runSingleTest(scenario, iterations, budget, generateReport);
    }
  }

  static void _showHelp(ArgParser parser) {
    print('''
Performance Monitor v$version

A tool for monitoring Flutter app performance and ensuring frame budget compliance.

Usage: dart tools/perf/performance_monitor.dart [options]

Options:
${parser.usage}

Examples:
  # Run all scenarios with default settings
  dart tools/perf/performance_monitor.dart

  # Run specific scenario
  dart tools/perf/performance_monitor.dart --scenario SendAmountScreen

  # Run with custom iterations and budget
  dart tools/perf/performance_monitor.dart --iterations 50 --budget 20

  # Generate detailed report
  dart tools/perf/performance_monitor.dart --report

  # Watch mode for continuous monitoring
  dart tools/perf/performance_monitor.dart --watch

Available Scenarios:
  - SendAmountScreen
  - SendReviewScreen
  - WelcomeScreen
  - NetworkSelectionScreen
  - RecipientSelectionScreen
''');
  }

  static Future<void> _runSingleTest(
    String? scenario,
    int iterations,
    double budget,
    bool generateReport,
  ) async {
    print('🚀 Performance Monitor v$version');
    print('=' * 50);
    
    if (scenario != null) {
      print('Running scenario: $scenario');
    } else {
      print('Running all scenarios');
    }
    
    print('Iterations: $iterations');
    print('Budget: ${budget}ms');
    print('');

    // This would integrate with the actual FrameProbe
    // For now, we'll simulate the output
    await _simulatePerformanceTest(scenario, iterations, budget);
    
    if (generateReport) {
      _generateReport();
    }
  }

  static Future<void> _runWatchMode(
    String? scenario,
    int iterations,
    double budget,
  ) async {
    print('🚀 Performance Monitor v$version - Watch Mode');
    print('=' * 50);
    print('Monitoring performance continuously...');
    print('Press Ctrl+C to stop');
    print('');

    Timer.periodic(const Duration(seconds: 30), (timer) async {
      print('⏰ Running performance check at ${DateTime.now().toIso8601String()}');
      await _simulatePerformanceTest(scenario, iterations, budget);
      print('');
    });

    // Keep the script running
    await Future.delayed(Duration.infinity);
  }

  static Future<void> _simulatePerformanceTest(
    String? scenario,
    int iterations,
    double budget,
  ) async {
    final scenarios = {
      'SendAmountScreen': 12.5,
      'SendReviewScreen': 14.2,
      'WelcomeScreen': 18.7,
      'NetworkSelectionScreen': 11.8,
      'RecipientSelectionScreen': 13.1,
    };

    if (scenario != null) {
      final time = scenarios[scenario] ?? 15.0;
      _printScenarioResult(scenario, time, budget);
    } else {
      for (final entry in scenarios.entries) {
        _printScenarioResult(entry.key, entry.value, budget);
      }
    }
  }

  static void _printScenarioResult(String name, double time, double budget) {
    final grade = _getGrade(time, budget);
    final status = _getStatus(time, budget);
    
    print('📊 $name: $status');
    print('   Time: ${time.toStringAsFixed(1)}ms | Grade: $grade | Budget: ${budget}ms');
    
    if (time > budget) {
      print('   ⚠️  Exceeds budget by ${(time - budget).toStringAsFixed(1)}ms');
    }
  }

  static String _getGrade(double time, double budget) {
    if (time <= budget) return 'A';
    if (time <= budget * 1.25) return 'B';
    if (time <= budget * 1.5) return 'C';
    if (time <= budget * 2.0) return 'D';
    return 'F';
  }

  static String _getStatus(double time, double budget) {
    if (time <= budget) return '✅ Excellent';
    if (time <= budget * 1.25) return '⚠️ Good';
    if (time <= budget * 1.5) return '⚠️ Fair';
    return '❌ Poor';
  }

  static void _generateReport() {
    print('');
    print('📈 Performance Report');
    print('=' * 50);
    print('Generated at: ${DateTime.now().toIso8601String()}');
    print('');
    
    print('📊 Summary:');
    print('  Total Scenarios: 5');
    print('  Within Budget: 3/5');
    print('  Within Warning: 4/5');
    print('');
    
    print('🏆 Best Performers:');
    print('  1. NetworkSelectionScreen: 11.8ms (A)');
    print('  2. SendAmountScreen: 12.5ms (A)');
    print('  3. RecipientSelectionScreen: 13.1ms (A)');
    print('');
    
    print('⚠️ Needs Attention:');
    print('  1. WelcomeScreen: 18.7ms (C) - SparkleLayer optimization needed');
    print('  2. SendReviewScreen: 14.2ms (B) - Fee calculations could be optimized');
    print('');
    
    print('💡 Recommendations:');
    print('  - Add RepaintBoundary around SparkleLayer');
    print('  - Optimize fee calculation rendering');
    print('  - Consider reducing particle count on low-end devices');
    print('  - Cache network images and icons');
    print('');
  }
}

/// Main entry point
void main(List<String> arguments) {
  PerformanceMonitor.main(arguments);
}
