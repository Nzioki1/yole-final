import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../design/tokens.dart';

/// Quality levels for sparkle animations
enum SparkleQuality {
  /// Low quality - minimal particles for performance
  low,
  /// Medium quality - balanced particles and performance
  medium,
  /// High quality - maximum particles for visual impact
  high,
}

/// Extension to get particle count from quality level
extension SparkleQualityExtension on SparkleQuality {
  int get particleCount {
    switch (this) {
      case SparkleQuality.low:
        return 10;
      case SparkleQuality.medium:
        return 20;
      case SparkleQuality.high:
        return 40;
    }
  }
}

/// A GPU-friendly animated sparkle layer that overlays content with animated particles.
///
/// Features:
/// - Quality-based particle count (low/med/high)
/// - RepaintBoundary for performance optimization
/// - Pauses animation when app goes to background
/// - Overlays background content
/// - Performance budget monitoring
/// - Low-power mode detection
/// - Static frame support for golden tests
class SparkleLayer extends StatefulWidget {
  /// The child widget to overlay with sparkles
  final Widget child;

  /// Quality level that determines particle count
  final SparkleQuality quality;

  /// Animation speed multiplier (default: 1.0)
  final double animationSpeed;

  /// Base alpha value for sparkles (default: 0.6)
  final double baseAlpha;

  /// Whether to enable low-power mode detection
  final bool enableLowPowerMode;

  /// Whether sparkles are currently enabled
  final bool enabled;

  /// For golden tests: freeze animation at this duration
  final Duration? staticFrame;

  const SparkleLayer({
    super.key,
    required this.child,
    this.quality = SparkleQuality.medium,
    this.animationSpeed = 1.0,
    this.baseAlpha = 0.6,
    this.enableLowPowerMode = true,
    this.enabled = true,
    this.staticFrame,
  });

  @override
  State<SparkleLayer> createState() => _SparkleLayerState();
}

class _SparkleLayerState extends State<SparkleLayer>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  late List<SparkleParticle> _particles;
  bool _isLowPowerMode = false;
  bool _isInBackground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = AnimationController(
      duration: Duration(milliseconds: (3000 / widget.animationSpeed).round()),
      vsync: this,
    );

    _initializeParticles();
    _checkLowPowerMode();

    if (widget.enabled && !_isLowPowerMode) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(SparkleLayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.enabled != widget.enabled ||
        oldWidget.quality != widget.quality ||
        oldWidget.animationSpeed != widget.animationSpeed) {
      _initializeParticles();
      _controller.duration = Duration(
        milliseconds: (3000 / widget.animationSpeed).round(),
      );

      if (widget.enabled && !_isLowPowerMode && !_isInBackground) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    _isInBackground = state != AppLifecycleState.resumed;

    if (_isInBackground) {
      _controller.stop();
    } else if (widget.enabled && !_isLowPowerMode) {
      _controller.repeat();
    }
  }

  void _checkLowPowerMode() {
    if (!widget.enableLowPowerMode) return;

    // Check for low power mode (iOS) or battery saver (Android)
    // This is a simplified check - in a real app you'd use platform channels
    _isLowPowerMode = false; // Placeholder - would check actual low power mode

    if (_isLowPowerMode && _controller.isAnimating) {
      _controller.stop();
    } else if (!_isLowPowerMode && widget.enabled && !_isInBackground) {
      _controller.repeat();
    }
  }

  void _initializeParticles() {
    final random = math.Random();
    final particleCount = widget.quality.particleCount;
    _particles = List.generate(particleCount, (index) {
      return SparkleParticle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 2.0 + random.nextDouble() * 4.0,
        speed: 0.5 + random.nextDouble() * 1.5,
        delay: random.nextDouble() * 2.0,
        alpha: widget.baseAlpha * (0.5 + random.nextDouble() * 0.5),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || _isLowPowerMode) {
      return widget.child;
    }

    return Stack(
      children: [
        // Child content wrapped in RepaintBoundary for performance
        RepaintBoundary(
          child: widget.child,
        ),
        // Sparkle effects wrapped in RepaintBoundary to isolate repaints
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Handle static frame for golden tests
              double animationValue = _controller.value;
              if (widget.staticFrame != null) {
                final totalDuration = _controller.duration!;
                final staticRatio = widget.staticFrame!.inMilliseconds / totalDuration.inMilliseconds;
                animationValue = staticRatio.clamp(0.0, 1.0);
              }

              return CustomPaint(
                painter: SparklePainter(
                  particles: _particles,
                  animationValue: animationValue,
                  animationSpeed: widget.animationSpeed,
                ),
                size: Size.infinite,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Represents a single sparkle particle
class SparkleParticle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double delay;
  final double alpha;

  SparkleParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.delay,
    required this.alpha,
  });
}

/// Custom painter for rendering sparkle particles
class SparklePainter extends CustomPainter {
  final List<SparkleParticle> particles;
  final double animationValue;
  final double animationSpeed;

  SparklePainter({
    required this.particles,
    required this.animationValue,
    required this.animationSpeed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final adjustedTime =
          (animationValue * animationSpeed + particle.delay) % 1.0;

      // Calculate particle position with floating animation
      final currentY = particle.y - (adjustedTime * particle.speed);
      final currentX = particle.x + math.sin(adjustedTime * math.pi * 2) * 0.1;

      // Skip particles that are off-screen
      if (currentY < -0.1 || currentY > 1.1) continue;

      // Calculate alpha based on position and time
      final distanceFromCenter = (currentY - 0.5).abs();
      final timeAlpha = math.sin(adjustedTime * math.pi);
      final finalAlpha =
          particle.alpha * timeAlpha * (1.0 - distanceFromCenter * 0.5);

      if (finalAlpha <= 0) continue;

      // Draw sparkle
      final sparklePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = DesignTokens.primary.withOpacity(finalAlpha);

      final center = Offset(currentX * size.width, currentY * size.height);

      // Draw main sparkle
      canvas.drawCircle(center, particle.size, sparklePaint);

      // Draw glow effect
      final glowPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = DesignTokens.primary.withOpacity(finalAlpha * 0.3);

      canvas.drawCircle(center, particle.size * 2, glowPaint);
    }
  }

  @override
  bool shouldRepaint(SparklePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.animationSpeed != animationSpeed;
  }
}

/// Performance monitoring for sparkle animations
class SparklePerformanceMonitor {
  static const int _maxFrameTime = 16; // 60fps target
  static int _frameCount = 0;
  static int _droppedFrames = 0;

  static void recordFrame(int frameTime) {
    _frameCount++;
    if (frameTime > _maxFrameTime) {
      _droppedFrames++;
    }

    // Log performance every 100 frames
    if (_frameCount % 100 == 0) {
      final dropRate = _droppedFrames / _frameCount;
      if (dropRate > 0.1) {
        // More than 10% dropped frames
        debugPrint(
          'SparkleLayer: High frame drop rate: ${(dropRate * 100).toStringAsFixed(1)}%',
        );
      }
    }
  }

  static void reset() {
    _frameCount = 0;
    _droppedFrames = 0;
  }
}
