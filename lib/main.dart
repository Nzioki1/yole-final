import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yole_final/core/crash/crash.dart';
import 'package:yole_final/core/analytics/analytics_service.dart';
import 'package:yole_final/core/analytics/analytics.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize crash reporting
  initializeCrashReporter(FakeCrashReporter());

  // Initialize analytics with fake implementation for now
  // In production, this would be replaced with Firebase Analytics
  AnalyticsService().initialize(FakeAnalytics());

  // Load environment variables (gracefully handle missing file)
  try {
    await dotenv.load(fileName: "assets/env/.env");
  } catch (e) {
    // Environment file not found, continue with default values
    print('Environment file not found, using default configuration');
  }

  runApp(const ProviderScope(child: App()));
}
