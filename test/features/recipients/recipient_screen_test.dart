import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yole_final/features/send/screens/send_recipient_screen.dart';
import 'package:yole_final/features/recipients/recipient_notifier.dart';
import 'package:yole_final/features/recipients/recipient_repo.dart';
import 'package:yole_final/features/recipients/dev_mock_recipient_repo.dart';
import '../../_harness/test_app.dart';
import '../../_harness/recipient_test_router.dart';

void main() {
  group('Recipient Screen Tests', () {
    testWidgets('Shows recent recipients initially', (tester) async {
      final overrides = <Override>[
        recipientRepoProvider.overrideWithValue(DevMockRecipientRepo()),
      ];

      await tester.pumpWidget(
        TestApp(router: recipientTestRouter, overrides: overrides),
      );
      await tester.pumpAndSettle();

      // Verify screen loads
      expect(find.text('Who are you sending money to?'), findsOneWidget);
      expect(find.text('Search by name, phone, or email'), findsOneWidget);

      // Verify recipients are loaded
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Mary W.'), findsOneWidget);
      expect(find.text('Acme Traders'), findsOneWidget);

      // Verify recipient items have correct keys
      expect(find.byKey(const Key('recipient_item_r1')), findsOneWidget);
      expect(find.byKey(const Key('recipient_item_r2')), findsOneWidget);
      expect(find.byKey(const Key('recipient_item_r3')), findsOneWidget);
    });

    testWidgets('Filters recipients by search query', (tester) async {
      final overrides = <Override>[
        recipientRepoProvider.overrideWithValue(DevMockRecipientRepo()),
      ];

      await tester.pumpWidget(
        TestApp(router: recipientTestRouter, overrides: overrides),
      );
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byKey(const Key('recipient_input')), 'Mary');
      await tester.pumpAndSettle();

      // Verify only Mary is shown
      expect(find.text('Mary W.'), findsOneWidget);
      expect(find.text('John Doe'), findsNothing);
      expect(find.text('Acme Traders'), findsNothing);
    });

    testWidgets('Tapping recipient navigates to next screen', (tester) async {
      final overrides = <Override>[
        recipientRepoProvider.overrideWithValue(DevMockRecipientRepo()),
      ];

      await tester.pumpWidget(
        TestApp(router: recipientTestRouter, overrides: overrides),
      );
      await tester.pumpAndSettle();

      // Verify we're on the recipient screen
      expect(find.text('Who are you sending money to?'), findsOneWidget);

      // Tap on a recipient
      await tester.tap(find.byKey(const Key('recipient_item_r1')));
      await tester.pumpAndSettle();

      // Verify navigation occurred - we should now be on the network screen
      expect(find.text('Network Screen'), findsOneWidget);
    });
  });
}
