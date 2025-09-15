import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Crash reporting interface for tracking and reporting application errors.
///
/// This interface provides a contract for crash reporting implementations,
/// allowing easy swapping between fake (for tests) and real (Firebase Crashlytics) implementations.
abstract class CrashReporter {
  /// Record an error with optional stack trace and context.
  ///
  /// [error] - The error object
  /// [stackTrace] - Optional stack trace
  /// [context] - Optional context information
  /// [fatal] - Whether this is a fatal error (default: false)
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
    bool fatal = false,
  });

  /// Record a custom error message.
  ///
  /// [message] - The error message
  /// [context] - Optional context information
  /// [fatal] - Whether this is a fatal error (default: false)
  Future<void> recordMessage(
    String message, {
    String? context,
    bool fatal = false,
  });

  /// Set user identifier for crash reports.
  ///
  /// [userId] - Unique identifier for the user
  Future<void> setUserId(String userId);

  /// Set custom key-value data for crash reports.
  ///
  /// [key] - The key
  /// [value] - The value
  Future<void> setCustomKey(String key, dynamic value);

  /// Log a breadcrumb for debugging.
  ///
  /// [message] - The breadcrumb message
  /// [category] - Optional category for the breadcrumb
  Future<void> logBreadcrumb(String message, {String? category});
}

/// Fake crash reporter implementation for testing.
///
/// This implementation logs errors to debug console and stores them
/// in memory for test verification. No network calls are made.
class FakeCrashReporter implements CrashReporter {
  final List<CrashReport> _reports = [];
  final Map<String, dynamic> _customKeys = {};
  final List<Breadcrumb> _breadcrumbs = [];
  String? _userId;

  /// Get all recorded crash reports for test verification.
  List<CrashReport> get reports => List.unmodifiable(_reports);

  /// Get custom keys for test verification.
  Map<String, dynamic> get customKeys => Map.unmodifiable(_customKeys);

  /// Get breadcrumbs for test verification.
  List<Breadcrumb> get breadcrumbs => List.unmodifiable(_breadcrumbs);

  /// Get current user ID for test verification.
  String? get userId => _userId;

  /// Clear all stored data (useful for test cleanup).
  void clear() {
    _reports.clear();
    _customKeys.clear();
    _breadcrumbs.clear();
    _userId = null;
  }

  @override
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
    bool fatal = false,
  }) async {
    final report = CrashReport(
      error: error,
      stackTrace: stackTrace,
      context: context,
      fatal: fatal,
      timestamp: DateTime.now(),
    );
    _reports.add(report);

    // Log to debug console for development
    print('Crash Report${fatal ? ' (FATAL)' : ''}: $error');
    if (context != null) print('Context: $context');
    if (stackTrace != null) print('Stack Trace: $stackTrace');
  }

  @override
  Future<void> recordMessage(
    String message, {
    String? context,
    bool fatal = false,
  }) async {
    await recordError(message, null, context: context, fatal: fatal);
  }

  @override
  Future<void> setUserId(String userId) async {
    _userId = userId;
    print('Crash Reporter User ID: $userId');
  }

  @override
  Future<void> setCustomKey(String key, dynamic value) async {
    _customKeys[key] = value;
    print('Crash Reporter Custom Key: $key = $value');
  }

  @override
  Future<void> logBreadcrumb(String message, {String? category}) async {
    final breadcrumb = Breadcrumb(
      message: message,
      category: category,
      timestamp: DateTime.now(),
    );
    _breadcrumbs.add(breadcrumb);
    print('Breadcrumb${category != null ? ' ($category)' : ''}: $message');
  }
}

/// Represents a crash report for testing purposes.
class CrashReport {
  final dynamic error;
  final StackTrace? stackTrace;
  final String? context;
  final bool fatal;
  final DateTime timestamp;

  const CrashReport({
    required this.error,
    this.stackTrace,
    this.context,
    required this.fatal,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'CrashReport(error: $error, context: $context, fatal: $fatal, timestamp: $timestamp)';
  }
}

/// Represents a breadcrumb for testing purposes.
class Breadcrumb {
  final String message;
  final String? category;
  final DateTime timestamp;

  const Breadcrumb({
    required this.message,
    this.category,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'Breadcrumb(message: $message, category: $category, timestamp: $timestamp)';
  }
}

/// Global crash reporter instance.
///
/// This should be initialized in main() and used throughout the app.
CrashReporter? _globalCrashReporter;

/// Get the global crash reporter instance.
CrashReporter get crashReporter {
  if (_globalCrashReporter == null) {
    throw StateError(
      'Crash reporter not initialized. Call initializeCrashReporter() in main().',
    );
  }
  return _globalCrashReporter!;
}

/// Initialize the global crash reporter.
///
/// This should be called in main() before runApp().
void initializeCrashReporter(CrashReporter reporter) {
  _globalCrashReporter = reporter;

  // Set up global Flutter error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    // Log to console in debug mode
    if (kDebugMode) {
      FlutterError.presentError(details);
    }

    // Record the error
    crashReporter.recordError(
      details.exception,
      details.stack,
      context: 'Flutter Framework Error',
      fatal: false,
    );
  };

  // Set up zone error handling for async errors
  runZonedGuarded(
    () {
      // App will run here
    },
    (error, stack) {
      crashReporter.recordError(
        error,
        stack,
        context: 'Zone Error',
        fatal: true,
      );
    },
  );
}

/// Record an error using the global crash reporter.
///
/// This is a convenience function for recording errors throughout the app.
Future<void> recordError(
  dynamic error,
  StackTrace? stackTrace, {
  String? context,
  bool fatal = false,
}) async {
  await crashReporter.recordError(
    error,
    stackTrace,
    context: context,
    fatal: fatal,
  );
}

/// Record a custom error message using the global crash reporter.
///
/// This is a convenience function for recording custom error messages.
Future<void> recordMessage(
  String message, {
  String? context,
  bool fatal = false,
}) async {
  await crashReporter.recordMessage(message, context: context, fatal: fatal);
}
