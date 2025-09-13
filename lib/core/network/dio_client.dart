import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'interceptors.dart';

/// Dio client configuration for Yole API
///
/// Provides:
/// - Base URL from environment variables
/// - Authentication interceptors
/// - Error handling
/// - Request/response logging in debug mode
class YoleDioClient {
  static Dio? _instance;

  /// Get configured Dio instance for Yole API
  static Dio get yoleDio {
    _instance ??= _createDio();
    return _instance!;
  }

  /// Create and configure Dio instance
  static Dio _createDio() {
    final baseUrl = dotenv.env['YOLE_API_BASE'] ?? 'https://api.yole.com';

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add interceptors
    dio.interceptors.add(YoleInterceptors.authInterceptor);

    // Add logging in debug mode
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
        ),
      );
    }

    return dio;
  }

  /// Reset Dio instance (useful for testing or config changes)
  static void reset() {
    _instance = null;
  }
}
