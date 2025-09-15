/// Performance budget tests for Flutter widgets
///
/// Tests that critical screens and components meet performance budgets
/// to ensure smooth 60fps performance on target devices.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../_harness/perf_utils.dart';
import 'performance_scenarios.dart';

void main() {
  group('Performance Budget Tests', () {
    // Performance budget in milliseconds (16.67ms for 60fps, with CI buffer)
    const double performanceBudgetMs = 18.0;
    const int iterations = 30;

    group('Core Scenarios', () {
      testWidgets('SendAmountScreen should meet performance budget', (tester) async {
        final result = await measurePerformance(
          tester,
          PerformanceScenarios.sendAmountScreen,
          iterations: iterations,
        );

        print('\n=== SendAmountScreen Performance ===');
        print(result.generateReport(performanceBudgetMs));

        expect(
          result.meetsBudget(performanceBudgetMs),
          isTrue,
          reason: 'SendAmountScreen build time (${result.avgBuildTime.toStringAsFixed(2)}ms) exceeds budget (${performanceBudgetMs}ms)',
        );
      });

      testWidgets('SendReviewScreen should meet performance budget', (tester) async {
        final result = await measurePerformance(
          tester,
          PerformanceScenarios.sendReviewScreen,
          iterations: iterations,
        );

        print('\n=== SendReviewScreen Performance ===');
        print(result.generateReport(performanceBudgetMs));

        expect(
          result.meetsBudget(performanceBudgetMs),
          isTrue,
          reason: 'SendReviewScreen build time (${result.avgBuildTime.toStringAsFixed(2)}ms) exceeds budget (${performanceBudgetMs}ms)',
        );
      });

      testWidgets('WelcomeScreen should meet performance budget', (tester) async {
        final result = await measurePerformance(
          tester,
          PerformanceScenarios.welcomeScreen,
          iterations: iterations,
        );

        print('\n=== WelcomeScreen Performance ===');
        print(result.generateReport(performanceBudgetMs));

        expect(
          result.meetsBudget(performanceBudgetMs),
          isTrue,
          reason: 'WelcomeScreen build time (${result.avgBuildTime.toStringAsFixed(2)}ms) exceeds budget (${performanceBudgetMs}ms)',
        );
      });
    });

    group('Extended Scenarios', () {
      testWidgets('NetworkSelectionScreen should meet performance budget', (tester) async {
        final result = await measurePerformance(
          tester,
          PerformanceScenarios.networkSelectionScreen,
          iterations: iterations,
        );

        print('\n=== NetworkSelectionScreen Performance ===');
        print(result.generateReport(performanceBudgetMs));

        expect(
          result.meetsBudget(performanceBudgetMs),
          isTrue,
          reason: 'NetworkSelectionScreen build time (${result.avgBuildTime.toStringAsFixed(2)}ms) exceeds budget (${performanceBudgetMs}ms)',
        );
      });

      testWidgets('SkeletonLoading should meet performance budget', (tester) async {
        final result = await measurePerformance(
          tester,
          PerformanceScenarios.skeletonLoading,
          iterations: iterations,
        );

        print('\n=== SkeletonLoading Performance ===');
        print(result.generateReport(performanceBudgetMs));

        expect(
          result.meetsBudget(performanceBudgetMs),
          isTrue,
          reason: 'SkeletonLoading build time (${result.avgBuildTime.toStringAsFixed(2)}ms) exceeds budget (${performanceBudgetMs}ms)',
        );
      });
    });

    group('Stress Test Scenarios', () {
      testWidgets('ComplexForm should meet performance budget', (tester) async {
        final result = await measurePerformance(
          tester,
          PerformanceScenarios.complexForm,
          iterations: iterations,
        );

        print('\n=== ComplexForm Performance ===');
        print(result.generateReport(performanceBudgetMs));

        expect(
          result.meetsBudget(performanceBudgetMs),
          isTrue,
          reason: 'ComplexForm build time (${result.avgBuildTime.toStringAsFixed(2)}ms) exceeds budget (${performanceBudgetMs}ms)',
        );
      });

      testWidgets('LongList should meet performance budget', (tester) async {
        final result = await measurePerformance(
          tester,
          PerformanceScenarios.longList,
          iterations: iterations,
        );

        print('\n=== LongList Performance ===');
        print(result.generateReport(performanceBudgetMs));

        expect(
          result.meetsBudget(performanceBudgetMs),
          isTrue,
          reason: 'LongList build time (${result.avgBuildTime.toStringAsFixed(2)}ms) exceeds budget (${performanceBudgetMs}ms)',
        );
      });

      testWidgets('GridView should meet performance budget', (tester) async {
        final result = await measurePerformance(
          tester,
          PerformanceScenarios.gridView,
          iterations: iterations,
        );

        print('\n=== GridView Performance ===');
        print(result.generateReport(performanceBudgetMs));

        expect(
          result.meetsBudget(performanceBudgetMs),
          isTrue,
          reason: 'GridView build time (${result.avgBuildTime.toStringAsFixed(2)}ms) exceeds budget (${performanceBudgetMs}ms)',
        );
      });
    });

    group('Comprehensive Performance Test', () {
      testWidgets('All core scenarios should meet performance budget', (tester) async {
        final scenarios = PerformanceScenarios.getCoreScenarios();
        final results = <String, PerformanceResult>{};

        // Measure all core scenarios
        for (final entry in scenarios.entries) {
          final result = await measurePerformance(
            tester,
            entry.value,
            iterations: iterations,
          );
          results[entry.key] = result;
        }

        // Print comprehensive report
        print('\n=== Comprehensive Performance Report ===');
        print('Budget: ${performanceBudgetMs}ms');
        print('Iterations: $iterations');
        print('');

        bool allPassed = true;
        for (final entry in results.entries) {
          final scenario = entry.key;
          final result = entry.value;
          final passed = result.meetsBudget(performanceBudgetMs);
          final grade = result.getPerformanceGrade(performanceBudgetMs);

          print('$scenario: ${passed ? 'PASS' : 'FAIL'} (${result.avgBuildTime.toStringAsFixed(2)}ms) - Grade: $grade');

          if (!passed) {
            allPassed = false;
          }
        }

        print('\n=== Performance Summary ===');
        print('Overall Status: ${allPassed ? 'PASS' : 'FAIL'}');
        print('');

        if (!allPassed) {
          print('=== Optimization Recommendations ===');
          print('1. Reduce SparkleLayer quality to low/medium');
          print('2. Add RepaintBoundary around heavy widgets');
          print('3. Cache images with precacheImage()');
          print('4. Use const constructors where possible');
          print('5. Minimize setState calls');
          print('6. Consider lazy loading for large lists');
          print('7. Use ListView.builder for dynamic lists');
          print('8. Implement widget caching for expensive operations');
        }

        expect(allPassed, isTrue, reason: 'One or more core scenarios failed to meet performance budget');
      });
    });

    group('Performance Regression Tests', () {
      testWidgets('Performance should not regress over time', (tester) async {
        // This test can be used to detect performance regressions
        // by comparing current performance with baseline measurements
        
        final baselineResults = <String, double>{
          'sendAmountScreen': 12.5,
          'sendReviewScreen': 15.2,
          'welcomeScreen': 14.8,
        };

        final scenarios = PerformanceScenarios.getCoreScenarios();
        final regressions = <String>[];

        for (final entry in scenarios.entries) {
          final scenario = entry.key;
          final builder = entry.value;
          
          if (baselineResults.containsKey(scenario)) {
            final result = await measurePerformance(
              tester,
              builder,
              iterations: iterations,
            );
            
            final baseline = baselineResults[scenario]!;
            final regressionThreshold = baseline * 1.2; // 20% regression threshold
            
            if (result.avgBuildTime > regressionThreshold) {
              regressions.add('$scenario: ${result.avgBuildTime.toStringAsFixed(2)}ms (baseline: ${baseline.toStringAsFixed(2)}ms)');
            }
          }
        }

        if (regressions.isNotEmpty) {
          print('\n=== Performance Regressions Detected ===');
          for (final regression in regressions) {
            print('⚠️  $regression');
          }
          print('');
          print('Consider investigating these performance regressions.');
        }

        expect(regressions, isEmpty, reason: 'Performance regressions detected: ${regressions.join(', ')}');
      });
    });
  });
}