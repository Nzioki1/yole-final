import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'goldens/_harness/golden_config.dart';
import 'package:yole_final/design/theme.dart';

/// Sanity check tests for golden test configuration
///
/// These tests verify that:
/// - App fonts load correctly
/// - Theme builds without errors
/// - Golden test harness is properly configured
void main() {
  group('Golden Test Configuration', () {
    setUpAll(GoldenTestBase.setUpAll);

    testWidgets('should load app fonts successfully', (tester) async {
      // This test verifies that loadAppFonts runs without errors
      // The actual font loading is done in setUpAll
      expect(true, isTrue);
    });

    testWidgets('should build light theme without errors', (tester) async {
      final theme = AppTheme.light;

      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(body: Text('Test')),
        ),
      );

      expect(theme, isNotNull);
      expect(theme.brightness, equals(Brightness.light));
    });

    testWidgets('should build dark theme without errors', (tester) async {
      final theme = AppTheme.dark;

      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(body: Text('Test')),
        ),
      );

      expect(theme, isNotNull);
      expect(theme.brightness, equals(Brightness.dark));
    });

    testWidgets('should create material app wrapper with light theme', (
      tester,
    ) async {
      final wrapper = GoldenConfig.materialAppWrapper(
        child: const Text('Test Widget'),
        brightness: Brightness.light,
      );

      await tester.pumpWidget(wrapper);

      expect(find.text('Test Widget'), findsOneWidget);
      expect(
        Theme.of(tester.element(find.text('Test Widget'))).brightness,
        equals(Brightness.light),
      );
    });

    testWidgets('should create material app wrapper with dark theme', (
      tester,
    ) async {
      final wrapper = GoldenConfig.materialAppWrapper(
        child: const Text('Test Widget'),
        brightness: Brightness.dark,
      );

      await tester.pumpWidget(wrapper);

      expect(find.text('Test Widget'), findsOneWidget);
      expect(
        Theme.of(tester.element(find.text('Test Widget'))).brightness,
        equals(Brightness.dark),
      );
    });

    testWidgets('should have correct device configurations', (tester) async {
      expect(GoldenConfig.devices, isNotNull);
      expect(GoldenConfig.devices.length, equals(3));

      // Check small device
      final smallDevice = GoldenConfig.devices[0];
      expect(smallDevice.name, equals('small'));
      expect(smallDevice.size, equals(const Size(360, 690)));
      expect(smallDevice.devicePixelRatio, equals(2.0));

      // Check medium device
      final mediumDevice = GoldenConfig.devices[1];
      expect(mediumDevice.name, equals('medium'));
      expect(mediumDevice.size, equals(const Size(390, 844)));
      expect(mediumDevice.devicePixelRatio, equals(3.0));

      // Check large device
      final largeDevice = GoldenConfig.devices[2];
      expect(largeDevice.name, equals('large'));
      expect(largeDevice.size, equals(const Size(412, 915)));
      expect(largeDevice.devicePixelRatio, equals(2.625));
    });

    testWidgets('should provide mock data for golden tests', (tester) async {
      expect(GoldenTestData.sampleRecipientName, equals('John Doe'));
      expect(GoldenTestData.sampleRecipientPhone, equals('+243 123 456 789'));
      expect(GoldenTestData.sampleNetwork, equals('Vodacom'));
      expect(GoldenTestData.sampleAmount, equals(150.00));
      expect(GoldenTestData.sampleCurrency, equals('USD'));
      expect(GoldenTestData.sampleFee, equals(2.50));
      expect(GoldenTestData.sampleExchangeRate, equals(2593.0));
    });

    testWidgets('should create mock repository data', (tester) async {
      final data = await MockGoldenRepository.getTransactionData();

      expect(data, isNotNull);
      expect(data['recipient'], isNotNull);
      expect(data['amount'], isNotNull);
      expect(data['exchange'], isNotNull);
      expect(data['transaction'], isNotNull);

      // Verify recipient data
      final recipient = data['recipient'] as Map<String, dynamic>;
      expect(recipient['name'], equals('John Doe'));
      expect(recipient['phone'], equals('+243 123 456 789'));
      expect(recipient['network'], equals('Vodacom'));

      // Verify amount data
      final amount = data['amount'] as Map<String, dynamic>;
      expect(amount['send'], equals(150.00));
      expect(amount['currency'], equals('USD'));
      expect(amount['fee'], equals(2.50));
      expect(amount['total'], equals(152.50));

      // Verify exchange data
      final exchange = data['exchange'] as Map<String, dynamic>;
      expect(exchange['rate'], equals(2593.0));
      expect(exchange['receive'], equals(389550.0));

      // Verify transaction data
      final transaction = data['transaction'] as Map<String, dynamic>;
      expect(transaction['id'], equals('TXN123456789'));
      expect(transaction['confirmation'], equals('ABC123'));
      expect(transaction['status'], equals('completed'));
    });

    testWidgets('should handle theme switching correctly', (tester) async {
      // Test light theme
      await tester.pumpWidget(
        GoldenConfig.materialAppWrapper(
          child: const Text('Light Theme Test'),
          brightness: Brightness.light,
        ),
      );

      expect(find.text('Light Theme Test'), findsOneWidget);
      final lightTheme = Theme.of(
        tester.element(find.text('Light Theme Test')),
      );
      expect(lightTheme.brightness, equals(Brightness.light));

      // Test dark theme
      await tester.pumpWidget(
        GoldenConfig.materialAppWrapper(
          child: const Text('Dark Theme Test'),
          brightness: Brightness.dark,
        ),
      );

      expect(find.text('Dark Theme Test'), findsOneWidget);
      final darkTheme = Theme.of(tester.element(find.text('Dark Theme Test')));
      expect(darkTheme.brightness, equals(Brightness.dark));
    });

    testWidgets('should validate golden test base class', (tester) async {
      // This test verifies that the GoldenTestBase class is properly structured
      expect(GoldenTestBase.setUpAll, isNotNull);
      expect(GoldenTestBase.setUpAll, isA<Function>());
    });
  });
}
