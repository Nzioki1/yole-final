# Performance Monitoring & Optimization

This document describes the performance monitoring system implemented to ensure frame budget compliance and detect performance regressions.

## Overview

The performance system consists of:

1. **Frame Probe** - Core performance measurement tool
2. **Test Scenarios** - Realistic widget scenarios for testing
3. **Frame Budget Tests** - Automated CI performance checks
4. **Performance Utils** - Optimization utilities and helpers
5. **CI Integration** - Automated performance monitoring

## Frame Budget Targets

- **Target**: ≤ 16ms per frame (60fps)
- **Warning**: ≤ 20ms per frame
- **CI Buffer**: +2ms for CI environment (18ms target)

## Performance Measurement

### Frame Probe (`tools/perf/frame_probe.dart`)

The core performance measurement tool that:

- Measures build and layout times
- Calculates frame budget compliance
- Provides performance grades (A-F)
- Generates detailed reports
- Supports CI environment detection

```dart
// Basic usage
final result = await FrameProbe.runScenario(
  PerformanceScenarios.sendAmountScreen(),
  iterations: 30,
  scenarioName: 'SendAmountScreen',
);

print(result.status); // ✅ Excellent (A) - 12.5ms
```

### Test Scenarios (`test/perf/performance_scenarios.dart`)

Realistic widget scenarios representing critical user flows:

- **SendAmountScreen** - Amount input with shimmer loading
- **SendReviewScreen** - Transaction review with fee calculations
- **WelcomeScreen** - Welcome screen with SparkleLayer
- **NetworkSelectionScreen** - Network selection with multiple tiles
- **RecipientSelectionScreen** - Recipient search and selection

## Running Performance Tests

### Local Development

```bash
# Run all performance tests
flutter test test/perf/

# Run specific test
flutter test test/perf/frame_budget_test.dart

# Run with verbose output
flutter test test/perf/ --reporter=expanded
```

### Using Performance Monitor

```bash
# Run all scenarios
dart tools/perf/performance_monitor.dart

# Run specific scenario
dart tools/perf/performance_monitor.dart --scenario SendAmountScreen

# Custom iterations and budget
dart tools/perf/performance_monitor.dart --iterations 50 --budget 20

# Generate detailed report
dart tools/perf/performance_monitor.dart --report

# Watch mode for continuous monitoring
dart tools/perf/performance_monitor.dart --watch
```

## Performance Optimizations

### RepaintBoundary Usage

Critical components are wrapped with `RepaintBoundary` to isolate repaints:

```dart
// SparkleLayer optimization
RepaintBoundary(
  child: widget.child,
),
RepaintBoundary(
  child: AnimatedBuilder(
    animation: _controller,
    builder: (context, child) => CustomPaint(...),
  ),
),
```

### Provider Optimization

Use `select()` to minimize rebuilds:

```dart
// Optimize provider rebuilds
Consumer(
  builder: (context, ref, child) {
    final selectedValue = ref.watch(provider.select((state) => state.specificValue));
    return Widget(selectedValue);
  },
)
```

### Image Caching

Precache images for better performance:

```dart
// Precache network images
await PerformanceUtils.precacheNetworkImage(
  'https://example.com/logo.png',
  context,
);

// Use optimized image widgets
OptimizedNetworkImage(
  url: 'https://example.com/image.jpg',
  width: 100,
  height: 100,
)
```

### Quality Settings

Adaptive quality based on device performance:

```dart
// Get optimal quality setting
final quality = PerformanceUtils.getOptimalQuality(); // 'low', 'medium', 'high'

// Optimize particle count
final particleCount = PerformanceUtils.getOptimalParticleCount(40);

// Optimize image quality
final imageQuality = PerformanceUtils.getOptimalImageQuality();
```

## CI Integration

### GitHub Actions

Performance tests run automatically on:

- Pull requests to main/develop branches
- Daily scheduled runs at 2 AM UTC
- Manual workflow dispatch

### Performance Job (`.github/workflows/performance.yml`)

The CI job:

1. Sets up Flutter environment
2. Runs performance tests with CI buffer
3. Comments PR with results
4. Generates performance reports

### CI Environment Detection

The system automatically detects CI environment and adjusts thresholds:

```dart
// CI detection
final isCI = PerformanceUtils.isCI;

// Adjusted thresholds
final budget = PerformanceUtils.adjustedBudget; // 18ms in CI
final warning = PerformanceUtils.adjustedWarning; // 22ms in CI
```

## Performance Guidelines

### When Tests Fail

If performance tests fail, consider these optimizations:

1. **Add RepaintBoundary** around static content
2. **Optimize provider rebuilds** with `select()`
3. **Cache images and icons** using `PerformanceUtils`
4. **Reduce particle count** on low-end devices
5. **Use const constructors** where possible
6. **Avoid unnecessary setState** calls
7. **Implement debouncing** for frequent updates

### Performance Best Practices

1. **Profile First** - Use Flutter Inspector to identify bottlenecks
2. **Measure Changes** - Run performance tests before/after optimizations
3. **Monitor CI** - Watch for performance regressions in PRs
4. **Device Testing** - Test on low-end devices for real-world performance
5. **Memory Management** - Clear caches when memory pressure is high

## Troubleshooting

### Common Issues

**High Frame Times:**
- Check for expensive operations in build methods
- Use `RepaintBoundary` to isolate repaints
- Optimize image loading and caching

**Inconsistent Performance:**
- Look for variable-cost operations
- Implement proper debouncing
- Check for memory leaks

**CI Failures:**
- Verify CI buffer is applied correctly
- Check for environment-specific issues
- Review performance regression trends

### Debugging Tools

```dart
// Measure build time
final buildTime = await PerformanceUtils.measureBuildTime(widgetBuilder);

// Monitor widget performance
Widget.withPerformanceMonitoring(
  label: 'MyWidget',
  measureBuildTime: true,
  child: MyWidget(),
);

// Debug provider rebuilds
ref.listen(provider, (previous, next) {
  print('Provider rebuilt: $previous -> $next');
});
```

## Performance Metrics

### Key Metrics Tracked

- **Build Time** - Widget construction time
- **Layout Time** - Widget layout calculation time
- **Total Frame Time** - Combined build + layout time
- **Standard Deviation** - Performance consistency
- **Min/Max Times** - Performance range

### Performance Grades

- **A** (≤ 16ms) - Excellent performance
- **B** (≤ 20ms) - Good performance
- **C** (≤ 25ms) - Fair performance
- **D** (≤ 33ms) - Poor performance
- **F** (> 33ms) - Unacceptable performance

## Future Enhancements

1. **Device-Specific Thresholds** - Different budgets for different device classes
2. **Memory Monitoring** - Track memory usage alongside frame times
3. **Network Performance** - Monitor API call performance
4. **User Journey Tracking** - End-to-end performance measurement
5. **Automated Optimization** - AI-powered performance suggestions

## Contributing

When adding new features:

1. Add performance test scenarios for new screens
2. Include RepaintBoundary optimizations
3. Test on low-end devices
4. Monitor CI performance results
5. Update this documentation

For questions or issues, please refer to the performance test failures in CI or create an issue with performance details.
