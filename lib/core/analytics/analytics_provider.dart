import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'analytics_service.dart';
import 'analytics.dart';

/// Provider for the analytics service
final analyticsProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});

/// Provider to initialize analytics on app start
final analyticsInitializerProvider = FutureProvider<void>((ref) async {
  final analytics = ref.read(analyticsProvider);
  analytics.initialize(
    FakeAnalytics(),
  ); // Use fake for now, replace with real implementation in production
});
