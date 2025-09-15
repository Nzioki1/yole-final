/// Integration tests for error handling system
///
/// Tests the complete error handling flow including:
/// - Error mapping to UI messages
/// - Retry functionality
/// - Error banner display
/// - Full-screen error display
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yole_final/core/errors/app_error.dart';
import 'package:yole_final/core/errors/error_mapper.dart';
import 'package:yole_final/core/errors/retry_policy.dart';
import 'package:yole_final/ui/errors/error_banner.dart';
import 'package:yole_final/ui/errors/error_fullscreen.dart';

void main() {
  group('Error Handling Integration Tests', () {
    group('Error Mapping Integration', () {
      testWidgets('should map all error types to appropriate UI messages', (tester) async {
        final errorTypes = [
          AppErrorType.network,
          AppErrorType.timeout,
          AppErrorType.server,
          AppErrorType.validation,
          AppErrorType.unauthorized,
          AppErrorType.unknown,
        ];

        for (final type in errorTypes) {
          final error = AppError(type: type);
          final message = ErrorMapper.uiMessage(error);
          final title = ErrorMapper.uiTitle(error);
          final suggestion = ErrorMapper.suggestedAction(error);

          // Verify all mappings return non-empty strings
          expect(message, isNotEmpty);
          expect(title, isNotEmpty);
          expect(suggestion, isNotEmpty);

          // Verify specific error type characteristics
          switch (type) {
            case AppErrorType.network:
              expect(message, contains('connection'));
              expect(title, contains('Connection'));
              break;
            case AppErrorType.timeout:
              expect(message, contains('timed out'));
              expect(title, contains('Timeout'));
              break;
            case AppErrorType.server:
              expect(message, contains('server'));
              expect(title, contains('Service'));
              break;
            case AppErrorType.validation:
              expect(message, contains('input'));
              expect(title, contains('Input'));
              break;
            case AppErrorType.unauthorized:
              expect(message, contains('denied'));
              expect(title, contains('Denied'));
              break;
            case AppErrorType.unknown:
              expect(message, contains('unexpected'));
              expect(title, contains('Wrong'));
              break;
          }
        }
      });

      testWidgets('should handle specific error codes correctly', (tester) async {
        final testCases = [
          (AppError.network(code: 'NO_INTERNET'), 'No internet connection'),
          (AppError.validation(code: 'INVALID_EMAIL'), 'valid email address'),
          (AppError.unauthorized(code: 'TOKEN_EXPIRED'), 'session has expired'),
          (AppError.server(code: 'MAINTENANCE'), 'performing maintenance'),
        ];

        for (final (error, expectedContent) in testCases) {
          final message = ErrorMapper.uiMessage(error);
          expect(message, contains(expectedContent));
        }
      });
    });

    group('Retry Policy Integration', () {
      test('should retry network errors with appropriate backoff', () async {
        const policy = RetryPolicy(
          maxAttempts: 4, // 1 initial + 3 retries = 4 total attempts
          baseDelayMs: 1, // Very short delay for testing
        );
        int attemptCount = 0;

        try {
          final result = await RetryManager.execute(
            () async {
              attemptCount++;
              if (attemptCount <= 2) {
                throw AppError.network();
              }
              return 'success';
            },
            policy: policy,
          );

          expect(result, equals('success'));
          expect(attemptCount, equals(3)); // Should succeed on third attempt
        } catch (e) {
          rethrow;
        }
      });

      test('should not retry validation errors', () async {
        const policy = RetryPolicy.network;
        int attemptCount = 0;

        expect(
          () async => await RetryManager.execute(
            () async {
              attemptCount++;
              throw AppError.validation();
            },
            policy: policy,
          ),
          throwsA(isA<AppError>()),
        );

        expect(attemptCount, equals(1)); // Should not retry
      });

      test('should respect custom retry logic', () async {
        const policy = RetryPolicy.network;
        int attemptCount = 0;

        final result = await RetryManager.execute(
          () async {
            attemptCount++;
            if (attemptCount == 1) {
              throw AppError.network();
            }
            return 'success';
          },
          policy: policy,
          shouldRetry: (error) => error is AppError && error.type == AppErrorType.network,
        );

        expect(result, equals('success'));
        expect(attemptCount, equals(2));
      });
    });

    group('Error Banner Integration', () {
      test('should map error types to correct retry button text', () {
        final networkError = AppError.network();
        final validationError = AppError.validation();
        final unauthorizedError = AppError.unauthorized();
        
        expect(ErrorMapper.retryLabel(networkError), equals('Try Again'));
        expect(ErrorMapper.retryLabel(validationError), equals('Fix & Retry'));
        expect(ErrorMapper.retryLabel(unauthorizedError), equals('Sign In Again'));
      });

      test('should map error types to correct help button text', () {
        final networkError = AppError.network();
        final timeoutError = AppError.timeout();
        final serverError = AppError.server();
        
        expect(ErrorMapper.helpLabel(networkError), equals('Check Connection'));
        expect(ErrorMapper.helpLabel(timeoutError), equals('Get Help'));
        expect(ErrorMapper.helpLabel(serverError), equals('Contact Support'));
      });

      testWidgets('should display error banner with correct message', (tester) async {
        final error = AppError.network(code: 'NO_INTERNET');
        bool retryPressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ErrorBanner(
                error: error,
                onRetry: () {
                  retryPressed = true;
                },
              ),
            ),
          ),
        );

        // Verify error message is displayed
        expect(find.textContaining('No internet connection'), findsOneWidget);
        
        // Verify retry button is present and functional
        expect(find.text('Try Again'), findsOneWidget);
        
        await tester.tap(find.text('Try Again'));
        expect(retryPressed, isTrue);
      });
    });

    group('Full-Screen Error Integration', () {
      test('should map error types to correct full-screen button text', () {
        final serverError = AppError.server(code: 'MAINTENANCE');
        final unauthorizedError = AppError.unauthorized(code: 'TOKEN_EXPIRED');
        
        expect(ErrorMapper.retryLabel(serverError), equals('Try Again'));
        expect(ErrorMapper.helpLabel(serverError), equals('Contact Support'));
        expect(ErrorMapper.retryLabel(unauthorizedError), equals('Sign In Again'));
        expect(ErrorMapper.helpLabel(unauthorizedError), equals('Contact Support'));
      });

      testWidgets('should display full-screen error correctly', (tester) async {
        final error = AppError.server(code: 'MAINTENANCE');
        bool retryPressed = false;
        bool helpPressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: ErrorFullScreen(
              error: error,
              onRetry: () {
                retryPressed = true;
              },
              onHelp: () {
                helpPressed = true;
              },
            ),
          ),
        );

        // Verify error title and message
        expect(find.text('Service Unavailable'), findsOneWidget);
        expect(find.textContaining('performing maintenance'), findsOneWidget);
        
        // Verify retry and help buttons
        expect(find.text('Try Again'), findsOneWidget);
        expect(find.text('Contact Support'), findsOneWidget);
        
        // Test button functionality
        await tester.tap(find.text('Try Again'));
        expect(retryPressed, isTrue);
        
        await tester.tap(find.text('Contact Support'));
        expect(helpPressed, isTrue);
      });
    });

    group('End-to-End Error Flow', () {
      test('should handle complete error flow from network failure to success', () async {
        // Simulate a network operation that fails first, then succeeds
        int attemptCount = 0;
        final errors = <AppError>[];
        
        Future<String> mockNetworkOperation() async {
          attemptCount++;
          if (attemptCount == 1) {
            final error = AppError.network(code: 'CONNECTION_REFUSED');
            errors.add(error);
            throw error;
          }
          return 'success';
        }

        // Test retry logic
        const policy = RetryPolicy(
          maxAttempts: 3,
          baseDelayMs: 1, // Very short delay for testing
        );

        final result = await RetryManager.execute(
          mockNetworkOperation,
          policy: policy,
        );

        // Verify the operation succeeded after retry
        expect(result, equals('success'));
        expect(attemptCount, equals(2));
        expect(errors.length, equals(1));
        expect(errors.first.type, equals(AppErrorType.network));
        expect(errors.first.code, equals('CONNECTION_REFUSED'));
      });

      test('should show appropriate UI mappings for different error types', () {
        final testCases = [
          (AppError.network(), 'Connection Problem', 'Try Again'),
          (AppError.validation(code: 'INVALID_AMOUNT'), 'Invalid Input', 'Fix & Retry'),
          (AppError.unauthorized(), 'Access Denied', 'Sign In Again'),
        ];

        for (final (error, expectedTitle, expectedButton) in testCases) {
          // Verify title and button text mappings
          expect(ErrorMapper.uiTitle(error), equals(expectedTitle));
          expect(ErrorMapper.retryLabel(error), equals(expectedButton));
        }
      });
    });

    group('Error Context and Metadata', () {
      test('should preserve error context through retry attempts', () async {
        final context = <String, dynamic>{
          'operation': 'fetch_recipients',
          'userId': '123',
          'timestamp': DateTime.now().toIso8601String(),
        };

        final error = AppError.network(
          code: 'CONNECTION_REFUSED',
          context: context,
        );

        // Verify context is preserved
        expect(error.context, equals(context));
        expect(error.context!['operation'], equals('fetch_recipients'));
        expect(error.context!['userId'], equals('123'));
      });

      test('should handle error from exception correctly', () async {
        final originalException = Exception('Original exception');
        final error = AppError.fromException(originalException);

        expect(error.type, equals(AppErrorType.unknown));
        expect(error.originalException, equals(originalException));
        expect(error.detail, contains('Original exception'));
      });

      test('should determine error display type correctly', () async {
        final networkError = AppError.network();
        final validationError = AppError.validation();
        final serverError = AppError.server();
        final unauthorizedError = AppError.unauthorized();

        // Test retryable property
        expect(networkError.isRetryable, isTrue);
        expect(validationError.isRetryable, isFalse);
        expect(serverError.isRetryable, isTrue);
        expect(unauthorizedError.isRetryable, isFalse);

        // Test display type properties
        expect(networkError.shouldShowInline, isTrue);
        expect(validationError.shouldShowInline, isTrue);
        expect(serverError.shouldShowFullScreen, isTrue);
        expect(unauthorizedError.shouldShowFullScreen, isTrue);
      });
    });
  });
}
