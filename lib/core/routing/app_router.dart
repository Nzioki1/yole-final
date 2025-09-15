// App routing configuration using go_router
// Single source of truth: docs/PRD.md

import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/auth/verify_email_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/forgot_password_success_screen.dart';
import '../../features/onboarding/welcome_screen.dart';
import '../../features/kyc/kyc_phone_screen.dart';
import '../../features/kyc/kyc_otp_screen.dart';
import '../../features/kyc/kyc_id_screen.dart';
import '../../features/kyc/kyc_selfie_screen.dart';
import '../../features/kyc/kyc_success_screen.dart';
import '../../features/kyc/kyc_error_screen.dart';
import '../../features/limits/limits_detail_screen.dart';
import '../../features/send/cap_limit_state.dart';
import '../../features/send/send_shell.dart';
import '../../features/send/screens/send_start_screen.dart';
import '../../features/send/screens/send_recipient_screen.dart';
import '../../features/send/screens/send_network_screen.dart';
import '../../features/send/screens/send_amount_screen.dart';
import '../../features/send/screens/send_review_screen.dart';
import '../../features/send/screens/send_auth_screen.dart';
import '../../features/send/screens/send_success_screen.dart';
import '../../features/send/send_amount_with_caps_screen.dart';
import '../../features/send/send_pay_webview_screen.dart';
import '../../features/send/send_failure_screen.dart';
import '../../features/transaction/transaction_detail_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/main/main_shell.dart';
import 'package:dio/dio.dart';
import '../../data/repos/pesapal_repo.dart';

/// App router configuration
class AppRouter {
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String forgotPasswordSuccess = '/forgot-password-success';
  static const String kycPhone = '/kyc/phone';
  static const String kycOtp = '/kyc/otp';
  static const String kycId = '/kyc/id';
  static const String kycSelfie = '/kyc/selfie';
  static const String kycSuccess = '/kyc/success';
  static const String kycError = '/kyc/error';
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

      // Welcome/Onboarding screen
      GoRoute(
        path: welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
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
      GoRoute(
        path: kycSuccess,
        name: 'kyc-success',
        builder: (context, state) => const KycSuccessScreen(),
      ),
      GoRoute(
        path: kycError,
        name: 'kyc-error',
        builder: (context, state) {
          final errorMessage = state.uri.queryParameters['message'];
          final errorCode = state.uri.queryParameters['code'];
          return KycErrorScreen(
            errorMessage: errorMessage,
            errorCode: errorCode,
          );
        },
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

      // Main app routes with bottom navigation
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const MainShell(initialTab: 'home'),
      ),

      // Send tab (main shell with send tab) - redirects to send flow
      GoRoute(
        path: '/send-tab',
        name: 'send-tab',
        builder: (context, state) => const MainShell(initialTab: 'send'),
      ),

      // Favorites (main shell with favorites tab)
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const MainShell(initialTab: 'favorites'),
      ),

      // Profile (main shell with profile tab)
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const MainShell(initialTab: 'profile'),
      ),

      // Notifications
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
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
          // New 6+ step send flow
          GoRoute(
            path: 'start',
            name: 'send-start',
            builder: (context, state) => const SendStartScreen(),
          ),
          GoRoute(
            path: 'recipient',
            name: 'send-recipient',
            builder: (context, state) => const SendRecipientScreen(),
          ),
          GoRoute(
            path: 'network',
            name: 'send-network',
            builder: (context, state) => const SendNetworkScreen(),
          ),
          GoRoute(
            path: 'amount',
            name: 'send-amount',
            builder: (context, state) => const SendAmountScreen(),
          ),
          GoRoute(
            path: 'review',
            name: 'send-review',
            builder: (context, state) => const SendReviewScreen(),
          ),
          GoRoute(
            path: 'auth',
            name: 'send-auth',
            builder: (context, state) => const SendAuthScreen(),
          ),
          GoRoute(
            path: 'success',
            name: 'send-success',
            builder: (context, state) => const SendSuccessScreen(),
          ),

          // Legacy routes (for backward compatibility)
          GoRoute(
            path: 'amount-with-caps',
            name: 'send-amount-with-caps',
            builder: (context, state) => const SendAmountWithCapsScreen(),
          ),
          GoRoute(
            path: 'pay',
            name: 'send-pay',
            builder: (context, state) {
              final redirectUrl = state.uri.queryParameters['url'] ?? '';
              final orderTrackingId =
                  state.uri.queryParameters['orderId'] ?? '';
              // TODO: Create PesapalRepository instance
              return SendPayWebViewScreen(
                redirectUrl: redirectUrl,
                orderTrackingId: orderTrackingId,
                pesapalRepo: PesapalRepository(Dio()), // Temporary
              );
            },
          ),
          GoRoute(
            path: 'failure',
            name: 'send-failure',
            builder: (context, state) {
              final recipientName =
                  state.uri.queryParameters['name'] ?? 'Recipient';
              final recipientPhone = state.uri.queryParameters['phone'] ?? '';
              final sendingAmount =
                  double.tryParse(state.uri.queryParameters['amount'] ?? '0') ??
                  0.0;
              final receiveAmount =
                  double.tryParse(
                    state.uri.queryParameters['receive'] ?? '0',
                  ) ??
                  0.0;
              final orderTrackingId =
                  state.uri.queryParameters['orderId'] ?? '';
              final errorMessage = state.uri.queryParameters['error'];
              return SendFailureScreen(
                recipientName: recipientName,
                recipientPhone: recipientPhone,
                sendingAmount: sendingAmount,
                receiveAmount: receiveAmount,
                orderTrackingId: orderTrackingId,
                errorMessage: errorMessage,
              );
            },
          ),
        ],
      ),
    ],
  );
}
