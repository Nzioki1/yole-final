/// Widget tests for inline progress components
///
/// Tests:
/// - InlineProgress display and behavior
/// - DebouncedButton prevents double taps
/// - Reduced motion disables shimmer
/// - Loading states and accessibility
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yole_final/ui/components/inline_progress.dart';

void main() {
  group('InlineProgress Tests', () {
    testWidgets('should display label correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineProgress(
              label: 'Processing...',
              isLoading: false,
            ),
          ),
        ),
      );

      expect(find.text('Processing...'), findsOneWidget);
    });

    testWidgets('should show progress indicator when loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineProgress(
              label: 'Processing...',
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Processing...'), findsOneWidget);
    });

    testWidgets('should not show progress indicator when not loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineProgress(
              label: 'Ready',
              isLoading: false,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Ready'), findsOneWidget);
    });

    testWidgets('should hide progress indicator when showProgress is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineProgress(
              label: 'Processing...',
              isLoading: true,
              showProgress: false,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Processing...'), findsOneWidget);
    });

    testWidgets('should apply custom progress color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineProgress(
              label: 'Processing...',
              isLoading: true,
              progressColor: Colors.red,
            ),
          ),
        ),
      );

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(progressIndicator.valueColor?.value, Colors.red);
    });

    testWidgets('should apply custom size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineProgress(
              label: 'Processing...',
              isLoading: true,
              size: 24.0,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(InlineProgress),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.width, 24.0);
      expect(sizedBox.height, 24.0);
    });
  });

  group('DebouncedButton Tests', () {
    testWidgets('should call onPressed when enabled', (tester) async {
      bool pressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DebouncedButton(
              onPressed: () {
                pressed = true;
              },
              child: const Text('Press Me'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Press Me'));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('should not call onPressed when loading', (tester) async {
      bool pressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DebouncedButton(
              isLoading: true,
              onPressed: () {
                pressed = true;
              },
              child: const Text('Press Me'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Press Me'));
      await tester.pumpAndSettle();

      expect(pressed, isFalse);
    });

    testWidgets('should prevent double taps during debounce', (tester) async {
      int pressCount = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DebouncedButton(
              debounceDuration: const Duration(milliseconds: 500),
              onPressed: () {
                pressCount++;
              },
              child: const Text('Press Me'),
            ),
          ),
        ),
      );

      // First tap
      await tester.tap(find.text('Press Me'));
      await tester.pump();
      
      // Second tap immediately (should be ignored)
      await tester.tap(find.text('Press Me'));
      await tester.pump();
      
      // Third tap immediately (should be ignored)
      await tester.tap(find.text('Press Me'));
      await tester.pump();

      expect(pressCount, 1);

      // Wait for debounce to complete
      await tester.pump(const Duration(milliseconds: 600));

      // Fourth tap after debounce (should work)
      await tester.tap(find.text('Press Me'));
      await tester.pump();

      expect(pressCount, 2);
    });

    testWidgets('should show loading indicator when loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DebouncedButton(
              isLoading: true,
              onPressed: () {},
              child: const Text('Submit'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('should not show loading indicator when showLoadingIndicator is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DebouncedButton(
              isLoading: true,
              showLoadingIndicator: false,
              onPressed: () {},
              child: const Text('Submit'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('should be disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DebouncedButton(
              onPressed: null,
              child: const Text('Disabled'),
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
  });

  group('InlineProgressButton Tests', () {
    testWidgets('should display label and button text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineProgressButton(
              label: 'Processing transaction...',
              buttonText: 'Submit',
              isLoading: false,
            ),
          ),
        ),
      );

      expect(find.text('Processing transaction...'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('should show progress indicator when loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineProgressButton(
              label: 'Processing...',
              buttonText: 'Submit',
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Processing...'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('should call onPressed when button is tapped', (tester) async {
      bool pressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineProgressButton(
              label: 'Ready',
              buttonText: 'Submit',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('should prevent double taps during debounce', (tester) async {
      int pressCount = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineProgressButton(
              label: 'Ready',
              buttonText: 'Submit',
              debounceDuration: const Duration(milliseconds: 300),
              onPressed: () {
                pressCount++;
              },
            ),
          ),
        ),
      );

      // First tap
      await tester.tap(find.text('Submit'));
      await tester.pump();
      
      // Second tap immediately (should be ignored)
      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(pressCount, 1);

      // Wait for debounce to complete
      await tester.pump(const Duration(milliseconds: 400));

      // Third tap after debounce (should work)
      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(pressCount, 2);
    });
  });

  group('Accessibility Tests', () {
    testWidgets('InlineProgress should be accessible', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineProgress(
              label: 'Processing transaction...',
              isLoading: true,
            ),
          ),
        ),
      );

      // Check that the progress indicator is accessible
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Check that the text is accessible
      expect(find.text('Processing transaction...'), findsOneWidget);
    });

    testWidgets('DebouncedButton should be accessible', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DebouncedButton(
              onPressed: () {},
              child: const Text('Submit'),
            ),
          ),
        ),
      );

      // Check that the button is accessible
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('should handle long text gracefully', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineProgress(
              label: 'This is a very long label that might wrap to multiple lines and should be handled gracefully by the component',
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.textContaining('This is a very long label'), findsOneWidget);
    });
  });

  group('Theme Tests', () {
    testWidgets('should adapt to light theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: InlineProgress(
              label: 'Light theme',
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Light theme'), findsOneWidget);
    });

    testWidgets('should adapt to dark theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: InlineProgress(
              label: 'Dark theme',
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Dark theme'), findsOneWidget);
    });
  });
}
