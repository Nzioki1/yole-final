/// Widget tests for network tile component
///
/// Tests:
/// - Network tile display and states
/// - Fee preview functionality
/// - Accessibility features
/// - Disabled states and validation
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yole_final/ui/components/network_tile.dart';
import 'package:yole_final/features/send/state/send_state.dart';
import 'package:yole_final/core/money.dart';

void main() {
  group('NetworkTile Tests', () {
    late NetworkInfo mockNetwork;

    setUp(() {
      mockNetwork = const NetworkInfo(
        id: 'mpesa',
        name: 'M-Pesa',
        type: NetworkType.mobileMoney,
        country: 'Kenya',
        currency: 'KES',
        minAmount: 10.0,
        maxAmount: 150000.0,
        feePercentage: 1.5,
        fixedFee: 0.0,
        processingTimeMinutes: 5,
        isActive: true,
        isRecommended: true,
      );
    });

    testWidgets('should display network information correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: mockNetwork,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('M-Pesa'), findsOneWidget);
      expect(find.text('Kenya • KES'), findsOneWidget);
      expect(find.text('Recommended'), findsOneWidget);
      expect(find.text('5m'), findsOneWidget);
    });

    testWidgets('should show selected state correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: mockNetwork,
              isSelected: true,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should show fee preview when available', (tester) async {
      final fee = Money.fromMajor(2.50, 'USD');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: mockNetwork,
              feePreview: fee,
              showFeePreview: true,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.textContaining('Fee:'), findsOneWidget);
      expect(find.textContaining('\$2.50'), findsOneWidget);
    });

    testWidgets('should not show fee preview when disabled', (tester) async {
      final fee = Money.fromMajor(2.50, 'USD');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: mockNetwork,
              feePreview: fee,
              showFeePreview: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.textContaining('Fee:'), findsNothing);
    });

    testWidgets('should show disabled state correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: mockNetwork,
              state: NetworkTileState.disabled,
              disabledReason: 'Minimum amount is \$10.00',
              onTap: null,
            ),
          ),
        ),
      );

      expect(find.text('Minimum amount is \$10.00'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('should show error state correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: mockNetwork,
              state: NetworkTileState.error,
              errorMessage: 'Network temporarily unavailable',
              onTap: null,
            ),
          ),
        ),
      );

      expect(find.text('Network temporarily unavailable'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should show loading state correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: mockNetwork,
              state: NetworkTileState.loading,
              onTap: null,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: mockNetwork,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(NetworkTile));
      expect(tapped, isTrue);
    });

    testWidgets('should not call onTap when disabled', (tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: mockNetwork,
              state: NetworkTileState.disabled,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(NetworkTile));
      expect(tapped, isFalse);
    });

    testWidgets('should show limits information', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: mockNetwork,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('\$10.00 - \$150,000.00'), findsOneWidget);
    });

    testWidgets('should have correct accessibility properties', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: mockNetwork,
              isSelected: true,
              onTap: () {},
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(NetworkTile));
      expect(semantics.isSelected, isTrue);
      expect(semantics.isButton, isTrue);
      expect(semantics.label, contains('M-Pesa'));
      expect(semantics.label, contains('Selected'));
    });

    testWidgets('should display network logo when available', (tester) async {
      final networkWithLogo = mockNetwork.copyWith(
        logoUrl: 'https://example.com/logo.png',
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: networkWithLogo,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should show fallback icon when logo fails to load', (tester) async {
      final networkWithLogo = mockNetwork.copyWith(
        logoUrl: 'https://invalid-url.com/logo.png',
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: networkWithLogo,
              onTap: () {},
            ),
          ),
        ),
      );

      // Should show fallback icon after image fails to load
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.phone_android), findsOneWidget);
    });

    testWidgets('should display different network types with correct icons', (tester) async {
      final bankNetwork = mockNetwork.copyWith(
        id: 'chase',
        name: 'Chase Bank',
        type: NetworkType.bankTransfer,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: bankNetwork,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.account_balance), findsOneWidget);
    });

    testWidgets('should format processing time correctly', (tester) async {
      final networkWithLongTime = mockNetwork.copyWith(
        processingTimeMinutes: 90,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: networkWithLongTime,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('1h 30m'), findsOneWidget);
    });

    testWidgets('should show currency validation error', (tester) async {
      final networkWithCurrency = mockNetwork.copyWith(
        requiredCurrency: 'KES',
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: networkWithCurrency,
              currentCurrency: 'USD',
              state: NetworkTileState.disabled,
              disabledReason: 'Only supports KES',
              onTap: null,
            ),
          ),
        ),
      );

      expect(find.text('Only supports KES'), findsOneWidget);
    });

    testWidgets('should show amount validation error', (tester) async {
      final amount = Money.fromMajor(5.0, 'USD');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: mockNetwork,
              amount: amount,
              state: NetworkTileState.disabled,
              disabledReason: 'Minimum amount is \$10.00',
              onTap: null,
            ),
          ),
        ),
      );

      expect(find.text('Minimum amount is \$10.00'), findsOneWidget);
    });

    testWidgets('should handle null amount gracefully', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: mockNetwork,
              amount: null,
              onTap: () {},
            ),
          ),
        ),
      );

      // Should not show fee preview when amount is null
      expect(find.textContaining('Fee:'), findsNothing);
    });

    testWidgets('should show recommended badge for recommended networks', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: mockNetwork,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Recommended'), findsOneWidget);
    });

    testWidgets('should not show recommended badge for non-recommended networks', (tester) async {
      final nonRecommendedNetwork = mockNetwork.copyWith(
        isRecommended: false,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkTile(
              network: nonRecommendedNetwork,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Recommended'), findsNothing);
    });
  });
}
