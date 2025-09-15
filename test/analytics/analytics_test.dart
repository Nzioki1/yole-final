import 'package:flutter_test/flutter_test.dart';
import 'package:yole_final/core/analytics/analytics.dart';
import 'package:yole_final/core/analytics/analytics_service.dart';

void main() {
  group('Analytics Tests', () {
    late FakeAnalytics fakeAnalytics;
    late AnalyticsService analyticsService;

    setUp(() {
      fakeAnalytics = FakeAnalytics();
      analyticsService = AnalyticsService();
      analyticsService.initialize(fakeAnalytics);
    });

    tearDown(() {
      fakeAnalytics.clear();
    });

    test('should log events without network calls', () async {
      // Act
      await analyticsService.logEvent('test_event', {'param1': 'value1'});

      // Assert
      expect(fakeAnalytics.events.length, 1);
      expect(fakeAnalytics.events.first.name, 'test_event');
      expect(fakeAnalytics.events.first.params['param1'], 'value1');
    });

    test('should log screen views', () async {
      // Act
      await analyticsService.logScreenView('test_screen', {
        'source': 'navigation',
      });

      // Assert
      expect(fakeAnalytics.events.length, 1);
      expect(fakeAnalytics.events.first.name, 'screen_view');
      expect(fakeAnalytics.events.first.params['screen_name'], 'test_screen');
      expect(fakeAnalytics.events.first.params['source'], 'navigation');
    });

    test('should log user actions', () async {
      // Act
      await analyticsService.logUserAction('button_clicked', {
        'button_id': 'submit',
      });

      // Assert
      expect(fakeAnalytics.events.length, 1);
      expect(fakeAnalytics.events.first.name, 'user_action');
      expect(fakeAnalytics.events.first.params['action'], 'button_clicked');
      expect(fakeAnalytics.events.first.params['button_id'], 'submit');
    });

    test('should log errors', () async {
      // Act
      await analyticsService.logError('network_error', {'code': '500'});

      // Assert
      expect(fakeAnalytics.events.length, 1);
      expect(fakeAnalytics.events.first.name, 'error');
      expect(fakeAnalytics.events.first.params['error'], 'network_error');
      expect(fakeAnalytics.events.first.params['code'], '500');
    });

    test('should set user properties', () async {
      // Act
      await analyticsService.setUserProperties({
        'user_type': 'premium',
        'region': 'US',
      });

      // Assert
      expect(fakeAnalytics.userProperties['user_type'], 'premium');
      expect(fakeAnalytics.userProperties['region'], 'US');
    });

    test('should set user ID', () async {
      // Act
      await analyticsService.setUserId('user123');

      // Assert
      expect(fakeAnalytics.userId, 'user123');
    });

    test('should clear stored data', () {
      // Arrange
      fakeAnalytics.logEvent('test_event');
      fakeAnalytics.setUserId('user123');
      fakeAnalytics.setUserProperties({'key': 'value'});

      // Act
      fakeAnalytics.clear();

      // Assert
      expect(fakeAnalytics.events.length, 0);
      expect(fakeAnalytics.userId, null);
      expect(fakeAnalytics.userProperties.length, 0);
    });

    test(
      'should maintain backward compatibility with legacy methods',
      () async {
        // Act
        analyticsService.trackEvent(
          'legacy_event',
          parameters: {'param': 'value'},
        );
        analyticsService.trackScreenView(
          'legacy_screen',
          parameters: {'source': 'test'},
        );
        analyticsService.trackUserAction(
          'legacy_action',
          parameters: {'button': 'click'},
        );
        analyticsService.trackError(
          'legacy_error',
          parameters: {'code': '404'},
        );

        // Assert
        expect(fakeAnalytics.events.length, 4);
        expect(fakeAnalytics.events[0].name, 'legacy_event');
        expect(fakeAnalytics.events[1].name, 'screen_view');
        expect(fakeAnalytics.events[2].name, 'user_action');
        expect(fakeAnalytics.events[3].name, 'error');
      },
    );
  });

  group('FakeAnalytics Tests', () {
    late FakeAnalytics fakeAnalytics;

    setUp(() {
      fakeAnalytics = FakeAnalytics();
    });

    tearDown(() {
      fakeAnalytics.clear();
    });

    test('should store events with timestamps', () async {
      // Act
      await fakeAnalytics.logEvent('test_event', {'param': 'value'});

      // Assert
      expect(fakeAnalytics.events.length, 1);
      expect(fakeAnalytics.events.first.name, 'test_event');
      expect(fakeAnalytics.events.first.params['param'], 'value');
      expect(fakeAnalytics.events.first.timestamp, isA<DateTime>());
    });

    test('should handle events without parameters', () async {
      // Act
      await fakeAnalytics.logEvent('simple_event');

      // Assert
      expect(fakeAnalytics.events.length, 1);
      expect(fakeAnalytics.events.first.name, 'simple_event');
      expect(fakeAnalytics.events.first.params, isEmpty);
    });

    test('should handle multiple events', () async {
      // Act
      await fakeAnalytics.logEvent('event1');
      await fakeAnalytics.logEvent('event2', {'param': 'value'});
      await fakeAnalytics.logEvent('event3');

      // Assert
      expect(fakeAnalytics.events.length, 3);
      expect(fakeAnalytics.events[0].name, 'event1');
      expect(fakeAnalytics.events[1].name, 'event2');
      expect(fakeAnalytics.events[2].name, 'event3');
    });
  });
}

