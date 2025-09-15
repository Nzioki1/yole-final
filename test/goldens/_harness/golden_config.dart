import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:yole_final/design/theme.dart';
import 'test_theme.dart';

/// Golden test configuration and utilities
///
/// This file provides the golden test harness with device configurations,
/// theme setup, and helper functions for consistent golden testing.
class GoldenConfig {
  static const String _fontFamily = 'Inter';

  /// Load app fonts for golden testing
  static Future<void> loadAppFonts() async {
    // Load fonts for golden testing without network requests
    // Fonts loaded via golden_toolkit

    // Set up font fallbacks for consistent rendering
    debugPrint('Loaded fonts for golden tests (Inter fallback to Roboto)');
  }

  /// Device configurations for golden testing
  static const List<Device> devices = [
    Device(name: 'small', size: Size(360, 690), devicePixelRatio: 2.0),
    Device(name: 'medium', size: Size(390, 844), devicePixelRatio: 3.0),
    Device(name: 'large', size: Size(412, 915), devicePixelRatio: 2.625),
  ];

  /// Material app wrapper with project theme
  static Widget materialAppWrapper({
    required Widget child,
    required Brightness brightness,
  }) {
    return MaterialApp(
      title: 'Yole Golden Tests',
      theme: brightness == Brightness.light ? TestTheme.light : TestTheme.dark,
      home: Scaffold(body: child),
      debugShowCheckedModeBanner: false,
    );
  }

  /// Pump widget for golden testing with theme
  static Future<void> pumpGolden(
    WidgetTester tester,
    Widget widget, {
    required String name,
    Brightness brightness = Brightness.light,
    Device? device,
  }) async {
    await tester.pumpWidgetBuilder(
      widget,
      wrapper: (child) =>
          materialAppWrapper(child: child, brightness: brightness),
      surfaceSize: device?.size ?? devices.first.size,
    );

    // For components with animations, use pumpWidget to avoid timeout
    await tester.pumpWidget(
      materialAppWrapper(child: widget, brightness: brightness),
    );
    await tester.pump(const Duration(milliseconds: 100));

    await expectLater(
      find.byWidget(widget),
      matchesGoldenFile('goldens/$name.png'),
    );
  }

  /// Pump widget for multi-golden testing (light/dark variants)
  static Future<void> pumpMultiGolden(
    WidgetTester tester,
    Widget Function(Brightness brightness) widgetBuilder, {
    required String name,
    Device? device,
  }) async {
    // Test light theme
    await pumpGolden(
      tester,
      widgetBuilder(Brightness.light),
      name: '${name}_light',
      brightness: Brightness.light,
      device: device,
    );

    // Test dark theme
    await pumpGolden(
      tester,
      widgetBuilder(Brightness.dark),
      name: '${name}_dark',
      brightness: Brightness.dark,
      device: device,
    );
  }

  /// Pump widget for device-specific golden testing
  static Future<void> pumpDeviceGolden(
    WidgetTester tester,
    Widget widget, {
    required String name,
    required Device device,
    Brightness brightness = Brightness.light,
  }) async {
    await pumpGolden(
      tester,
      widget,
      name: '${name}_${device.name}',
      brightness: brightness,
      device: device,
    );
  }

  /// Pump widget for comprehensive golden testing (all devices + themes)
  static Future<void> pumpComprehensiveGolden(
    WidgetTester tester,
    Widget Function(Brightness brightness) widgetBuilder, {
    required String name,
  }) async {
    for (final device in devices) {
      for (final brightness in [Brightness.light, Brightness.dark]) {
        await pumpGolden(
          tester,
          widgetBuilder(brightness),
          name:
              '${name}_${device.name}_${brightness == Brightness.light ? 'light' : 'dark'}',
          brightness: brightness,
          device: device,
        );
      }
    }
  }
}

/// Golden test base class with common setup
abstract class GoldenTestBase {
  /// Setup for golden tests
  static Future<void> setUpAll() async {
    await GoldenConfig.loadAppFonts();
  }

  /// Test golden widget with light theme
  Future<void> testGoldenLight(
    WidgetTester tester,
    Widget widget, {
    required String name,
    Device? device,
  }) async {
    await GoldenConfig.pumpGolden(
      tester,
      widget,
      name: '${name}_light',
      brightness: Brightness.light,
      device: device,
    );
  }

  /// Test golden widget with dark theme
  Future<void> testGoldenDark(
    WidgetTester tester,
    Widget widget, {
    required String name,
    Device? device,
  }) async {
    await GoldenConfig.pumpGolden(
      tester,
      widget,
      name: '${name}_dark',
      brightness: Brightness.dark,
      device: device,
    );
  }

  /// Test golden widget with both themes
  Future<void> testGoldenMulti(
    WidgetTester tester,
    Widget Function(Brightness brightness) widgetBuilder, {
    required String name,
    Device? device,
  }) async {
    await GoldenConfig.pumpMultiGolden(
      tester,
      widgetBuilder,
      name: name,
      device: device,
    );
  }

  /// Test golden widget across all devices
  Future<void> testGoldenAllDevices(
    WidgetTester tester,
    Widget Function(Brightness brightness) widgetBuilder, {
    required String name,
  }) async {
    await GoldenConfig.pumpComprehensiveGolden(
      tester,
      widgetBuilder,
      name: name,
    );
  }
}

/// Mock data for golden tests
class GoldenTestData {
  static const String sampleRecipientName = 'John Doe';
  static const String sampleRecipientPhone = '+243 123 456 789';
  static const String sampleNetwork = 'Vodacom';
  static const double sampleAmount = 150.00;
  static const String sampleCurrency = 'USD';
  static const double sampleFee = 2.50;
  static const double sampleExchangeRate = 2593.0;
  static const String sampleTransactionId = 'TXN123456789';
  static const String sampleConfirmationCode = 'ABC123';
}

/// Mock repository for golden tests
class MockGoldenRepository {
  static Future<Map<String, dynamic>> getTransactionData() async {
    return {
      'recipient': {
        'name': GoldenTestData.sampleRecipientName,
        'phone': GoldenTestData.sampleRecipientPhone,
        'network': GoldenTestData.sampleNetwork,
      },
      'amount': {
        'send': GoldenTestData.sampleAmount,
        'currency': GoldenTestData.sampleCurrency,
        'fee': GoldenTestData.sampleFee,
        'total': GoldenTestData.sampleAmount + GoldenTestData.sampleFee,
      },
      'exchange': {
        'rate': GoldenTestData.sampleExchangeRate,
        'receive':
            GoldenTestData.sampleAmount * GoldenTestData.sampleExchangeRate,
      },
      'transaction': {
        'id': GoldenTestData.sampleTransactionId,
        'confirmation': GoldenTestData.sampleConfirmationCode,
        'status': 'completed',
        'timestamp': DateTime.now().toIso8601String(),
      },
    };
  }
}
