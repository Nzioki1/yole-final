/// Success animation component for celebrating successful actions
///
/// This component provides a celebratory animation for successful
/// operations like completed transactions or successful form submissions.
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../design/tokens.dart';
import '../../design/typography.dart';

/// Success animation component for celebrating successful actions
///
/// This component provides a non-blocking celebratory animation
/// that can be used to indicate successful operations.
class SuccessAnimation extends StatefulWidget {
  /// Creates a success animation component
  ///
  /// [duration] - How long the animation should run
  /// [onDone] - Callback when animation completes
  /// [staticFrame] - For golden tests: freeze animation at this duration
  const SuccessAnimation({
    super.key,
    this.duration = const Duration(seconds: 3),
    this.onDone,
    this.staticFrame,
  });

  /// How long the animation should run
  final Duration? duration;

  /// Callback when animation completes
  final VoidCallback? onDone;

  /// For golden tests: freeze animation at this duration
  final Duration? staticFrame;

  @override
  State<SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _rotationAnimation;

  final List<Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: widget.duration ?? const Duration(seconds: 3),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeInOut),
    );

    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onDone?.call();
      }
    });

    _particleController.addListener(() {
      setState(() {
        _updateParticles();
      });
    });

    _startAnimation();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (widget.staticFrame != null) {
      // For golden tests: set animation to a specific frame
      _mainController.duration = widget.staticFrame!;
      _particleController.duration = widget.staticFrame!;
      _mainController.forward();
      _particleController.forward();
    } else {
      // Normal animation
      _mainController.forward();
      _particleController.forward();
    }
    _createParticles();
  }

  void _createParticles() {
    for (int i = 0; i < 20; i++) {
      _particles.add(
        Particle(
          x: 0.5,
          y: 0.5,
          vx: (_random.nextDouble() - 0.5) * 0.02,
          vy: (_random.nextDouble() - 0.5) * 0.02,
          life: 1.0,
          color: _getRandomColor(),
        ),
      );
    }
  }

  void _updateParticles() {
    _particles.removeWhere((particle) {
      particle.x += particle.vx;
      particle.y += particle.vy;
      particle.life -= 0.02;
      particle.vy += 0.001; // Gravity effect
      return particle.life <= 0;
    });
  }

  Color _getRandomColor() {
    final colors = [
      DesignTokens.primary,
      DesignTokens.success,
      DesignTokens.warning,
      DesignTokens.info,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Particle effects
            ..._particles.map(
              (particle) => Positioned(
                left: particle.x * MediaQuery.of(context).size.width,
                top: particle.y * MediaQuery.of(context).size.height,
                child: Opacity(
                  opacity: particle.life,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: particle.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),

            // Main success content
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Success icon
                    Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: isDark
                              ? DesignTokens.darkSuccess
                              : DesignTokens.success,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (isDark
                                          ? DesignTokens.darkSuccess
                                          : DesignTokens.success)
                                      .withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check,
                          size: 40,
                          color: isDark
                              ? DesignTokens.darkOnSuccess
                              : DesignTokens.onSuccess,
                        ),
                      ),
                    ),

                    // Text removed from new API - use staticFrame for golden tests
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Particle class for confetti animation
class Particle {
  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.life,
    required this.color,
  });

  double x;
  double y;
  double vx;
  double vy;
  double life;
  Color color;
}
