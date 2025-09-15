/// Widget tests for error mapper functionality
///
/// Tests that each error type maps to correct UI messages,
/// titles, and actions.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:yole_final/core/errors/app_error.dart';
import 'package:yole_final/core/errors/error_mapper.dart';

void main() {
  group('ErrorMapper Tests', () {
    group('UI Message Mapping', () {
      test('should map network errors to appropriate messages', () {
        final error = AppError.network();
        final message = ErrorMapper.uiMessage(error);
        
        expect(message, contains('Network connection failed'));
        expect(message, contains('internet connection'));
      });

      test('should map network errors with specific codes', () {
        final error = AppError.network(code: 'NO_INTERNET');
        final message = ErrorMapper.uiMessage(error);
        
        expect(message, contains('No internet connection'));
        expect(message, contains('network settings'));
      });

      test('should map timeout errors to appropriate messages', () {
        final error = AppError.timeout();
        final message = ErrorMapper.uiMessage(error);
        
        expect(message, contains('Request timed out'));
      });

      test('should map server errors to appropriate messages', () {
        final error = AppError.server();
        final message = ErrorMapper.uiMessage(error);
        
        expect(message, contains('servers are experiencing issues'));
      });

      test('should map validation errors to appropriate messages', () {
        final error = AppError.validation();
        final message = ErrorMapper.uiMessage(error);
        
        expect(message, contains('check your input'));
      });

      test('should map validation errors with specific codes', () {
        final error = AppError.validation(code: 'INVALID_EMAIL');
        final message = ErrorMapper.uiMessage(error);
        
        expect(message, contains('valid email address'));
      });

      test('should map unauthorized errors to appropriate messages', () {
        final error = AppError.unauthorized();
        final message = ErrorMapper.uiMessage(error);
        
        expect(message, contains('Access denied'));
      });

      test('should map unknown errors to appropriate messages', () {
        final error = AppError.unknown();
        final message = ErrorMapper.uiMessage(error);
        
        expect(message, contains('unexpected error occurred'));
      });

      test('should use detail message for unknown errors when available', () {
        final error = AppError.unknown(detail: 'Custom error message');
        final message = ErrorMapper.uiMessage(error);
        
        expect(message, equals('Custom error message'));
      });
    });

    group('UI Title Mapping', () {
      test('should map network errors to appropriate titles', () {
        final error = AppError.network();
        final title = ErrorMapper.uiTitle(error);
        
        expect(title, equals('Connection Problem'));
      });

      test('should map timeout errors to appropriate titles', () {
        final error = AppError.timeout();
        final title = ErrorMapper.uiTitle(error);
        
        expect(title, equals('Request Timeout'));
      });

      test('should map server errors to appropriate titles', () {
        final error = AppError.server();
        final title = ErrorMapper.uiTitle(error);
        
        expect(title, equals('Service Unavailable'));
      });

      test('should map validation errors to appropriate titles', () {
        final error = AppError.validation();
        final title = ErrorMapper.uiTitle(error);
        
        expect(title, equals('Invalid Input'));
      });

      test('should map unauthorized errors to appropriate titles', () {
        final error = AppError.unauthorized();
        final title = ErrorMapper.uiTitle(error);
        
        expect(title, equals('Access Denied'));
      });

      test('should map unknown errors to appropriate titles', () {
        final error = AppError.unknown();
        final title = ErrorMapper.uiTitle(error);
        
        expect(title, equals('Something Went Wrong'));
      });
    });

    group('Suggested Action Mapping', () {
      test('should map network errors to appropriate actions', () {
        final error = AppError.network();
        final action = ErrorMapper.suggestedAction(error);
        
        expect(action, contains('Check your internet connection'));
      });

      test('should map timeout errors to appropriate actions', () {
        final error = AppError.timeout();
        final action = ErrorMapper.suggestedAction(error);
        
        expect(action, contains('taking longer than expected'));
      });

      test('should map server errors to appropriate actions', () {
        final error = AppError.server();
        final action = ErrorMapper.suggestedAction(error);
        
        expect(action, contains('servers are experiencing issues'));
      });

      test('should map validation errors to appropriate actions', () {
        final error = AppError.validation();
        final action = ErrorMapper.suggestedAction(error);
        
        expect(action, contains('check your input'));
      });

      test('should map unauthorized errors to appropriate actions', () {
        final error = AppError.unauthorized();
        final action = ErrorMapper.suggestedAction(error);
        
        expect(action, contains('sign in again'));
      });

      test('should map unknown errors to appropriate actions', () {
        final error = AppError.unknown();
        final action = ErrorMapper.suggestedAction(error);
        
        expect(action, contains('try again or contact support'));
      });
    });

    group('Icon Name Mapping', () {
      test('should map network errors to appropriate icons', () {
        final error = AppError.network();
        final iconName = ErrorMapper.iconName(error);
        
        expect(iconName, equals('wifi_off'));
      });

      test('should map timeout errors to appropriate icons', () {
        final error = AppError.timeout();
        final iconName = ErrorMapper.iconName(error);
        
        expect(iconName, equals('schedule'));
      });

      test('should map server errors to appropriate icons', () {
        final error = AppError.server();
        final iconName = ErrorMapper.iconName(error);
        
        expect(iconName, equals('error_outline'));
      });

      test('should map validation errors to appropriate icons', () {
        final error = AppError.validation();
        final iconName = ErrorMapper.iconName(error);
        
        expect(iconName, equals('warning'));
      });

      test('should map unauthorized errors to appropriate icons', () {
        final error = AppError.unauthorized();
        final iconName = ErrorMapper.iconName(error);
        
        expect(iconName, equals('lock'));
      });

      test('should map unknown errors to appropriate icons', () {
        final error = AppError.unknown();
        final iconName = ErrorMapper.iconName(error);
        
        expect(iconName, equals('help_outline'));
      });
    });

    group('Retry Label Mapping', () {
      test('should map network errors to appropriate retry labels', () {
        final error = AppError.network();
        final retryLabel = ErrorMapper.retryLabel(error);
        
        expect(retryLabel, equals('Try Again'));
      });

      test('should map timeout errors to appropriate retry labels', () {
        final error = AppError.timeout();
        final retryLabel = ErrorMapper.retryLabel(error);
        
        expect(retryLabel, equals('Retry'));
      });

      test('should map server errors to appropriate retry labels', () {
        final error = AppError.server();
        final retryLabel = ErrorMapper.retryLabel(error);
        
        expect(retryLabel, equals('Try Again'));
      });

      test('should map validation errors to appropriate retry labels', () {
        final error = AppError.validation();
        final retryLabel = ErrorMapper.retryLabel(error);
        
        expect(retryLabel, equals('Fix & Retry'));
      });

      test('should map unauthorized errors to appropriate retry labels', () {
        final error = AppError.unauthorized();
        final retryLabel = ErrorMapper.retryLabel(error);
        
        expect(retryLabel, equals('Sign In Again'));
      });

      test('should map unknown errors to appropriate retry labels', () {
        final error = AppError.unknown();
        final retryLabel = ErrorMapper.retryLabel(error);
        
        expect(retryLabel, equals('Try Again'));
      });
    });

    group('Help Label Mapping', () {
      test('should map network errors to appropriate help labels', () {
        final error = AppError.network();
        final helpLabel = ErrorMapper.helpLabel(error);
        
        expect(helpLabel, equals('Check Connection'));
      });

      test('should map timeout errors to appropriate help labels', () {
        final error = AppError.timeout();
        final helpLabel = ErrorMapper.helpLabel(error);
        
        expect(helpLabel, equals('Get Help'));
      });

      test('should map server errors to appropriate help labels', () {
        final error = AppError.server();
        final helpLabel = ErrorMapper.helpLabel(error);
        
        expect(helpLabel, equals('Contact Support'));
      });

      test('should map validation errors to appropriate help labels', () {
        final error = AppError.validation();
        final helpLabel = ErrorMapper.helpLabel(error);
        
        expect(helpLabel, equals('Get Help'));
      });

      test('should map unauthorized errors to appropriate help labels', () {
        final error = AppError.unauthorized();
        final helpLabel = ErrorMapper.helpLabel(error);
        
        expect(helpLabel, equals('Contact Support'));
      });

      test('should map unknown errors to appropriate help labels', () {
        final error = AppError.unknown();
        final helpLabel = ErrorMapper.helpLabel(error);
        
        expect(helpLabel, equals('Get Help'));
      });
    });

    group('Should Show Retry', () {
      test('should show retry for retryable errors', () {
        final networkError = AppError.network();
        final timeoutError = AppError.timeout();
        final serverError = AppError.server();
        
        expect(ErrorMapper.shouldShowRetry(networkError), isTrue);
        expect(ErrorMapper.shouldShowRetry(timeoutError), isTrue);
        expect(ErrorMapper.shouldShowRetry(serverError), isTrue);
      });

      test('should not show retry for non-retryable errors', () {
        final validationError = AppError.validation();
        final unauthorizedError = AppError.unauthorized();
        final unknownError = AppError.unknown();
        
        expect(ErrorMapper.shouldShowRetry(validationError), isFalse);
        expect(ErrorMapper.shouldShowRetry(unauthorizedError), isFalse);
        expect(ErrorMapper.shouldShowRetry(unknownError), isFalse);
      });
    });

    group('Should Show Help', () {
      test('should show help for appropriate error types', () {
        final timeoutError = AppError.timeout();
        final serverError = AppError.server();
        final unauthorizedError = AppError.unauthorized();
        final unknownError = AppError.unknown();
        
        expect(ErrorMapper.shouldShowHelp(timeoutError), isTrue);
        expect(ErrorMapper.shouldShowHelp(serverError), isTrue);
        expect(ErrorMapper.shouldShowHelp(unauthorizedError), isTrue);
        expect(ErrorMapper.shouldShowHelp(unknownError), isTrue);
      });

      test('should not show help for self-resolvable errors', () {
        final networkError = AppError.network();
        final validationError = AppError.validation();
        
        expect(ErrorMapper.shouldShowHelp(networkError), isFalse);
        expect(ErrorMapper.shouldShowHelp(validationError), isFalse);
      });
    });

    group('Edge Cases', () {
      test('should handle errors with null codes gracefully', () {
        final error = AppError.network(code: null);
        final message = ErrorMapper.uiMessage(error);
        
        expect(message, isNotEmpty);
        expect(message, contains('Network connection failed'));
      });

      test('should handle errors with empty codes gracefully', () {
        final error = AppError.network(code: '');
        final message = ErrorMapper.uiMessage(error);
        
        expect(message, isNotEmpty);
        expect(message, contains('Network connection failed'));
      });

      test('should handle errors with unknown codes gracefully', () {
        final error = AppError.network(code: 'UNKNOWN_CODE');
        final message = ErrorMapper.uiMessage(error);
        
        expect(message, isNotEmpty);
        expect(message, contains('Network connection failed'));
      });
    });
  });
}
