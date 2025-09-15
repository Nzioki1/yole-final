import 'package:flutter/material.dart';

class MotionDurations {
  static const fast = Duration(milliseconds: 120);
  static const med  = Duration(milliseconds: 200);
  static const slow = Duration(milliseconds: 320);
}

class MotionCurves {
  static const ease       = Curves.ease;
  static const easeOut    = Curves.easeOut;
  static const easeInOut  = Curves.easeInOut;
  static const spring     = Curves.easeOutBack; // lightweight spring-like
}

/// Fades child in from 0→1 opacity.
Widget fadeIn({
  required Widget child,
  Duration duration = MotionDurations.med,
  Curve curve = MotionCurves.easeOut,
  Key? key,
}) {
  return TweenAnimationBuilder<double>(
    key: key,
    tween: Tween(begin: 0, end: 1),
    duration: duration,
    curve: curve,
    child: child,
    builder: (context, value, child) => Opacity(opacity: value, child: child),
  );
}

/// Slides child on Y axis (default: from 12px down to 0).
Widget slideY({
  required Widget child,
  double begin = 12,
  Duration duration = MotionDurations.med,
  Curve curve = MotionCurves.easeOut,
  Key? key,
}) {
  return TweenAnimationBuilder<double>(
    key: key,
    tween: Tween(begin: begin, end: 0),
    duration: duration,
    curve: curve,
    child: child,
    builder: (context, value, child) =>
        Transform.translate(offset: Offset(0, value), child: child),
  );
}

/// Scales child from startScale→1.
Widget scaleIn({
  required Widget child,
  double startScale = 0.98,
  Duration duration = MotionDurations.fast,
  Curve curve = MotionCurves.easeOut,
  Key? key,
}) {
  return TweenAnimationBuilder<double>(
    key: key,
    tween: Tween(begin: startScale, end: 1),
    duration: duration,
    curve: curve,
    child: child,
    builder: (context, s, child) => Transform.scale(scale: s, child: child),
  );
}

/// Shared-axis like transitions: X, Y, Z (opacity+scale/slide).
Page<T> sharedAxisX<T>({required Widget child, LocalKey? key}) =>
    _SharedAxisPage<T>(child: child, axis: Axis.horizontal, key: key);
Page<T> sharedAxisY<T>({required Widget child, LocalKey? key}) =>
    _SharedAxisPage<T>(child: child, axis: Axis.vertical, key: key);
Page<T> sharedAxisZ<T>({required Widget child, LocalKey? key}) =>
    _SharedAxisPage<T>(child: child, axis: null, key: key);

class _SharedAxisPage<T> extends Page<T> {
  final Widget child;
  final Axis? axis;
  const _SharedAxisPage({required this.child, this.axis, LocalKey? key}) : super(key: key);

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (c, a, s) => child,
      transitionsBuilder: (c, a, s, child) {
        final fade = CurvedAnimation(parent: a, curve: MotionCurves.easeInOut);
        final scale = Tween<double>(begin: 0.98, end: 1).animate(fade);
        final slide = (axis == Axis.horizontal)
            ? Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(fade)
            : (axis == Axis.vertical)
                ? Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(fade)
                : null;
        Widget w = FadeTransition(opacity: fade, child: child);
        w = ScaleTransition(scale: scale, child: w);
        if (slide != null) w = SlideTransition(position: slide, child: w);
        return w;
      },
      transitionDuration: MotionDurations.med,
      reverseTransitionDuration: MotionDurations.med,
    );
  }
}

/// Press interaction wrapper with scale/opacity micro-interaction.
class AnimatedPress extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;
  final double pressedScale;
  final double pressedOpacity;
  const AnimatedPress({
    Key? key,
    required this.child,
    this.onTap,
    this.duration = MotionDurations.fast,
    this.pressedScale = 0.97,
    this.pressedOpacity = 0.95,
  }) : super(key: key);

  @override
  State<AnimatedPress> createState() => _AnimatedPressState();
}

class _AnimatedPressState extends State<AnimatedPress> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedOpacity(
        duration: widget.duration,
        opacity: _down ? widget.pressedOpacity : 1,
        child: AnimatedScale(
          duration: widget.duration,
          scale: _down ? widget.pressedScale : 1,
          child: widget.child,
        ),
      ),
    );
  }
}