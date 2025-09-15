/// Unit tests for motion helpers and system
///
/// Tests:
/// - MotionDurations constants
/// - MotionCurves constants
/// - MotionHelpers animation creation
/// - AnimatedPress behavior
/// - MotionThemeData functionality
library;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yole_final/ui/motion/motion.dart';

void main() {
  group('MotionDurations', () {
    test('should have correct duration values', () {
      expect(MotionDurations.fast, const Duration(milliseconds: 120));
      expect(MotionDurations.medium, const Duration(milliseconds: 200));
      expect(MotionDurations.slow, const Duration(milliseconds: 320));
      expect(MotionDurations.extraSlow, const Duration(milliseconds: 500));
      expect(MotionDurations.veryFast, const Duration(milliseconds: 80));
    });
  });

  group('MotionCurves', () {
    test('should have correct curve values', () {
      expect(MotionCurves.ease, Curves.easeInOut);
      expect(MotionCurves.easeOut, Curves.easeOut);
      expect(MotionCurves.easeIn, Curves.easeIn);
      expect(MotionCurves.easeInOut, Curves.easeInOut);
      expect(MotionCurves.spring, Curves.elasticOut);
      expect(MotionCurves.micro, Curves.easeOutCubic);
    });

    test('springGentle should be a custom curve', () {
      expect(MotionCurves.springGentle, isA<Cubic>());
    });
  });

  group('MotionHelpers', () {
    late AnimationController controller;

    setUp(() {
      controller = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: TestVSync(),
      );
    });

    tearDown(() {
      controller.dispose();
    });

    group('fadeIn', () {
      test('should create fade animation with default values', () {
        final animation = MotionHelpers.fadeIn(controller: controller);
        
        expect(animation, isA<Animation<double>>());
        expect(animation.value, 0.0); // Initial value
        
        controller.forward();
        expect(animation.value, 1.0); // Final value
      });

      test('should create fade animation with custom values', () {
        final animation = MotionHelpers.fadeIn(
          controller: controller,
          duration: const Duration(milliseconds: 300),
          delay: const Duration(milliseconds: 100),
          curve: Curves.easeIn,
        );
        
        expect(animation, isA<Animation<double>>());
      });
    });

    group('slideY', () {
      test('should create slide animation with default values', () {
        final animation = MotionHelpers.slideY(controller: controller);
        
        expect(animation, isA<Animation<Offset>>());
        expect(animation.value, const Offset(0.0, 30.0)); // Initial value
        
        controller.forward();
        expect(animation.value, const Offset(0.0, 0.0)); // Final value
      });

      test('should create slide animation with custom values', () {
        final animation = MotionHelpers.slideY(
          controller: controller,
          begin: 50.0,
          end: 10.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        
        expect(animation, isA<Animation<Offset>>());
        expect(animation.value, const Offset(0.0, 50.0)); // Initial value
      });
    });

    group('scaleIn', () {
      test('should create scale animation with default values', () {
        final animation = MotionHelpers.scaleIn(controller: controller);
        
        expect(animation, isA<Animation<double>>());
        expect(animation.value, 0.8); // Initial value
        
        controller.forward();
        expect(animation.value, 1.0); // Final value
      });

      test('should create scale animation with custom values', () {
        final animation = MotionHelpers.scaleIn(
          controller: controller,
          begin: 0.5,
          end: 1.2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        
        expect(animation, isA<Animation<double>>());
        expect(animation.value, 0.5); // Initial value
      });
    });

    group('sharedAxisX', () {
      test('should create shared axis X animation', () {
        final animation = MotionHelpers.sharedAxisX(
          controller: controller,
          forward: true,
        );
        
        expect(animation, isA<Animation<double>>());
        expect(animation.value, 1.0); // Initial value
        
        controller.forward();
        expect(animation.value, 0.0); // Final value
      });

      test('should create reverse shared axis X animation', () {
        final animation = MotionHelpers.sharedAxisX(
          controller: controller,
          forward: false,
        );
        
        expect(animation, isA<Animation<double>>());
        expect(animation.value, -1.0); // Initial value
      });
    });

    group('sharedAxisY', () {
      test('should create shared axis Y animation', () {
        final animation = MotionHelpers.sharedAxisY(
          controller: controller,
          forward: true,
        );
        
        expect(animation, isA<Animation<double>>());
        expect(animation.value, 1.0); // Initial value
        
        controller.forward();
        expect(animation.value, 0.0); // Final value
      });
    });

    group('sharedAxisZ', () {
      test('should create shared axis Z animation', () {
        final animation = MotionHelpers.sharedAxisZ(
          controller: controller,
          forward: true,
        );
        
        expect(animation, isA<Animation<double>>());
        expect(animation.value, 0.8); // Initial value
        
        controller.forward();
        expect(animation.value, 1.0); // Final value
      });
    });
  });

  group('AnimatedPress', () {
    testWidgets('should render child correctly', (tester) async {
      const testWidget = AnimatedPress(
        child: Text('Test Button'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: testWidget,
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('should handle press events', (tester) async {
      bool pressed = false;
      
      final testWidget = AnimatedPress(
        onPressed: () {
          pressed = true;
        },
        child: const Text('Test Button'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: testWidget,
          ),
        ),
      );

      await tester.tap(find.text('Test Button'));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('should not respond when disabled', (tester) async {
      bool pressed = false;
      
      final testWidget = AnimatedPress(
        enabled: false,
        onPressed: () {
          pressed = true;
        },
        child: const Text('Test Button'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: testWidget,
          ),
        ),
      );

      await tester.tap(find.text('Test Button'));
      await tester.pumpAndSettle();

      expect(pressed, isFalse);
    });

    testWidgets('should apply custom scale and opacity', (tester) async {
      const testWidget = AnimatedPress(
        scaleValue: 0.9,
        opacityValue: 0.8,
        child: Text('Test Button'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: testWidget,
          ),
        ),
      );

      // Check that the widget is rendered
      expect(find.text('Test Button'), findsOneWidget);
    });
  });

  group('MotionThemeData', () {
    test('should have correct default values', () {
      const theme = MotionThemeData();
      
      expect(theme.fastDuration, MotionDurations.fast);
      expect(theme.mediumDuration, MotionDurations.medium);
      expect(theme.slowDuration, MotionDurations.slow);
      expect(theme.defaultCurve, MotionCurves.ease);
      expect(theme.entranceCurve, MotionCurves.easeOut);
      expect(theme.exitCurve, MotionCurves.easeIn);
      expect(theme.microInteractionCurve, MotionCurves.micro);
      expect(theme.pressScale, 0.97);
      expect(theme.pressOpacity, 0.95);
      expect(theme.pressDuration, MotionDurations.fast);
      expect(theme.sharedAxisDuration, MotionDurations.medium);
      expect(theme.sharedAxisCurve, MotionCurves.easeInOut);
    });

    test('should create copy with modified values', () {
      const theme = MotionThemeData();
      final modifiedTheme = theme.copyWith(
        pressScale: 0.9,
        pressOpacity: 0.8,
      );
      
      expect(modifiedTheme.pressScale, 0.9);
      expect(modifiedTheme.pressOpacity, 0.8);
      expect(modifiedTheme.fastDuration, theme.fastDuration); // Unchanged
    });
  });

  group('MotionThemeExtension', () {
    test('should create copy with modified values', () {
      const extension = MotionThemeExtension(
        motionTheme: MotionThemeData(),
      );
      
      final modifiedExtension = extension.copyWith(
        motionTheme: const MotionThemeData(
          pressScale: 0.9,
        ),
      );
      
      expect((modifiedExtension as MotionThemeExtension).motionTheme.pressScale, 0.9);
    });

    test('should lerp between themes', () {
      const extension1 = MotionThemeExtension(
        motionTheme: MotionThemeData(
          pressScale: 0.97,
          pressOpacity: 0.95,
        ),
      );
      
      const extension2 = MotionThemeExtension(
        motionTheme: MotionThemeData(
          pressScale: 0.9,
          pressOpacity: 0.8,
        ),
      );
      
      final lerpedExtension = extension1.lerp(extension2, 0.5);
      
      expect((lerpedExtension as MotionThemeExtension).motionTheme.pressScale, closeTo(0.935, 0.001));
      expect(lerpedExtension.motionTheme.pressOpacity, closeTo(0.875, 0.001));
    });
  });
}

/// Test VSync for animation controllers
class TestVSync extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}
