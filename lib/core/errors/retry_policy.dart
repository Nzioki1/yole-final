/// Retry policy utility for handling retry logic with backoff
///
/// Provides configurable retry strategies with exponential backoff
/// and jitter to handle transient failures gracefully.
library;

import 'dart:math';

/// Retry policy configuration
class RetryPolicy {
  /// Maximum number of retry attempts
  final int maxAttempts;
  
  /// Base delay between retries (in milliseconds)
  final int baseDelayMs;
  
  /// Maximum delay between retries (in milliseconds)
  final int maxDelayMs;
  
  /// Multiplier for exponential backoff
  final double backoffMultiplier;
  
  /// Whether to add jitter to prevent thundering herd
  final bool useJitter;
  
  /// Jitter factor (0.0 to 1.0)
  final double jitterFactor;

  const RetryPolicy({
    this.maxAttempts = 3,
    this.baseDelayMs = 500,
    this.maxDelayMs = 5000,
    this.backoffMultiplier = 2.0,
    this.useJitter = true,
    this.jitterFactor = 0.1,
  });

  /// Default retry policy for network operations
  static const RetryPolicy network = RetryPolicy(
    maxAttempts: 3,
    baseDelayMs: 500,
    maxDelayMs: 5000,
    backoffMultiplier: 2.0,
    useJitter: true,
  );

  /// Retry policy for quick operations (like API calls)
  static const RetryPolicy quick = RetryPolicy(
    maxAttempts: 2,
    baseDelayMs: 250,
    maxDelayMs: 1000,
    backoffMultiplier: 1.5,
    useJitter: true,
  );

  /// Retry policy for slow operations (like file uploads)
  static const RetryPolicy slow = RetryPolicy(
    maxAttempts: 5,
    baseDelayMs: 1000,
    maxDelayMs: 10000,
    backoffMultiplier: 2.0,
    useJitter: true,
  );

  /// No retry policy
  static const RetryPolicy none = RetryPolicy(
    maxAttempts: 1,
    baseDelayMs: 0,
    maxDelayMs: 0,
    backoffMultiplier: 1.0,
    useJitter: false,
  );

  /// Calculates the delay for the given attempt number
  Duration calculateDelay(int attemptNumber) {
    if (attemptNumber <= 0) {
      return Duration.zero;
    }

    // Calculate exponential backoff
    final exponentialDelay = baseDelayMs * pow(backoffMultiplier, attemptNumber - 1);
    
    // Apply maximum delay cap
    final cappedDelay = min(exponentialDelay, maxDelayMs.toDouble());
    
    // Add jitter if enabled
    if (useJitter) {
      final random = Random();
      final jitter = cappedDelay * jitterFactor * (random.nextDouble() - 0.5) * 2;
      final finalDelay = max(0, cappedDelay + jitter);
      return Duration(milliseconds: finalDelay.round());
    }
    
    return Duration(milliseconds: cappedDelay.round());
  }

  /// Gets all retry delays for this policy
  List<Duration> get allDelays {
    return List.generate(
      maxAttempts - 1,
      (index) => calculateDelay(index + 1),
    );
  }

  /// Gets the total time for all retries
  Duration get totalRetryTime {
    return allDelays.fold<Duration>(
      Duration.zero,
      (total, delay) => total + delay,
    );
  }

  /// Creates a copy with updated fields
  RetryPolicy copyWith({
    int? maxAttempts,
    int? baseDelayMs,
    int? maxDelayMs,
    double? backoffMultiplier,
    bool? useJitter,
    double? jitterFactor,
  }) {
    return RetryPolicy(
      maxAttempts: maxAttempts ?? this.maxAttempts,
      baseDelayMs: baseDelayMs ?? this.baseDelayMs,
      maxDelayMs: maxDelayMs ?? this.maxDelayMs,
      backoffMultiplier: backoffMultiplier ?? this.backoffMultiplier,
      useJitter: useJitter ?? this.useJitter,
      jitterFactor: jitterFactor ?? this.jitterFactor,
    );
  }
}

/// Retry context for tracking retry attempts
class RetryContext {
  /// Current attempt number (1-based)
  int currentAttempt;
  
  /// Total number of attempts made
  int totalAttempts;
  
  /// Whether the operation succeeded
  bool isSuccess;
  
  /// Last error encountered
  Object? lastError;
  
  /// Start time of the retry operation
  final DateTime startTime;
  
  /// Retry policy being used
  final RetryPolicy policy;

  RetryContext({
    required this.policy,
    this.currentAttempt = 1,
    this.totalAttempts = 0,
    this.isSuccess = false,
    this.lastError,
    DateTime? startTime,
  }) : startTime = startTime ?? DateTime.now();

  /// Whether there are more retry attempts available
  bool get hasMoreAttempts => currentAttempt < policy.maxAttempts;

  /// Whether the operation is complete (success or max attempts reached)
  bool get isComplete => isSuccess || !hasMoreAttempts;

  /// Gets the delay for the next retry attempt
  Duration get nextDelay => policy.calculateDelay(currentAttempt);

  /// Gets the total elapsed time
  Duration get elapsedTime => DateTime.now().difference(startTime);

  /// Moves to the next attempt
  void nextAttempt() {
    currentAttempt++;
    totalAttempts++;
  }

  /// Marks the operation as successful
  void markSuccess() {
    isSuccess = true;
  }

  /// Records an error and moves to next attempt
  void recordError(Object error) {
    lastError = error;
    nextAttempt();
  }

  /// Creates a copy with updated fields
  RetryContext copyWith({
    int? currentAttempt,
    int? totalAttempts,
    bool? isSuccess,
    Object? lastError,
  }) {
    return RetryContext(
      policy: policy,
      currentAttempt: currentAttempt ?? this.currentAttempt,
      totalAttempts: totalAttempts ?? this.totalAttempts,
      isSuccess: isSuccess ?? this.isSuccess,
      lastError: lastError ?? this.lastError,
      startTime: startTime,
    );
  }
}

/// Retry manager for executing operations with retry logic
class RetryManager {
  /// Executes an operation with retry logic
  static Future<T> execute<T>(
    Future<T> Function() operation, {
    RetryPolicy policy = RetryPolicy.network,
    bool Function(Object error)? shouldRetry,
  }) async {
    final context = RetryContext(policy: policy);
    
    while (!context.isComplete) {
      try {
        final result = await operation();
        context.markSuccess();
        return result;
      } catch (error) {
        // Check if we should retry this error
        if (shouldRetry != null && !shouldRetry(error)) {
          rethrow;
        }
        
        // Record the error and increment attempt count
        context.recordError(error);
        
        // If no more attempts after this error, rethrow the error
        if (!context.hasMoreAttempts) {
          rethrow;
        }
        
        // Wait before next attempt
        await Future.delayed(context.nextDelay);
      }
    }
    
    // This should never be reached, but just in case
    throw context.lastError ?? Exception('Operation failed after all retries');
  }

  /// Executes an operation with custom retry context
  static Future<T> executeWithContext<T>(
    Future<T> Function(RetryContext context) operation, {
    RetryPolicy policy = RetryPolicy.network,
    bool Function(Object error)? shouldRetry,
  }) async {
    final context = RetryContext(policy: policy);
    
    while (!context.isComplete) {
      try {
        final result = await operation(context);
        context.markSuccess();
        return result;
      } catch (error) {
        context.recordError(error);
        
        // Check if we should retry this error
        if (shouldRetry != null && !shouldRetry(error)) {
          rethrow;
        }
        
        // If no more attempts, rethrow the error
        if (context.isComplete) {
          rethrow;
        }
        
        // Wait before next attempt
        await Future.delayed(context.nextDelay);
      }
    }
    
    // This should never be reached, but just in case
    throw context.lastError ?? Exception('Operation failed after all retries');
  }
}

/// Extension to provide retry functionality on Future
extension RetryExtension<T> on Future<T> Function() {
  /// Executes this operation with retry logic
  Future<T> withRetry({
    RetryPolicy policy = RetryPolicy.network,
    bool Function(Object error)? shouldRetry,
  }) {
    return RetryManager.execute(
      this,
      policy: policy,
      shouldRetry: shouldRetry,
    );
  }
}
