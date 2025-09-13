// App routing configuration using go_router
// Single source of truth: docs/PRD.md

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/auth/verify_email_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/forgot_password_success_screen.dart';
import '../../features/kyc/kyc_phone_screen.dart';
import '../../features/kyc/kyc_otp_screen.dart';
import '../../features/kyc/kyc_id_screen.dart';
import '../../features/kyc/kyc_selfie_screen.dart';
import '../../features/limits/limits_detail_screen.dart';
import '../../features/send/cap_limit_state.dart';
import '../../features/home/home_screen.dart';
import '../../features/send/send_shell.dart';
import '../../features/transaction/transaction_detail_screen.dart';

/// App router configuration
class AppRouter {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String forgotPasswordSuccess = '/forgot-password-success';
  static const String kycPhone = '/kyc/phone';
  static const String kycOtp = '/kyc/otp';
  static const String kycId = '/kyc/id';
  static const String kycSelfie = '/kyc/selfie';
  static const String mpesaCapDetails = '/limits/mpesa';
  static const String home = '/home';
  static const String send = '/send';
  static const String transactionDetail = '/transaction/:id';

  /// Router configuration
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      // Splash screen
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth routes
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: verifyEmail,
        name: 'verify-email',
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: forgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: forgotPasswordSuccess,
        name: 'forgot-password-success',
        builder: (context, state) => const ForgotPasswordSuccessScreen(),
      ),

      // KYC routes
      GoRoute(
        path: kycPhone,
        name: 'kyc-phone',
        builder: (context, state) => const KycPhoneScreen(),
      ),
      GoRoute(
        path: kycOtp,
        name: 'kyc-otp',
        builder: (context, state) => const KycOtpScreen(),
      ),
      GoRoute(
        path: kycId,
        name: 'kyc-id',
        builder: (context, state) => const KycIdScreen(),
      ),
      GoRoute(
        path: kycSelfie,
        name: 'kyc-selfie',
        builder: (context, state) => const KycSelfieScreen(),
      ),

      // Limits routes
      GoRoute(
        path: mpesaCapDetails,
        name: 'mpesa-cap-details',
        builder: (context, state) {
          final typeParam = state.uri.queryParameters['type'] ?? 'daily';
          final type = (typeParam == 'per_txn')
              ? CapBreach.perTxn
              : CapBreach.daily;
          return LimitsDetailScreen(type: type);
        },
      ),

      // Main app routes
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Transaction detail route
      GoRoute(
        path: transactionDetail,
        name: 'transaction-detail',
        builder: (context, state) {
          final transactionId = state.pathParameters['id']!;
          return TransactionDetailScreen(transactionId: transactionId);
        },
      ),

      // Send flow routes (shell with child routes)
      GoRoute(
        path: send,
        name: 'send',
        builder: (context, state) => const SendShell(),
        routes: [
          // Child routes for send flow will be added here
          // /send/recipient, /send/amount, /send/review, etc.
        ],
      ),
    ],
  );
}
