/// Tests for retry policy functionality
///
/// Tests retry logic, backoff calculations, and retry context management.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:yole_final/core/errors/retry_policy.dart';

void main() {
  group('RetryPolicy Tests', () {
    group('Basic Configuration', () {
      test('should create policy with default values', () {
        const policy = RetryPolicy();
        
        expect(policy.maxAttempts, equals(3));
        expect(policy.baseDelayMs, equals(500));
        expect(policy.maxDelayMs, equals(5000));
        expect(policy.backoffMultiplier, equals(2.0));
        expect(policy.useJitter, isTrue);
        expect(policy.jitterFactor, equals(0.1));
      });

      test('should create policy with custom values', () {
        const policy = RetryPolicy(
          maxAttempts: 5,
          baseDelayMs: 1000,
          maxDelayMs: 10000,
          backoffMultiplier: 1.5,
          useJitter: false,
          jitterFactor: 0.2,
        );
        
        expect(policy.maxAttempts, equals(5));
        expect(policy.baseDelayMs, equals(1000));
        expect(policy.maxDelayMs, equals(10000));
        expect(policy.backoffMultiplier, equals(1.5));
        expect(policy.useJitter, isFalse);
        expect(policy.jitterFactor, equals(0.2));
      });

      test('should create predefined policies', () {
        expect(RetryPolicy.network.maxAttempts, equals(3));
        expect(RetryPolicy.quick.maxAttempts, equals(2));
        expect(RetryPolicy.slow.maxAttempts, equals(5));
        expect(RetryPolicy.none.maxAttempts, equals(1));
      });
    });

    group('Delay Calculation', () {
      test('should calculate correct delays for network policy', () {
        const policy = RetryPolicy.network;
        
        final delay1 = policy.calculateDelay(1);
        final delay2 = policy.calculateDelay(2);
        final delay3 = policy.calculateDelay(3);
        
        expect(delay1.inMilliseconds, equals(500));
        expect(delay2.inMilliseconds, equals(1000));
        expect(delay3.inMilliseconds, equals(2000));
      });

      test('should respect maximum delay cap', () {
        const policy = RetryPolicy(
          baseDelayMs: 1000,
          maxDelayMs: 2000,
          backoffMultiplier: 3.0,
        );
        
        final delay1 = policy.calculateDelay(1);
        final delay2 = policy.calculateDelay(2);
        final delay3 = policy.calculateDelay(3);
        
        expect(delay1.inMilliseconds, equals(1000));
        expect(delay2.inMilliseconds, equals(2000)); // Capped at maxDelayMs
        expect(delay3.inMilliseconds, equals(2000)); // Capped at maxDelayMs
      });

      test('should handle zero and negative attempt numbers', () {
        const policy = RetryPolicy.network;
        
        final delay0 = policy.calculateDelay(0);
        final delayNegative = policy.calculateDelay(-1);
        
        expect(delay0.inMilliseconds, equals(0));
        expect(delayNegative.inMilliseconds, equals(0));
      });

      test('should generate all delays correctly', () {
        const policy = RetryPolicy(
          maxAttempts: 4,
          baseDelayMs: 100,
          backoffMultiplier: 2.0,
        );
        
        final delays = policy.allDelays;
        
        expect(delays.length, equals(3));
        expect(delays[0].inMilliseconds, equals(100));
        expect(delays[1].inMilliseconds, equals(200));
        expect(delays[2].inMilliseconds, equals(400));
      });

      test('should calculate total retry time', () {
        const policy = RetryPolicy(
          maxAttempts: 3,
          baseDelayMs: 500,
          backoffMultiplier: 2.0,
        );
        
        final totalTime = policy.totalRetryTime;
        
        expect(totalTime.inMilliseconds, equals(1500)); // 500 + 1000
      });
    });

    group('Jitter', () {
      test('should add jitter when enabled', () {
        const policy = RetryPolicy(
          baseDelayMs: 1000,
          useJitter: true,
          jitterFactor: 0.1,
        );
        
        // Run multiple times to test jitter variation
        final delays = <Duration>[];
        for (int i = 0; i < 10; i++) {
          delays.add(policy.calculateDelay(1));
        }
        
        // All delays should be within jitter range
        for (final delay in delays) {
          expect(delay.inMilliseconds, greaterThanOrEqualTo(900));
          expect(delay.inMilliseconds, lessThanOrEqualTo(1100));
        }
        
        // Delays should vary (not all be exactly 1000)
        final uniqueDelays = delays.toSet();
        expect(uniqueDelays.length, greaterThan(1));
      });

      test('should not add jitter when disabled', () {
        const policy = RetryPolicy(
          baseDelayMs: 1000,
          useJitter: false,
        );
        
        // Run multiple times to ensure no variation
        final delays = <Duration>[];
        for (int i = 0; i < 10; i++) {
          delays.add(policy.calculateDelay(1));
        }
        
        // All delays should be exactly the same
        for (final delay in delays) {
          expect(delay.inMilliseconds, equals(1000));
        }
      });
    });

    group('Copy With', () {
      test('should create copy with updated fields', () {
        const original = RetryPolicy.network;
        
        final updated = original.copyWith(
          maxAttempts: 5,
          baseDelayMs: 1000,
        );
        
        expect(updated.maxAttempts, equals(5));
        expect(updated.baseDelayMs, equals(1000));
        expect(updated.maxDelayMs, equals(original.maxDelayMs));
        expect(updated.backoffMultiplier, equals(original.backoffMultiplier));
        expect(updated.useJitter, equals(original.useJitter));
        expect(updated.jitterFactor, equals(original.jitterFactor));
      });
    });
  });

  group('RetryContext Tests', () {
    test('should create context with default values', () {
      const policy = RetryPolicy.network;
      final context = RetryContext(policy: policy);
      
      expect(context.currentAttempt, equals(1));
      expect(context.totalAttempts, equals(0));
      expect(context.isSuccess, isFalse);
      expect(context.lastError, isNull);
      expect(context.policy, equals(policy));
    });

    test('should track attempt progression', () {
      const policy = RetryPolicy.network;
      final context = RetryContext(policy: policy);
      
      expect(context.hasMoreAttempts, isTrue);
      expect(context.isComplete, isFalse);
      
      context.nextAttempt();
      
      expect(context.currentAttempt, equals(2));
      expect(context.totalAttempts, equals(1));
      expect(context.hasMoreAttempts, isTrue);
      expect(context.isComplete, isFalse);
    });

    test('should mark success correctly', () {
      const policy = RetryPolicy.network;
      final context = RetryContext(policy: policy);
      
      context.markSuccess();
      
      expect(context.isSuccess, isTrue);
      expect(context.isComplete, isTrue);
    });

    test('should record errors correctly', () {
      const policy = RetryPolicy.network;
      final context = RetryContext(policy: policy);
      final error = Exception('Test error');
      
      context.recordError(error);
      
      expect(context.lastError, equals(error));
      expect(context.currentAttempt, equals(2));
      expect(context.totalAttempts, equals(1));
    });

    test('should calculate next delay correctly', () {
      const policy = RetryPolicy.network;
      final context = RetryContext(policy: policy);
      
      final nextDelay = context.nextDelay;
      
      expect(nextDelay.inMilliseconds, equals(500));
    });

    test('should track elapsed time', () {
      const policy = RetryPolicy.network;
      final context = RetryContext(policy: policy);
      
      final elapsedTime = context.elapsedTime;
      
      expect(elapsedTime.inMilliseconds, greaterThanOrEqualTo(0));
    });

    test('should handle max attempts reached', () {
      const policy = RetryPolicy(maxAttempts: 2);
      final context = RetryContext(policy: policy);
      
      context.nextAttempt(); // Now at attempt 2
      context.nextAttempt(); // Now at attempt 3, exceeds max
      
      expect(context.hasMoreAttempts, isFalse);
      expect(context.isComplete, isTrue);
    });

    test('should create copy with updated fields', () {
      const policy = RetryPolicy.network;
      final context = RetryContext(policy: policy);
      
      final updated = context.copyWith(
        currentAttempt: 3,
        isSuccess: true,
      );
      
      expect(updated.currentAttempt, equals(3));
      expect(updated.isSuccess, isTrue);
      expect(updated.totalAttempts, equals(context.totalAttempts));
      expect(updated.lastError, equals(context.lastError));
      expect(updated.policy, equals(context.policy));
    });
  });

  group('RetryManager Tests', () {
    test('should execute successful operation without retries', () async {
      const policy = RetryPolicy.network;
      
      final result = await RetryManager.execute(
        () async => 'success',
        policy: policy,
      );
      
      expect(result, equals('success'));
    });

    test('should retry failed operation until success', () async {
      const policy = RetryPolicy(
        maxAttempts: 3,
        baseDelayMs: 10, // Short delay for testing
      );
      
      int attemptCount = 0;
      
      final result = await RetryManager.execute(
        () async {
          attemptCount++;
          if (attemptCount < 3) {
            throw Exception('Attempt $attemptCount failed');
          }
          return 'success after $attemptCount attempts';
        },
        policy: policy,
      );
      
      expect(result, equals('success after 3 attempts'));
      expect(attemptCount, equals(3));
    });

    test('should fail after max attempts reached', () async {
      const policy = RetryPolicy(
        maxAttempts: 2,
        baseDelayMs: 10,
      );
      
      int attemptCount = 0;
      
      expect(
        () async => await RetryManager.execute(
          () async {
            attemptCount++;
            throw Exception('Attempt $attemptCount failed');
          },
          policy: policy,
        ),
        throwsA(isA<Exception>()),
      );
      
      expect(attemptCount, equals(2));
    });

    test('should respect custom shouldRetry function', () async {
      const policy = RetryPolicy(
        maxAttempts: 3,
        baseDelayMs: 10,
      );
      
      int attemptCount = 0;
      
      expect(
        () async => await RetryManager.execute(
          () async {
            attemptCount++;
            throw Exception('Non-retryable error');
          },
          policy: policy,
          shouldRetry: (error) => false, // Don't retry any errors
        ),
        throwsA(isA<Exception>()),
      );
      
      expect(attemptCount, equals(1)); // Should not retry
    });

    test('should execute operation with context', () async {
      const policy = RetryPolicy.network;
      
      final result = await RetryManager.executeWithContext(
        (context) async {
          if (context.currentAttempt == 1) {
            throw Exception('First attempt failed');
          }
          return 'success on attempt ${context.currentAttempt}';
        },
        policy: policy,
      );
      
      expect(result, equals('success on attempt 2'));
    });
  });

  group('RetryExtension Tests', () {
    test('should add retry functionality to Future functions', () async {
      const policy = RetryPolicy(
        maxAttempts: 2,
        baseDelayMs: 10,
      );
      
      int attemptCount = 0;
      
      final result = await (() async {
        attemptCount++;
        if (attemptCount == 1) {
          throw Exception('First attempt failed');
        }
        return 'success';
      }).withRetry(policy: policy);
      
      expect(result, equals('success'));
      expect(attemptCount, equals(2));
    });
  });
}
