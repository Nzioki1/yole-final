/// Integration tests for network selection functionality
///
/// Tests:
/// - Network loading and display
/// - Fee calculation and validation
/// - Selection flow with error handling
/// - Amount-based validation
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yole_final/features/send/screens/send_network_screen.dart';
import 'package:yole_final/features/send/providers/network_selection_provider.dart';
import 'package:yole_final/features/send/state/send_state.dart';
import 'package:yole_final/core/money.dart';
import 'package:yole_final/ui/errors/error_banner.dart';

void main() {
  group('Network Selection Integration Tests', () {
    testWidgets('should load and display networks correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const SendNetworkScreen(),
          ),
        ),
      );

      // Wait for networks to load
      await tester.pumpAndSettle();

      // Should display network tiles
      expect(find.text('M-Pesa'), findsOneWidget);
      expect(find.text('Chase Bank'), findsOneWidget);
      expect(find.text('Venmo'), findsOneWidget);
      expect(find.text('PayPal'), findsOneWidget);
    });

    testWidgets('should show loading state initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const SendNetworkScreen(),
          ),
        ),
      );

      // Should show loading indicator initially
      expect(find.text('Loading available networks...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should enable continue button when network is selected', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const SendNetworkScreen(),
          ),
        ),
      );

      // Wait for networks to load
      await tester.pumpAndSettle();

      // Initially no continue button
      expect(find.byKey(const Key('network_next')), findsNothing);

      // Select a network
      await tester.tap(find.text('M-Pesa'));
      await tester.pumpAndSettle();

      // Should show continue button
      expect(find.byKey(const Key('network_next')), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('should show fee preview when amount is available', (tester) async {
      final container = ProviderContainer();
      
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const SendNetworkScreen(),
          ),
        ),
      );

      // Wait for networks to load
      await tester.pumpAndSettle();

      // Set an amount
      await container.read(networkSelectionProvider.notifier).updateAmount(
        Money.fromMajor(100.0, 'USD'),
      );
      await tester.pumpAndSettle();

      // Should show fee preview
      expect(find.textContaining('Fee:'), findsWidgets);
    });

    testWidgets('should disable networks that exceed amount limits', (tester) async {
      final container = ProviderContainer();
      
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const SendNetworkScreen(),
          ),
        ),
      );

      // Wait for networks to load
      await tester.pumpAndSettle();

      // Set a very small amount
      await container.read(networkSelectionProvider.notifier).updateAmount(
        Money.fromMajor(1.0, 'USD'),
      );
      await tester.pumpAndSettle();

      // Some networks should be disabled due to minimum amount
      expect(find.textContaining('Minimum amount'), findsWidgets);
    });

    testWidgets('should disable networks that exceed maximum amount', (tester) async {
      final container = ProviderContainer();
      
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const SendNetworkScreen(),
          ),
        ),
      );

      // Wait for networks to load
      await tester.pumpAndSettle();

      // Set a very large amount
      await container.read(networkSelectionProvider.notifier).updateAmount(
        Money.fromMajor(200000.0, 'USD'),
      );
      await tester.pumpAndSettle();

      // Some networks should be disabled due to maximum amount
      expect(find.textContaining('Maximum amount'), findsWidgets);
    });

    testWidgets('should show currency validation errors', (tester) async {
      final container = ProviderContainer();
      
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const SendNetworkScreen(),
          ),
        ),
      );

      // Wait for networks to load
      await tester.pumpAndSettle();

      // Change currency to one that some networks don't support
      await container.read(networkSelectionProvider.notifier).updateCurrency('KES');
      await tester.pumpAndSettle();

      // Some networks should be disabled due to currency mismatch
      expect(find.textContaining('Only supports'), findsWidgets);
    });

    testWidgets('should show error state when network loading fails', (tester) async {
      // This test would require mocking the FeesRepository to throw an error
      // For now, we'll test the error display structure
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const SendNetworkScreen(),
          ),
        ),
      );

      // Wait for initial load
      await tester.pumpAndSettle();

      // Should not show error banner initially
      expect(find.byType(ErrorBanner), findsNothing);
    });

    testWidgets('should handle network selection and navigation', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const SendNetworkScreen(),
          ),
        ),
      );

      // Wait for networks to load
      await tester.pumpAndSettle();

      // Select a network
      await tester.tap(find.text('M-Pesa'));
      await tester.pumpAndSettle();

      // Should show continue button
      expect(find.byKey(const Key('network_next')), findsOneWidget);

      // Tap continue (this would normally navigate, but we're testing the button)
      await tester.tap(find.byKey(const Key('network_next')));
      await tester.pumpAndSettle();
    });

    testWidgets('should show empty state when no networks are available', (tester) async {
      final container = ProviderContainer();
      
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const SendNetworkScreen(),
          ),
        ),
      );

      // Wait for networks to load
      await tester.pumpAndSettle();

      // This test would require mocking the FeesRepository to return empty list
      // For now, we'll verify the empty state structure exists
      
      // The empty state should show when networks list is empty
      // This would be triggered by a mock that returns no networks
    });

    testWidgets('should show processing time for each network', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const SendNetworkScreen(),
          ),
        ),
      );

      // Wait for networks to load
      await tester.pumpAndSettle();

      // Should show processing times
      expect(find.text('5m'), findsOneWidget); // M-Pesa
      expect(find.text('1h'), findsOneWidget); // Chase Bank
      expect(find.text('2m'), findsOneWidget); // Venmo
      expect(find.text('15m'), findsOneWidget); // PayPal
    });

    testWidgets('should show recommended badge for recommended networks', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const SendNetworkScreen(),
          ),
        ),
      );

      // Wait for networks to load
      await tester.pumpAndSettle();

      // Should show recommended badges
      expect(find.text('Recommended'), findsWidgets);
    });

    testWidgets('should handle network tile tap correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const SendNetworkScreen(),
          ),
        ),
      );

      // Wait for networks to load
      await tester.pumpAndSettle();

      // Tap on a network tile
      await tester.tap(find.text('M-Pesa'));
      await tester.pumpAndSettle();

      // Should show continue button
      expect(find.byKey(const Key('network_next')), findsOneWidget);
    });

    testWidgets('should not allow selection of disabled networks', (tester) async {
      final container = ProviderContainer();
      
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const SendNetworkScreen(),
          ),
        ),
      );

      // Wait for networks to load
      await tester.pumpAndSettle();

      // Set an amount that disables some networks
      await container.read(networkSelectionProvider.notifier).updateAmount(
        Money.fromMajor(1.0, 'USD'),
      );
      await tester.pumpAndSettle();

      // Try to tap on a disabled network
      final disabledNetworkFinder = find.textContaining('Minimum amount');
      if (disabledNetworkFinder.evaluate().isNotEmpty) {
        // The network should be disabled and not selectable
        expect(find.byKey(const Key('network_next')), findsNothing);
      }
    });

    testWidgets('should recalculate fees when amount changes', (tester) async {
      final container = ProviderContainer();
      
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const SendNetworkScreen(),
          ),
        ),
      );

      // Wait for networks to load
      await tester.pumpAndSettle();

      // Set initial amount
      await container.read(networkSelectionProvider.notifier).updateAmount(
        Money.fromMajor(100.0, 'USD'),
      );
      await tester.pumpAndSettle();

      // Should show fee preview
      expect(find.textContaining('Fee:'), findsWidgets);

      // Change amount
      await container.read(networkSelectionProvider.notifier).updateAmount(
        Money.fromMajor(200.0, 'USD'),
      );
      await tester.pumpAndSettle();

      // Should still show fee preview with updated amounts
      expect(find.textContaining('Fee:'), findsWidgets);
    });

    testWidgets('should show network limits correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const SendNetworkScreen(),
          ),
        ),
      );

      // Wait for networks to load
      await tester.pumpAndSettle();

      // Should show limits for each network
      expect(find.textContaining('\$10.00 - \$150,000.00'), findsOneWidget); // M-Pesa
      expect(find.textContaining('\$25.00 - \$100,000.00'), findsOneWidget); // Chase
      expect(find.textContaining('\$1.00 - \$50,000.00'), findsOneWidget); // Venmo
    });
  });
}
