import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yole_final/core/routing/app_router.dart';
import 'package:yole_final/features/send/screens/send_start_screen.dart';
import 'package:yole_final/features/send/screens/send_recipient_screen.dart';
import 'package:yole_final/features/send/screens/send_network_screen.dart';
import 'package:yole_final/features/send/screens/send_amount_screen.dart';
import 'package:yole_final/features/send/screens/send_review_screen.dart';
import 'package:yole_final/features/send/screens/send_auth_screen.dart';
import 'package:yole_final/features/send/screens/send_success_screen.dart';

/// Test router configuration for integration tests
///
/// This router mimics the app routes but with:
/// - initialLocation set to '/send/start'
/// - no authentication guards
/// - no redirects
final RouterConfig<Object> testRouter = GoRouter(
  initialLocation: '/send/start',
  routes: [
    // Send flow routes
    GoRoute(
      path: '/send/start',
      builder: (context, state) => const SendStartScreen(),
    ),
    GoRoute(
      path: '/send/recipient',
      builder: (context, state) => const SendRecipientScreen(),
    ),
    GoRoute(
      path: '/send/network',
      builder: (context, state) => const SendNetworkScreen(),
    ),
    GoRoute(
      path: '/send/amount',
      builder: (context, state) => const SendAmountScreen(),
    ),
    GoRoute(
      path: '/send/review',
      builder: (context, state) => const SendReviewScreen(),
    ),
    GoRoute(
      path: '/send/auth',
      builder: (context, state) => const SendAuthScreen(),
    ),
    GoRoute(
      path: '/send/success',
      builder: (context, state) => const SendSuccessScreen(),
    ),
  ],
  // No redirects or guards for tests
  redirect: (context, state) => null,
);
