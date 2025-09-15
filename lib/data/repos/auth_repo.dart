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
    // Mock registration for testing - TODO: Remove in production
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // Simulate successful registration
    return {
      'userId': 'new_user_${DateTime.now().millisecondsSinceEpoch}',
      'email': email,
      'name': '$name $surname',
      'message': 'Registration successful. Please verify your email.',
    };
  }

  /// Login user
  ///
  /// Expected payload: { email, password }
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // Mock login for testing - TODO: Remove in production
    if (email == 'test@yole.com' && password == 'Test') {
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay
      return {
        'userId': 'test_user_123',
        'name': 'Test User',
        'email': email,
        'emailVerified': true,
        'kycComplete': true,
        'accessToken': 'mock_access_token',
        'refreshToken': 'mock_refresh_token',
      };
    }

    // For other users, try real API call
    try {
      return await _apiClient.login({'email': email, 'password': password});
    } catch (e) {
      // If API call fails, throw a meaningful error
      throw Exception('Login failed: Invalid email or password');
    }
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
  Future<void> logout() async {
    await _apiClient.logout();
  }

  /// Request password reset
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    return await _apiClient.forgotPassword(email);
  }

  /// Resend email verification
  Future<void> resendEmailVerification() async {
    await _apiClient.resendEmailVerification();
  }

  /// Get current user (placeholder - needs proper implementation)
  Future<Map<String, dynamic>> getCurrentUser() async {
    // TODO: Implement proper user retrieval
    return {'id': '1', 'email': 'user@example.com', 'verified': false};
  }
}
