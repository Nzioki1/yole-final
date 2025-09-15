import 'package:flutter_test/flutter_test.dart';
import 'package:yole_final/core/crash/crash.dart';

void main() {
  group('Crash Reporting Tests', () {
    late FakeCrashReporter fakeCrashReporter;

    setUp(() {
      fakeCrashReporter = FakeCrashReporter();
    });

    tearDown(() {
      fakeCrashReporter.clear();
    });

    test('should record errors without network calls', () async {
      // Arrange
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;

      // Act
      await fakeCrashReporter.recordError(
        error,
        stackTrace,
        context: 'test_context',
      );

      // Assert
      expect(fakeCrashReporter.reports.length, 1);
      expect(fakeCrashReporter.reports.first.error, error);
      expect(fakeCrashReporter.reports.first.stackTrace, stackTrace);
      expect(fakeCrashReporter.reports.first.context, 'test_context');
      expect(fakeCrashReporter.reports.first.fatal, false);
    });

    test('should record fatal errors', () async {
      // Arrange
      final error = Exception('Fatal error');

      // Act
      await fakeCrashReporter.recordError(error, null, fatal: true);

      // Assert
      expect(fakeCrashReporter.reports.length, 1);
      expect(fakeCrashReporter.reports.first.error, error);
      expect(fakeCrashReporter.reports.first.fatal, true);
    });

    test('should record custom error messages', () async {
      // Act
      await fakeCrashReporter.recordMessage(
        'Custom error message',
        context: 'test_context',
      );

      // Assert
      expect(fakeCrashReporter.reports.length, 1);
      expect(fakeCrashReporter.reports.first.error, 'Custom error message');
      expect(fakeCrashReporter.reports.first.context, 'test_context');
      expect(fakeCrashReporter.reports.first.fatal, false);
    });

    test('should set user ID', () async {
      // Act
      await fakeCrashReporter.setUserId('user123');

      // Assert
      expect(fakeCrashReporter.userId, 'user123');
    });

    test('should set custom keys', () async {
      // Act
      await fakeCrashReporter.setCustomKey('app_version', '1.0.0');
      await fakeCrashReporter.setCustomKey('user_type', 'premium');

      // Assert
      expect(fakeCrashReporter.customKeys['app_version'], '1.0.0');
      expect(fakeCrashReporter.customKeys['user_type'], 'premium');
    });

    test('should log breadcrumbs', () async {
      // Act
      await fakeCrashReporter.logBreadcrumb(
        'User clicked button',
        category: 'navigation',
      );
      await fakeCrashReporter.logBreadcrumb(
        'API call started',
        category: 'network',
      );

      // Assert
      expect(fakeCrashReporter.breadcrumbs.length, 2);
      expect(fakeCrashReporter.breadcrumbs[0].message, 'User clicked button');
      expect(fakeCrashReporter.breadcrumbs[0].category, 'navigation');
      expect(fakeCrashReporter.breadcrumbs[1].message, 'API call started');
      expect(fakeCrashReporter.breadcrumbs[1].category, 'network');
    });

    test('should clear stored data', () {
      // Arrange
      fakeCrashReporter.recordError(Exception('test'), null);
      fakeCrashReporter.setUserId('user123');
      fakeCrashReporter.setCustomKey('key', 'value');
      fakeCrashReporter.logBreadcrumb('test message');

      // Act
      fakeCrashReporter.clear();

      // Assert
      expect(fakeCrashReporter.reports.length, 0);
      expect(fakeCrashReporter.userId, null);
      expect(fakeCrashReporter.customKeys.length, 0);
      expect(fakeCrashReporter.breadcrumbs.length, 0);
    });

    test('should handle multiple error reports', () async {
      // Act
      await fakeCrashReporter.recordError(Exception('Error 1'), null);
      await fakeCrashReporter.recordError(
        Exception('Error 2'),
        null,
        fatal: true,
      );
      await fakeCrashReporter.recordMessage('Custom error');

      // Assert
      expect(fakeCrashReporter.reports.length, 3);
      expect(
        fakeCrashReporter.reports[0].error.toString(),
        'Exception: Error 1',
      );
      expect(
        fakeCrashReporter.reports[1].error.toString(),
        'Exception: Error 2',
      );
      expect(fakeCrashReporter.reports[1].fatal, true);
      expect(fakeCrashReporter.reports[2].error, 'Custom error');
    });
  });

  group('CrashReport Tests', () {
    test('should create crash report with all fields', () {
      // Arrange
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;
      final timestamp = DateTime.now();

      // Act
      final report = CrashReport(
        error: error,
        stackTrace: stackTrace,
        context: 'test_context',
        fatal: true,
        timestamp: timestamp,
      );

      // Assert
      expect(report.error, error);
      expect(report.stackTrace, stackTrace);
      expect(report.context, 'test_context');
      expect(report.fatal, true);
      expect(report.timestamp, timestamp);
    });

    test('should create crash report with minimal fields', () {
      // Arrange
      final error = 'Simple error message';
      final timestamp = DateTime.now();

      // Act
      final report = CrashReport(
        error: error,
        stackTrace: null,
        context: null,
        fatal: false,
        timestamp: timestamp,
      );

      // Assert
      expect(report.error, error);
      expect(report.stackTrace, null);
      expect(report.context, null);
      expect(report.fatal, false);
      expect(report.timestamp, timestamp);
    });
  });

  group('Breadcrumb Tests', () {
    test('should create breadcrumb with all fields', () {
      // Arrange
      final timestamp = DateTime.now();

      // Act
      final breadcrumb = Breadcrumb(
        message: 'Test message',
        category: 'test_category',
        timestamp: timestamp,
      );

      // Assert
      expect(breadcrumb.message, 'Test message');
      expect(breadcrumb.category, 'test_category');
      expect(breadcrumb.timestamp, timestamp);
    });

    test('should create breadcrumb without category', () {
      // Arrange
      final timestamp = DateTime.now();

      // Act
      final breadcrumb = Breadcrumb(
        message: 'Test message',
        category: null,
        timestamp: timestamp,
      );

      // Assert
      expect(breadcrumb.message, 'Test message');
      expect(breadcrumb.category, null);
      expect(breadcrumb.timestamp, timestamp);
    });
  });
}
