import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Authentication state provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

/// Authentication state
class AuthState {
  final bool isAuthenticated;
  final bool isEmailVerified;
  final bool isKycComplete;
  final String? userId;
  final String? userName;
  final String? userEmail;

  const AuthState({
    this.isAuthenticated = false,
    this.isEmailVerified = false,
    this.isKycComplete = false,
    this.userId,
    this.userName,
    this.userEmail,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isEmailVerified,
    bool? isKycComplete,
    String? userId,
    String? userName,
    String? userEmail,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isKycComplete: isKycComplete ?? this.isKycComplete,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}

/// Authentication notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _loadAuthState();
  }

  /// Load authentication state from storage
  Future<void> _loadAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isAuth = prefs.getBool('isAuthenticated') ?? false;
      final isEmailVerified = prefs.getBool('isEmailVerified') ?? false;
      final isKycComplete = prefs.getBool('isKycComplete') ?? false;
      final userId = prefs.getString('userId');
      final userName = prefs.getString('userName');
      final userEmail = prefs.getString('userEmail');

      state = AuthState(
        isAuthenticated: isAuth,
        isEmailVerified: isEmailVerified,
        isKycComplete: isKycComplete,
        userId: userId,
        userName: userName,
        userEmail: userEmail,
      );
    } catch (e) {
      print('Error loading auth state: $e');
    }
  }

  /// Login user
  Future<void> login({
    required String userId,
    required String userName,
    required String userEmail,
    bool isEmailVerified = false,
    bool isKycComplete = false,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setBool('isEmailVerified', isEmailVerified);
      await prefs.setBool('isKycComplete', isKycComplete);
      await prefs.setString('userId', userId);
      await prefs.setString('userName', userName);
      await prefs.setString('userEmail', userEmail);

      state = state.copyWith(
        isAuthenticated: true,
        isEmailVerified: isEmailVerified,
        isKycComplete: isKycComplete,
        userId: userId,
        userName: userName,
        userEmail: userEmail,
      );
    } catch (e) {
      print('Error saving login state: $e');
    }
  }

  /// Update email verification status
  Future<void> updateEmailVerification(bool isVerified) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isEmailVerified', isVerified);

      state = state.copyWith(isEmailVerified: isVerified);
    } catch (e) {
      print('Error updating email verification: $e');
    }
  }

  /// Update KYC completion status
  Future<void> updateKycCompletion(bool isComplete) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isKycComplete', isComplete);

      state = state.copyWith(isKycComplete: isComplete);
    } catch (e) {
      print('Error updating KYC completion: $e');
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      state = const AuthState();
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}
