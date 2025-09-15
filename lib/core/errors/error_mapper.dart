/// Error mapper for converting AppError to user-friendly messages
///
/// Provides consistent error message mapping with localization support
/// and fallback messages for all error types.
library;

import 'app_error.dart';

/// Maps AppError to user-friendly UI messages
class ErrorMapper {
  /// Maps an AppError to a user-friendly message
  static String uiMessage(AppError error) {
    switch (error.type) {
      case AppErrorType.network:
        return _getNetworkMessage(error);
      case AppErrorType.timeout:
        return _getTimeoutMessage(error);
      case AppErrorType.server:
        return _getServerMessage(error);
      case AppErrorType.validation:
        return _getValidationMessage(error);
      case AppErrorType.unauthorized:
        return _getUnauthorizedMessage(error);
      case AppErrorType.unknown:
        return _getUnknownMessage(error);
    }
  }

  /// Gets a short title for the error
  static String uiTitle(AppError error) {
    switch (error.type) {
      case AppErrorType.network:
        return 'Connection Problem';
      case AppErrorType.timeout:
        return 'Request Timeout';
      case AppErrorType.server:
        return 'Service Unavailable';
      case AppErrorType.validation:
        return 'Invalid Input';
      case AppErrorType.unauthorized:
        return 'Access Denied';
      case AppErrorType.unknown:
        return 'Something Went Wrong';
    }
  }

  /// Gets a suggested action for the error
  static String suggestedAction(AppError error) {
    switch (error.type) {
      case AppErrorType.network:
        return 'Check your internet connection and try again';
      case AppErrorType.timeout:
        return 'The request is taking longer than expected. Please try again';
      case AppErrorType.server:
        return 'Our servers are experiencing issues. Please try again later';
      case AppErrorType.validation:
        return 'Please check your input and try again';
      case AppErrorType.unauthorized:
        return 'Please sign in again or contact support';
      case AppErrorType.unknown:
        return 'Please try again or contact support if the problem persists';
    }
  }

  /// Gets an icon name for the error
  static String iconName(AppError error) {
    switch (error.type) {
      case AppErrorType.network:
        return 'wifi_off';
      case AppErrorType.timeout:
        return 'schedule';
      case AppErrorType.server:
        return 'error_outline';
      case AppErrorType.validation:
        return 'warning';
      case AppErrorType.unauthorized:
        return 'lock';
      case AppErrorType.unknown:
        return 'help_outline';
    }
  }

  /// Gets network-specific error messages
  static String _getNetworkMessage(AppError error) {
    // Check for specific network error codes
    switch (error.code) {
      case 'NO_INTERNET':
        return 'No internet connection. Please check your network settings and try again.';
      case 'CONNECTION_REFUSED':
        return 'Unable to connect to our servers. Please check your connection and try again.';
      case 'DNS_FAILURE':
        return 'Network configuration issue. Please check your internet connection.';
      case 'SSL_ERROR':
        return 'Secure connection failed. Please check your network settings.';
      default:
        return 'Network connection failed. Please check your internet connection and try again.';
    }
  }

  /// Gets timeout-specific error messages
  static String _getTimeoutMessage(AppError error) {
    // Check for specific timeout scenarios
    switch (error.code) {
      case 'LOGIN_TIMEOUT':
        return 'Login is taking longer than expected. Please try again.';
      case 'TRANSACTION_TIMEOUT':
        return 'Transaction processing is taking longer than expected. Please try again.';
      case 'FETCH_TIMEOUT':
        return 'Loading data is taking longer than expected. Please try again.';
      default:
        return 'Request timed out. Please try again.';
    }
  }

  /// Gets server-specific error messages
  static String _getServerMessage(AppError error) {
    // Check for specific server error codes
    switch (error.code) {
      case 'MAINTENANCE':
        return 'We\'re performing maintenance. Please try again in a few minutes.';
      case 'OVERLOADED':
        return 'Our servers are busy. Please try again in a moment.';
      case 'RATE_LIMITED':
        return 'Too many requests. Please wait a moment before trying again.';
      case 'SERVICE_UNAVAILABLE':
        return 'This service is temporarily unavailable. Please try again later.';
      case 'INTERNAL_ERROR':
        return 'An internal error occurred. Please try again or contact support.';
      default:
        return 'Our servers are experiencing issues. Please try again later.';
    }
  }

  /// Gets validation-specific error messages
  static String _getValidationMessage(AppError error) {
    // Check for specific validation error codes
    switch (error.code) {
      case 'INVALID_EMAIL':
        return 'Please enter a valid email address.';
      case 'INVALID_PHONE':
        return 'Please enter a valid phone number.';
      case 'INVALID_AMOUNT':
        return 'Please enter a valid amount.';
      case 'INSUFFICIENT_FUNDS':
        return 'Insufficient funds for this transaction.';
      case 'AMOUNT_TOO_LOW':
        return 'Amount is too low. Please enter a higher amount.';
      case 'AMOUNT_TOO_HIGH':
        return 'Amount exceeds the maximum limit.';
      case 'INVALID_CURRENCY':
        return 'Invalid currency selected.';
      case 'RECIPIENT_NOT_FOUND':
        return 'Recipient not found. Please check the details and try again.';
      case 'DUPLICATE_TRANSACTION':
        return 'A similar transaction was already processed.';
      case 'KYC_REQUIRED':
        return 'Additional verification is required. Please complete KYC.';
      case 'ACCOUNT_LOCKED':
        return 'Your account is temporarily locked. Please contact support.';
      default:
        return error.detail ?? 'Please check your input and try again.';
    }
  }

  /// Gets unauthorized-specific error messages
  static String _getUnauthorizedMessage(AppError error) {
    // Check for specific authorization error codes
    switch (error.code) {
      case 'INVALID_TOKEN':
        return 'Your session has expired. Please sign in again.';
      case 'TOKEN_EXPIRED':
        return 'Your session has expired. Please sign in again.';
      case 'INSUFFICIENT_PERMISSIONS':
        return 'You don\'t have permission to perform this action.';
      case 'ACCOUNT_SUSPENDED':
        return 'Your account has been suspended. Please contact support.';
      case 'KYC_PENDING':
        return 'Your account verification is pending. Please complete KYC.';
      case 'KYC_REJECTED':
        return 'Your account verification was rejected. Please contact support.';
      default:
        return 'Access denied. Please sign in again or contact support.';
    }
  }

  /// Gets unknown error messages
  static String _getUnknownMessage(AppError error) {
    // Provide a generic message for unknown errors
    return error.detail ?? 'An unexpected error occurred. Please try again or contact support.';
  }

  /// Gets a retry button label based on error type
  static String retryLabel(AppError error) {
    switch (error.type) {
      case AppErrorType.network:
        return 'Try Again';
      case AppErrorType.timeout:
        return 'Retry';
      case AppErrorType.server:
        return 'Try Again';
      case AppErrorType.validation:
        return 'Fix & Retry';
      case AppErrorType.unauthorized:
        return 'Sign In Again';
      case AppErrorType.unknown:
        return 'Try Again';
    }
  }

  /// Gets a help button label
  static String helpLabel(AppError error) {
    switch (error.type) {
      case AppErrorType.network:
        return 'Check Connection';
      case AppErrorType.timeout:
        return 'Get Help';
      case AppErrorType.server:
        return 'Contact Support';
      case AppErrorType.validation:
        return 'Get Help';
      case AppErrorType.unauthorized:
        return 'Contact Support';
      case AppErrorType.unknown:
        return 'Get Help';
    }
  }

  /// Determines if the error should show a retry button
  static bool shouldShowRetry(AppError error) {
    return error.isRetryable;
  }

  /// Determines if the error should show a help button
  static bool shouldShowHelp(AppError error) {
    switch (error.type) {
      case AppErrorType.network:
      case AppErrorType.validation:
        return false; // These are usually self-resolvable
      case AppErrorType.timeout:
      case AppErrorType.server:
      case AppErrorType.unauthorized:
      case AppErrorType.unknown:
        return true;
    }
  }
}
