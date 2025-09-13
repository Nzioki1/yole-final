import '../api/yole_api_client.dart';

/// Authentication repository
///
/// Handles:
/// - User registration
/// - Login/logout
/// - Token refresh
/// - Password reset
///
/// Uses dynamic models for MVP - TODO: Add strong typing later
class AuthRepository {
  const AuthRepository(this._apiClient);

  final YoleApiClient _apiClient;

  /// Register a new user
  ///
  /// Expected payload: { email, name, surname, password, country }
  Future<Map<String, dynamic>> register({
    required String email,
    required String name,
    required String surname,
    required String password,
    required String country,
  }) async {
    return await _apiClient.register({
      'email': email,
      'name': name,
      'surname': surname,
      'password': password,
      'country': country,
    });
  }

  /// Login user
  ///
  /// Expected payload: { email, password }
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await _apiClient.login({'email': email, 'password': password});
  }

  /// Refresh access token
  ///
  /// Expected payload: { refresh_token }
  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  }) async {
    return await _apiClient.refreshToken({'refresh_token': refreshToken});
  }

  /// Logout user
  Future<Map<String, dynamic>> logout() async {
    return await _apiClient.logout();
  }

  /// Request password reset
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    return await _apiClient.forgotPassword(email);
  }
}
