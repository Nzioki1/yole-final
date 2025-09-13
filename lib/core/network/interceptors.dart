import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Network interceptors for Yole API
///
/// Provides:
/// - Accept header: application/x.yole.v1+json
/// - X-API-Key header from environment
/// - Authorization Bearer token from secure storage
/// - Automatic token refresh on 401 responses
class YoleInterceptors {
  static const _storage = FlutterSecureStorage();

  /// Main interceptor that adds required headers
  static Interceptor get authInterceptor => InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Add Accept header
      options.headers['Accept'] = 'application/x.yole.v1+json';

      // Add X-API-Key from environment
      final apiKey = dotenv.env['YOLE_API_KEY'];
      if (apiKey != null) {
        options.headers['X-API-Key'] = apiKey;
      }

      // Add Authorization Bearer token if available
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }

      handler.next(options);
    },
    onError: (error, handler) async {
      // Handle 401 Unauthorized - try to refresh token
      if (error.response?.statusCode == 401) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Retry the original request with new token
          final accessToken = await _storage.read(key: 'access_token');
          if (accessToken != null) {
            error.requestOptions.headers['Authorization'] =
                'Bearer $accessToken';
            final response = await Dio().fetch(error.requestOptions);
            handler.resolve(response);
            return;
          }
        }
      }

      handler.next(error);
    },
  );

  /// Refresh token interceptor
  static Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) return false;

      // TODO: Implement token refresh API call
      // This would call POST /api/refresh-token with the refresh token
      // and update the stored access_token

      return false; // Placeholder - implement actual refresh logic
    } catch (e) {
      return false;
    }
  }

  /// Logout interceptor - clears stored tokens
  static Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  /// Store tokens after successful login
  static Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }
}
