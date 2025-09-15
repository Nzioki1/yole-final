/// Application error types and error model
///
/// Provides typed error handling with consistent error types
/// and structured error information for UI display.
library;

/// Types of application errors
enum AppErrorType {
  /// Network connectivity issues
  network,
  
  /// Request timeout
  timeout,
  
  /// Server-side errors (5xx)
  server,
  
  /// Validation errors (4xx)
  validation,
  
  /// Authentication/authorization errors (401/403)
  unauthorized,
  
  /// Unknown/unexpected errors
  unknown,
}

/// Application error model
///
/// Represents a structured error with type, code, and details
/// for consistent error handling throughout the app.
class AppError {
  /// The type of error
  final AppErrorType type;
  
  /// Optional error code from the API
  final String? code;
  
  /// Optional detailed error message
  final String? detail;
  
  /// Optional original exception that caused this error
  final Object? originalException;
  
  /// Timestamp when the error occurred
  final DateTime timestamp;
  
  /// Optional context information about where the error occurred
  final Map<String, dynamic>? context;

  AppError({
    required this.type,
    this.code,
    this.detail,
    this.originalException,
    DateTime? timestamp,
    this.context,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Creates a network error
  factory AppError.network({
    String? code,
    String? detail,
    Object? originalException,
    Map<String, dynamic>? context,
  }) {
    return AppError(
      type: AppErrorType.network,
      code: code,
      detail: detail,
      originalException: originalException,
      context: context,
    );
  }

  /// Creates a timeout error
  factory AppError.timeout({
    String? code,
    String? detail,
    Object? originalException,
    Map<String, dynamic>? context,
  }) {
    return AppError(
      type: AppErrorType.timeout,
      code: code,
      detail: detail,
      originalException: originalException,
      context: context,
    );
  }

  /// Creates a server error
  factory AppError.server({
    String? code,
    String? detail,
    Object? originalException,
    Map<String, dynamic>? context,
  }) {
    return AppError(
      type: AppErrorType.server,
      code: code,
      detail: detail,
      originalException: originalException,
      context: context,
    );
  }

  /// Creates a validation error
  factory AppError.validation({
    String? code,
    String? detail,
    Object? originalException,
    Map<String, dynamic>? context,
  }) {
    return AppError(
      type: AppErrorType.validation,
      code: code,
      detail: detail,
      originalException: originalException,
      context: context,
    );
  }

  /// Creates an unauthorized error
  factory AppError.unauthorized({
    String? code,
    String? detail,
    Object? originalException,
    Map<String, dynamic>? context,
  }) {
    return AppError(
      type: AppErrorType.unauthorized,
      code: code,
      detail: detail,
      originalException: originalException,
      context: context,
    );
  }

  /// Creates an unknown error
  factory AppError.unknown({
    String? code,
    String? detail,
    Object? originalException,
    Map<String, dynamic>? context,
  }) {
    return AppError(
      type: AppErrorType.unknown,
      code: code,
      detail: detail,
      originalException: originalException,
      context: context,
    );
  }

  /// Creates an error from an exception
  factory AppError.fromException(
    Object exception, {
    String? code,
    String? detail,
    Map<String, dynamic>? context,
  }) {
    if (exception is AppError) {
      return exception;
    }

    // Map common exception types to AppError types
    if (exception.toString().contains('SocketException') ||
        exception.toString().contains('NetworkException')) {
      return AppError.network(
        code: code,
        detail: detail ?? exception.toString(),
        originalException: exception,
        context: context,
      );
    }

    if (exception.toString().contains('TimeoutException')) {
      return AppError.timeout(
        code: code,
        detail: detail ?? exception.toString(),
        originalException: exception,
        context: context,
      );
    }

    return AppError.unknown(
      code: code,
      detail: detail ?? exception.toString(),
      originalException: exception,
      context: context,
    );
  }

  /// Whether this error is retryable
  bool get isRetryable {
    switch (type) {
      case AppErrorType.network:
      case AppErrorType.timeout:
      case AppErrorType.server:
        return true;
      case AppErrorType.validation:
      case AppErrorType.unauthorized:
      case AppErrorType.unknown:
        return false;
    }
  }

  /// Whether this error should show a full-screen error
  bool get shouldShowFullScreen {
    switch (type) {
      case AppErrorType.unauthorized:
      case AppErrorType.server:
        return true;
      case AppErrorType.network:
      case AppErrorType.timeout:
      case AppErrorType.validation:
      case AppErrorType.unknown:
        return false;
    }
  }

  /// Whether this error should show an inline banner
  bool get shouldShowInline {
    switch (type) {
      case AppErrorType.network:
      case AppErrorType.timeout:
      case AppErrorType.validation:
        return true;
      case AppErrorType.server:
      case AppErrorType.unauthorized:
      case AppErrorType.unknown:
        return false;
    }
  }

  @override
  String toString() {
    return 'AppError(type: $type, code: $code, detail: $detail)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppError &&
        other.type == type &&
        other.code == code &&
        other.detail == detail;
  }

  @override
  int get hashCode {
    return Object.hash(type, code, detail);
  }

  /// Creates a copy of this error with updated fields
  AppError copyWith({
    AppErrorType? type,
    String? code,
    String? detail,
    Object? originalException,
    DateTime? timestamp,
    Map<String, dynamic>? context,
  }) {
    return AppError(
      type: type ?? this.type,
      code: code ?? this.code,
      detail: detail ?? this.detail,
      originalException: originalException ?? this.originalException,
      timestamp: timestamp ?? this.timestamp,
      context: context ?? this.context,
    );
  }
}

/// Extension to provide additional error utilities
extension AppErrorExtension on AppError {
  /// Gets a short description of the error type
  String get typeDescription {
    switch (type) {
      case AppErrorType.network:
        return 'Network Error';
      case AppErrorType.timeout:
        return 'Timeout Error';
      case AppErrorType.server:
        return 'Server Error';
      case AppErrorType.validation:
        return 'Validation Error';
      case AppErrorType.unauthorized:
        return 'Authorization Error';
      case AppErrorType.unknown:
        return 'Unknown Error';
    }
  }

  /// Gets a user-friendly error category
  String get category {
    switch (type) {
      case AppErrorType.network:
      case AppErrorType.timeout:
        return 'Connection';
      case AppErrorType.server:
        return 'Service';
      case AppErrorType.validation:
        return 'Input';
      case AppErrorType.unauthorized:
        return 'Security';
      case AppErrorType.unknown:
        return 'General';
    }
  }
}
