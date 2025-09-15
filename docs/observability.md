# Observability & Performance Monitoring

This document describes the observability and performance monitoring system implemented in the Yole Flutter app.

## Overview

The observability system provides:
- **Analytics**: Event tracking with fake implementation for tests
- **Crash Reporting**: Error tracking with global error handling
- **Performance Monitoring**: Frame budget enforcement for CI

## Analytics

### Interface

The analytics system uses the `Analytics` interface defined in `lib/core/analytics/analytics.dart`:

```dart
abstract class Analytics {
  Future<void> logEvent(String name, [Map<String, dynamic>? params]);
  Future<void> logScreenView(String screenName, [Map<String, dynamic>? params]);
  Future<void> logUserAction(String action, [Map<String, dynamic>? params]);
  Future<void> logError(String error, [Map<String, dynamic>? params]);
  Future<void> setUserProperties(Map<String, dynamic> properties);
  Future<void> setUserId(String userId);
}
```

### Usage

```dart
// Get the analytics service
final analytics = AnalyticsService();

// Log events
await analytics.logEvent('button_clicked', {'button_id': 'submit'});
await analytics.logScreenView('send_money');
await analytics.logUserAction('form_submitted');
await analytics.logError('network_timeout');

// Set user data
await analytics.setUserId('user123');
await analytics.setUserProperties({'user_type': 'premium'});
```

### Testing

The system uses `FakeAnalytics` for tests, which:
- Stores events in memory for verification
- Logs to console for debugging
- Makes no network calls

```dart
// In tests
final fakeAnalytics = FakeAnalytics();
AnalyticsService().initialize(fakeAnalytics);

// Verify events
expect(fakeAnalytics.events.length, 1);
expect(fakeAnalytics.events.first.name, 'button_clicked');
```

## Crash Reporting

### Interface

The crash reporting system uses the `CrashReporter` interface defined in `lib/core/crash/crash.dart`:

```dart
abstract class CrashReporter {
  Future<void> recordError(dynamic error, StackTrace? stackTrace, {String? context, bool fatal = false});
  Future<void> recordMessage(String message, {String? context, bool fatal = false});
  Future<void> setUserId(String userId);
  Future<void> setCustomKey(String key, dynamic value);
  Future<void> logBreadcrumb(String message, {String? category});
}
```

### Usage

```dart
// Record errors
await recordError(Exception('Network error'), stackTrace, context: 'API call');
await recordMessage('User action failed', context: 'form_submission');

// Set context
await crashReporter.setUserId('user123');
await crashReporter.setCustomKey('app_version', '1.0.0');
await crashReporter.logBreadcrumb('User navigated to send screen', category: 'navigation');
```

### Global Error Handling

The system automatically captures Flutter framework errors and async errors:

```dart
// In main()
initializeCrashReporter(FakeCrashReporter());
```

## Performance Monitoring

### Frame Budget

The performance system enforces frame rendering budgets:

- **Target**: 16ms per frame (60 FPS)
- **Minimum**: 33ms per frame (30 FPS)
- **CI Check**: Automated performance budget validation

### Usage

```dart
// Wrap screens with performance monitoring
PerformanceMonitor(
  screenName: 'send_money',
  child: SendMoneyScreen(),
)
```

### CI Integration

The CI pipeline includes performance checks:

```yaml
- name: Run performance budget check
  run: |
    flutter test test/perf/performance_test.dart
```

## Testing Strategy

### Analytics Testing

- Use `FakeAnalytics` for all tests
- Verify event parameters and timing
- No network calls in unit/widget tests

### Crash Reporting Testing

- Use `FakeCrashReporter` for all tests
- Verify error capture and context
- Test global error handling

### Performance Testing

- Disable animations in tests (`enabled: false`)
- Measure frame times and render performance
- Fail CI if performance degrades

## Production Setup

### Analytics

Replace `FakeAnalytics` with real implementation:

```dart
// In main()
AnalyticsService().initialize(FirebaseAnalytics());
```

### Crash Reporting

Replace `FakeCrashReporter` with real implementation:

```dart
// In main()
initializeCrashReporter(FirebaseCrashlytics());
```

### Performance Monitoring

- Enable `PerformanceMonitor` in production
- Monitor frame drop rates
- Set up alerts for performance degradation

## Best Practices

1. **Always use the interface**: Don't call analytics/crash services directly
2. **Test with fakes**: Use fake implementations in all tests
3. **Monitor performance**: Enable performance monitoring in production
4. **Handle errors gracefully**: Use crash reporting for all error scenarios
5. **Track user journeys**: Log meaningful events for product insights

## Troubleshooting

### Common Issues

1. **Analytics not working**: Check if `AnalyticsService().initialize()` was called
2. **Crash reports missing**: Verify `initializeCrashReporter()` was called in main()
3. **Performance tests failing**: Ensure animations are disabled in tests
4. **Network calls in tests**: Make sure fake implementations are used

### Debug Mode

In debug mode, all services log to console for easy debugging:

```
Analytics Event: button_clicked with params: {button_id: submit}
Crash Report: Exception: Network error
Breadcrumb (navigation): User navigated to send screen
```

