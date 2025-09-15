/// Analytics interface for tracking user events and behavior.
///
/// This interface provides a contract for analytics implementations,
/// allowing easy swapping between fake (for tests) and real (Firebase) implementations.
abstract class Analytics {
  /// Log an event with optional parameters.
  ///
  /// [name] - The event name (e.g., 'button_clicked', 'screen_viewed')
  /// [params] - Optional parameters to include with the event
  Future<void> logEvent(String name, [Map<String, dynamic>? params]);

  /// Log a screen view event.
  ///
  /// [screenName] - The name of the screen being viewed
  /// [params] - Optional additional parameters
  Future<void> logScreenView(String screenName, [Map<String, dynamic>? params]);

  /// Log a user action event.
  ///
  /// [action] - The action being performed (e.g., 'button_clicked', 'form_submitted')
  /// [params] - Optional parameters
  Future<void> logUserAction(String action, [Map<String, dynamic>? params]);

  /// Log an error event.
  ///
  /// [error] - The error code or message
  /// [params] - Optional parameters including stack trace, context, etc.
  Future<void> logError(String error, [Map<String, dynamic>? params]);

  /// Set user properties.
  ///
  /// [properties] - Map of user properties to set
  Future<void> setUserProperties(Map<String, dynamic> properties);

  /// Set user ID for tracking.
  ///
  /// [userId] - Unique identifier for the user
  Future<void> setUserId(String userId);
}

/// Fake analytics implementation for testing.
///
/// This implementation logs events to debug console and stores them
/// in memory for test verification. No network calls are made.
class FakeAnalytics implements Analytics {
  final List<AnalyticsEvent> _events = [];
  final Map<String, dynamic> _userProperties = {};
  String? _userId;

  /// Get all logged events for test verification.
  List<AnalyticsEvent> get events => List.unmodifiable(_events);

  /// Get user properties for test verification.
  Map<String, dynamic> get userProperties => Map.unmodifiable(_userProperties);

  /// Get current user ID for test verification.
  String? get userId => _userId;

  /// Clear all stored events and properties (useful for test cleanup).
  void clear() {
    _events.clear();
    _userProperties.clear();
    _userId = null;
  }

  @override
  Future<void> logEvent(String name, [Map<String, dynamic>? params]) async {
    final event = AnalyticsEvent(
      name: name,
      params: params ?? {},
      timestamp: DateTime.now(),
    );
    _events.add(event);

    // Log to debug console for development
    print(
      'Analytics Event: $name${params != null ? ' with params: $params' : ''}',
    );
  }

  @override
  Future<void> logScreenView(
    String screenName, [
    Map<String, dynamic>? params,
  ]) async {
    await logEvent('screen_view', {'screen_name': screenName, ...?params});
  }

  @override
  Future<void> logUserAction(
    String action, [
    Map<String, dynamic>? params,
  ]) async {
    await logEvent('user_action', {'action': action, ...?params});
  }

  @override
  Future<void> logError(String error, [Map<String, dynamic>? params]) async {
    await logEvent('error', {'error': error, ...?params});
  }

  @override
  Future<void> setUserProperties(Map<String, dynamic> properties) async {
    _userProperties.addAll(properties);
    print('Analytics User Properties: $properties');
  }

  @override
  Future<void> setUserId(String userId) async {
    _userId = userId;
    print('Analytics User ID: $userId');
  }
}

/// Represents a single analytics event for testing purposes.
class AnalyticsEvent {
  final String name;
  final Map<String, dynamic> params;
  final DateTime timestamp;

  const AnalyticsEvent({
    required this.name,
    required this.params,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'AnalyticsEvent(name: $name, params: $params, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnalyticsEvent &&
        other.name == name &&
        _mapEquals(other.params, params);
  }

  @override
  int get hashCode => name.hashCode ^ _mapHashCode(params);
}

/// Helper function to compare maps for equality.
bool _mapEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
  if (a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || a[key] != b[key]) return false;
  }
  return true;
}

/// Helper function to compute hash code for maps.
int _mapHashCode(Map<String, dynamic> map) {
  int hash = 0;
  for (final entry in map.entries) {
    hash ^= entry.key.hashCode ^ entry.value.hashCode;
  }
  return hash;
}

