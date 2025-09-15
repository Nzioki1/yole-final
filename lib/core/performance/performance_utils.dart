/// Performance utilities for optimizing app performance
///
/// Provides utilities for:
/// - Provider optimization
/// - Image caching and precaching
/// - Performance monitoring
/// - Memory management
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Performance optimization utilities
class PerformanceUtils {
  /// Cache for precached images
  static final Map<String, ImageProvider> _imageCache = {};
  
  /// Cache for precached icons
  static final Map<String, IconData> _iconCache = {};

  /// Precache image for better performance
  static Future<void> precacheImage(
    String key,
    ImageProvider imageProvider,
    BuildContext context,
  ) async {
    if (_imageCache.containsKey(key)) return;
    
    try {
      await precacheImage(imageProvider, context);
      _imageCache[key] = imageProvider;
    } catch (e) {
      debugPrint('Failed to precache image $key: $e');
    }
  }

  /// Precache network image
  static Future<void> precacheNetworkImage(
    String url,
    BuildContext context, {
    Map<String, String>? headers,
  }) async {
    if (_imageCache.containsKey(url)) return;
    
    try {
      final imageProvider = NetworkImage(url, headers: headers);
      await precacheImage(url, imageProvider, context);
    } catch (e) {
      debugPrint('Failed to precache network image $url: $e');
    }
  }

  /// Precache asset image
  static Future<void> precacheAssetImage(
    String assetPath,
    BuildContext context,
  ) async {
    if (_imageCache.containsKey(assetPath)) return;
    
    try {
      final imageProvider = AssetImage(assetPath);
      await precacheImage(assetPath, imageProvider, context);
    } catch (e) {
      debugPrint('Failed to precache asset image $assetPath: $e');
    }
  }

  /// Clear image cache
  static void clearImageCache() {
    _imageCache.clear();
  }

  /// Get cached image provider
  static ImageProvider? getCachedImage(String key) {
    return _imageCache[key];
  }

  /// Cache icon data
  static void cacheIcon(String key, IconData icon) {
    _iconCache[key] = icon;
  }

  /// Get cached icon
  static IconData? getCachedIcon(String key) {
    return _iconCache[key];
  }

  /// Clear icon cache
  static void clearIconCache() {
    _iconCache.clear();
  }

  /// Optimize provider rebuilds by using select
  static Widget optimizeProvider<T>(
    ProviderListenable<T> provider,
    Widget Function(T value) builder, {
    String? debugLabel,
  }) {
    return Consumer(
      builder: (context, ref, child) {
        final value = ref.watch(provider);
        return builder(value);
      },
    );
  }

  /// Optimize provider with selector to reduce rebuilds
  static Widget optimizeProviderWithSelector<T, R>(
    ProviderListenable<T> provider,
    R Function(T value) selector,
    Widget Function(R value) builder, {
    String? debugLabel,
  }) {
    return Consumer(
      builder: (context, ref, child) {
        final value = ref.watch(provider.select(selector));
        return builder(value);
      },
    );
  }

  /// Debounce function calls to prevent excessive rebuilds
  static void debounce(
    String key,
    Duration duration,
    VoidCallback callback,
  ) {
    _Debouncer.debounce(key, duration, callback);
  }

  /// Throttle function calls to limit execution frequency
  static void throttle(
    String key,
    Duration duration,
    VoidCallback callback,
  ) {
    _Throttler.throttle(key, duration, callback);
  }

  /// Measure widget build time
  static Future<double> measureBuildTime(
    WidgetBuilder builder,
  ) async {
    final stopwatch = Stopwatch()..start();
    
    // Create widget
    final widget = builder(null);
    
    // Create element and mount
    final element = widget.createElement();
    element.mount(null, null);
    
    final buildTime = stopwatch.elapsedMicroseconds / 1000.0;
    stopwatch.stop();
    
    return buildTime;
  }

  /// Check if device is low-end for performance optimizations
  static bool isLowEndDevice() {
    // This would typically check device specs
    // For now, we'll use a simple heuristic
    return false; // TODO: Implement device detection
  }

  /// Get optimal quality setting based on device performance
  static String getOptimalQuality() {
    if (isLowEndDevice()) {
      return 'low';
    }
    return 'medium';
  }

  /// Optimize image quality based on device performance
  static double getOptimalImageQuality() {
    if (isLowEndDevice()) {
      return 0.7; // Lower quality for low-end devices
    }
    return 1.0; // Full quality for high-end devices
  }

  /// Get optimal particle count for effects
  static int getOptimalParticleCount(int baseCount) {
    if (isLowEndDevice()) {
      return (baseCount * 0.5).round(); // Reduce particles by 50%
    }
    return baseCount;
  }

  /// Memory pressure callback
  static void onMemoryPressure() {
    // Clear caches when memory pressure is high
    clearImageCache();
    clearIconCache();
    
    // Force garbage collection
    // Note: This is not recommended in production
    // but can be useful for testing
    debugPrint('Memory pressure detected - cleared caches');
  }
}

/// Debouncer utility for preventing excessive function calls
class _Debouncer {
  static final Map<String, Timer> _timers = {};

  static void debounce(String key, Duration duration, VoidCallback callback) {
    _timers[key]?.cancel();
    _timers[key] = Timer(duration, () {
      callback();
      _timers.remove(key);
    });
  }

  static void cancel(String key) {
    _timers[key]?.cancel();
    _timers.remove(key);
  }

  static void cancelAll() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
  }
}

/// Throttler utility for limiting function call frequency
class _Throttler {
  static final Map<String, DateTime> _lastCall = {};

  static void throttle(String key, Duration duration, VoidCallback callback) {
    final now = DateTime.now();
    final lastCall = _lastCall[key];
    
    if (lastCall == null || now.difference(lastCall) >= duration) {
      _lastCall[key] = now;
      callback();
    }
  }

  static void reset(String key) {
    _lastCall.remove(key);
  }

  static void resetAll() {
    _lastCall.clear();
  }
}

/// Performance monitoring extension for widgets
extension PerformanceExtension on Widget {
  /// Wrap widget with performance monitoring
  Widget withPerformanceMonitoring({
    String? label,
    bool measureBuildTime = false,
  }) {
    if (!measureBuildTime) return this;
    
    return _PerformanceWrapper(
      label: label ?? 'Widget',
      child: this,
    );
  }

  /// Wrap widget with RepaintBoundary for performance
  Widget withRepaintBoundary({
    String? debugLabel,
  }) {
    return RepaintBoundary(
      child: this,
    );
  }

  /// Wrap widget with AutomaticKeepAliveClientMixin for performance
  Widget withKeepAlive() {
    return _KeepAliveWrapper(child: this);
  }
}

/// Performance wrapper widget
class _PerformanceWrapper extends StatefulWidget {
  const _PerformanceWrapper({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  State<_PerformanceWrapper> createState() => _PerformanceWrapperState();
}

class _PerformanceWrapperState extends State<_PerformanceWrapper> {
  @override
  Widget build(BuildContext context) {
    final stopwatch = Stopwatch()..start();
    
    final result = widget.child;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final buildTime = stopwatch.elapsedMicroseconds / 1000.0;
      debugPrint('${widget.label} build time: ${buildTime.toStringAsFixed(1)}ms');
    });
    
    return result;
  }
}

/// Keep alive wrapper widget
class _KeepAliveWrapper extends StatefulWidget {
  const _KeepAliveWrapper({required this.child});

  final Widget child;

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

/// Performance-optimized image widget
class OptimizedImage extends StatelessWidget {
  const OptimizedImage({
    super.key,
    required this.imageProvider,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.quality,
    this.cacheKey,
  });

  final ImageProvider imageProvider;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double? quality;
  final String? cacheKey;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Image(
        image: imageProvider,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: width?.toInt(),
        cacheHeight: height?.toInt(),
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}

/// Performance-optimized network image
class OptimizedNetworkImage extends StatelessWidget {
  const OptimizedNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.headers,
    this.cacheKey,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Map<String, String>? headers;
  final String? cacheKey;

  @override
  Widget build(BuildContext context) {
    return OptimizedImage(
      imageProvider: NetworkImage(url, headers: headers),
      width: width,
      height: height,
      fit: fit,
      cacheKey: cacheKey ?? url,
    );
  }
}
